local Configuration = (require "st.zwave.CommandClass.Configuration")({ version = 1 })
local capabilities = require "st.capabilities"
local ZwaveDriver = require "st.zwave.driver"
local defaults = require "st.zwave.defaults"
local cc = require "st.zwave.CommandClass"
local preferencesMap = require "preferences"
local log = require "log"


local ZWAVE_MOTION_TEMP_LIGHT_SENSOR_FINGERPRINTS = {
  {mfr = 0x0371, prod = 0x0002, model = 0x0005}, -- ZW005-C EU Aeotec TriSensor
  {mfr = 0x0371, prod = 0x0102, model = 0x0005}, -- ZW005-A US Aeotec TriSensor
  {mfr = 0x0371, prod = 0x0202, model = 0x0005}  -- ZW005-B AU Aeotec TriSensor
}

local function can_handle_zwave_motion_temp_light_sensor(opts, driver, device, ...)
  for _, fingerprint in ipairs(ZWAVE_MOTION_TEMP_LIGHT_SENSOR_FINGERPRINTS) do
    if device:id_match(fingerprint.mfr, fingerprint.prod, fingerprint.model) then
      return true
    end
  end
  return false
end

local function parameterNumberToParameterName(preferences,parameterNumber)
  for id, parameter in pairs(preferences) do
    if parameter.parameter_number == parameterNumber then
      return id
    end
  end
end

--Update when a WakeUp notification is received
local function update_preferences(self, device, args)
  for id, value in pairs(device.preferences) do
    local oldPreferenceValue = args.old_st_store.preferences[id]
    local newParameterValue = tonumber(device.preferences[id])
    local syncValue = device:get_field(id)
    if preferencesMap[id] and (oldPreferenceValue ~= newParameterValue or syncValue == false) then
      device:send(Configuration:Set({parameter_number = preferencesMap[id].parameter_number, size = preferencesMap[id].size, configuration_value = newParameterValue}))
      device:set_field(id, false, {persist = true})
      device:send(Configuration:Get({parameter_number = preferencesMap[id].parameter_number}))
    end
  end
end

--Verify if the preference where set in the device
local function configuration_report(driver, device, cmd)
  if preferencesMap then
    local parameterName = parameterNumberToParameterName(preferencesMap, cmd.args.parameter_number)
    local configValueSetByUser = device.preferences[parameterName]
    local configValueReportedByDevice = cmd.args.configuration_value
    if (parameterName and configValueSetByUser == configValueReportedByDevice) then
      device:set_field(parameterName, true, {persist = true})
    end
  end
end

local function init_dev(self, device)
  if preferencesMap then
    device:set_update_preferences_fn(update_preferences)
    for id, _  in pairs(preferencesMap) do
      device:set_field(id, true, {persist = true})
    end
  end
end

local driver_template = {
  zwave_handlers = {
    [cc.CONFIGURATION] = {
      [Configuration.REPORT] = configuration_report
    }
  },
  supported_capabilities = {
    capabilities.motionSensor,
    capabilities.temperatureMeasurement,
    capabilities.illuminanceMeasurement,
    capabilities.battery,
  },
  lifecycle_handlers = {
    init = init_dev
  },
  NAME = "zwave aeotec trisensor",
  can_handle = can_handle_zwave_motion_temp_light_sensor,
}

--[[
  The default handlers take care of the Command Classes and the translation to capability events 
  for most devices, but you can still define custom handlers to override them.
]]--

defaults.register_for_default_handlers(driver_template, driver_template.supported_capabilities)
local triSensor = ZwaveDriver("zwave-aeotec-trisensor", driver_template)
triSensor:run()