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
-- Temperatur Sensor pin (nodemcu I/O Index)
tempsensor_pin = 4
--------------------------------------

print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
print(" NodeMCU Briefkastenwaechter     ")
print(" mit DS18B20 Temperatursensor    ")
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
    
    return temp
end
-- ignore first reading (it's old because it was taken before going to DeepSleep)
getTemperature(tempsensor_pin)

-- Pushingbox API request (uses Pushingbox variables)
function triggerPushingboxScenario(temp)        
    conn = net.createConnection(net.TCP, 0)
    conn:on("receive", function(conn, payload)
        if string.find(payload, "HTTP/1.1 200 OK") then
            print(" -> SUCCESS")
        else
            print(payload)
            print(" -> FAIL")
        end
        -- Go to deep sleep anyway and never wake up
        print("~~~~~~~~~~~~~~~~~~")
        print(" DeepSleeping...  ")
        print("~~~~~~~~~~~~~~~~~~")
        node.dsleep(0,1)
    end)
    conn:dns('api.pushingbox.com', function(conn, ip) 
        conn:connect(80, ip) 
        conn:send("GET /pushingbox?devid=" ..devid.. "&temperatur=" ..temperature.. " HTTP/1.1\r\n"..
            "Host: api.pushingbox.com\r\n"..
            "Connection: close\r\n"..
            "Accept: */*\r\n"..
            "\r\n")
    end)
    conn = nil
end

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
        
        -- trigger the specified device scenario (devid)
        print(" Triggering Pushingbox Scenario...")
        triggerPushingboxScenario(temperature)
    end
end)

-- force deep sleep if e.g. AP is not reachable
tmr.alarm(1, 10000, 0, function()
    print("~~~~~~~~~~~~~~~~~~~~~~")
    print(" Forcing DeepSleep...")
    print("~~~~~~~~~~~~~~~~~~~~~~")
    node.dsleep(0,1)
end)
