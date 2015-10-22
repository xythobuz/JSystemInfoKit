![Logo](/Icon.png)

# SystemInfoKit ![] (https://img.shields.io/travis/jBot-42/JSystemInfoKit.svg)
A comprehensive, compact, and well tested system information framework for Cocoa on OS X by the creator of the most complete source on the SMC. 

## Features

### Detailed Device Information

With minimal code, SystemInfoKit can provide detailed device information including device UUID, serial number, model string, and display resolution, CPU specifications, and network information including the ip address, host name, and public IP address.

### Complete SMC Integration

SystemInfoKit's SMC integration is based on [SMCWrapper](https://github.com/FergusInLondon/SMCWrapper). It provides an additional layer of functionality over SMCWrapper including the ability to find all working SMC keys and get human-readable descriptions for keys.

### Built-in System Monitoring Functions

SystemInfoKit provides a comprehensive system monitoring class which can be used to find CPU usage, memory usage, disk usage, network usage, and even detailed information on the battery.

## How To Use

SystemInfoKit is broken up into 3 main modules: JSKDevice, which accesses device information, JSKSMC, which accesses the SMC, and JSKSystemMonitor, which can be used for system monitoring.

### JSKDevice

### JSKSMC

### JSKSystemMonitor

## Contributions

Issues and pull requests are welcome!

## Licensing

SystemInfoKit, SMCWrapper, and the original SMC tool are released under the GNU GPL v2.0 License.

### Copyright

SystemInfoKit copyright © 2015 JRW (@jBot-42)
SMCWrapper copyright © 2014 Fergus Morrow (@FergusInLondon)
Apple SMC Tool copyright © 2006 devnull 
