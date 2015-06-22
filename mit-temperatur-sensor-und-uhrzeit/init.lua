--------------------------------------
-- WIFI configuration (only needs to be done once)
--------------------------------------
wifi.setmode(wifi.STATION)
--wifi.sta.config("SSID", "PASSWD")
wifi.sta.connect()

--------------------------------------
-- Pushingbox device id
devid = "xxxxx"
--------------------------------------
-- Sevrer to get the time from (not NTP)
time_server_ip = "192.168.0.123"
--------------------------------------
-- Temperatur Sensor pin (nodemcu I/O Index)
tempsensor_pin = 4
--------------------------------------
-- time offset
time_offset = 1
--------------------------------------
-- decimal places
precision = 1
--------------------------------------

print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
print(" NodeMCU Briefkastenwaechter     ")
print(" mit Temp-Sensor und Uhrzeit     ")
print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")

-- Read temperature sensor
function getTemperature(sensor_pin)
    sensor = require("ds18b20")
    
    sensor.setup(sensor_pin)
    temp = sensor.read()
    if temp == nil then
        print("Couldn't read sensor. Check wiring")
        temp = 0
    end
    
    return string.format("%."..precision.."f", temp)
end
-- ignore first reading (it's old because it was taken before going to DeepSleep)
getTemperature(tempsensor_pin)

-- Pushingbox api request
dofile("trigger_scenario.lc")

-- wait until we have an IP from the AP
tmr.alarm(0, 1000, 1, function()
    print(" Checking IP...")
    if wifi.sta.getip() == nil then
        -- do nothing
    else
        print(" -> IP: "..wifi.sta.getip())
        print("~~~~~~~~~~~~~~~~~~~~~~~~~")
        tmr.stop(0)

        -- get ds temperature
        print(" Getting temperature...  ")
        temperature = getTemperature(tempsensor_pin)
        print(" -> Temperature: " ..temperature.. "'C")
        print("~~~~~~~~~~~~~~~~~~~~~~~~~")
        
        -- Get time from webserver
        print(" Getting time...")
        dofile("get_time.lc")
    end
end)

-- force deep sleep if e.g. AP is not reachable
tmr.alarm(1, 10000, 0, function()
    print("~~~~~~~~~~~~~~~~~~~~~~")
    print(" Forcing DeepSleep...")
    print("~~~~~~~~~~~~~~~~~~~~~~")
    node.dsleep(0,1)
end)
