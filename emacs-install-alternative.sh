# from http://blog.renaud.io/blog/2011/11/01/build-and-setup-gnu-emacs-24-from-git-the-alternatives-way-on-debian-gnu-linux/
# Sets the emacs25 built and isntalled to /usr/local/bin to the main alternative, as well as the related tools.

for i in etags ctags emacsclient ebrowse rcs-checkin grep-changelog emacs
do
    if [ -f /usr/local/bin/$i ]; then
        if [ -f /usr/local/bin/$i.emacs25 ]; then
            rm /usr/local/bin/$i.emacs25
        fi
        mv /usr/local/bin/$i /usr/local/bin/$i.emacs25
    fi
done

if [ -f /usr/local/bin/emacs.emacs25 ]; then
    if [ -f /usr/local/bin/emacs25-x ]; then
        rm /usr/local/bin/emacs25-x
    fi
    ln -s /usr/local/bin/emacs.emacs25 /usr/local/bin/emacs25-x
fi

sudo update-alternatives --install /usr/bin/emacs emacs \
  /usr/local/bin/emacs25-x 30 \
  --slave /usr/share/icons/hicolor/128x128/apps/emacs.png emacs-128x128.png \
  /usr/local/share/icons/hicolor/128x128/apps/emacs.png \
  --slave /usr/share/icons/hicolor/16x16/apps/emacs.png emacs-16x16.png \
  /usr/local/share/icons/hicolor/16x16/apps/emacs.png \
  --slave /usr/share/icons/hicolor/24x24/apps/emacs.png emacs-24x24.png \
  /usr/local/share/icons/hicolor/24x24/apps/emacs.png \
  --slave /usr/share/icons/hicolor/32x32/apps/emacs.png emacs-32x32.png \
  /usr/local/share/icons/hicolor/32x32/apps/emacs.png \
  --slave /usr/share/icons/hicolor/48x48/apps/emacs.png emacs-48x48.png \
  /usr/local/share/icons/hicolor/48x48/apps/emacs.png \
  --slave /usr/share/icons/hicolor/scalable/mimetypes/emacs-document.svg emacs-document.svg \
  /usr/local/share/icons/hicolor/scalable/mimetypes/emacs-document.svg \
  --slave /usr/share/man/man1/emacs.1.gz emacs.1.gz \
  /usr/local/share/man/man1/emacs.1.gz \
  --slave /usr/share/icons/hicolor/scalable/apps/emacs.png emacs.svg \
  /usr/local/share/icons/hicolor/scalable/apps/emacs.svg

sudo update-alternatives --install /usr/bin/etags etags \
  /usr/local/bin/etags.emacs25 35 \
  --slave /usr/share/man/man1/etags.1.gz etags.1.gz \
  /usr/local/share/man/man1/etags.1.gz

sudo update-alternatives --install /usr/bin/ctags ctags \
  /usr/local/bin/ctags.emacs25 35 \
  --slave /usr/share/man/man1/ctags.1.gz ctags.1.gz \
  /usr/local/share/man/man1/ctags.1.gz

sudo update-alternatives --install /usr/bin/emacsclient emacsclient \
  /usr/local/bin/emacsclient.emacs25 30 \
  --slave /usr/share/man/man1/emacsclient.1.gz emacsclient.1.gz \
  /usr/local/share/man/man1/emacsclient.1.gz

sudo update-alternatives --install /usr/bin/ebrowse ebrowse \
  /usr/local/bin/ebrowse.emacs25 30 \
  --slave /usr/share/man/man1/ebrowse.1.gz ebrowse.1.gz \
  /usr/local/share/man/man1/ebrowse.1.gz

sudo update-alternatives --install /usr/bin/rcs-checkin rcs-checkin \
  /usr/local/bin/rcs-checkin.emacs25 30 \
  --slave /usr/share/man/man1/rcs-checkin.1.gz rcs-checkin.1.gz \
  /usr/local/share/man/man1/rcs-checkin.1.gz

sudo update-alternatives --install /usr/bin/grep-changelog \
  grep-changelog /usr/local/bin/grep-changelog.emacs25 30 \
  --slave /usr/share/man/man1/grep-changelog.1.gz grep-changelog.1.gz \
  /usr/local/share/man/man1/grep-changelog.1.gz
