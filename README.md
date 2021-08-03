# SmartThings Edge Drivers

## What is SmartThings Edge?
SmartThings Edge is our new architecture for Hub Connected devices that uses Device Drivers to execute commands locally on SmartThings Hubs. Edge Drivers are [Lua©-based](https://www.lua.org/) and can be used for Hub Connected devices, including Zigbee, Z-Wave, and LAN protocols. SmartThings Edge will bring new benefits such as reduced latency and cloud costs.


## Getting Started
In this repository, you’ll find different ready-to-install sample Edge Drivers that can help you integrate your devices to the SmartThings platform.
For more information on building Edge Drivers, look at the resources in [More Information](#More-Information)

## Zigbee SmartThings Multipurpose sensor
Example integrating a SmartThings Multipurpose sensor, which is has the following Capabilities:
 - Contact Sensor
 - Temperature Measurement
 - Acceleration/Vibration Sensor
 - Three Axis Sensor

[Sample Code](https://github.com/SmartThingsDevelopers/DeviceDrivers/blob/main/st-multipurpose-sensor)


## LAN RGB Light Bulb
Example integrating an ESP8266 board via LAN. This device is configured to work as a RGB Light Bulb and uses the following Capabilities:
  - Switch
  - Switch Level
  - Color Control

[Sample Code](https://github.com/SmartThingsDevelopers/DeviceDrivers/blob/main/lightbulb-lan-esp8266)


## Z-Wave Aeotec Tri Sensor
Example integrating the Aeotec’s Tri Sensor which has the following Capabilities:
 - Motion Sensor
 - Illuminance Measurement
 - Temperature Measurement

[Sample Code](https://github.com/SmartThingsDevelopers/DeviceDrivers/blob/main/aeotec-trisensor)

## Installation Tutorial
Make sure you have the following:
1. The latest version of the SmartThings app ([Android](https://play.google.com/store/apps/details?id=com.samsung.android.oneconnect) | [iOS](https://apps.apple.com/us/app/smartthings/id1222822904))
2. A SmartThings Hub with firmware version 38.x or greater
3. A compatible device ready to be integrated:

   a. Battery's level is enough for the device functionality (Zigbee Multi Sensor and Aeotec Tri Sensor)
   
   b. The device was previously excluded from the Z-Wave network or is a fresh installation (Aeotec Tri Sensor)
   
   c. You've installed the [LightBulb App](https://github.com/SmartThingsDevelopers/DeviceDrivers/tree/main/lightbulb-lan-esp8266/app) in the ESP8266 NodeMCU board and it's wired according to the [schematics](https://github.com/SmartThingsDevelopers/DeviceDrivers/tree/main/lightbulb-lan-esp8266/app#schematics) (LAN Lightbulb)

You'll find further installation instructions in each sample and in the Tutorial Community posts:
* [Zigbee SmartThings Multipurpose sensor Tutorial](https://community.smartthings.com/t/creating-drivers-for-zigbee-devices-with-smartthings-edge/229502)
* [LAN RGB Light Bulb Tutorial](https://community.smartthings.com/t/creating-drivers-for-lan-devices-with-smartthings-edge/229501)
* [Z-Wave Aeotec Tri Sensor Tutorial](https://community.smartthings.com/t/creating-drivers-for-zwave-devices-with-smartthings-edge/229503)

## More Information
Take a look at the announcement of [SmartThings Edge](https://community.smartthings.com/t/announcing-smartthings-edge/229555) in our Community.

## Support
If you have any questions about the specification document, visit [community.smartthings.com](community.smartthings.com).
