local res_handler = {}

function res_handler.ok_200(body)
  -- Monkey patch on default header
  -- because the Driver socket.http/ltn12
  -- response handler fails to
  -- handle text/plain responses
  --
  -- Update below when fixed:
  --local cnt_type = 'text/plain'
  local cnt_type = ''
  local status = 'HTTP/1.1 200 OK'
  local cache_stat = 'Cache-Control : no-cache, private'

  -- Handle NULL response body
  body = body or ''

  -- Handle Content-Type Header
  if type(body) == 'string' then
    -- HTML Response
    if body:find('html') then
      cnt_type = 'Content-Type: text/html'
    -- XML Response
    elseif body:find('xml') then
      cnt_type = 'Content-Type: text/xml'
    end
  -- JSON Response
  elseif type(body) == 'table' then
    cnt_type = 'Content-Type: application/json'
    body = sjson.encode(body)
  end

  -- Handle Content-Length Header
  local cnt_length = 'Content-Length: '..#body

  -- Build response
  local res = {}
  table.insert(res, status)
  table.insert(res, cache_stat)
  table.insert(res, cnt_length)
  table.insert(res, cnt_type)

  res = {table.concat(res, '\r\n'), body}
  return table.concat(res, '\r\n\r\n')
end

-- HTML Views
res_handler.WIFI_CONFIG_VIEW =
  [[<!DOCTYPE html><html>
  <head>
  <meta name="viewport"
  content="width=device-width, initial-scale=1">
  </head>
  <body>
  <h3>Wifi setup</h3>
  <p>Configure your WiFi Router</p>
  <form>
    <label for="ssid">SSID:</label><br>
    <input type="text" id="ssid" name="ssid"><br>
    <label for="pwd">Password:</label><br>
    <input type="password" id="pwd" name="pwd"><br>
    <br>
    <button type="submit">Connect</button>
  </form>
  </body>
  </html>]]

res_handler.REDIRECT_VIEW =
  [[<!DOCTYPE html><html>
  <head>
  <meta name="viewport"
  content="width=device-width, initial-scale=1">
  </head>
  <body>
    <h3>Connecting...</h3>
    <p>You can switch back to your main network...</p>
  </body>
  </html>]]

res_handler.CONTROL_VIEW=
  [[<!DOCTYPE html><html>
  <head>
  <meta name="viewport"
  content="width=device-width, initial-scale=1">
  </head>
  <body>
    <h2>Device Control</h2>
    <div>
    <h4>Switch</h4>
    <button onclick="onOff('on')">ON</button>
    <button onclick="onOff('off')">OFF</button>
    </div>
    <div>
    <h4>Switch Level</h4>
    <input type="range" min="0" max="100" value="0" id="switch-level">
    </div>
  <script>
    let slider = document.getElementById('switch-level');
    slider.onmouseup = () => sendLevel();
    // callback debouncer
    let debounce = (callback, timeout=300) => {
      let timer;
      return (...args) => {
        clearTimeout(timer);
        timer = setTimeout(() => { callback.apply(this, args); }, timeout);
      }
    }

    let onOff = debounce(async(val) => {
      console.log(`local command - switch=${val}`);
      await fetch(`/control?switch=${val}`);
    });

    let sendLevel = debounce(async() => {
      console.log(`local command - level=${slider.value}`);
      await fetch(`/control?level=${slider.value}`);
    })
  </script>
  </body>
  </html>]]

res_handler.DEVICE_INFO_XML =
table.concat({
  "<?xml version='1.0'?>",
  "<root xmlns='urn:schemas-upnp-org:device-1-0 configId='1'>",
  "<specVersion>",
    "<major>2</major>",
    "<minor>0</minor>",
  "</specVersion>",
  "<device>",
    "<deviceType>urn:SmartThingsCommunity:device:Light:1</deviceType>",
    "<presentationURL>/</presentationURL>",
    "<friendlyName>"..DEV.NAME.."</friendlyName>",
    "<manufacturer>"..DEV.MN.."</manufacturer>",
    "<manufacturerURL>https://community.smartthings.com</manufacturerURL>",
    "<modelName>RGB LightBulb</modelName>",
    "<serialNumber>"..DEV.SN.."</serialNumber>",
    "<UDN>uuid:"..DEV.CHIP_ID.."-"..DEV.SN.."</UDN>",
  "</device></root>"
}, '\r\n')

return res_handler
