rednet.open(top)

local LOG_SERVER_PROTOCOL = "logserver"

while true do
    local senderId, message, protocol = rednet.receive(LOG_SERVER_PROTOCOL)
    print(senderId, message);
end