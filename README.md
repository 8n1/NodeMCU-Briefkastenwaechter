# NodeMCU-Briefkastenwaechter

Rewritten and modified version of the fensterwaechter project by "DasBasti". 

### What's different
This version instantly triggers a Pushingbox Scenario after reset/first start, and then if succeeded goes into infinite DeepSleep. 
The only way to wake up and repeat this process is to reset the device (or by taking away and reattaching the power supply, - obviously :) )

### Configuration
Just edit the Pushingbox device id (devid) by replacing the xxxxx (line 11) with the device id of the scenario you want to trigger and you are good to go.
And also if you haven't done this already connect your ESP module to your wifi network by commenting 'in' the wifi configuration and customizing line 5.

.:.

### Resources / Thanks to:

1. http://www.kurzschluss-blog.de/2015/03/esp8266-1-fensterwachter.html
2. https://github.com/DasBasti/esp8266
3. https://github.com/nodemcu/nodemcu-firmware
4. https://github.com/nodemcu/nodemcu-firmware/wiki/nodemcu_api_en


### Tags:
ESP8266, NodeMCU, Lua, Pushingbox, DeepSleep
