# ===============
#  .xinitrc
# ===============

# Language
export LANG=ja_JP.UTF-8
export LANGUAGE=ja_JP.UTF-8

# Input method
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"


# X resources
[[ -s ~/.Xresources ]] && xrdb -merge ~/.Xresources

# Keyboard
setxkbmap -option ctrl:nocaps

# Application
xcompmgr &


exec startlxde

