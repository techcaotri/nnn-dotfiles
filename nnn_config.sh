# nnn configurations
export NNN_PLUG='*:fzplug;c:my_copy_path;C:my_fz_cmd;d:dragdrop;e:!code-insiders "$nnn"*;E:!code-insiders "$(dirname "$nnn")"*;f:fzcd;F:fzopen;j:autojump;i:imgview;I:!gwenview "$(dirname "$nnn")"*;o:my_open_with;O:my_fz_open_with;p:preview-tui;Q:my_nnn_quitall;t:preview-tabbed;v:vidthumb;x:!ark -ba "$nnn" 2>/dev/null 1>/dev/null & *;X:!chmod +x $nnn;'
export NNN_FCOLORS='c1e2272e006033f7c6d6abc4'
alias nnn=nnn_left
alias nnn_left='/home/tripham/bin/nnn -e -a -o -R -i -d -H -P p -s left -S'
alias nnn_right='/home/tripham/bin/nnn -e -a -o -R -i -d -H -P p -s right -S'
export LC_COLLATE="C"
export NNN_FIFO="/tmp/nnn.fifo"
export SPLIT='v'
