# aeotec-trisensor-driver
Driver for the Aeotec TriSensor (Z-Wave)

Model: ZWA005-(A, B and C)

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

8. Put your device in pairing mode by pressing the device’s action button once. The green led will be on. 

_Note: If the purple led is on, it means the device wasn’t removed from the previous Z-Wave network. (Check the [User’s manual](https://products.z-wavealliance.org/ProductManual/File?folder=&filename=MarketCertificationFiles/2919/TriSensor%20user%20manual%2020180416.pdf) for the exclusion or reset instructions)_

9. The Hub will search for available devices and after a few seconds, the secure setup option will appear, click on it.
10. Select the room where your device will be installed and click on “next”
11. If you have access to a QR code, scan it. Otherwise, click on “enter pin code instead” and enter the first 5 digits of the DSK (located in the internal part of the device’s battery cover.)
12. Select “add device”, if the inclusion was successful, the device's white and green led will flash 
13. Stay on this page until the "infoChanged" life cycle is received and the Driver starts getting the `REPORT` commands from the device.

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

