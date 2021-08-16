# Sample Edge Driver for ESP8266 Light bulb

Model: NodeMCU ESP8266

Protocol: LAN

## Prerequisites

A SmartThings Hub with firmware version 38.x or greater and a LAN device ready to connect.

For this tutorial, we used an ESP8266 but the same principles can be used to integrate any LAN-based device that supports SSDP and HTTP.

1. Set up the SmartThings CLI according to the [configuration document](https://github.com/SmartThingsCommunity/smartthings-cli/blob/master/packages/cli/doc/configuration.md).
2. Add the [Edge Driver plugin](https://github.com/SmartThingsCommunity/edge-alpha-cli-plugin#set-up) to the CLI.
3. Configure your development environment for the [SmartThingsEdgeDrivers](https://github.com/SmartThingsCommunity/SmartThingsEdgeDriversBeta)

## Uploading Your Driver to SmartThings

_Note: Take a look at the installation tutorial in our [Developer's Community](https://community.smartthings.com/t/creating-drivers-for-zwave-devices-with-smartthings-edge/229503)._

1. Compile the driver:

```
smartthings edge:drivers:package driver/
```

2. Create a channel for your driver

```
smartthings edge:channels:create
```

3. Enroll your driver into the channel

```
smartthings edge:channels:enroll
```

4. Publish your driver to the channel

```
smartthings edge:drivers:publish
```

5. If the package was successfully created, you can call the command below and follow the on-screen prompts to install the Driver in your Hub:

```
smartthings edge:drivers:install
```

You should see the confirmation message: `Driver {driver-id} installed to Hub {hub-id}`

6. Use your WiFi router or the [SmartThings IDE](https://account.smartthings.com/login) > My Hubs to locate and copy the IP Address for your Hub.

7. From a computer on the same local network as your Hub, open a new terminal window and run the command to get the logs from all the installed drivers.

```
smartthings edge:drivers:logcat --hub-address=x.x.x.x -a
```

## Onboarding your New Device

1. Setup the ESP8266 board and embedded app according to [these instructions](./app).
2. Open the _SmartThings App_ and follow these steps _(notice that you must add the device in the same location your Hub is installed)_:

   - Select **Add (+)** and then **Device**.
   - Tap on **Scan nearby** and check the logs emitted at your _logcat_ session.

As soon as your device gets installed, the _Driver_ will send a
periodic _Ping HTTP Requests_ with **IP and Port** reference of the server that will
listen for external device updates at `X.X.X.X:XXXXX/push-state`.
