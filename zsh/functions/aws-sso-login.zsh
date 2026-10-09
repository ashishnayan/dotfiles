# AWS SSO Firefox Container Router
#
#   aws-login [session|profile]   -> log in to one target, in its container
#   aws-login-all [targets...]    -> log in to every container, one after another
#
# 1. DEFINE YOUR MAPPING HERE
# Format: "aws_config_name:Firefox_Container_Name" (order is the login order)
typeset -ga AWS_SSO_ROUTES
AWS_SSO_ROUTES=(
    "tx:TymeCentral"
    "tx-wks:TymeCentral-WKS"
    "gt:GO-PH"
    "gt-pln:GO-PH"
    "gt-dev:GO-PH-Dev"
    "gt-tst:GO-PH-Tst"
    "gt-stg:GO-PH-Stg"
    "gt-prd:GO-PH-Prd"
)

# 2. FALLBACK CONFIGURATION
typeset -g AWS_SSO_DEFAULT_SESSION="gt"
typeset -g AWS_SSO_DEFAULT_CONTAINER="GO-PH"
typeset -g AWS_SSO_FIREFOX_BIN="/Applications/Firefox.app/Contents/MacOS/firefox"

# --- helpers ----------------------------------------------------------------

_aws_sso_urlencode() {
    python3 -c 'import sys, urllib.parse; print(urllib.parse.quote(sys.argv[1], safe=""))' "$1"
}

_aws_sso_container_for() {
    local name="$1" route
    for route in "${AWS_SSO_ROUTES[@]}"; do
        if [[ "${route%%:*}" == "$name" ]]; then
            print -r -- "${route#*:}"
            return 0
        fi
    done
    return 1
}

# Resolve how to log in: the name may be an [sso-session] or a [profile].
# Per-env names (gt-stg, gt-dev, ...) are profiles; only gt/tx are sessions.
# Prints "profile" or "sso-session"; returns 1 if the name is in neither.
_aws_sso_kind_of() {
    local name="$1"
    local aws_config="${AWS_CONFIG_FILE:-$HOME/.aws/config}"
    if grep -qE "^\[profile[[:space:]]+${name}\][[:space:]]*$" "$aws_config" 2>/dev/null; then
        print -r -- "profile"
    elif grep -qE "^\[sso-session[[:space:]]+${name}\][[:space:]]*$" "$aws_config" 2>/dev/null; then
        print -r -- "sso-session"
    else
        return 1
    fi
}

# The [sso-session] a name ultimately authenticates against (its token cache key).
_aws_sso_session_of() {
    local name="$1" kind
    kind=$(_aws_sso_kind_of "$name") || return 1
    if [[ "$kind" == "sso-session" ]]; then
        print -r -- "$name"
    else
        aws configure get sso_session --profile "$name" 2>/dev/null
    fi
}

# Print the configured routes, annotated with what each name is in aws config.
_aws_sso_print_routes() {
    local route name container kind session
    for route in "${AWS_SSO_ROUTES[@]}"; do
        name="${route%%:*}"
        container="${route#*:}"
        if kind=$(_aws_sso_kind_of "$name"); then
            session=$(_aws_sso_session_of "$name")
            printf '    %-8s -> %-16s (%s, session: %s)\n' "$name" "$container" "$kind" "$session"
        else
            printf '    %-8s -> %-16s (⚠️  not in aws config)\n' "$name" "$container"
        fi
    done
}

_aws_sso_help() {
    cat <<'EOF'
AWS SSO Firefox Container Router

  aws-login [target]        log in to one target, in its Firefox container
  aws-login-all [target...] log in to every container, one after another

Targets are [sso-session] or [profile] names from ~/.aws/config.

aws-login
  target                    defaults to $AWS_SSO_DEFAULT_SESSION
  -h, --help                show this help

aws-login-all
  (no flags)                one login per unique container  [default]
  -s, --sessions-only       one login per unique [sso-session] — fewest logins
  -e, --every               every mapped entry, no deduping
  -n, --dry-run             print the plan and exit without logging in
  -h, --help                show this help
  target...                 only these targets instead of the whole map

  Short flags may be clustered, e.g. -sn.
  Logins run sequentially: each waits for you to finish auth in its container.

Note: profiles sharing an [sso-session] share one CLI token, so -s is enough
to authenticate the CLI. Use the default (per container) when you also want a
browser SSO session in each container for console access.

EOF
    echo "Configured routes (name -> Firefox container):"
    _aws_sso_print_routes
    echo
    echo "Fallback: session '$AWS_SSO_DEFAULT_SESSION', container '$AWS_SSO_DEFAULT_CONTAINER'"
    echo "Config:   ${AWS_CONFIG_FILE:-$HOME/.aws/config}"
    echo "Firefox:  $AWS_SSO_FIREFOX_BIN"
}

