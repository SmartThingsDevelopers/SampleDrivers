# LAN Driver for ESP8266 LightBulb

### Software Requirements

1. Latest version of the [SmartThings CLI](https://github.com/SmartThingsCommunity/smartthings-cli).
1. [Edge Alpha CLI Plugin](https://github.com/SmartThingsCommunity/edge-alpha-cli-plugin#smartthings-edge-alpha-cli-plugin).

### Setup

1. Compile the driver:

       smartthings edge:drivers:package driver/

1. Install and select Hub after the prompt:

       smartthings edge:drivers:install <driver_id>

1. Enable logs _(the **Hub Address** can be found at the **My Hubs** tab of the
[Groove IDE](https://account.smartthings.com/))_

       smartthings edge:drivers:logcat --hub-address 192.168.X.XX <driver_id>

_**Note**: If you get **authentication errors** while using the SmartThings CLI, delete your `credentials.yaml` and `config.yaml` located at `~/.config/@smartthings/cli` and execute: `smartthings edge:drivers`. This actions will trigger the OAuth service, and a new access token will be created. For a better reference on these configuration files, check [this documentation](https://github.com/SmartThingsCommunity/smartthings-cli/blob/master/packages/cli/doc/configuration.md)._

### Discovery of the ESP8266 LightBulb

Once the _ESP8266 board_ has been configured as explained [Here](../app/README.md),
it will be ready to get integrated into the _SmartThings ecosystem_ doing as follows:

1. At the **Dashboard** of your _SmartThings app_, tap the "**+**" icon.
2. Select **Device** and **Scan** _(top-right option of the screen)_.

At this point, you will see some lifecycle logs and your device will be available at the **Dashboard**.

In addition, as soon as your device gets _initialized_, the _Driver_ will send a
periodic _Ping HTTP Requests_ with **IP and Port** reference of the server that will
listen for external device updates at `X.X.X.X:XXXXX/push-state`.
