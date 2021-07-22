# st-multipurpose-sensor-driver
Driver for the SmartThings Multipurpose Sensor (Zigbee)
Model: IM6001-MPP04

## Prerequisites 
1. Set up the SmartThings CLI according to the [configuration document](https://github.com/SmartThingsCommunity/smartthings-cli/blob/master/packages/cli/doc/configuration.md).
2. Add the [Edge Driver plugin](https://github.com/SmartThingsCommunity/edge-alpha-cli-plugin#set-up) to the CLI.
3. Configure the development environment for the [SmartThingsEdgeDrivers](https://github.com/SmartThingsCommunity/SmartThingsEdgeDriversBeta)
4. A SmartThings Multipurpose sensor (Zigbee).
5. The Alpha firmware installed on your Hub.

## Uploading Your Driver to SmartThings
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

2. Put your device in pairing mode; the specifications will vary by manufacturer (for the SmartThings Multi, press the device’s reset button once). 
3. Keep the terminal view open until you see only reporting values messages in the logs.

Example Output
```
<ZigbeeDevice: device-id [source-id] (Multipurpose Sensor f1)> emitting event: {"attribute_id":"temperature","component_id":"main","state":{"unit":"C","value":28.66},"capability_id":"temperatureMeasurement"}
```

If your Device paired correctly and the Driver was applied, you should not see any errors in the logs (including "UNSUPPORTED" responses to any Zigbee TX message). You can validate this by opening the SmartThings app and controlling and/or viewing all of the devices Capabilities (e.g., open/close or change the temperature).