# Core: run one `aws sso login` and route its verification URL into a container.
_aws_sso_login_one() {
    local session_name="$1" container_name="$2"
    local login_kind
    local -a login_args

    login_kind=$(_aws_sso_kind_of "$session_name") || {
        echo "❌ '$session_name' is neither a [profile] nor an [sso-session] in ${AWS_CONFIG_FILE:-$HOME/.aws/config}"
        return 1
    }
    if [[ "$login_kind" == "profile" ]]; then
        login_args=(--profile "$session_name")
    else
        login_args=(--sso-session "$session_name")
    fi

    if [[ ! -x "$AWS_SSO_FIREFOX_BIN" ]]; then
        echo "❌ Firefox not found at $AWS_SSO_FIREFOX_BIN"
        return 1
    fi

    echo "=================================================="
    echo "☁️  AWS CLI Container Login Automator"
    echo "🔄 Session:   [$session_name] ($login_kind)"
    echo "📦 Container: [$container_name]"
    echo "=================================================="

    local encoded_container
    encoded_container=$(_aws_sso_urlencode "$container_name")

    # Declared outside the loop so the URL seen on an earlier line is still
    # available when the device code shows up on a later one.
    local sso_url="" encoded_url="" sso_code=""

    script -q /dev/null aws sso login "${login_args[@]}" --no-browser 2>&1 | while IFS= read -r line; do
        echo "$line"

        # 3. INTERCEPT TARGET ENDPOINT LINKS
        if [[ "$line" =~ "https://(device\.sso|oidc)\.[a-z0-9-]+\.amazonaws\.com/" ]]; then
            sso_url=$(echo "$line" | grep -oE "https://[a-zA-Z0-9./?=&%+_-]+")
            # Percent-encode the SSO URL so & inside it isn't parsed as a
            # container ext param separator
            encoded_url=$(_aws_sso_urlencode "$sso_url")

            # Route immediately if this is an automated OIDC loopback flow link
            if [[ "$sso_url" =~ "oidc" ]]; then
                echo "🚀 Launching OIDC Authorization URL inside Firefox container..."
                $AWS_SSO_FIREFOX_BIN "ext+container:name=${encoded_container}&url=${encoded_url}" &!
            fi
        fi

        # 4. FALLBACK FOR TRADITIONAL DEVICE AUTH CODES (if prompted)
        if [[ "$line" =~ "[A-Z0-9]{4}-[A-Z0-9]{4}" ]]; then
            sso_code=$(echo "$line" | grep -oE "[A-Z0-9]{4}-[A-Z0-9]{4}")

            # Copy to macOS clipboard
            echo -n "$sso_code" | pbcopy
            echo -e "\n📋 Code [$sso_code] copied to your macOS clipboard!"

            if [[ -n "$encoded_url" ]]; then
                echo "🚀 Launching Device Verification URL inside Firefox container..."
                $AWS_SSO_FIREFOX_BIN "ext+container:name=${encoded_container}&url=${encoded_url}" &!
            fi
        fi
    done

    return ${pipestatus[1]}
}

# --- public functions -------------------------------------------------------

aws-login() {
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        _aws_sso_help
        return 0
    fi

    local session_name="${1:-$AWS_SSO_DEFAULT_SESSION}"
    local container_name

    container_name=$(_aws_sso_container_for "$session_name") || {
        echo "⚠️  Session '$session_name' not found in mapping. Using fallback container."
        container_name="$AWS_SSO_DEFAULT_CONTAINER"
    }

    _aws_sso_login_one "$session_name" "$container_name"
}

