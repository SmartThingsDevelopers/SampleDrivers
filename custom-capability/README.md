Custom Capability Example
=========================

This shows an example using a custom Capability from within a SmartThings Edge Driver.  To get this
working, follow the information found in [SmartThings Community](https://community.smartthings.com/t/custom-capability-and-cli-developer-preview/197296).

Once you have created a custom Capability, you can then view the definition of your capability
back as JSON using the CLI command. For demonstration purposes, we created `fancySwitch`. 

Note that for {resentation purposes, you are no longer using the `--dth`
flag. Going forward, you will use the profile ID instead of the dth ID.

```shell script
smartthings capabilities [ID] [VERSION] -o=cap.json
```

Once you have the definition in your package, you can refer to the Capability from the capabilities library.

```lua
local capabilities = require "st.capabilities"
local fancySwitch = capabilities["your_namespace.fancySwitch"]
```

Note that the syntax `capabilities.your_namespace.fancySwitch` is NOT supported.  The 
combined `your_namespace.fancySwitch` is treated as a singular ID and thus the capabilities table must be indexed by the complete ID.

If you want to register handlers for your Capability Commands, you must place an entry in the
capabilities table under the qualified name. When the command is received, the driver library
code will be able to properly find and match the capability information.

```lua

...

local driver_template = {
  capability_handlers = {
    [fancySwitch.ID] = {
      [fancySwitch.commands.fancyOn.NAME] = switch_defaults.on,
      [fancySwitch.commands.fancyOff.NAME] = switch_defaults.off,
      [fancySwitch.commands.fancySet.NAME] = fancy_set_handler,
    }
  }
}
```

At this point, you should be able to use the capability like any other standard capability.

Testing
-------

Since the definition of your Capability will be synced from the cloud when your driver is running on a hub, you
will need to add a local definition that the libraries can access for the integration tests to
work as expected. To do this, navigate into your `lua_libs` directory and find
`lua_libs/st/capabilities/generated`. Within that directory create a new folder with the name of your
namespace.  From that directory, create a Lua file with a filename of `yourCapabilityId.lua` - where the capability
ID does NOT include your namespace.  Finally, add a single return statement to that file and return a string with the
JSON definition of your Capability.

 ```lua
 return [[
{
    "id": "your_namespace.fancySwitch",
    "version": 1,
    ...
}
]]
```

Now your tests should be able to refer to the Capability as it would when running on the hub.

This process will be improved in future updates to avoid the need to add to the library files.
