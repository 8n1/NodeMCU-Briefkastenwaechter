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

print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
print(" NodeMCU Briefkastenwaechter ")
print(" - powered by Pushingbox     ")
print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")

-- Pushingbox API request
function triggerPushingboxScenario()
    conn = net.createConnection(net.TCP, 0)
    conn:on("receive", function(conn, payload)
        if string.find(payload, "HTTP/1.1 200 OK") then
            print(" -> SUCCESS")
        else
            print(payload)
            print(" -> FAIL")
        end
        -- go to deep sleep anyway and never wake up
        print("~~~~~~~~~~~~~~~~~~")
        print(" DeepSleeping...  ")
        print("~~~~~~~~~~~~~~~~~~")
        node.dsleep(0,1)
    end)
    conn:dns('api.pushingbox.com', function(conn, ip) 
        conn:connect(80, ip) 
        conn:send("GET /pushingbox?devid=" ..devid.. " HTTP/1.1\r\n"..
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
        
        -- trigger the specified device scenario (devid)
        print(" Triggering Pushingbox Scenario...")
        triggerPushingboxScenario()
    end
end)

-- force deep sleep if e.g. AP is not reachable
tmr.alarm(1, 10000, 0, function()
    print("~~~~~~~~~~~~~~~~~~~~~~")
    print(" Forcing DeepSleep...")
    print("~~~~~~~~~~~~~~~~~~~~~~")
    node.dsleep(0,1)
end)
