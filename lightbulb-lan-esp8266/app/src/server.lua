local res = require('responses')

----------------------
-- Query String Parser
local function qsparse(str)
  local res = {}
  for k,v in str:gmatch('([%w-_]+)=([%w+-_!@#$%^]+)') do
    res[k:lower()] = v
  end
  return res
end
-----------------------
-- HTTP Response Parser
local function httpparse(data)
  local res = {}
  res.status = data:sub(0, data:find('\r\n'))
  for k, v in data:gmatch('([%w-]+): ([%a+-: /=]+)') do
    res[k:lower()] = v
  end
  return res
end

--------------------
-- Push Remote State
local function push_state(data)
  if not DEV.HUB.addr or not DEV.HUB.port then
    print('NO HUB REGISTERED')
    return nil
  end

  -- Prepare URL
  local url = string.format(
    'http://%s:%s/push-state', DEV.HUB.addr, DEV.HUB.port)
  -- JSONstringify table
  data.uuid = DEV.HUB.ext_uuid
  local data = sjson.encode(data)

  print('PUSH STATE\r\nURL:  '..url..
        '\r\nDATA: '..data)
  return http.post(
    url,'Content-Type: application/json\r\n',data,
    function(code, data) print(code, data) end)
end

-----------------
-- ESP8266 Server
function server_start()
  -- Request receiver calback
  local function recv_cb(conn, data)
    print('INCOMING HTTP REQUEST:\r\n'..data)
    -- parse query string
    local httpdata = httpparse(data)
    local qs = qsparse(httpdata.status)

    -- Collect WiFi Configuration
    -- params to initialize Wifi
    -- Station service.
    if qs.ssid and qs.pwd then
      wifi_sta_start(qs.ssid, qs.pwd)
      conn:send(
        res.ok_200(res.REDIRECT_VIEW))

    -- Resource that provides the
    -- metadata of the device.
    -- This resource is provided
    -- via ssdp response.
    elseif httpdata.status:find(DEV.NAME..'.xml') then
      return conn:send(
        res.ok_200(res.DEVICE_INFO_XML))

    -- Resource that will allow to
    -- register a parent node (Hub)
    -- storing its address and port.
    elseif httpdata.status:find('/ping?') then
      if qs.ip and qs.port then
        DEV.HUB.addr = qs.ip
        DEV.HUB.port = qs.port
        DEV.HUB.ext_uuid = qs.ext_uuid
        print(
          '\r\nPING\r\n'..
          'HUB LOCATION:    http://'..
          qs.ip..':'..qs.port..
          '\r\nEXT_UUID:        '..qs.ext_uuid..'\r\n')
        return conn:send(res.ok_200())
      end

    -- Resource that will allow
    -- device state poll retrieving
    -- the raw state at the DEV.cache
    -- table JSON formatted.
    elseif httpdata.status:find('/refresh') then
      return conn:send(res.ok_200(DEV.cache))

    -- Resource that allows to
    -- unlink the registered
    -- parent node (Hub)
    elseif httpdata.status:find('/delete') then
      print('HUB REVOKED')
      DEV.HUB.addr = nil
      DEV.HUB.port = nil
      DEV.HUB.ext_uuid = nil
      return conn:send(
        res.ok_200())

    -- Resource that allows device
    -- control either at the ST App
    -- or at browsers
    elseif httpdata.status:find('/control') then
      local push_data = nil
      -- Switch
      if qs.switch then
        led_switch_ctl(qs.switch)
        push_data = {switch=qs.switch}
      -- Switch Level
      elseif qs.level then
        led_lvl_ctl(tonumber(qs.level))
        push_data = {level=qs.level}
      -- Color Control
      elseif qs.red or qs.green or qs.blue then
        led_clr_ctl(
          tonumber(qs.red),
          tonumber(qs.green),
          tonumber(qs.blue))
      end

      -- If request came from
      -- browser control view
      if httpdata['user-agent'] ~= nil then
        -- Try to push state to
        -- Hub for bidirectional
        -- comms (device built-in
        -- /control page).
        if push_data ~= nil then
          push_state(push_data)
        end

        conn:send(
          res.ok_200(res.CONTROL_VIEW))
        push_data = nil
        collectgarbage()
        return
      end
      -- Simple Response
      -- for socket comm
      -- on /control
      return conn:send(
        res.ok_200())
    else
      -- wifi setting default
      conn:send(
        res.ok_200(res.WIFI_CONFIG_VIEW))
    end -- end routing
    qs = nil
    httpdata = nil
    collectgarbage()
  end -- receive callback

  local server = net.createServer(net.TCP)
  server:listen(SRV_PORT, function(conn)
    conn:on('receive', recv_cb)
    conn:on('sent', function(conn) conn:close() end) -- close connection
  end)
end
