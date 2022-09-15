#installs all Plugins from brummer

pushd $(mktemp -d) && git clone https://github.com/brummer10/GxPlugins.lv2.git
cd *
git submodule init
git submodule update
make
sudo make install
sudo mv /usr/lib/lv2/* /home/modpi/.lv2/
