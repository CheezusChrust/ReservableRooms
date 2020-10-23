local entsInRoom = 0
util.AddNetworkString("reservableRoomUserFeedBack")

local function sendMsg(ply, msg)
    net.Start("reservableRoomUserFeedBack")
    net.WriteString(msg)
    net.Send(ply)
end

local function checkRoomDoors()
    local rooms = util.JSONToTable(file.Read("reservablerooms/" .. game.GetMap() .. ".txt", "DATA"))

    for k, v in pairs(rooms) do
        if v[8] then
            local doorEntity = nil

            for ke, doorent in pairs(ents.FindByName(tostring(v[8]))) do
                doorEntity = doorent
            end

            for key, roomEnt in pairs(ents.FindByClass("reservableroom")) do
                if roomEnt:GetRID() == tonumber(v[1]) then
                    roomEnt:SetDoorEnt(doorEntity)
                end
            end
        end
    end
end

concommand.Add("addreservableroom", function(ply, cmd, args)
    local rooms = util.JSONToTable(file.Read("reservablerooms/" .. game.GetMap() .. ".txt", "DATA"))

    if not IsValid(ply) then
        local argsIsValidCount = 0

        for k, v in pairs(args) do
            if v and tonumber(v) then
                argsIsValidCount = argsIsValidCount + 1
            end
        end

        if argsIsValidCount == 7 then
            local room = {}

            if args[8] then
                room = {args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8]}
            else
                room = {args[1], args[2], args[3], args[4], args[5], args[6], args[7]}
            end

            --Ensure args conform to AABB mins/maxs
            local x1, y1, z1, x2, y2, z2 = args[2], args[3], args[4], args[5], args[6], args[7]

            local tmp
            if x1 > x2 then
                tmp = x2
                x2 = x1
                x1 = tmp
                room[2] = x1
                room[5] = x2
            end
            if y1 > y2 then
                tmp = y2
                y2 = y1
                y1 = tmp
                room[3] = y1
                room[6] = y2
            end
            if z1 > z2 then
                tmp = z2
                z2 = z1
                z1 = tmp
                room[4] = z1
                room[7] = z2
            end

            table.insert(rooms, room)
            file.Write("reservablerooms/" .. game.GetMap() .. ".txt", util.TableToJSON(rooms, false))
            local reservableRoom = ents.Create("reservableroom")
            reservableRoom:SetPos(Vector(0, 0, 0))
            reservableRoom:Spawn()
            reservableRoom:SetRID(room[1])
            reservableRoom:SetCollisionBounds(Vector(x1, y1, z1), Vector(x2, y2, z2))
            checkRoomDoors()
            print("You have created a room.")
        else
            print("Please enter the command correctly.")
        end
    else
        if ply:IsAdmin() or ply:IsSuperAdmin() then
            local argsIsValidCount = 0

            for k, v in pairs(args) do
                if v and tonumber(v) then
                    argsIsValidCount = argsIsValidCount + 1
                end
            end

            if argsIsValidCount == 7 then
                local room = {}

                if args[8] then
                    room = {args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8]}
                else
                    room = {args[1], args[2], args[3], args[4], args[5], args[6], args[7]}
                end

                --Ensure args conform to AABB mins/maxs
                local x1, y1, z1, x2, y2, z2 = args[2], args[3], args[4], args[5], args[6], args[7]

                local tmp
                if x1 > x2 then
                    tmp = x2
                    x2 = x1
                    x1 = tmp
                    room[2] = x1
                    room[5] = x2
                end
                if y1 > y2 then
                    tmp = y2
                    y2 = y1
                    y1 = tmp
                    room[3] = y1
                    room[6] = y2
                end
                if z1 > z2 then
                    tmp = z2
                    z2 = z1
                    z1 = tmp
                    room[4] = z1
                    room[7] = z2
                end

                table.insert(rooms, room)
                file.Write("reservablerooms/" .. game.GetMap() .. ".txt", util.TableToJSON(rooms, false))
                local reservableRoom = ents.Create("reservableroom")
                reservableRoom:SetPos(Vector(0, 0, 0))
                reservableRoom:Spawn()
                reservableRoom:SetRID(room[1])
                reservableRoom:SetCollisionBounds(Vector(room[2], room[3], room[4]), Vector(room[5], room[6], room[7]))
                checkRoomDoors()
                sendMsg(ply, "You have created a room.")
            else
                sendMsg(ply, "Please enter the command correctly.")
            end
        else
            sendMsg(ply, "You are not admin.")
        end
    end
end)

