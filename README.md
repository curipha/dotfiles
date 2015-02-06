dotfiles
========
dotfiles for Linux/BSD/Cygwin.

`vimrc` and `gvimrc` are also used by Vim on Windows.
Refer to the `dotfiles_w` repository for what is used only on Windows.

About dotfiles
--------------
Description describes only what appears to be necessary.

### bash_profile
Hide bash and run zsh.
I made it because there was an environment where it could not `chsh`.

### fonts.conf
It can no longer change the font from the GUI in latter Ubuntu.
This is a response for it.

### zshrc
Execute the following command if your system does not provide C.UTF-8 locale by default.

```
sudo localedef -c -i POSIX -f UTF-8 C.UTF-8
```

About script
------------

### _setup.sh
Run it when clone this repository in new environment.
`~/.*rc` of symbolic links will be created.

Links
-----
- Migmix (Japanese font) http://mix-mplus-ipa.sourceforge.jp/migmix/

