from .auto_subs import check_auto_subs
from .grok_bot import check_grok_bot

# REPOS[].source → checker. Add a function here when a new upstream appears.
SOURCES = {
    "grok-bot": check_grok_bot,
    "auto-subs": check_auto_subs,
}
