# Mark-off report browser (enterprise-reconciliation-svc)
#
#   markoff                     -> pick profile, org, account, file (fzf all the way down)
#   markoff 9834                -> jump to the account whose number ends 9834
#   markoff 9834 10092026       -> ...narrowed to one window date (ddmmyyyy)
#   markoff --profile gt-prd    -> any flag can precede/follow the positionals
#
# The service logs `account_suffix` but names the file after `accountName`, so this
# resolves suffix -> name via the same organisation-accounts-index GSI the report
# reads, then applies the service's _slug() to rebuild the S3 key prefix.
#
# In the file picker: enter downloads + counts rows, ctrl-o opens it in $EDITOR.

# profile -> mark-off output bucket (matches testing-configuration-*.json)
typeset -gA MARKOFF_BUCKETS
MARKOFF_BUCKETS=(
    gt-dev "enterprise-recon.dev.sg.gotyme.com.ph"
    gt-tst "enterprise-recon.tst.sg.gotyme.com.ph"
    gt-stg "enterprise-recon.stg.sg.gotyme.com.ph"
    gt-prd "enterprise-recon.prd.sg.gotyme.com.ph"
    tb-tst "enterprise-recon.tst.irl.tymebank.co.za"
    tb-stg "enterprise-recon.stg.irl.tymebank.co.za"
    tb-prd "enterprise-recon.prd.irl.tymebank.co.za"
)

# S3 org folder -> organisationId, so a suffix can be resolved without asking.
# Unmapped orgs still browse fine; only suffix lookup needs the id (or --org-id).
typeset -gA MARKOFF_ORG_IDS
MARKOFF_ORG_IDS=(
    ApeX-Enterprise "9f5866ba-adac-4703-a45d-e2fe7f02d067"
)

typeset -g MARKOFF_DEFAULT_PROFILE="gt-stg"
typeset -g MARKOFF_REGION="ap-southeast-1"
typeset -g MARKOFF_PREFIX="out/markoff"
typeset -g MARKOFF_TABLE="enterprise-reconciliation"

# --- helpers ----------------------------------------------------------------

_markoff_help() {
    print -r -- "markoff [suffix] [ddmmyyyy] [options]"
    print -r -- ""
    print -r -- "  -p, --profile NAME   aws profile (default: $MARKOFF_DEFAULT_PROFILE)"
    print -r -- "  -o, --org NAME       S3 org folder, skips the org picker"
    print -r -- "      --org-id UUID    organisationId for suffix lookup on unmapped orgs"
    print -r -- "  -b, --bucket NAME    override the bucket for this profile"
    print -r -- "  -n, --count N        files to list (default 40, newest last)"
    print -r -- "  -h, --help           this"
    print -r -- ""
    print -r -- "known profiles:"
    local p
    for p in ${(ok)MARKOFF_BUCKETS}; do
        printf '    %-8s -> %s\n' "$p" "${MARKOFF_BUCKETS[$p]}"
    done
}

# Mirror of the service's _slug(): anything outside [A-Za-z0-9_-] collapses to '-'.
_markoff_slug() {
    python3 -c '
import re, sys
print(re.sub(r"[^A-Za-z0-9_-]+", "-", sys.argv[1]).strip("-") or "unknown")' "$1"
}

# List an org'\''s accounts as "suffix<TAB>accountName", newest projection first.
_markoff_accounts() {
    local profile="$1" org_id="$2"
    aws dynamodb query \
        --table-name "$MARKOFF_TABLE" \
        --index-name organisation-accounts-index \
        --key-condition-expression "organisationId = :o" \
        --expression-attribute-values "{\":o\":{\"S\":\"$org_id\"}}" \
        --projection-expression "accountNumber, accountName" \
        --profile "$profile" --region "$MARKOFF_REGION" --output json 2>/dev/null |
        jq -r '.Items[] | "\(.accountNumber.S[-4:])\t\(.accountName.S)"' | sort
}

# --- main -------------------------------------------------------------------

