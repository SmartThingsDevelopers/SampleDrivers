# LAN Driver for custom ESP8266 LightBulb

## Prerequisites

Any version SmartThings Hub with firmware version 38.x or greater and a LAN device ready to connect.

For this tutorial, we used an ESP8266 but the same principles can be used to integrate any LAN-based device that supports SSDP and HTTP.

1. Setup the [SmartThings CLI](https://github.com/SmartThingsCommunity/smartthings-cli) according to the [configuration document](https://github.com/SmartThingsCommunity/smartthings-cli/blob/master/packages/cli/doc/configuration.md).
1. Install the [Edge CLI Plugin](https://github.com/SmartThingsCommunity/edge-alpha-cli-plugin#smartthings-edge-alpha-cli-plugin).

## Uploading your Driver to SmartThings

1.  Compile the driver:

```
    smartthings edge:drivers:package driver/
```

2.  Install the driver and follow the prompt:

```
    smartthings edge:drivers:install <driver_id>
```

3. Use your WiFi router or the **[SmartThings IDE](https://account.smartthings.com/) > My Hubs** to locate and copy the IP Address for your Hub and run the _logcat_ command to connect to your Hub and begin listening to the Driver logs:

```
  smartthings edge:drivers:logcat --hub-address 192.168.X.XX <driver_id>
```

## Onboarding your New Device

1. Setup the ESP8266 board and embedded app according to [these instruction](../app/README.md).
2. Open the _SmartThings App_ and follow these steps _(notice that you must add the device in the same location your Hub is installed)_:

   - Select **Add (+)** and then **Device**.
   - Tap on **Scan nearby** and check the logs emitted at your _logcat_ session.

As soon as your device gets installed, the _Driver_ will send a
periodic _Ping HTTP Requests_ with **IP and Port** reference of the server that will
listen for external device updates at `X.X.X.X:XXXXX/push-state`.
