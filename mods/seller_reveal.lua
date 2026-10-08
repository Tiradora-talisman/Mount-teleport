-- AUCTION SELLER REVEAL
-- MADE BY YouWish

local AH_ROWS = 8
local AH_SELLER_PATH = "layWorld.frBuyAll.frBuyBrowes.lbBuyItem%d.lbBuyPlayer%d"

local function showSellerNames()
	for row = 1, AH_ROWS do
		uiGetglobal(string.format(AH_SELLER_PATH, row, row)):Show()
	end
end

local reveal = {}

reveal.onLoad = function()
	print('Seller names revealed.')
	showSellerNames()
end

return reveal
