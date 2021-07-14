local Driver = require('st.driver')
local caps = require('st.capabilities')

-- local imports
local discovery = require('discovery')
local lifecycles = require('lifecycles')
local commands = require('commands')
local server = require('server')

--------------------
-- Driver definition
local driver =
  Driver(
    'LAN-LightBulb',
    {
      discovery = discovery.start,
      lifecycle_handlers = lifecycles,
      supported_capabilities = {
        caps.switch,
        caps.switchLevel,
        caps.colorControl,
        caps.refresh
      },
      capability_handlers = {
        -- Switch command handler
        [caps.switch.ID] = {
          [caps.switch.commands.on.NAME] = commands.on_off,
          [caps.switch.commands.off.NAME] = commands.on_off
        },
        -- Switch Level command handler
        [caps.switchLevel.ID] = {
          [caps.switchLevel.commands.setLevel.NAME] = commands.set_level
        },
        -- Color Control command handler
        [caps.colorControl.ID] = {
          [caps.colorControl.commands.setColor.NAME] = commands.set_color
        },
        -- Refresh command handler
        [caps.refresh.ID] = {
          [caps.refresh.commands.refresh.NAME] = commands.refresh
        }
      }
    }
  )

---------------------------------------
-- Switch control for external commands
function driver:on_off(device, on_off)
  if on_off == 'off' then
    return device:emit_event(caps.switch.switch.off())
  end
  return device:emit_event(caps.switch.switch.on())
end

---------------------------------------------
-- Switch level control for external commands
function driver:set_level(device, lvl)
  if lvl == 0 then
    device:emit_event(caps.switch.switch.off())
  else
    device:emit_event(caps.switch.switch.on())
  end
  return device:emit_event(caps.switchLevel.level(lvl))
end

-----------------------------
-- Initialize Hub server
-- that will open port to
-- allow bidirectional comms.
server.start(driver)

--------------------
-- Initialize Driver
driver:run()
