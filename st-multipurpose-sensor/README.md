# st-multipurpose-sensor-driver
Driver for the SmartThings Multipurpose Sensor (Zigbee)
Model: IM6001-MPP04

## Prerequisites 
1. Set up the SmartThings CLI according to the [configuration document](https://github.com/SmartThingsCommunity/smartthings-cli/blob/master/packages/cli/doc/configuration.md).
2. Add the [Edge Driver plugin](https://github.com/SmartThingsCommunity/edge-alpha-cli-plugin#set-up) to the CLI.
3. Configure the development environment for the [SmartThingsEdgeDrivers](https://github.com/SmartThingsCommunity/SmartThingsEdgeDriversBeta)
4. A SmartThings Multipurpose sensor (Zigbee).
5. The Alpha firmware installed on your Hub.

## Installation
1. Clone this repository in a local directory.
2. Open a terminal and go to this repository's directory. 
3. Build and upload the Driver package with this command:
```
smartthings edge:drivers:package ./
```
You will receive as a response the Driver's ID, name, and package key.

4. Use the below command to install the driver. When prompted, select the corresponding [Hub device ID](https://smartthings.developer.samsung.com/docs/api-ref/st-api.html#operation/getDevices) and the Driver's package.
```
smartthings edge:drivers:install
```
5. Use your WiFi router or the [SmartThings IDE](https://account.smartthings.com/login) > My Hubs to locate and copy the IP Address for your Hub.
6. From a computer on the same local network as your hub, open a new terminal window and run the command to get the logs from all the installed drivers.
```
smartthings edge:drivers:logcat --hub-address=x.x.x.x -a
```
7. Open the SmartThings App and go to the location where the hub is installed.

    a. Go to Add (+) > Device
    
    b. Reset your device back to the pairing mode.
    
    c. Select Scan nearby (If you have more than one, select the corresponding Hub as well)
    
8. In the logs, you will see the RX and TX messages as part of the communication with the device.
9. You shouldn't see any errors in the driver's logs (including the "UNSUPPORTED" response to any TX message). This means the device was added and the event will be received successfully.

