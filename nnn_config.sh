# nnn configurations
export NNN_PLUG='*:fzplug;/:fzsearch;c:my_copy_path;C:my_fz_cmd;d:dragdrop;e:!code-insiders "$nnn"*;E:!code-insiders "$(dirname "$nnn")"*;f:my_fj_cmd;F:fzcd;j:my_z_cmd;i:my_fzf_image_preview;I:imgview;l:my_lfrun;o:my_open_with;O:my_open_with_options;p:preview-tui;Q:my_nnn_quitall;n:cppath;s:my_fz_open_with;t:preview-tabbed;v:vidthumb;w:ctx_switcher;x:!ark -ba "$nnn" 2>/dev/null 1>/dev/null & *;X:!chmod +x $nnn;z:my_zi_cmd;'
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