markoff() {
    emulate -L zsh
    setopt local_options pipe_fail

    local profile="$MARKOFF_DEFAULT_PROFILE" bucket="" org="" org_id=""
    local suffix="" date="" limit=40
    local -a positional

    while (( $# )); do
        case "$1" in
            -h|--help)    _markoff_help; return 0 ;;
            -p|--profile) profile="$2"; shift 2 ;;
            -b|--bucket)  bucket="$2";  shift 2 ;;
            -o|--org)     org="$2";     shift 2 ;;
            --org-id)     org_id="$2";  shift 2 ;;
            -n|--count)   limit="$2";   shift 2 ;;
            -*)           print -u2 -- "unknown option: $1"; return 1 ;;
            *)            positional+=("$1"); shift ;;
        esac
    done
    suffix="${positional[1]:-}"
    date="${positional[2]:-}"

    local dep
    for dep in aws jq fzf; do
        command -v "$dep" >/dev/null 2>&1 || { print -u2 -- "missing dependency: $dep"; return 1 }
    done

    : ${bucket:=${MARKOFF_BUCKETS[$profile]}}
    if [[ -z "$bucket" ]]; then
        print -u2 -- "no bucket mapped for profile '$profile' — pass --bucket, or add it to MARKOFF_BUCKETS"
        return 1
    fi

    if ! aws sts get-caller-identity --profile "$profile" --region "$MARKOFF_REGION" >/dev/null 2>&1; then
        print -u2 -- "no valid credentials for '$profile' — run: aws-login $profile"
        return 1
    fi

    local gray cyan green reset
    gray=$(tput setaf 8); cyan="$(tput bold)$(tput setaf 6)"; green=$(tput setaf 2); reset=$(tput sgr0)

    # 1. org folder
    if [[ -z "$org" ]]; then
        local -a orgs
        orgs=(${(f)"$(aws s3api list-objects-v2 --bucket "$bucket" --prefix "$MARKOFF_PREFIX/" \
            --delimiter / --profile "$profile" --region "$MARKOFF_REGION" \
            --query 'CommonPrefixes[].Prefix' --output text 2>/dev/null | tr '\t' '\n' |
            sed "s#^$MARKOFF_PREFIX/##; s#/\$##" | grep -v '^$')"})
        (( ${#orgs} )) || { print -u2 -- "no org folders under s3://$bucket/$MARKOFF_PREFIX/"; return 1 }
        if (( ${#orgs} == 1 )); then
            org="${orgs[1]}"
        else
            org=$(print -rl -- "${orgs[@]}" | fzf --prompt="Org ($profile)> " --height=40%) || return
        fi
    fi
    [[ -n "$org" ]] || return

    : ${org_id:=${MARKOFF_ORG_IDS[$org]}}

    # 2. account -> slugged name token
    local account_name="" slug=""
    if [[ -n "$org_id" ]]; then
        local accounts
        accounts=$(_markoff_accounts "$profile" "$org_id")
        if [[ -n "$accounts" ]]; then
            local picked=""
            if [[ -n "$suffix" ]]; then
                picked=$(print -r -- "$accounts" | awk -F'\t' -v s="$suffix" '$1 == s {print; exit}')
                [[ -n "$picked" ]] || print -u2 -- "${gray}no account ending in $suffix — falling back to picker${reset}"
            fi
            if [[ -z "$picked" ]]; then
                picked=$(print -r -- "$accounts" | column -t -s $'\t' |
                    fzf --prompt="Account> " --height=40% \
                        --header="suffix  accountName   (esc = all accounts)") || picked=""
            fi
            if [[ -n "$picked" ]]; then
                # Drop the suffix column, whether it is tab-separated (awk match)
                # or space-padded (column -t via the picker).
                account_name=$(print -r -- "$picked" | sed -E 's/^[^[:space:]]+[[:space:]]+//')
                slug=$(_markoff_slug "$account_name")
            fi
        else
            print -u2 -- "${gray}could not read accounts (no dynamodb access?) — listing all files${reset}"
        fi
    elif [[ -n "$suffix" ]]; then
        print -u2 -- "${gray}no organisationId mapped for '$org' — pass --org-id to resolve suffix $suffix${reset}"
    fi

    # 3. file
    local key_prefix="$MARKOFF_PREFIX/$org/EnterpriseMarkoff_${org}_"
    [[ -n "$slug" ]] && key_prefix+="${slug}_"
    [[ -n "$date" ]] && key_prefix+="${date}"

    print -r -- "${gray}s3://$bucket/$key_prefix${reset}"
    [[ -n "$account_name" ]] && print -r -- "${gray}account: $account_name${reset}"

    local listing
    listing=$(aws s3api list-objects-v2 --bucket "$bucket" --prefix "$key_prefix" \
        --profile "$profile" --region "$MARKOFF_REGION" \
        --query "sort_by(Contents,&LastModified)[-${limit}:].[LastModified,Size,Key]" \
        --output text 2>/dev/null | grep -v '^None')
    if [[ -z "$listing" ]]; then
        print -u2 -- "no objects match that prefix"
        return 1
    fi

    # Preview the first 4 KiB via a ranged GET — instant even for multi-MB reports.
    local preview_cmd
    preview_cmd='key=$(echo {} | awk "{print \$NF}"); '
    preview_cmd+='aws s3api get-object --bucket '"$bucket"' --key "$key" --range bytes=0-4095 '
    preview_cmd+='--profile '"$profile"' --region '"$MARKOFF_REGION"' /dev/stdout 2>/dev/null '
    preview_cmd+='| head -12 | cut -c1-400'

    local selected
    selected=$(print -r -- "$listing" | column -t |
        fzf --prompt="File> " --height=80% --tac \
            --header="enter = download + count rows | ctrl-o = open in \$EDITOR" \
            --preview "$preview_cmd" --preview-window=down:60%:wrap \
            --expect=ctrl-o) || return
    local action="${selected%%$'\n'*}" row="${selected#*$'\n'}"
    [[ -n "$row" ]] || return

    local key size
    key=$(print -r -- "$row" | awk '{print $NF}')
    size=$(print -r -- "$row" | awk '{print $2}')

    local out="${TMPDIR:-/tmp}/${key:t}"
    aws s3 cp "s3://$bucket/$key" "$out" --profile "$profile" --region "$MARKOFF_REGION" --quiet || return

    local rows
    rows=$(python3 -c '
import csv, sys
with open(sys.argv[1], newline="") as f:
    print(sum(1 for _ in csv.DictReader(f)))' "$out")

    print -r -- ""
    print -r -- "${cyan}${key:t}${reset}"
    print -r -- "  rows:  ${green}${rows}${reset}"
    print -r -- "  bytes: $size"
    print -r -- "  local: $out"

    [[ "$action" == "ctrl-o" ]] && ${EDITOR:-less} "$out"
    return 0
}
