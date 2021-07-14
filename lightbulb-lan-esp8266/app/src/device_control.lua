---------------------
-- LED Switch - Level
function led_lvl_ctl(lvl)
  lvl = (PULSE_PRD / 100) * lvl
  DEV.cache.lvl = lvl
  return pwm2.set_duty(MAIN_GPIO, math.floor(lvl))
end

--------------------
-- LED Color Control
function led_clr_ctl(r, g, b)
  DEV.cache.clr.r = r
  DEV.cache.clr.g = g
  DEV.cache.clr.b = b
  -- due to common anode rgb led,
  -- values will be opposite,
  -- e.g. 255 = off, 0 = on
  pwm2.set_duty(RED_GPIO, (PULSE_PRD - DEV.cache.clr.r))
  pwm2.set_duty(GREEN_GPIO, (PULSE_PRD - DEV.cache.clr.g))
  pwm2.set_duty(BLUE_GPIO, (PULSE_PRD - DEV.cache.clr.b))
  return
end

---------------------
-- LED Switch Control
function led_switch_ctl(on_off)
  if on_off == 'off' then
    return pwm2.set_duty(MAIN_GPIO, 0)
  end

  if DEV.cache.lvl == 0 then
    return pwm2.set_duty(MAIN_GPIO, 255)
  end
  return pwm2.set_duty(
    MAIN_GPIO, math.floor(DEV.cache.lvl))
end
