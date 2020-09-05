#! /usr/bin/env bash
set -e

readonly USAGE="Usage: $0 [--lewd]"
declare -a args
lewd="false"
while (( "$#" ))
do
    case "$1" in
        -h|--help)
            echo "$USAGE"
            exit
            ;;
        --)
            shift
            break
            ;;
        --lewd)
            lewd="true"
            break
            ;;
        *)
            args+=("$1")
            ;;
    esac
    shift
done
args+=("$@")

# {{{ Colors, logging functions
readonly PROG_NAME="$0"

function RESET            { echo -e "\e[0m";  }
function BOLD             { echo -e "\e[1m";  }
function RESET_BOLD       { echo -e "\e[21m"; }
function DIM              { echo -e "\e[2m";  }
function RESET_DIM        { echo -e "\e[22m"; }
function UNDERLINED       { echo -e "\e[4m";  }
function RESET_UNDERLINED { echo -e "\e[24m"; }
function BRRED            { echo -e "\e[31m"; }
function RED              { echo -e "\e[91m"; }
function BRGREEN          { echo -e "\e[32m"; }
function GREEN            { echo -e "\e[92m"; }
function BRYELLOW         { echo -e "\e[33m"; }
function YELLOW           { echo -e "\e[93m"; }
function BRBLUE           { echo -e "\e[34m"; }
function BLUE             { echo -e "\e[94m"; }
function BRPURPLE         { echo -e "\e[35m"; }
function PURPLE           { echo -e "\e[95m"; }
function BRCYAN           { echo -e "\e[36m"; }
function CYAN             { echo -e "\e[96m"; }
function BRGRAY           { echo -e "\e[37m"; }
function GRAY             { echo -e "\e[97m"; }
function RESET_FG         { echo -e "\e[39m"; }

function now { date +%FT%T; }

# _log COLORS LABEL [MESSAGE [...]]
function _log {
    color="$1"
    shift
    level="$1"
    shift
    echo -n "$color$level $PROG_NAME ${color}[$(now)]:" "$@"
    RESET
}

function dbg   { _log "$(GRAY)"         "[debug]" "$@"; }
function info  { _log "$(BRGREEN)"      "[info] " "$@"; }
function warn  { _log "$(BRYELLOW)"     "[warn] " "$@"; }
function error { _log "$(BRRED)"        "[error]" "$@"; }
function fatal { _log "$(BOLD)$(BRRED)" "[FATAL]" "$@"; exit 1; }
function cmd   { _log "$(CYAN)"         "[run]  " "\$ $(BOLD)$(UNDERLINED)$*"; }
# }}}


info "Paste a tweet and then hit Ctrl-D:"
tweet=$(</dev/stdin)
if jq --arg tweet "$tweet" --exit-status '.[] | any(. == $tweet)' \
    ./data/puppy.json >/dev/null; then
    error "Looks like that tweet's already in in the corpus!"
else
    tmp=$(mktemp)
    jq --arg tweet "$tweet" \
        --argjson lewd "$lewd" \
        '. + [{pt: $tweet} + (if $lewd then {lewd: true} else {} end)]' ./data/puppy.json > "$tmp"
    mv "$tmp" ./data/puppy.json
fi

