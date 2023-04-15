if syn and syn.request then request = syn.request end
local queueteleport = syn and syn.queue_on_teleport or queue_on_teleport
assert(typeof(request) and typeof(queueteleport) and typeof(isfile) and typeof(makefolder) and typeof(isfolder) and typeof(readfile) and typeof(writefile) == 'function',"Missing functions")

local game = game
local PlaceId = game.PlaceId
local JobId = game.JobId
local PlaceIdString = tostring(PlaceId)

local folderpath = "VoxlHopperData"
local JobIdStorage = folderpath.."\\JobIdStorage.json"
local getDate = folderpath.."\\LastRan.json"
local getSettings = folderpath.."\\Settings.json"

local data
local data2
local data3
local code

local Players = game:FindService("Players")
local http = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

local function jsone(str) return http:JSONEncode(str) end
local function jsond(str) return http:JSONDecode(str) end

if not isfolder(folderpath) then
    makefolder(folderpath)
    print("Created Folder",folderpath)
end


if isfile(JobIdStorage) then
    data = jsond(readfile(JobIdStorage))
else
    data = {
        JobIds = {}
    }
    writefile(JobIdStorage,jsone(data))
    print("Created JobIdStorage",JobIdStorage)
end

time = os.time()

if isfile(getDate) then
    data2 = jsond(readfile(getDate))
else
    data2 = {
        time
    }
    writefile(getDate,jsone(data2))
    print("Created getDate",getDate)
end


if isfile(getSettings) then
    data3 = jsond(readfile(getSettings))
else
    data3 = {
        Ascending = false,
        WhaleWebhook = "",
        EventWebhook = "",
        Exclusions = [],
    }
    writefile(getSettings,jsone(data3))
    print("Created getSettings",getSettings)
end



local LastRan
for i,v in pairs(data2) do
LastRan = v
end

print(LastRan)
print(type(LastRan))
if (os.time() - LastRan) >= 600 then
    data = {
        JobIds = {}
    }
    time = os.time()
    data2 = {
        time
    }
    
    writefile(getDate,jsone(data2))
    writefile(JobIdStorage,jsone(data))
end

if not table.find(data['JobIds'],JobId) then
    table.insert(data['JobIds'],JobId)
end

writefile(JobIdStorage,jsone(data))

repeat task.wait() until game:IsLoaded() and Players.LocalPlayer

local lp = Players.LocalPlayer

local servers = {}
local cursor = ''

local Ascend

if data3["Ascending"] == true then
    Ascend = 1 -- Ascending
else
    Ascend = 2 -- Descending
end

while cursor and #servers <= 0 do
    local req = request({Url = ("https://games.roblox.com/v1/games/%s/servers/Public?sortOrder="..Ascend.."&limit=100&cursor%s"):format(PlaceId,cursor)})
    local body = jsond(req.Body)
    
    if body and body.data then
        coroutine.wrap(function()
            for i,v in next, body.data do
                if typeof(v) == 'table' and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and not table.find(data['JobIds'],v.id) then
                    table.insert(servers,1,v.id)
                end
            end
        end)()
        
        if body.nextPageCursor then
            cursor = body.nextPageCursor
        end
    end
    task.wait()
end
local succ,err = pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/BillyHri/voxxers/main/code.lua",true))()
end)
if not succ then
    rconsoleprint("An Error has occursed\nPlease Check: Code script at Line \nError:\n"..err)
    return
end

queueteleport([[loadstring(game:HttpGet("https://raw.githubusercontent.com/BillyHri/voxxers/main/rejoinscript.lua"))()]])

while #servers > 0 do
    local random = servers[math.random(1,#servers)]
    
    TeleportService:TeleportToPlaceInstance(PlaceId,random,lp)
    task.wait(1)
end
