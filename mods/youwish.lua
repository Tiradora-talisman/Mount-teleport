-- YOUWISH v1.0
-- MADE BY YouWish

local menu = {}

local MENU_TITLE = "YOUWISH v1.0"

local CELL_W, CELL_H = 55, 50
local CELL_GAP = 1
local GRID_X, GRID_Y = 5, 5

local PANEL_THRESHOLD = 500
local SHORTCUTS = {
	{ label = "ARENA",  id = 24  },
	{ label = "GUILD",  id = 500 },
	{ label = "POST",   id = 501 },
	{ label = "MARKET", id = 502 },
	{ label = "FORGE",  id = 503 },
	{ label = "IDENT",  id = 504 },
	{ label = "DONATE", id = 505 },
	{ label = "G-EXIT", id = 506 },
}

local PANEL_ACTIONS = {
	[500] = "guildterrenter:NA?NA=0",
	[501] = "mail:NA?NA=0",
	[502] = "auction:NA?NA=0",
	[503] = "smithing:NA?NA=0",
	[504] = "identify:NA?NA=0",
	[505] = "guildterrcontribute:NA?NA=0",
	[506] = "guildterrleave:NA?NA=0",
}

local PROXIMITY_HOOKS = {
	"uiNpcDialogCheckDistance",
	"uiMailDialogCheckDistance",
	"uiBusinessCheckBuyDistance",
	"uiBusinessCheckSaleDistance",
	"CheckLastTalkedNpcDistance",
	"uiStallCheckDistance",
	"uiGuild_NpcDialogCheckDistance",
	"uiPointCardCheckDistance",
	"uiTaskCheckDistance",
	"uiUserTradCheckDistance",
}

local function passAlways()
	return true
end

local function bypassProximity()
	for _, hookName in ipairs(PROXIMITY_HOOKS) do
		_G[hookName] = passAlways
	end
end

local function hideNamed(parent, childName)
	local target = SAPI.GetChild(parent, childName)
	if target then
		target:Hide()
	end
end

local function stampTitle(frame)
	local header = SAPI.GetChild(frame, "btMonthText")
	if header then
		header:SetText(MENU_TITLE)
		header:SetSize(200, 20)
	end
end

local function configureCell(cell, shortcut, column)
	cell:MoveTo(GRID_X + column * (CELL_W + CELL_GAP), GRID_Y)
	cell:SetSize(CELL_W, CELL_H)
	cell:SetChecked(false)

	local caption = SAPI.GetChild(cell, "lbDayInMonth")
	if caption then
		caption:SetText(shortcut.label)
		caption:MoveTo(-20, 15)
		caption:SetSize(CELL_W + 20, 20)
	end

	for n = 1, 3 do
		hideNamed(cell, "lbShortcut" .. n)
	end
	hideNamed(cell, "btUserEvent")

	cell.WarpId = shortcut.id
	cell.WarpLabel = shortcut.label
	cell:Show()
end

menu.onLoad = function()
	print(MENU_TITLE .. " loaded")

	uiGetglobal("layWorld.frmMiniMapEx.btCalendar"):SetNormalImage(SAPI.GetImage('ghost001_w'))

	bypassProximity()
end

menu.onTick = function()
	bypassProximity()
end

function layWorld_frmCalendar_OnShow(self)
	uiClientMsg("YouWish", true)

	local grid = SAPI.GetChild(self, "lbCalendarMonth")
	if grid then
		local cursor = 1

		for row = 1, 6 do
			local rowFrame = SAPI.GetChild(grid, "lbCalendarWeek" .. row)
			if rowFrame then
				for col = 1, 7 do
					local cell = SAPI.GetChild(rowFrame, "cbCalendarDay" .. col)
					if cell then
						local shortcut = SHORTCUTS[cursor]
						if shortcut then
							configureCell(cell, shortcut, col - 1)
							cursor = cursor + 1
						else
							cell:Hide()
						end
					end
				end
			end
		end
	end

	hideNamed(self, "btNextMonth")
	hideNamed(self, "btPreMonth")
	hideNamed(self, "btCreateUserEvent")
	stampTitle(self)

	self:Show()
end

function layWorld_wtCalendarManager_OnUpdate(self)
	stampTitle(self)
end

function frmCalendar_TemplateCalendarDay_OnLClick(self)
	local id = self.WarpId
	if not id then
		return
	end

	self:SetChecked(false)

	if id >= PANEL_THRESHOLD then
		local action = PANEL_ACTIONS[id]
		if action then
			uiPost(action)
		end
		return nil
	end

	uiClientMsg("Warping to " .. self.WarpLabel .. "...", false)
	uiPost("RequestIntoEctype:UNLEASHED?id=" .. id)
end

return menu
