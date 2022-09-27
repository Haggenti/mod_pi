#!/bin/bash -e

set -x
#Install Dependencies
sudo apt-get -y install jackd2 virtualenv python3-pip python3-dev git build-essential libasound2-dev libjack-jackd2-dev liblilv-dev libjpeg-dev zlib1g-dev cmake debhelper dh-autoreconf dh-python gperf intltool ladspa-sdk libarmadillo-dev libasound2-dev libavahi-gobject-dev libavcodec-dev libavutil-dev libbluetooth-dev libboost-dev libeigen3-dev libfftw3-dev libglib2.0-dev libglibmm-2.4-dev libgtk2.0-dev libgtkmm-2.4-dev libjack-jackd2-dev libjack-jackd2-dev liblilv-dev liblrdf0-dev libsamplerate0-dev libsigc++-2.0-dev libsndfile1-dev libsndfile1-dev libzita-convolver-dev libzita-resampler-dev lv2-dev p7zip-full python3-all python3-setuptools libreadline-dev zita-alsa-pcmi-utils hostapd dnsmasq iptables python3-smbus python3-dev liblo-dev libzita-alsa-pcmi-dev

#Install Python Dependencies
#https://github.com/moddevices/mod-ui/blob/master/requirements.txt
sudo pip3 install pyserial==3.0 pystache==0.5.4 aggdraw==1.3.11 scandir backports.shutil-get-terminal-size
sudo pip3 install pycrypto
sudo pip3 install tornado==4.3
sudo pip3 install Pillow==8.4.0
sudo pip3 install cython

#Install Mod Software
mkdir /home/raspberryUsername/.lv2
mkdir /home/raspberryUsername/data
mkdir /home/raspberryUsername/data/.pedalboards
mkdir /home/raspberryUsername/data/user-files
cd /home/raspberryUsername/data/user-files
mkdir "Speaker Cabinets IRs"
mkdir "Reverb IRs"
mkdir "Audio Loops"
mkdir "Audio Recordings"
mkdir "Audio Samples"
mkdir "Audio Tracks"
mkdir "MIDI Clips"
mkdir "MIDI Songs"
mkdir "Hydrogen Drumkits"
mkdir "SF2 Instruments"
mkdir "SFZ Instruments"

#jackd2
pushd $(mktemp -d) && git clone https://github.com/jackaudio/jack2.git
pushd jack2
./waf configure --prefix=/usr
./waf build
sudo ./waf install PREFIX=/usr

#Browsepy
pushd $(mktemp -d) && git clone https://github.com/moddevices/browsepy.git
pushd browsepy
sudo pip3 install ./

#Mod-host
pushd $(mktemp -d) && git clone --branch hotfix-1.11 https://github.com/moddevices/mod-host.git
pushd mod-host
make -j 4
sudo make install

#Mod-ui
pushd $(mktemp -d) && git clone --branch hotfix-1.12 https://github.com/moddevices/mod-ui.git
pushd mod-ui
chmod +x setup.py
cd utils
make
cd ..
sudo ./setup.py install

#Hylia - required for LINK sync Ableton Link
#pushd $(mktemp -d) && git clone https://github.com/CarloCattano/Hylia-pi4.git
#pushd Hylia-pi4
#make -j4
#sudo make install PREFIX=/usr

cd /home/raspberryUsername/mod_pi

#Create Services
sudo cp *.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable browsepy.service 
sudo systemctl enable jack.service
sudo systemctl enable mod-host.service 
sudo systemctl enable mod-ui.service

sudo gpasswd -a $USER audio

echo "@audio - rtprio 99" | sudo tee -a /etc/security/limits.conf
echo "@audio - memlock unlimited" | sudo tee -a /etc/security/limits.conf

echo "creating /etc/environment and setting jack promiscuous mode"
echo 'JACK_PROMISCUOUS_SERVER=jack' | sudo tee -a /etc/environment

echo "cleaning tmp folder"
sudo rm -rf /tmp/*

#fluisynth fix
sudo apt install libpulse-dev
sudo mv libfluidsynth.so.1 /usr/lib/aarch64-linux-gnu/libfluidsynth.so.1

#calf delay
sudo cp /lib/aarch64-linux-gnu/libpcre.so /lib/aarch64-linux-gnu/libpcre.so.1

#Plugin Libs
sudo apt install libc6-dev libcairo2-dev libx11-dev x11proto-dev lv2-dev liblilv-dev libfluidsynth-dev

#Disable unused services
sudo systemctl disable bluetooth.service
sudo systemctl disable hciuart.service
sudo systemctl disable ModemManager.service


echo "starting mod"
./startMod.sh
