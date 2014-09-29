#
# .xinitrc (2014-9-29)
#

# Language
export LANG=ja_JP.UTF-8
export LANGUAGE=ja_JP.UTF-8

# Input method
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"


# Application
xcompmgr &

exec startlxde

