
cp -r -f wifi-hotspot.conf /etc/dnsmasq.d/
cp -r -f hostapd.conf /etc/hostapd/
cp -r -f ifupdown.sh /etc/hostapd/
cp -r -f dnsmasq.conf /etc/

mkdir /usr/lib/wifi-hotspot/
cp -r -f disable_wifi_hotspot.sh /usr/lib/wifi-hotspot/
cp -r -f enable_wifi_hotspot.sh /usr/lib/wifi-hotspot/

cp wifi-hotspot.service /usr/lib/systemd/system/wifi-hotspot.service

systemctl daemon-reload
systemctl start wifi-hotspot.service
systemctl enable wifi-hotspot.service
