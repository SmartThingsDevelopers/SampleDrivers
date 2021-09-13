------------------------
-- Load config & modules
dofile('config.lua')
dofile('device_control.lua')
dofile('server.lua')
dofile('upnp.lua')

---------------------------
-- Init Device Access Point
print([[
> LightBulb ESP8266 App Ready...
> WiFi Access Point enabled...
]])

wifi.setmode(wifi.STATIONAP)
wifi.ap.config(WIFI_AP_CONFIG)
-----------------------------
-- Init main network services
function wifi_sta_start(ssid, pwd) -- credentials will be forgotten as soon as device reboots
  local wifi_config = { ssid=ssid, pwd=pwd, save=true }
  wifi.sta.config(wifi_config)
  print('connecting to wifi...')
end

----------------------------
-- Init Switch and Switch
-- Level gpio off by default
pwm2.setup_pin_hz(MAIN_GPIO, PWM_FREQ, PULSE_PRD, DEV.cache.lvl) -- off
-- Due to the Common anode RGB
-- LED, duty is inverted
pwm2.setup_pin_hz(GREEN_GPIO, PWM_FREQ, PULSE_PRD, DEV.cache.clr.g)
pwm2.setup_pin_hz(RED_GPIO, PWM_FREQ, PULSE_PRD, DEV.cache.clr.r)
pwm2.setup_pin_hz(BLUE_GPIO, PWM_FREQ, PULSE_PRD, DEV.cache.clr.b)
pwm2.start()

--------------
-- init server
server_start()

---------------------
-- Wifi event monitor
-- callbacks:
--
-- STATION Connected
wifi.eventmon.register(
  wifi.eventmon.STA_CONNECTED,
  function(evt)
    print(
      'service: station\r\n'..
      'status:  connected\r\n'..
      'ssid:    '..evt.SSID..'\r\n'..
      'bssid:   '..evt.BSSID..'\r\n')
  end)

-- STATION Disconnected
wifi.eventmon.register(
  wifi.eventmon.STA_DISCONNECTED,
  function (evt)
    print(
      'service:  station\r\n'..
      'status:   disconnected\r\n'..
      'reason:   '..evt.reason..'\r\n'..
      'ssid:     '..evt.SSID..'\r\n'..
      'bssid:    '..evt.BSSID..'\r\n')
  end)

-- STATION IP ready
wifi.eventmon.register(
  wifi.eventmon.STA_GOT_IP,
  function (evt)
    print(
      'service:  station\r\n'..
      'status:   IP Address ready\r\n'..
      'action:   start UPnP Socket\r\n'..
      'netmask:  '..evt.netmask..'\r\n'..
      'gateway:  '..evt.netmask..'\r\n'..
      '>>> DEVICE AVAILABLE OVER LAN AT: '..evt.IP..'\r\n')
      -- initialize ssdp session
      upnp_start()
  end)

-- ACCESS POINT new client
wifi.eventmon.register(
  wifi.eventmon.AP_STACONNECTED,
  function (evt)
    print(
      'service:  access point\r\n'..
      'action:   start LAN AP socket\r\n'..
      'status:   client connected\r\n'..
      'MAC:      '..evt.MAC..'\r\n'..
      'AID:      '..evt.AID..'\r\n')
  end)
