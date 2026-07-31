# nnn configurations
# NOTE: added `r:my_trash_restore` plugin shortcut (invoke with ;r)
# NOTE: added `h:nnn-history` plugin shortcut (invoke with ;h) -- jump to any
#       directory visited in any tab/session/instance (needs O_HIST + NNN_HIST).
# NOTE: added `S:nnn-sessions` plugin shortcut (invoke with ;S) -- view and
#       manage sessions: preview all 8 contexts, activate, snapshot/restore,
#       rename/delete/duplicate, workspace capture (needs O_SSN_PIPE for a
#       full-fidelity activate/restore).
export NNN_PLUG='*:fzplug;/:fzsearch;c:my_copy_path;C:my_fz_cmd;d:dragdrop;e:!code-insiders "$nnn"*;E:!code-insiders "$(dirname "$nnn")"*;f:my_fj_cmd;F:fzcd;h:nnn-history;j:my_z_cmd;i:my_fzf_image_preview;I:imgview;l:my_lfrun;o:my_open_with;O:my_open_with_options;p:preview-tui;Q:my_nnn_quitall;n:cppath;r:my_trash_restore;s:my_fz_open_with;S:nnn-sessions;t:preview-tabbed;v:vidthumb;w:ctx_switcher;x:!ark -ba "$nnn" 2>/dev/null 1>/dev/null & *;X:!chmod +x $nnn;z:my_zi_cmd;'
export NNN_FCOLORS='c1e2272e006033f7c6d6abc4'
alias nnn=nnn_left
alias nnn_left='/home/tripham/bin/nnn -e -a -o -r -R -i -d -H -P a -P p -s left -S -f'
alias nnn_right='/home/tripham/bin/nnn -e -a -o -r -R -i -d -H -P a -P p -s right -S -f'
export LC_COLLATE="C"
export NNN_FIFO="/tmp/nnn.fifo"
export NNN_SPLIT='h'
export NNN_PREVIEWWIDTH=1280
export NNN_PREVIEWHEIGHT=720
export NNN_BATTHEME='TwoDark'

# Route nnn deletes (x / Ctrl-X) to the trash can instead of permanent rm.
# 1 = trash-cli (trash-put), 2 = gio trash. Requires `trash-cli` installed.
# WARNING: the built-in `X` (Shift-X) key is SEL_RM_RF and is ALWAYS a
# permanent rm -rf regardless of this setting. Use lowercase `x` to delete.
export NNN_TRASH=1

# Shared, unlimited directory history across all 8 contexts, both sessions
# (left/right) and both running instances. Recorded by nnn built with O_HIST=1
# (build.sh) into ~/.config/nnn/.dirhistory; jump to any entry with ;h
# (the nnn-history plugin). Set to 'local' or unset to disable.
export NNN_HIST=global

# ---------------------------------------------------------------------------
# Session management (;S -> nnn-sessions plugin).
#
# The manager lists every saved session, previews ALL 8 contexts' paths (plus
# cursor/last/filter), and can activate, snapshot, restore, rename, delete or
# duplicate them, and capture left+right+@ as one "workspace".
#
# Because nnn is built with O_SSN_ON_CD, the on-disk session file mirrors the
# live instance, so a snapshot is an accurate point-in-time backup. Snapshots
# live in ~/.config/nnn/sessions/.backups/<name>/<timestamp> next to a decoded
# .txt mirror; workspace captures in ~/.config/nnn/sessions/.snapshots/.
#
# NNN_SSN_KEEP: how many snapshots to keep per session (0 = keep everything).
#               The oldest are pruned automatically after each new snapshot.
export NNN_SSN_KEEP=20
#
# NNN_SSN_GIT=1 also commits sessions/ after each snapshot (the nnn config dir
# is already a git submodule), giving unlimited, diffable history. Off by default.
# export NNN_SSN_GIT=1
#
# The preview lists all 8 context paths at the top (always visible) with the
# per-context cursor/last/filter details below. Since a session is taller than
# the pane, the preview scrolls: alt-j/k a line, alt-u/d half a page, alt-b/f a
# page, alt-g/G to the ends, alt-p cycles the preview size, alt-z toggles wrap
# and alt-h hides it. NNN_SSN_PREVIEW overrides the geometry (any fzf
# --preview-window spec) -- e.g. a taller pane at the bottom:
# export NNN_SSN_PREVIEW='down,70%,wrap'
#
# A full-fidelity activate/restore (sort, filter, cursor, colors -- not just
# directories) needs nnn built with O_SSN_PIPE=1 (see build.sh), which exports
# NNN_SSN_PIPE=1 so the plugin can detect it. Without it the plugin degrades to
# cd-ing into the session's current directory.

# ---------------------------------------------------------------------------
# cwd-guard (bash) -- companion to ~/.config/fish/conf.d/nnn_cwd_guard.fish.
# Full analysis: nnn repo docs/nnn_Problems_And_Solutions.md.
#
# Because NNN_TRASH routes `x` deletes through trash-put (which *moves* the
# directory to ~/.local/share/Trash/files/), a terminal cd'd into a directory
# that gets trashed has its kernel CWD silently follow the inode into the Trash.
# The bash builtin `pwd -P` keeps showing the (recreated) original path, so new
# files land in the Trash unnoticed. This hook detects the mismatch each prompt
# and (by default) re-attaches to $PWD.
#   NNN_CWD_GUARD=0         disable     NNN_CWD_GUARD_AUTOCD=0   warn only
#
# Installed only in INTERACTIVE bash, so it is a no-op when fish imports this
# file via `bass` (which runs it in a non-interactive bash just to grab env).
if [ -n "${BASH_VERSION:-}" ] && [[ $- == *i* ]]; then
    __nnn_cwd_guard() {
        [ "${NNN_CWD_GUARD:-1}" = 1 ] || return 0
        local cur logical here
        cur=$(command stat -c '%d:%i' -- . 2>/dev/null) || return 0
        logical=$(command stat -Lc '%d:%i' -- "$PWD" 2>/dev/null)   # symlink-safe
        [ "$cur" = "$logical" ] && return 0     # CWD matches $PWD -> nothing to do
        here=$(env pwd -P 2>/dev/null)          # real getcwd, not the stale builtin
        case "$here" in
            */.local/share/Trash/*|*/.Trash-*/*)
                printf '\033[1;33m[cwd-guard] this shell is physically inside the Trash:\n            %s\033[0m\n' "$here" >&2 ;;
            *)
                printf '\033[1;33m[cwd-guard] working dir moved/replaced under this shell (real: %s)\033[0m\n' "${here:-<gone>}" >&2 ;;
        esac
        if [ -d "$PWD" ] && [ "${NNN_CWD_GUARD_AUTOCD:-1}" != 0 ]; then
            builtin cd -- "$PWD" 2>/dev/null && \
                printf '\033[1;32m[cwd-guard] re-attached to %s\033[0m\n' "$PWD" >&2
        elif [ ! -d "$PWD" ]; then
            printf '\033[1;33m[cwd-guard] original path no longer exists: %s\033[0m\n' "$PWD" >&2
        fi
    }
    case ";${PROMPT_COMMAND:-};" in
        *";__nnn_cwd_guard;"*) ;;
        *) PROMPT_COMMAND="__nnn_cwd_guard${PROMPT_COMMAND:+;$PROMPT_COMMAND}" ;;
    esac
fi

export NNN_DND_OSC72=1
export NNN_DND_DEBUG=/tmp/nnn-dnd.log
