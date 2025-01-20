#Create Centipid Bridge
/interface bridge
add name="Centipid Main bridge"

#rename ether1 to "INTERNET Source"
/interface ethernet
set [ find default-name=ether1 ] name="Internet Source"

#Create a Hotspot Profile
/ip hotspot profile
add hotspot-address=30.0.0.1 login-by=cookie,http-chap,http-pap,mac-cookie \
    name="Centipid Hotspot Profile" radius-interim-update=10m use-radius=yes

#Create Pool for Hotspot and Pppoe
/ip pool
add name="Centipid Pppoe Pool" ranges=60.0.0.1-60.0.0.254
add name="Centipid Hotspot Pool" ranges=30.0.0.2-30.0.0.254

#Create a dhcp server for hotspot pool
/ip dhcp-server
add address-pool="Centipid Hotspot Pool" disabled=no interface=\
    "Centipid Main bridge" lease-time=1h name="Centipid Dhcp Server"

#Create Centipid Hotspot Server
/ip hotspot
add address-pool="Centipid Hotspot Pool" addresses-per-mac=1 disabled=no \
    interface="Centipid Main bridge" name="Centipid Hotspot" profile=\
    "Centipid Hotspot Profile"

#Create Centipid Pppoe profile
/ppp profile
add dns-server=8.8.8.8,8.8.4.4 local-address="Centipid Pppoe Pool" name=\
    INTERNET remote-address="Centipid Pppoe Pool"


#Create Centipid pppoe Server
/interface pppoe-server server
add authentication=pap disabled=no interface="Centipid Main bridge" \
    one-session-per-host=yes service-name="Centipid Pppoe server"

#Hotspot Network
/ip address
add address=30.0.0.1/24 comment="hotspot network" interface=\
    "Centipid Main bridge" network=30.0.0.0
/ip dhcp-server network
add address=30.0.0.0/24 comment="hotspot network" gateway=30.0.0.1

#Firewall block for icmp and client isolation
/ip firewall filter
add action=passthrough chain=unused-hs-chain comment=\
    "place hotspot rules here" disabled=yes
add action=drop chain=input comment="ICMP Block on Centipid Bridge" \
    in-interface="Centipid Main bridge" protocol=icmp
add action=drop chain=forward comment="Client Isolution for Hotspot" \
    dst-address=30.0.0.0/24 in-interface="Centipid Main bridge" src-address=\
    30.0.0.0/24
add action=drop chain=forward comment="Client Isolution for Pppoe" \
    dst-address=60.0.0.0/24 in-interface="Centipid Main bridge" src-address=\
    60.0.0.0/24


#Mangle rule for antishairing and hide router ip
/ip firewall mangle
add action=change-ttl chain=postrouting comment=\
    "Centipid Hotspot Anti-shairing" new-ttl=set:1 out-interface=\
    "Centipid Main bridge" passthrough=yes
add action=change-ttl chain=prerouting comment="Router Hide IP" new-ttl=\
    increment:2 passthrough=yes

#NAT rule for hotspot and pppoe
/ip firewall nat
add action=masquerade chain=srcnat comment=\
    "Masquerade Centipid Pppoe network" out-interface="Internet Source"
add action=passthrough chain=unused-hs-chain comment=\
    "place hotspot rules here" disabled=yes
add action=masquerade chain=srcnat comment=\
    "Centipid masquerade hotspot network" src-address=30.0.0.0/24


#set time to Nairobi Kenya
/system clock
set time-zone-autodetect=no time-zone-name=Africa/Nairobi

