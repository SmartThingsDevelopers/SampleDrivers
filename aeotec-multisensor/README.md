# Sample Edge Driver for Aeotec MultiSensor 6

Model: ZW100-(A, B, C and G)

Protocol: Z-Wave

## Prerequisites

1. Set up the SmartThings CLI according to the [configuration document](https://github.com/SmartThingsCommunity/smartthings-cli/blob/master/packages/cli/doc/configuration.md).
2. Add the [Edge Driver plugin](https://github.com/SmartThingsCommunity/edge-alpha-cli-plugin#set-up) to the CLI.
3. Configure your development environment for the [SmartThingsEdgeDrivers](https://github.com/SmartThingsCommunity/SmartThingsEdgeDriversBeta)
4. A SmartThings hub with firmware version 000.038.000XX or greater and an Aeotec MultiSensor 6.

## Uploading Your Driver to SmartThings

_Note: Take a look at the installation tutorial in our [Developer's Community](https://community.smartthings.com/t/creating-drivers-for-zwave-devices-with-smartthings-edge/229503)._

1. Compile the driver:

```
smartthings edge:drivers:package driver/
```

2. Next, create a channel for your driver

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

You should see the confirmation message: "Driver {driver-id} installed to Hub {hub-id}"

6. Use your WiFi router or the [SmartThings IDE](https://account.smartthings.com/login) > My Hubs to locate and copy the IP Address for your Hub.

7. From a computer on the same local network as your Hub, open a new terminal window and run the command to get the logs from all the installed drivers.

```
smartthings edge:drivers:logcat --hub-address=x.x.x.x -a
```

## Onboarding your New Device

1. Open the SmartThings App and go to the location where the hub is installed.
2. Go to Add (+) > Device or select _Scan Nearby_ (If you have more than one, select the corresponding Hub as well)

3. Put your device in pairing mode; the specifications will vary by manufacturer (for the [Aeotec MultiSensor 6](https://products.z-wavealliance.org/ProductManual/File?folder=&filename=MarketCertificationFiles/2684/Aeon%20Labs%20MultiSensor%206%20manual.pdf), press the device’s action button once).

4. Keep the terminal view open until the "infoChanged" lifecycle event is received and the driver starts getting the `REPORT` commands from the device.

Example Output

```text
<ZwaveDevice: deviceId [3C] (Aeotec Multisensor)> received Z-Wave command: {args={alarm_level=0, alarm_type=0, event="MOTION_DETECTION", event_parameter="", notification_status="ON", notification_type="HOME_SECURITY", v1_alarm_level=0, v1_alarm_type=0, z_wave_alarm_event=8, z_wave_alarm_status="ON", z_wave_alarm_type="BURGLAR", zensor_net_source_node_id=0}, cmd_class="NOTIFICATION", cmd_id="REPORT", dst_channels={}, encap="S2_AUTH", payload="\x00\x00\x00\xFF\x07\x08\x00", src_channel=0, version=3}
```

If your Device paired correctly and the Driver was applied, you should not see any errors in the logs. You can validate this by opening the SmartThings app and controlling and/or viewing all of the devices Capabilities (e.g., motion or change the temperature).

## Additional Notes

1. This driver allows you to change 2 configuration parameters of the device.
2. When experimenting with Z-Wave devices, remember to exclude the device before re-pairing.