# Log in to every mapped Firefox container, sequentially.
#
#   aws-login-all              one login per unique container (default)
#   aws-login-all -s           one login per unique [sso-session] (fewest logins)
#   aws-login-all -e           every mapped entry, no deduping
#   aws-login-all -n           dry run: print the plan and exit
#   aws-login-all gt tx-wks    only these targets
#
# Note: all gt-* profiles share the [sso-session gt] token, so -s is enough for
# the CLI. Use the default (per container) when you also want a browser session
# in each container for console access.
aws-login-all() {
    local dedupe="container" dry_run=0
    local -a targets
    # declared once up front: re-declaring a local in the same scope makes zsh
    # print it instead of just resetting it
    local entry name container key t i
    local -a candidates plan skipped failed
    local -A seen

    # Expand clustered short flags (-sn -> -s -n) so they behave like getopts.
    local -a expanded
    local arg c
    for arg in "$@"; do
        if [[ "$arg" == -[a-zA-Z][a-zA-Z]* && "$arg" != --* ]]; then
            for (( c = 2; c <= ${#arg}; c++ )); do expanded+=("-${arg[c]}"); done
        else
            expanded+=("$arg")
        fi
    done
    set -- "${expanded[@]}"

    while (( $# )); do
        case "$1" in
            -s|--sessions-only) dedupe="session" ;;
            -e|--every)         dedupe="none" ;;
            -n|--dry-run)       dry_run=1 ;;
            -h|--help)          _aws_sso_help; return 0 ;;
            -*)
                echo "❌ unknown option: $1"
                echo "   try: aws-login-all --help"
                return 1
                ;;
            *)  targets+=("$1") ;;
        esac
        shift
    done

    # Build the candidate list: explicit targets, or everything in the map.
    if (( ${#targets} )); then
        for t in "${targets[@]}"; do
            container=$(_aws_sso_container_for "$t") || container="$AWS_SSO_DEFAULT_CONTAINER"
            candidates+=("$t:$container")
        done
    else
        candidates=("${AWS_SSO_ROUTES[@]}")
    fi

    # Resolve + dedupe into the final plan.
    for entry in "${candidates[@]}"; do
        name="${entry%%:*}"
        container="${entry#*:}"

        if ! _aws_sso_kind_of "$name" >/dev/null; then
            skipped+=("$name (not in aws config)")
            continue
        fi

        case "$dedupe" in
            container) key="c:$container" ;;
            session)   key="s:$(_aws_sso_session_of "$name")" ;;
            none)      key="n:$name" ;;
        esac

        if [[ -n "${seen[$key]}" ]]; then
            skipped+=("$name (covered by ${seen[$key]})")
            continue
        fi
        seen[$key]="$name"
        plan+=("$entry")
    done

    if (( ${#plan} == 0 )); then
        echo "❌ Nothing to log in to."
        (( ${#skipped} )) && printf '   ⏭  %s\n' "${skipped[@]}"
        return 1
    fi

    echo "🗂  Login plan (dedupe: $dedupe) — ${#plan} login(s):"
    i=1
    for entry in "${plan[@]}"; do
        printf '   %d. %-8s -> %s\n' "$i" "${entry%%:*}" "${entry#*:}"
        (( i++ ))
    done
    (( ${#skipped} )) && printf '   ⏭  skipped: %s\n' "${skipped[@]}"

    if (( dry_run )); then
        return 0
    fi

    echo "\nEach login waits for you to finish auth in its Firefox container."
    i=1
    for entry in "${plan[@]}"; do
        name="${entry%%:*}"
        echo "\n──────── [$i/${#plan}] $name ────────"
        if ! _aws_sso_login_one "$name" "${entry#*:}"; then
            echo "❌ Login failed for $name"
            failed+=("$name")
        fi
        (( i++ ))
    done

    echo "\n=================================================="
    echo "✅ Done: $(( ${#plan} - ${#failed} ))/${#plan} succeeded"
    (( ${#failed} )) && echo "❌ Failed: ${failed[*]}"
    echo "=================================================="

    (( ${#failed} == 0 ))
}
