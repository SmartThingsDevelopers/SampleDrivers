# SmartThings Edge Drivers

## What is SmartThings Edge?

SmartThings Edge is our new architecture for Hub Connected devices that uses Device Drivers to execute commands locally on SmartThings Hubs. Edge Drivers are [Lua©-based](https://www.lua.org/) and can be used for Hub Connected devices, including Zigbee, Z-Wave, and LAN protocols. SmartThings Edge will bring new benefits such as reduced latency and cloud costs.

## Getting Started

In this repository, you’ll find different ready-to-install sample Edge Drivers that can help you integrate your devices to the SmartThings platform.
For more information on building Edge Drivers, look at the resources in [More Information](#More-Information)

## Zigbee SmartThings Multipurpose sensor

Example integrating a SmartThings Multipurpose sensor, which has the following Capabilities:

- Contact Sensor
- Temperature Measurement
- Acceleration/Vibration Sensor
- Three Axis Sensor

[Sample Code](./st-multipurpose-sensor)

## LAN RGB Light Bulb

Example integrating an ESP8266 board via LAN. This device is configured to work as a RGB Light Bulb and has the following Capabilities:

- Switch
- Switch Level
- Color Control

[Sample Code](./lightbulb-lan-esp8266)

## Z-Wave Aeotec MultiSensor 6

Example integrating the Aeotec’s MultiSensor 6 which has the following Capabilities:

- Motion Sensor
- Illuminance Measurement
- Temperature Measurement

[Sample Code](./aeotec-multisensor)

## `thingsim` device simulator

Example **LAN Device Integration** through an **RPC Server** which supports the following capabilities:

- Switch

[Sample Code](./thingsim)

## Custom Capability Integration

Example **Zigbee Driver** that implements a single-attribute custom capability.

- _<namespace>.fancySwitch_
- Refresh

[Sample Code](./custom-capability)

## Hello World example

Example Driver to get started with **LAN-based device integrations**. This basic implmentation supports the following capabilities:

- Switch

[Sample Code](./hello-world)

## Installation Tutorial

Make sure you have the following:

1. The latest version of the SmartThings app ([Android](https://play.google.com/store/apps/details?id=com.samsung.android.oneconnect) | [iOS](https://apps.apple.com/us/app/smartthings/id1222822904))
2. A SmartThings Hub with firmware version 38.x or greater
3. A compatible device ready to be integrated:

   a. Battery's level is enough for the device functionality (Zigbee Multi Sensor and Aeotec MultiSensor 6)

   b. The device was previously excluded from the Z-Wave network or is a fresh installation (Aeotec MultiSensor 6)

   c. You've installed the [LightBulb App](https://github.com/SmartThingsDevelopers/DeviceDrivers/tree/main/lightbulb-lan-esp8266/app) in the ESP8266 NodeMCU board and it's wired according to the [schematics](https://github.com/SmartThingsDevelopers/DeviceDrivers/tree/main/lightbulb-lan-esp8266/app#schematics) (LAN Lightbulb)

You'll find further installation instructions in each sample and in the Tutorial Community posts:

- [Zigbee SmartThings Multipurpose sensor Tutorial](https://community.smartthings.com/t/creating-drivers-for-zigbee-devices-with-smartthings-edge/229502)
- [LAN RGB Light Bulb Tutorial](https://community.smartthings.com/t/creating-drivers-for-lan-devices-with-smartthings-edge/229501)
- [Z-Wave Aeotec MultiSensor 6 Tutorial](https://community.smartthings.com/t/creating-drivers-for-zwave-devices-with-smartthings-edge/229503)
- [Tutorial | Writing an RPC Client Edge Device Driver](https://community.smartthings.com/t/tutorial-writing-an-rpc-client-edge-device-driver/230285)

## More Information

Take a look at the announcement of [SmartThings Edge](https://community.smartthings.com/t/announcing-smartthings-edge/229555) in our Community.

## Support

If you have any questions about the specification document, visit [community.smartthings.com](https://community.smartthings.com/c/developer-programs).
