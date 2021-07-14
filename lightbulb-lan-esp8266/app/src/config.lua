----------------
-- Socket Config
-- UDP UPnP
MC_PORT=1900
LOCAL_ADDR='0.0.0.0'
MC_ADDR='239.255.255.250'
-- TCP Server
SRV_PORT=80

--------------------
-- Wifi Access Point
-- config
WIFI_AP_CONFIG = {
  ssid='LightBulb-ESP8266',
  pwd='dummy-passphrase',
  save=true,
  hidden=false,
  max=1
}

--------------
-- Device info
DEV = {
  CHIP_ID=string.format('%x', node.chipid()),
  SN='SN-ESP8266-696',
  MN='SmartThingsCommunity',
  NAME='LightBulbESP8266',
  TYPE='LAN',
  ext_uuid=nil,
  cache={
    lvl=0, -- 0%/off
    clr={r=0,g=0,b=0} -- e.g. 255 each
  },
  HUB = { addr=nil, port=nil }
}

--------------
-- GPIO config
MAIN_GPIO=1
RED_GPIO=5
GREEN_GPIO=6
BLUE_GPIO=7
PWM_FREQ=800
PULSE_PRD=255