concommand.Add("removereservableroom", function(ply, cmd, args)
    if not IsValid(ply) then
        if not args[1] or not tonumber(args[1]) then
            print("Please enter the command correctly.")

            return
        end

        local roomExists = false

        for k, v in pairs(ents.FindByClass("reservableroom")) do
            if v:GetRID() == tonumber(args[1]) then
                roomExists = true
                v:Remove()
            end
        end

        if not roomExists then
            print("The specified room does not exist.")

            return
        end

        print("You have removed the specified room.")
        local rooms = util.JSONToTable(file.Read("reservablerooms/" .. game.GetMap() .. ".txt", "DATA"))

        for k, v in pairs(rooms) do
            if v[1] == args[1] then
                rooms[k] = nil
            end
        end

        file.Write("reservablerooms/" .. game.GetMap() .. ".txt", util.TableToJSON(rooms, false))
    else
        if not ply:IsAdmin() and not ply:IsSuperAdmin() then
            sendMsg(ply, "You are not admin.")

            return
        end

        if not args[1] or not tonumbers(args[1]) then
            sendMsg(ply, "Please enter the command correctly.")

            return
        end

        local roomExists = false

        for k, v in pairs(ents.FindByClass("reservableroom")) do
            if v:GetRID() == tonumber(args[1]) then
                roomExists = true
                v:Remove()
            end
        end

        if not roomExists then
            sendMsg(ply, "The specified room does not exist.")

            return
        end

        sendMsg(ply, "You have removed the specified room.")
        local rooms = util.JSONToTable(file.Read("reservablerooms/" .. game.GetMap() .. ".txt", "DATA"))

        for k, v in pairs(rooms) do
            if v[1] == args[1] then
                rooms[k] = nil
            end
        end

        file.Write("reservablerooms/" .. game.GetMap() .. ".txt", util.TableToJSON(rooms, false))
    end
end)

local function checkDIR()
    if not file.Exists("reservablerooms/" .. game.GetMap() .. ".txt", "DATA") then
        if not file.Exists("reservablerooms", "DATA") then
            file.CreateDir("reservablerooms")
        end

        local rooms = {}
        file.Write("reservablerooms/" .. game.GetMap() .. ".txt", util.TableToJSON(rooms, false))
    end
end

local function createRooms()
    local rooms = util.JSONToTable(file.Read("reservablerooms/" .. game.GetMap() .. ".txt", "DATA"))

    for k, v in pairs(rooms) do
        local reservableRoom = ents.Create("reservableroom")
        reservableRoom:SetPos(Vector(0, 0, 0))
        reservableRoom:Spawn()
        reservableRoom:SetRID(v[1])
        reservableRoom:SetCollisionBounds(Vector(v[2], v[3], v[4]), Vector(v[5], v[6], v[7]))
    end
end

local function checkIfRoomIsClear(ply, id)
    for k, v in pairs(ents.FindByClass("reservableroom")) do
        if v:GetRID() == tonumber(id) then
            entsInRoom = 0
            local entsInRoomChecker = ents.FindInBox(v:OBBMins(), v:OBBMaxs())

            for i = 1, #entsInRoomChecker do
                if entsInRoomChecker[i]:IsPlayer() then
                    if entsInRoomChecker[i] ~= ply then
                        entsInRoom = entsInRoom + 1
                    end
                elseif IsValid(entsInRoomChecker[i]:CPPIGetOwner()) and entsInRoomChecker[i]:GetClass() ~= "reservableroom" then
                    if entsInRoomChecker[i]:CPPIGetOwner() ~= ply then
                        entsInRoom = entsInRoom + 1
                    end
                end
            end
        end
    end
end

local function lockRRoomDoor(ply)
    local ownsRoom = false

    for k, v in pairs(ents.FindByClass("reservableroom")) do
        if v:GetOwner() == ply then
            ownsRoom = true
        end
    end

    if not ownsRoom then
        sendMsg(ply, "You do not own a door.")

        return
    end

    local doorExists = false

    for k, v in pairs(ents.FindByClass("reservableroom")) do
        if v:GetOwner() == ply and IsValid(v:GetDoorEnt()) then
            doorExists = true
        end
    end

    if not doorExists then
        sendMsg(ply, "There is no door for this room.")

        return
    end

    for k, v in pairs(ents.FindByClass("reservableroom")) do
        if v:GetOwner() == ply then
            v:GetDoorEnt():Fire("lock")
        end
    end

    sendMsg(ply, "You have locked your door.")
end

