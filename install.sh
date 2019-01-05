#!/bin/bash
ln -s $(pwd)/vimrc ~/.vimrc

mkdir -p ~/.config/openbox
ln -s $(pwd)/openbox/autostart ~/.config/openbox/autostart
ln -s $(pwd)/openbox/menu.xml ~/.config/openbox/menu.xml
ln -s $(pwd)/openbox/rc.xml ~/.config/openbox/rc.xml
echo "source $(pwd)/bashrc" >> ~/.bashrc

