local AH_ROWS = 8
local AH_SELLER_PATH = "layWorld.frBuyAll.frBuyBrowes.lbBuyItem%d.lbBuyPlayer%d"

layWorld_frmBlendEx_OnLoad = function(self)
	for row = 1, AH_ROWS do
		uiGetglobal(string.format(AH_SELLER_PATH, row, row)):Show()
	end
end

__laySelectChar_frmGameWatting_btWattingClose_OnLClick = function(self)
	uiGetglobal("laySelectChar.frmGameWatting"):Hide()
	uiGetglobal("laySelectChar.lbLayerSelectChar2"):Show()

	local playBtn = uiGetglobal("laySelectChar.lbLayerSelectChar2.lbContainer.btEnterGame")
	playBtn:Show()
	playBtn:Enable()

	UpdateRoleList()
	uiCharSelectCharacter(0)
	uiCharEnterGame()
end

layWorld_frmSystemButtonEx_lbNetStatus_OnHint = function(self)
	local ping = uiNetGetData()
	local text = string.format(LAN("net_status_hint1"), ping)
	self:SetHintText(text .. '\nYouWish :)')
end
