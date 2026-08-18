pipeline-status() {
  local profile="gt-pln"
  local watch=false
  local arg
  for arg in "$@"; do
    case "$arg" in
      --watch) watch=true ;;
      *) profile="$arg" ;;
    esac
  done

  local preview_cmd
  preview_cmd='aws codepipeline get-pipeline-state --name {} --profile '"$profile"' --query "stageStates[].{Stage:stageName,Status:latestExecution.status}" --output table 2>/dev/null'

  local name
  name=$(aws codepipeline list-pipelines --profile "$profile" --query 'pipelines[].name' --output text \
    | tr '\t' '\n' | fzf --prompt="Pipeline ($profile)> " --preview "$preview_cmd" --preview-window=right:60%:wrap)
  [[ -z "$name" ]] && return

  local green red yellow gray cyan reset
  green=$(tput setaf 2); red=$(tput setaf 1); yellow=$(tput setaf 3); gray=$(tput setaf 8); reset=$(tput sgr0)
  cyan="$(tput bold)$(tput setaf 6)"

  _pipeline_status_rule() {
    local cols
    cols=$(tput cols 2>/dev/null)
    [[ -z "$cols" || "$cols" -le 0 ]] && cols=60
    printf '%*s' "$cols" '' | tr ' ' '─'
  }

  _pipeline_status_fetch() {
    if command -v gum >/dev/null 2>&1; then
      gum spin --spinner dot --title "Fetching pipeline state..." --show-output -- \
        aws codepipeline get-pipeline-state --name "$name" --profile "$profile" --output json
    else
      aws codepipeline get-pipeline-state --name "$name" --profile "$profile" --output json
    fi
  }

  _pipeline_status_summary_line() {
    local overall summary
    overall=$(jq -r '
        [.stageStates[].actionStates[].latestExecution.status // "N/A"] as $statuses |
        if ($statuses | index("Failed")) then "FAILED"
        elif ($statuses | index("InProgress")) then "IN PROGRESS"
        else "SUCCEEDED"
        end
      ' <<< "$1")
    summary=$(jq -r '
        def iconFor:
          if . == "Succeeded" then "✅"
          elif . == "Failed" then "❌"
          elif . == "InProgress" then "🔄"
          elif . == "Cancelled" or . == "Abandoned" or . == "Superseded" then "⏸"
          else "➖"
          end;
        [.stageStates[].actionStates[].latestExecution.status // "N/A"]
        | group_by(.) | map("\(.[0] | iconFor) \(length) \(.[0])") | join("  ")
      ' <<< "$1")

    local overallColor overallIcon
    case "$overall" in
      FAILED) overallColor="$red"; overallIcon="❌" ;;
      "IN PROGRESS") overallColor="$yellow"; overallIcon="🔄" ;;
      *) overallColor="$green"; overallIcon="✅" ;;
    esac

    typeset -g _pipeline_last_overall="$overall"

    echo "${gray}$(_pipeline_status_rule)${reset}"
    echo "${overallIcon} Pipeline: ${name}  |  Status: ${overallColor}${overall}${reset}  |  ${summary}" \
      | sed -E \
        -e "s/([0-9]+ Succeeded)/${green}\1${reset}/" \
        -e "s/([0-9]+ Failed)/${red}\1${reset}/" \
        -e "s/([0-9]+ InProgress)/${yellow}\1${reset}/" \
        -e "s/([0-9]+ (Cancelled|Abandoned|Superseded|N\/A))/${gray}\1${reset}/"
    echo "${gray}$(_pipeline_status_rule)${reset}"

    [[ "$overall" == "IN PROGRESS" ]]
  }

  _pipeline_status_render() {
    local state
    state=$(_pipeline_status_fetch)

    _pipeline_status_summary_line "$state"
    echo

    { echo -e "STAGE\tACTION\tSTATUS\tAGE\tPIPELINE-EXEC-ID"; \
      jq -r '
          def parsets:
            if . == null then null else
              capture("^(?<d>[^.]+)\\.(?<frac>[0-9]+)(?<sign>[+-])(?<oh>[0-9]{2}):(?<om>[0-9]{2})$") as $c |
              (($c.d + "Z") | strptime("%Y-%m-%dT%H:%M:%SZ") | mktime) as $naive |
              (($c.oh|tonumber)*3600 + ($c.om|tonumber)*60) as $off |
              (if $c.sign == "-" then -$off else $off end) as $offset |
              ($naive - $offset)
            end;
          def fmtdur:
            (. as $s |
             if $s >= 3600 then "\($s/3600|floor)h \(($s%3600)/60|floor)m"
             elif $s >= 60 then "\($s/60|floor)m \($s%60|floor)s"
             else "\($s|floor)s"
             end);
          def iconFor:
            if . == "Succeeded" then "✅"
            elif . == "Failed" then "❌"
            elif . == "InProgress" then "🔄"
            elif . == "Cancelled" or . == "Abandoned" or . == "Superseded" then "⏸"
            else "➖"
            end;
          .stageStates[] | .stageName as $stage |
            (.latestExecution.pipelineExecutionId // "N/A") as $pipelineExecId |
            .actionStates[] |
            (.latestExecution.status // "N/A") as $status |
            (.latestExecution.lastStatusChange | parsets) as $ts |
            (if $ts then (now - $ts | fmtdur) else "N/A" end) as $age |
            ("\($status | iconFor) \($status)") as $displayStatus |
            [$stage, .actionName, $displayStatus, $age, $pipelineExecId] | @tsv' <<< "$state"; \
    } | column -t -s $'\t' \
      | sed -E \
        -e "s/^(.*Succeeded.*)\$/${green}\1${reset}/" \
        -e "s/^(.*Failed.*)\$/${red}\1${reset}/" \
        -e "s/^(.*InProgress.*)\$/${yellow}\1${reset}/" \
        -e "s/^(.*(Cancelled|Abandoned|Superseded).*)\$/${gray}\1${reset}/"

    local failures_tsv
    failures_tsv=$(jq -r '
        def truncmsg: if length > 80 then .[0:77] + "..." else . end;
        .stageStates[] | .stageName as $stage |
          (.latestExecution.pipelineExecutionId // "N/A") as $pipelineExecId |
          .actionStates[] |
          select(.latestExecution.status == "Failed") |
          [$stage, .actionName, $pipelineExecId,
           ((.latestExecution.errorDetails.message // .latestExecution.summary // "N/A") | truncmsg),
           (.latestExecution.externalExecutionUrl // "N/A")] | @tsv
      ' <<< "$state")

    if [[ -n "$failures_tsv" ]]; then
      echo
      { echo -e "STAGE\tACTION\tPIPELINE-EXEC-ID\tERROR\tLOG"; echo "$failures_tsv"; } \
        | column -t -s $'\t' \
        | sed -E "2,\$ s/^([^ ]+)/${cyan}\1${reset}/"
    fi

    echo
    _pipeline_status_summary_line "$state"
  }

  if $watch; then
    while true; do
      clear
      _pipeline_status_render
      local rc=$?
      [[ $rc -ne 0 ]] && break
      echo
      echo "${gray}Watching... refreshing every 5s (Ctrl+C to stop)${reset}"
      sleep 5
    done
    if [[ "$(uname)" == "Darwin" ]] && command -v osascript >/dev/null 2>&1; then
      osascript -e "display notification \"${_pipeline_last_overall}\" with title \"Pipeline: ${name}\"" 2>/dev/null
    fi
  else
    _pipeline_status_render
  fi

  unset _pipeline_last_overall
  unfunction _pipeline_status_render _pipeline_status_summary_line _pipeline_status_rule _pipeline_status_fetch
}