local function unlockRRoomDoor(ply)
    local ownsRoom = false

    for k, v in pairs(ents.FindByClass("reservableroom")) do
        if v:GetOwner() == ply then
            ownsRoom = true
        end
    end

    if not ownsRoom then
        sendMsg(ply, "You do not own a door.")

        return
    end

    local doorExists = false

    for k, v in pairs(ents.FindByClass("reservableroom")) do
        if v:GetOwner() == ply and IsValid(v:GetDoorEnt()) then
            doorExists = true
        end
    end

    if not doorExists then
        sendMsg(ply, "There is no door for this room.")

        return
    end

    for k, v in pairs(ents.FindByClass("reservableroom")) do
        if v:GetOwner() == ply then
            v:GetDoorEnt():Fire("unlock")
        end
    end

    sendMsg(ply, "You have unlocked your door.")
end

local function reserveReservableRoom(ply, id)
    if not id or not isnumber(id) then
        sendMsg(ply, "Please enter a correct ID.")

        return
    end

    local roomIsValid = false

    for k, v in pairs(ents.FindByClass("reservableroom")) do
        if tonumber(id) == v:GetRID() then
            roomIsValid = true
        end
    end

    if not roomIsValid then
        sendMsg(ply, "Please enter a correct ID.")

        return
    end

    local alreadyOwnsRoom = false

    for k, v in pairs(ents.FindByClass("reservableroom")) do
        if v:GetOwner() == ply then
            alreadyOwnsRoom = true
        end
    end

    if alreadyOwnsRoom then
        sendMsg(ply, "You already own a room.")

        return
    end

    checkIfRoomIsClear(ply, id)

    if entsInRoom ~= 0 then
        sendMsg(ply, "There is something or someone in this room.")

        return
    end

    local roomAlreadyOwned = false

    for k, v in pairs(ents.FindByClass("reservableroom")) do
        if v:GetRID() == tonumber(id) and IsValid(v:GetOwner()) then
            roomAlreadyOwned = true
        end
    end

    if roomAlreadyOwned then
        sendMsg(ply, "Someone already owns this room.")

        return
    end

    for k, v in pairs(ents.FindByClass("reservableroom")) do
        if v:GetRID() == tonumber(id) then
            v:SetOwner(ply)

            if IsValid(v:GetDoorEnt()) then
                v:GetDoorEnt():Fire("close")
            end
        end
    end

    lockRRoomDoor(ply)
    sendMsg(ply, "You have claimed room " .. id .. ".")
end

local function clearReservableRoom(ply, id)
    if not ply:IsAdmin() and not ply:IsSuperAdmin() then
        sendMsg(ply, "You are not >= admin.")

        return
    end

    if not isnumber(id) or not id then
        sendMsg(ply, "Please enter a correct ID.")

        return
    end

    local roomIsValid = false

    for k, v in pairs(ents.FindByClass("reservableroom")) do
        if tonumber(id) == v:GetRID() then
            roomIsValid = true
        end
    end

    if not roomIsValid then
        sendMsg(ply, "Please enter a correct ID.")

        return
    end

    for k, v in pairs(ents.FindByClass("reservableroom")) do
        if v:GetRID() == tonumber(id) then
            v:SetOwner(nil)
        end
    end

    sendMsg(ply, "You have cleared room " .. id .. ".")
end

local function unclaimReservableRoom(ply)
    local ownsRoom = false

    for k, v in pairs(ents.FindByClass("reservableroom")) do
        if v:GetOwner() == ply then
            ownsRoom = true
        end
    end

    if not ownsRoom then
        sendMsg(ply, "You do not own a room.")

        return
    end

    unlockRRoomDoor(ply)

    for k, v in pairs(ents.FindByClass("reservableroom")) do
        if v:GetOwner() == ply then
            v:SetOwner(nil)
        end
    end

    sendMsg(ply, "You have unclaimed your room.")
end

hook.Add("PlayerSay", "playerSayReservableRoomCommand", function(ply, text)
    local plySaySplit = string.Split(string.lower(text), " ")

    if plySaySplit[1] == "!claim" then
        reserveReservableRoom(ply, tonumber(plySaySplit[2]))

        return ""
    end

    if plySaySplit[1] == "!clear" then
        clearReservableRoom(ply, tonumber(plySaySplit[2]))

        return ""
    end

    if plySaySplit[1] == "!lockdoor" then
        lockRRoomDoor(ply)

        return ""
    end

    if plySaySplit[1] == "!unclaim" then
        unclaimReservableRoom(ply)

        return ""
    end

    if plySaySplit[1] == "!unlockdoor" then
        unlockRRoomDoor(ply)

        return ""
    end
end)

hook.Add("PlayerDisconnected", "playerLeftUnReserveRoomHook", function(ply)
    unclaimReservableRoom(ply)
end)

hook.Add("InitPostEntity", "reservableRoomsInitPostEntityHook", function()
    checkDIR()
    createRooms()
    checkRoomDoors()
end)