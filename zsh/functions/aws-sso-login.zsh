# AWS SSO Firefox Container Router Function
aws-login() {
    # 1. DEFINE YOUR MAPPING HERE
    # Format: ["session_name"]="Firefox_Container_Name"
    typeset -A SESSION_MAP
    SESSION_MAP=(
        ["tx"]="TymeCentral"
        ["tx-wks"]="TymeCentral-WKS"
        ["gt"]="GO-PH"
        ["gt-dev"]="GO-PH-Dev"
        ["gt-tst"]="GO-PH-Tst"
        ["gt-stg"]="GO-PH-Stg"
        ["gt-prd"]="GO-PH-Prd"
    )

    local FIREFOX_BIN="/Applications/Firefox.app/Contents/MacOS/firefox"
    # 2. FALLBACK CONFIGURATION
    local DEFAULT_SESSION="gt"
    local DEFAULT_CONTAINER="GO-PH"

    # Determine session to use
    local SESSION_NAME="${1:-$DEFAULT_SESSION}"

    # Lookup container using the map
    local CONTAINER_NAME="${SESSION_MAP[$SESSION_NAME]}"

    # Fallback if session is missing from map
    if [ -z "$CONTAINER_NAME" ]; then
        echo "⚠️  Session '$SESSION_NAME' not found in mapping. Using fallback container."
        CONTAINER_NAME="$DEFAULT_CONTAINER"
    fi

    echo "=================================================="
    echo "☁️  AWS CLI Container Login Automator"
    echo "🔄 Session:   [$SESSION_NAME]"
    echo "📦 Container: [$CONTAINER_NAME]"
    echo "=================================================="

    # Run AWS login and capture streams
    script -q /dev/null aws sso login --sso-session "$SESSION_NAME" --no-browser 2>&1 | while IFS= read -r line; do
        echo "$line"
        # 3. INTERCEPT TARGET ENDPOINT LINKS
        if [[ "$line" =~ "https://(device\.sso|oidc)\.[a-z0-9-]+\.amazonaws\.com/" ]]; then
            # Extract the raw formatted link parameter payload accurately
            local sso_url=$(echo "$line" | grep -oE "https://[a-zA-Z0-9./?=&%+_-]+")
            
            # URL encode container name string for macOS safety
            local encoded_container=$(objcrun -e "import Foundation; print('$CONTAINER_NAME'.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)" 2>/dev/null || echo "$CONTAINER_NAME")

            # Percent-encode the SSO URL so & inside it isn't parsed as a container ext param separator
            local encoded_url=$(python3 -c "import urllib.parse, sys; print(urllib.parse.quote(sys.argv[1], safe=''))" "$sso_url")

            # Route immediately if this is an automated OIDC loopback flow link
            if [[ "$sso_url" =~ "oidc" ]]; then
                echo "🚀 Launching OIDC Authorization URL inside Firefox container..."
                $FIREFOX_BIN "ext+container:name=${encoded_container}&url=${encoded_url}" &!
            fi
        fi
        
        # 4. FALLBACK FOR TRADITIONAL DEVICE AUTH CODES (if prompted)
        if [[ "$line" =~ "Enter the code:" ]]; then
            local sso_code=$(echo "$line" | grep -oE "[A-Z0-9]{4}-[A-Z0-9]{4}")
            
            # Copy to macOS clipboard
            echo -n "$sso_code" | pbcopy
            echo -e "\n📋 Code [$sso_code] copied to your macOS clipboard!"
            
            echo "🚀 Launching Device Verification URL inside Firefox container..."
            $FIREFOX_BIN "ext+container:name=${encoded_container}&url=${encoded_url}" &!
        fi
    done
}
