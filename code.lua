local Event = game.ReplicatedStorage.UniversedSettings.CurrentEvent
local plr = game.Players.LocalPlayer
local OSTime = os.time()
local Time = os.date('!*t', OSTime)

local folderpath = "VoxlHopperData"
local getSettings = folderpath.."\\Settings.json"
local data3

if isfile(getSettings) then
    data3 = jsond(readfile(getSettings))
else
    data3 = {
        Ascending = false,
        WhaleWebhook = "",
        EventWebhook = "",
    }
    writefile(getSettings,jsone(data3))
    print("Created getSettings",getSettings)
end

local roleDictionary = {
	["VoidEncroaching"] = "1096678199087337562",
	["BloodMoon"] = "1096678143613472848",
	["HarvestMoon"] = "1096678122553880647",
}

local eventColour = {
	["VoidEncroaching"] = "7b14cc",
	["BloodMoon"] = "cc1414",
	["HarvestMoon"] = "6078e1",
}

local function getexploit()
    local exploit =
        (syn and not is_sirhurt_closure and not pebc_execute and "Synapse X") or 
        (isexecutorclosure and "Script-Ware V2") or
        (secure_load and "Sentinel") or
        (is_sirhurt_closure and "SirHurt V4") or
        (pebc_execute and "ProtoSmasher") or
        (KRNL_LOADED and "Krnl") or
        (WrapGlobal and "WeAreDevs") or
        (isvm and "Proxo") or
        (shadow_env and "Shadow") or
        (jit and "EasyExploits") or
        (getreg()['CalamariLuaEnv'] and "Calamari") or
        (unit and "Unit") or
        ("Undetectable")
    return exploit
end


local function getAllPlayers()
local playerIds = {}
for i,v in pairs(game.Players:GetPlayers()) do
      if v.UserId ~= plr.UserId then
      table.insert(playerIds, v.UserId)
	end
end
local stringa = "https://www.roblox.com/users/"
concatetable = {}
local stringab = ""
for i,v in pairs(playerIds) do
    print(stringa..v.."/profile ")
    table.insert(concatetable, "\n"..stringa..v.."/profile ")
    stringab = stringab.."\n"..stringa..v.."/profile "
end
print(stringab)

return stringab
end

rconsoleprint(data3["WhaleWebhook"])
rconsoleprint(data3["EventWebhook"])
if data3["WhaleWebhook"] == "" or data3["EventWebhook"] == "" then
	rconsoleprint("Missing webhook in either whale event or eventwebhook. Look in your workspace folder for 'VoxlHopperData', then go into settings and change it."
	return
end


if game.Workspace.Others:FindFirstChild("CloudWhale") then
print("Whale found")

local Content = '<@&1096678090400333905>'
local Embed = {
			["title"] = "__**EVENT FOUND: Sky Whale**__",
			["description"] = "Players:"..getAllPlayers(),
			["type"] = "rich",
			["color"] = tonumber(0x00ffff),
			["footer"] = {
			    ["text"] = "Don't worry if nobody in the server has their joins on."
			},
			["timestamp"] = string.format('%d-%d-%dT%02d:%02d:%02dZ', Time.year, Time.month, Time.day, Time.hour, Time.min, Time.sec),
};
(syn and syn.request or http_request or http.request) {
    Url = data3["WhaleWebhook"] -- set this to ur own webhook
    Method = 'POST';
    Headers = {
        ['Content-Type'] = 'application/json';
    };
    Body = game:GetService'HttpService':JSONEncode({content = Content; embeds = {Embed}; });
};
end

if Event.Value ~= "None" and Event.Value ~= "Loading" then
	print("Found event: "..Event.Value)
local Content = "<@&"..roleDictionary[Event.Value]..">" or ""
local Embed = {
			["title"] = "__**EVENT FOUND: **__"..Event.Value,
			["description"] = "Players:"..getAllPlayers(),
			["type"] = "rich",
			["color"] = tonumber(eventColour[Event.Value]),
			["footer"] = {
			    ["text"] = "Don't worry if nobody in the server has their joins on."
			},
			["timestamp"] = string.format('%d-%d-%dT%02d:%02d:%02dZ', Time.year, Time.month, Time.day, Time.hour, Time.min, Time.sec),
};
(syn and syn.request or http_request or http.request) {
    Url = data3["EventWebhook"] -- set this to ur own webhook
    Method = 'POST';
    Headers = {
        ['Content-Type'] = 'application/json';
    };
    Body = game:GetService'HttpService':JSONEncode({content = Content; embeds = {Embed}; });
};
end
