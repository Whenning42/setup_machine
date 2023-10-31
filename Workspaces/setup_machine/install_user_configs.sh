# Ask for confirmation on overwrite be default.
# Other options to consider include "-n" for no
# clobber and "" for force overwrite.
EXTRA_FLAGS="-i"
REPO="https://github.com/Whenning42/setup_machine"

git init
git remote add origin $REPO
git fetch
cd install_scripts
cp $EXTRA_FLAGS .config/i3/config ~/.config/i3/config
cp $EXTRA_FLAGS .bashrc ~/.bashrc
cp $EXTRA_FLAGS .xinitrc ~/.xinitrc
cp $EXTRA_FLAGS .Xdefaults ~/.Xdefaults

