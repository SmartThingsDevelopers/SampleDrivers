local socket = require('socket')
local cosock = require "cosock"
local http = cosock.asyncify "socket.http"
local ltn12 = require('ltn12')
local log = require('log')
local config = require('config')
-- XML modules
local xml2lua = require "xml2lua"
local xml_handler = require "xmlhandler.tree"

-----------------------
-- SSDP Response parser
local function parse_ssdp(data)
  local res = {}
  res.status = data:sub(0, data:find('\r\n'))
  for k, v in data:gmatch('([%w-]+): ([%a+-: /=]+)') do
    res[k:lower()] = v
  end
  return res
end

-- Fetching device metadata via
-- <device_location>/<device_name>.xml
-- from SSDP Response Location header
local function fetch_device_info(url)
  log.info('===== FETCHING DEVICE METADATA...')
  local res = {}
  local _, status = http.request({
    url=url,
    sink=ltn12.sink.table(res)
  })

  -- XML Parser
  local xmlres = xml_handler:new()
  local xml_parser = xml2lua.parser(xmlres)
  xml_parser:parse(table.concat(res))

  -- Device metadata
  local meta = xmlres.root.root.device

  if not xmlres.root or not meta then
    log.error('===== FAILED TO FETCH METADATA AT: '..url)
    return nil
  end

  return {
    name=meta.friendlyName,
    vendor=meta.UDN,
    mn=meta.manufacturer,
    model=meta.modelName,
    location=url:sub(0, url:find('/'..meta.friendlyName)-1)
  }
end

-- This function enables a UDP
-- Socket and broadcast a single
-- M-SEARCH request, i.e., it
-- must be looped appart.
local function find_device()
  -- UDP socket initialization
  local upnp = socket.udp()
  upnp:setsockname('*', 0)
  upnp:setoption('broadcast', true)
  upnp:settimeout(config.MC_TIMEOUT)

  -- broadcasting request
  log.info('===== SCANNING NETWORK...')
  upnp:sendto(config.MSEARCH, config.MC_ADDRESS, config.MC_PORT)

  -- Socket will wait n seconds
  -- based on the s:setoption(n)
  -- to receive a response back.
  local res = upnp:receivefrom()

  -- close udp socket
  upnp:close()

  if res ~= nil then
    return res
  end
  return nil
end

local function create_device(driver, device)
  log.info('===== CREATING DEVICE...')
  log.info('===== DEVICE DESTINATION ADDRESS: '..device.location)
  -- device metadata table
  local metadata = {
    type = config.DEVICE_TYPE,
    device_network_id = device.location,
    label = device.name,
    profile = config.DEVICE_PROFILE,
    manufacturer = device.mn,
    model = device.model,
    vendor_provided_label = device.UDN
  }
  return driver:try_create_device(metadata)
end

-- Discovery service which will
-- invoke the above private functions.
--    - find_device
--    - parse_ssdp
--    - fetch_device_info
--    - create_device
--
-- This resource is linked to
-- driver.discovery and it is
-- automatically called when
-- user scan devices from the
-- SmartThings App.
local disco = {}
function disco.start(driver, opts, cons)
  while true do
    local device_res = find_device()

    if device_res ~= nil then
      device_res = parse_ssdp(device_res)
      log.info('===== DEVICE FOUND IN NETWORK...')
      log.info('===== DEVICE DESCRIPTION AT: '..device_res.location)

      local device = fetch_device_info(device_res.location)
      return create_device(driver, device)
    end
    log.error('===== DEVICE NOT FOUND IN NETWORK')
  end
end

return disco
