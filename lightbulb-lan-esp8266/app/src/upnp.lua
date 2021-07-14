-------------------------
-- HTTP Response Parser
local function httpparse(payload)
  local data = { status='', headers={} }
  data.status = payload:sub(0, payload:find('\r\n'))
  for k, v in payload:gmatch('(%w+[%w+-]+): ([%w+-: ()/=;]+)') do
    data.headers[k:lower()] = v
  end
  return data
end
----------------
-- UPnP listener
-- for SSDP flow
function upnp_start()
  net.multicastJoin('', MC_ADDR)

  local SSDP_RES = table.concat({
    'HTTP/1.1 200 OK',
    'Cache-Control: max-age=100',
    'EXT:',
    'SERVER: NodeMCU/Lua5.1.4 UPnP/1.1 '..DEV.NAME..'/0.1',
    'ST: upnp:rootdevice',
    'USN: uuid:'..DEV.CHIP_ID..'-'..DEV.SN,
    'Location: http://'..wifi.sta.getip()..':80/'..DEV.NAME..'.xml'
  }, '\r\n')

  -- Listen on-demand M-SEARCH streams.
  local function recv_cb(conn, payload, port, ip)
    local req = httpparse(payload)
    local headers = req.headers

    print('INCOMING TRAFFIC:\r\n'..payload..'\r\n')
    if req and req.status:find('M-SEARCH') then
      if headers.st:find(DEV.MN) and headers.st:find(DEV.NAME) then
        --print('DISCOVERY STREAM:\r\n'..payload..'\r\n')
        print('SSDP RESPONSE:\r\n'..SSDP_RES..'\r\n')
         --Send SSDP repsonse
        conn:send(port, ip, SSDP_RES)
        SSDP_RES = nil
        req = nil
        collectgarbage()
      end
    end
  end

  -- Close UDP socket
  -- end  session
  local function close_cb(conn)
    conn:close()
    net.multicastLeave('', MC_ADDR)
  end

  -- Init socket
  local upnp = net.createUDPSocket()
  upnp:on('receive', recv_cb)
  upnp:on('sent', close_cb)
  upnp:listen(MC_PORT, LOCAL_ADDR)
end
