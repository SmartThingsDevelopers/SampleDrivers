# aeotec-trisensor-driver
Driver for the Aeotec TriSensor (Z-Wave)

Model: ZWA005-(A, B and C)

## Prerequisites 
1. Set up the SmartThings CLI according to the [configuration document](https://github.com/SmartThingsCommunity/smartthings-cli/blob/master/packages/cli/doc/configuration.md).
2. Add the [Edge Driver plugin](https://github.com/SmartThingsCommunity/edge-alpha-cli-plugin#set-up) to the CLI.
3. Configure the development environment for the [SmartThingsEdgeDrivers](https://github.com/SmartThingsCommunity/SmartThingsEdgeDriversBeta)
4. A SmartThings Multipurpose sensor (Zigbee).
5. The Alpha firmware installed on your Hub.

## Uploading Your Driver to SmartThings
_Note: Take a look at the installation tutorial in our [Developer's Community](https://community.smartthings.com/t/creating-drivers-for-zwave-devices-with-smartthings-edge/229503)._

1. Compile the driver:
```
       smartthings edge:drivers:package driver/
```
2. Install and select Hub after the prompt:
```
       smartthings edge:drivers:install <driver_id>
```
3. Use your WiFi router or the [SmartThings IDE](https://account.smartthings.com/login) > My Hubs to locate and copy the IP Address for your Hub.
4. From a computer on the same local network as your Hub, open a new terminal window and run the command to get the logs from all the installed drivers.
```
smartthings edge:drivers:logcat --hub-address=x.x.x.x -a
```

## Onboarding your New Device
1. Open the SmartThings App and go to the location where the hub is installed.

    a. Go to Add (+) > Device
    
    b. Select Scan nearby (If you have more than one, select the corresponding Hub as well)
    
2. Put your device in pairing mode; the specifications will vary by manufacturer (for the [Aeotec Trisensor]((https://products.z-wavealliance.org/ProductManual/File?folder=&filename=MarketCertificationFiles/2919/TriSensor%20user%20manual%2020180416.pdf)), press the device’s action button once).  
3. After a few seconds, the secure setup option will appear, click on it to start the inclusion process.
4. Select the room where your device will be installed and tap on “next”
5. If you have access to a QR code, scan it. Otherwise, click on “enter pin code instead” and enter the first 5 digits of the DSK (In the Aeotec Trisensor, it’s located in the internal part of the battery cover.)
6. Select “add device” and stay on this page until the "infoChanged" life cycle is received and the Driver starts getting the `REPORT` commands from the device.

Example Output
```
<ZwaveDevice: deviceId [3C] (Aeotec Trisensor A)> received Z-Wave command: {args={alarm_level=0, alarm_type=0, event="MOTION_DETECTION", event_parameter="", notification_status="ON", notification_type="HOME_SECURITY", v1_alarm_level=0, v1_alarm_type=0, z_wave_alarm_event=8, z_wave_alarm_status="ON", z_wave_alarm_type="BURGLAR", zensor_net_source_node_id=0}, cmd_class="NOTIFICATION", cmd_id="REPORT", dst_channels={}, encap="S2_AUTH", payload="\x00\x00\x00\xFF\x07\x08\x00", src_channel=0, version=3}
```
7. Select the device to enter its details. If the sensor detects motion, the SmartThings app should display this status

## Modify the device's preferences
This Driver allows you to change 3 configuration parameters of the device:

* Clear Motion time
* Temperature Report Interval
* Illumination Report Interval

Follow the steps below:

1. Go to the Device details
2. Click on menu (three dots symbol)
3. Select "settings". You'll see the values set as default.
4. Write the new value you want to set (unit: seconds) and click on "Save"
5. You need to wake up the device to send the new values (hold the action button at least 2 seconds or until the Red led is on). The Driver will receive the WAKE UP notification and will set the new config parameters.

Note: remember that if the reporting values are higher (less often), the battery will last longer.

## Delete device

1. Open the SmartThings App, select the hub where the device was included.
2. Go to menu (three dots symbol) > Z-Wave utilities
3. Select “Z-Wave exclusion” to put the hub in exclusion mode.
4. Click the action button on the device once. You should see a success message on this page and the  device's led flashing

