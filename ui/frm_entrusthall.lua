-- YOUWISH SCRIPT LOADER
-- MADE BY YouWish
-- v1.0

local SCRIPT_DIR = 'mods'
local OUTPUT_FILE = "temp_output.txt"

runShell = function(command)
	os.execute(command .. " > " .. OUTPUT_FILE)
	local handle = io.open(OUTPUT_FILE, "r")
	local output = handle:read("*all")
	handle:close()
	os.remove(OUTPUT_FILE)
	return output
end
executeCommand = runShell

string.trim = function(str)
	local trimmed = string.gsub(str, "^%s*(.-)%s*$", "%1")
	return trimmed
end

local function scanScripts(dir)
	local listing = runShell("dir /b " .. dir)
	local names = {}
	local known = {}

	if listing == "" then
		print("Nothing to load in: " .. dir)
		return names
	end

	for line in string.gfind(listing, "([^\r\n]+)") do
		local name = string.trim(line)
		if name ~= "" and string.find(name, "%.lua$") and not known[name] then
			known[name] = true
			print("Detected script: " .. name)
			table.insert(names, name)
		end
	end

	return names
end

local function loadScripts(dir)
	local active = {}

	for _, name in ipairs(scanScripts(dir)) do
		local path = dir .. "/" .. name
		local ok, result = pcall(dofile, path)
		if ok then
			print("Loaded: " .. path)
			active[name] = result
		else
			print("Could not load: " .. path)
		end
	end

	return active
end

local activeMods = nil

local function dispatch(eventName)
	for _, entry in pairs(activeMods) do
		local handler = entry[eventName]
		if handler then
			handler()
		end
	end
end

function layWorld_frmEntrusthall_OnLoad(self)
	print("== YOUWISH LOADER v1.0 ==")
	activeMods = loadScripts(SCRIPT_DIR)
	dispatch("onLoad")
end

__layWorld_lbLayerAlern_OnUpdate = function(self)
	dispatch("onTick")
end

function layWorld_frmEntrusthall_OnEvent(self, event, arg)
end

function layWorld_frmEntrusthall_OnShow(self)
end

function layWorld_frmEntrusthall_BtnRefresh_OnClicked(self)
end

function layWorld_frmEntrusthall_BtnPrepage_OnClicked(self)
end

function layWorld_frmEntrusthall_BtnNextpage_OnClicked(self)
end

function layWorld_frmEntrusthall_OnHide(self)
end

layWorld_frmSystemButtonEx_lbNetStatus_OnHint = function(self)
	local ping = uiNetGetData()
	local text = string.format(LAN("net_status_hint1"), ping)
	self:SetHintText(text .. '\nYouWish :)')
end

local function reportRange()
	if uiNpcDialogCheckDistance() == false then
		print("NPC range check failed")
	end
end

function layWorld_frmDialogerEx_OnUpdate(self, delta)
	reportRange()
end

function layWorld_frmMailEx_OnUpdate(self, delta)
	reportRange()
end

_G.uiNpcDialogCheckDistance = function()
	return true
end
