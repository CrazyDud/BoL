local Hero = {"Talon","Cassiopeia","Akali","Katarina","Kennen"}
--Champions coming soon (maybe): Cassiopeia, Akali, Talon, [Katarina], Kennen

--[[		Auto Update		]]
local sversion = "1.1"
local AUTOUPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/CrazyDud/BoL/master/Crazy Bundle.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH..GetCurrentEnv().FILE_NAME
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

function AutoupdaterMsg(msg) print("<font color = \"#0066CC\">[Crazy Bundle] </font> <font color = \"#fff8e7\">"..msg.."</font>") end
if AUTOUPDATE then
	local ServerData = GetWebResult(UPDATE_HOST, "/CrazyDud/BoL/master/version/Crazy Bundle.version")
	if ServerData then
		ServerVersion = type(tonumber(ServerData)) == "number" and tonumber(ServerData) or nil
		if ServerVersion then
			if tonumber(sversion) < ServerVersion then
				AutoupdaterMsg("New version available"..ServerVersion)
				AutoupdaterMsg("Updating, please don't press F9")
				DelayAction(function() DownloadFile(UPDATE_URL, UPDATE_FILE_PATH, function () AutoupdaterMsg("Successfully updated. ("..sversion.." => "..ServerVersion.."), press F9 twice to load the updated version.") end) end, 3)
			else
				AutoupdaterMsg("You have got the latest version ("..ServerVersion..")")
			end
		end
	else
		AutoupdaterMsg("Error downloading version info")
	end
end

require "SxOrbwalk"
--require "VPrediction"
require "HPrediction"

TextList = {"", "Kill Him!"}
KillText = {}
colorText = ARGB(255,255,204,0)

RedColor = 0xCC0000
GreenColor = 0xFF008000
BlueColor = 0x000099

if myHero.charName == Hero[1] then 

print (Hero[1].." script loaded.")

local W = {range = 750}
local E = {range = 700}
local R = {range = 650}
local AA = {range = 125}
local ignite = nil
local iDmg = 0
local target = nil
local ts
local ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 1000, DAMAGE_PHYSICAL, true)


function OnLoad()
	TMenu()
	IgniteCheck()
	    ItemNames				= {
		[3303]				= "ArchAngelsDummySpell",
		[3007]				= "ArchAngelsDummySpell",
		[3144]				= "BilgewaterCutlass",
		[3188]				= "ItemBlackfireTorch",
		[3153]				= "ItemSwordOfFeastAndFamine",
		[3405]				= "TrinketSweeperLvl1",
		[3411]				= "TrinketOrbLvl1",
		[3166]				= "TrinketTotemLvl1",
		[3450]				= "OdinTrinketRevive",
		[2041]				= "ItemCrystalFlask",
		[2054]				= "ItemKingPoroSnack",
		[2138]				= "ElixirOfIron",
		[2137]				= "ElixirOfRuin",
		[2139]				= "ElixirOfSorcery",
		[2140]				= "ElixirOfWrath",
		[3184]				= "OdinEntropicClaymore",
		[2050]				= "ItemMiniWard",
		[3401]				= "HealthBomb",
		[3363]				= "TrinketOrbLvl3",
		[3092]				= "ItemGlacialSpikeCast",
		[3460]				= "AscWarp",
		[3361]				= "TrinketTotemLvl3",
		[3362]				= "TrinketTotemLvl4",
		[3159]				= "HextechSweeper",
		[2051]				= "ItemHorn",
		--[2003]			= "RegenerationPotion",
		[3146]				= "HextechGunblade",
		[3187]				= "HextechSweeper",
		[3190]				= "IronStylus",
		[2004]				= "FlaskOfCrystalWater",
		[3139]				= "ItemMercurial",
		[3222]				= "ItemMorellosBane",
		[3042]				= "Muramana",
		[3043]				= "Muramana",
		[3180]				= "OdynsVeil",
		[3056]				= "ItemFaithShaker",
		[2047]				= "OracleExtractSight",
		[3364]				= "TrinketSweeperLvl3",
		[2052]				= "ItemPoroSnack",
		[3140]				= "QuicksilverSash",
		[3143]				= "RanduinsOmen",
		[3074]				= "ItemTiamatCleave",
		[3800]				= "ItemRighteousGlory",
		[2045]				= "ItemGhostWard",
		[3342]				= "TrinketOrbLvl1",
		[3040]				= "ItemSeraphsEmbrace",
		[3048]				= "ItemSeraphsEmbrace",
		[2049]				= "ItemGhostWard",
		[3345]				= "OdinTrinketRevive",
		[2044]				= "SightWard",
		[3341]				= "TrinketSweeperLvl1",
		[3069]				= "shurelyascrest",
		[3599]				= "KalistaPSpellCast",
		[3185]				= "HextechSweeper",
		[3077]				= "ItemTiamatCleave",
		[2009]				= "ItemMiniRegenPotion",
		[2010]				= "ItemMiniRegenPotion",
		[3023]				= "ItemWraithCollar",
		[3290]				= "ItemWraithCollar",
		[2043]				= "VisionWard",
		[3340]				= "TrinketTotemLvl1",
		[3090]				= "ZhonyasHourglass",-----We need this
		[3154]				= "wrigglelantern",
		[3142]				= "YoumusBlade",
		[3157]				= "ZhonyasHourglass",
		[3512]				= "ItemVoidGate",
		[3131]				= "ItemSoTD",
		[3137]				= "ItemDervishBlade",
		[3352]				= "RelicSpotter",
		[3350]				= "TrinketTotemLvl2",
	}
	_G.ITEM_1				= 06
	_G.ITEM_2				= 07
	_G.ITEM_3				= 08
	_G.ITEM_4				= 09
	_G.ITEM_5				= 10
	_G.ITEM_6				= 11
	_G.ITEM_7				= 12
	
	___GetInventorySlotItem	= rawget(_G, "GetInventorySlotItem")
	_G.GetInventorySlotItem	= GetSlotItem
end

function GetCustomTarget()
	ts:update()
	if _G.AutoCarry and ValidTarget(_G.AutoCarry.Crosshair:GetTarget()) then return _G.AutoCarry.Crosshair:GetTarget() end
	if not _G.Reborn_Loaded then return ts.target end
    if ValidTarget(SelectedTarget) then return SelectedTarget end
	return ts.target
end

function IgniteCheck()
	if myHero:GetSpellData(SUMMONER_1).name:find("summonerdot") then
		ignite = SUMMONER_1
	elseif myHero:GetSpellData(SUMMONER_2).name:find("summonerdot") then
		ignite = SUMMONER_2
	end
end

function AutoIgnite(enemy)
  	iDmg = ((IREADY and getDmg("IGNITE", enemy, myHero)) or 0) 
	if enemy.health <= iDmg and GetDistance(enemy) <= 600 and ignite ~= nil
		then
			if IREADY then CastSpell(ignite, enemy) end
	end
end

-----------------------------------------------------Target lock with Mouse----------------------------------


function OnWndMsg(Msg, Key)
	if Msg == WM_LBUTTONDOWN and TalonM.Combo.Target then
		local dist = 0
		local Selecttarget = nil
		for i, enemy in ipairs(GetEnemyHeroes()) do
			if ValidTarget(enemy) and enemy.type == myHero.type then
				if GetDistance(enemy, mousePos) <= dist or Selecttarget == nil then
					dist = GetDistance(enemy, mousePos)
					Selecttarget = enemy
				end
			end
		end
		if Selecttarget and dist < 300 then
			if SelectedTarget and Selecttarget.charName == SelectedTarget.charName then
				SelectedTarget = nil
				if TalonM.Combo.Target then 
					PrintChat("Target deselected: "..Selecttarget.charName) 
				end
			else
				SelectedTarget = Selecttarget
				if TalonM.Combo.Target then
					PrintChat("New target selected: "..Selecttarget.charName) 
				end
			end
		end
	end
end

function Checks()
	IREADY = (ignite ~= nil and myHero:CanUseSpell(ignite) == READY)
	QREADY = (myHero:CanUseSpell(_Q) == READY)
	WREADY = (myHero:CanUseSpell(_W) == READY)
	EREADY = (myHero:CanUseSpell(_E) == READY)
	RREADY = (myHero:CanUseSpell(_R) == READY)
	
	calcDmg()
	if ValidTarget(target) then
		if TalonM.Misc.KS then KS(target) end
		if TalonM.Misc.Ignite then AutoIgnite(target) end
		if TalonM.Misc.Hydra then Hydra(target) end
	end
	if TalonM.combokey then
		Combo()
	end
	if TalonM.harasskey then
		Poke()
	end
end

function OnTick()
	target = GetCustomTarget()	
	Checks()
	if _G.AutoCarry then
		_G.AutoCarry.Crosshair:ForceTarget(custom_target)
	end 
end

function TMenu()
	TalonM = scriptConfig("Talon","Talon")
		TalonM:addParam("combokey","Combo Key [defeault(Space)]",SCRIPT_PARAM_ONKEYDOWN,false,32)
		TalonM:addParam("harasskey","Harass Key[defeault(C)]",SCRIPT_PARAM_ONKEYDOWN,false,string.byte("C"))
		
	TalonM:addTS(ts)
		
	TalonM:addSubMenu("Combo", "Combo")
		TalonM.Combo:addParam("comboQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
		TalonM.Combo:addParam("comboW", "Use W", SCRIPT_PARAM_ONOFF, true)
  		TalonM.Combo:addParam("comboE", "Use E", SCRIPT_PARAM_ONOFF, true)
		TalonM.Combo:addParam("comboR", "Use R", SCRIPT_PARAM_ONOFF, true)
		TalonM.Combo:addParam("Comboing", "Q/W/E/R", SCRIPT_PARAM_ONOFF, true)-----------------change desc
        TalonM.Combo:addParam("Target", "Left Click target Lock", SCRIPT_PARAM_ONOFF, true)
		
	TalonM:addSubMenu("Harass", "Harass")
		TalonM.Harass:addParam("Harass", "Harass", SCRIPT_PARAM_ONOFF, true)
		TalonM.Harass:addParam("Mana", "Mana Manager %", SCRIPT_PARAM_SLICE, 50, 1, 100, 0)
		
	TalonM:addSubMenu("Misc", "Misc")
		TalonM.Misc:addParam("Ignite", "Use Auto Ignite", SCRIPT_PARAM_ONOFF, true)
		TalonM.Misc:addParam("KS", "Use skills to KS", SCRIPT_PARAM_ONOFF, false)
		TalonM.Misc:addParam("KSEQ", "Use E>Q to KS", SCRIPT_PARAM_ONOFF, false)
		TalonM.Misc:addParam("KSW", "Use W to KS", SCRIPT_PARAM_ONOFF, false)
		TalonM.Misc:addParam("Hydra", "Auto Use Hydra/Tiamat", SCRIPT_PARAM_ONOFF, false)
	
	TalonM:addSubMenu("Draws", "Draws")
  	    TalonM.Draws:addParam("WRange", "Draw W Range", SCRIPT_PARAM_ONOFF, true)
        TalonM.Draws:addParam("ERange", "Draw E Range", SCRIPT_PARAM_ONOFF, true)
		TalonM.Draws:addParam("RRange", "Draw R Range", SCRIPT_PARAM_ONOFF, true)
  		TalonM.Draws:addParam("Target", "Draw Circle on Target", SCRIPT_PARAM_ONOFF, true)
  		TalonM.Draws:addParam("killtext", "Show if can kill enemy", SCRIPT_PARAM_ONOFF, true)		
  		TalonM.Draws:addParam("drawHP", "Draw Dmg on HPBar", SCRIPT_PARAM_ONOFF, false)
		
	TalonM:addSubMenu("LFC", "LFC")
        TalonM.LFC:addParam("LagFree", "Activate Lag Free Circles", SCRIPT_PARAM_ONOFF, false) 
        TalonM.LFC:addParam("CL", "Length before Snapping", SCRIPT_PARAM_SLICE, 350, 75, 2000, 0) 
        TalonM.LFC:addParam("CLinfo", "Higher length = Lower FPS Drops", SCRIPT_PARAM_INFO, "") 
		
	if _G.Reborn_Loaded then
	DelayAction(function()
		PrintChat("<font color = \"#FFFFFF\">[Talon] </font><font color = \"#FF0000\">SAC Status:</font> <font color = \"#FFFFFF\">Successfully integrated.</font> </font>")
		TalonM:addParam("SACON","[Talon] SAC:R support is active.", 5, "")
		isSAC = true
	end, 10)
	elseif not _G.Reborn_Loaded then
		PrintChat("<font color = \"#FFFFFF\">[Talon] </font><font color = \"#FF0000\">Orbwalker not found:</font> <font color = \"#FFFFFF\">SxOrbWalk integrated.</font> </font>")
		TalonM:addSubMenu("Orbwalker", "SxOrb")
		SxOrb:LoadToMenu(TalonM.SxOrb)
		isSX = true
	end
	TalonM:permaShow("combokey")
	TalonM:permaShow("harasskey")
		
end

function KS(enemy)
	if TMenu.Misc.KSEQ then
		if QREADY and EREADY and getDmg("Q", enemy, myHero) > enemy.health then
			if GetDistance(enemy) <= E.range then
				CastSpell(_E, target)
				CastSpell(_Q)
			end
		end
	elseif TMenu.Misc.KSW then
		if WREADY and getDmg("W", enemy, myHero) > enemy.health then
			if GetDistance(enemy) <= W.range-150 then
				CastSpell(_W, enemy.x, enemy.z)
			end
		end
	end
end

function Combo()
	if ValidTarget(target) then
		if WREADY and TalonM.Combo.comboW and GetDistance(target) <= W.range then
			CastSpell(_W, target.x, target.z)
		end
    	if EREADY and TalonM.Combo.comboE and GetDistance(target) <= E.range then
			CastSpell(_E, target)
			if QREADY then
			CastSpell(_Q)
			end
      	end
		if QREADY and TalonM.Combo.comboQ and GetDistance(target) <= AA.range then
			CastSpell(_Q)
      	end
		if RREADY and TalonM.Combo.comboR and GetDistance(target) <= R.range then
			if EREADY then
			CastSpell(_E, target)
			end
			CastSpell(_R)
		end
	end
end

function Poke()
	if ValidTarget(target) and myHero.mana / myHero.maxMana > TalonM.Harass.Mana / 100 then
    	if TalonM.Harass.Harass then
			if WREADY and GetDistance(target) <= W.range-100 then
				CastSpell(_W, target.x, target.z)
			end
		end
	end
end

function calcDmg()
	for i=1, heroManager.iCount do
		local Target = heroManager:GetHero(i)
		if ValidTarget(Target) and Target ~= nil then
			qDmg = ((QREADY and getDmg("Q", Target, myHero)) or 0)
			wDmg = ((WREADY and getDmg("W", Target, myHero)) or 0)
			eDmg = ((EREADY and getDmg("E", Target, myHero)) or 0)
			rDmg = ((RREADY and getDmg("R", Target, myHero)) or 0)
			allDmg = (qDmg) + ((wDmg)*3) + (eDmg) + (rDmg)
			
			if Target.health > allDmg then
				KillText[i] = 1
			elseif Target.health <= allDmg then
				KillText[i] = 2
			end
		end
	end	
end

for i, enemy in ipairs(GetEnemyHeroes()) do
    enemy.barData = {PercentageOffset = {x = 0, y = 0} }
end

-----------------------------------------------------------------------LFC-----------------------------------

-- Barasia, vadash, viseversa
function DrawCircleNextLvl(x, y, z, radius, width, color, chordlength)
	radius = radius or 300
	quality = math.max(8,round(180/math.deg((math.asin((chordlength/(2*radius)))))))
	quality = 2 * math.pi / quality
	radius = radius*.92
	local points = {}
	for theta = 0, 2 * math.pi + quality, quality do
		local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
		points[#points + 1] = D3DXVECTOR2(c.x, c.y)
	end
	DrawLines2(points, width or 1, color or 4294967295)
end

function round(num)
	if num >= 0 then return math.floor(num+.5) else return math.ceil(num-.5) end
end

function DrawCircle2(x, y, z, radius, color)
	local vPos1 = Vector(x, y, z)
	local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
	local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
	local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
	if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y }) then
		DrawCircleNextLvl(x, y, z, radius, 1, color, 80)
	end
end

function GetEnemyHPBarPos(enemy)

    if not enemy.barData then
        return
    end

    local barPos = GetUnitHPBarPos(enemy)
    local barPosOffset = GetUnitHPBarOffset(enemy)
    local barOffset = Point(enemy.barData.PercentageOffset.x, enemy.barData.PercentageOffset.y)
    local barPosPercentageOffset = Point(enemy.barData.PercentageOffset.x, enemy.barData.PercentageOffset.y)

    local BarPosOffsetX = 169
    local BarPosOffsetY = 47
    local CorrectionX = 16
    local CorrectionY = 4

    barPos.x = barPos.x + (barPosOffset.x - 0.5 + barPosPercentageOffset.x) * BarPosOffsetX + CorrectionX
    barPos.y = barPos.y + (barPosOffset.y - 0.5 + barPosPercentageOffset.y) * BarPosOffsetY + CorrectionY 

    local StartPos = Point(barPos.x, barPos.y)
    local EndPos = Point(barPos.x + 103, barPos.y)

    return Point(StartPos.x, StartPos.y), Point(EndPos.x, EndPos.y)

end

function DrawIndicator(enemy)
	local Qdmg, Wdmg, Edmg, Rdmg, AAdmg = getDmg("Q", enemy, myHero), getDmg("W", enemy, myHero), getDmg("E", enemy, myHero), getDmg("R", enemy, myHero), getDmg("AD", enemy, myHero)
	
	Qdmg = ((QREADY and Qdmg) or 0)
	Edmg = ((EREADY and Edmg) or 0)
	Wdmg = ((WREADY and Wdmg) or 0)
	Rdmg = ((RREADY and Rdmg) or 0)
	AAdmg = ((Aadmg) or 0)

    local damage = AAdmg + Qdmg + Wdmg + Edmg + Rdmg 

    local SPos, EPos = GetEnemyHPBarPos(enemy)

    if not SPos then return end

    local barwidth = EPos.x - SPos.x
    local Position = SPos.x + math.max(0, (enemy.health - damage) / enemy.maxHealth) * barwidth

	DrawText("|", 16, math.floor(Position), math.floor(SPos.y + 8), ARGB(255,0,255,0))
    DrawText("HP: "..math.floor(enemy.health - damage), 12, math.floor(SPos.x + 25), math.floor(SPos.y - 15), (enemy.health - damage) > 0 and ARGB(255, 0, 255, 0) or  ARGB(255, 255, 0, 0))
end

---------------------------Auto Hydra/Tiamat-------------------------------
function GetSlotItem(id, unit)
	
	unit 		= unit or myHero

	if (not ItemNames[id]) then
		return ___GetInventorySlotItem(id, unit)
	end

	local name	= ItemNames[id]
	
	for slot = ITEM_1, ITEM_7 do
		local item = unit:GetSpellData(slot).name
		if ((#item > 0) and (item:lower() == name:lower())) then
			return slot
		end
	end

end

function Hydra(unit)
	local Slot = GetInventorySlotItem(3074)
		if Slot ~= nil and myHero:CanUseSpell(Slot) == READY and ValidTarget(unit) then
			if GetDistance(unit) <= 385 and TalonM.combokey then
				CastSpell(Slot)
			end
	end
end

function OnDraw()
	if TalonM.LFC.LagFree then
		if WREADY and not myHero.dead then
			if TalonM.Draws.WRange then
				DrawCircle2(myHero.x, myHero.y, myHero.z, W.range, 0xFF008000)
			end
		end
		if EREADY and not myHero.dead then
			if TalonM.Draws.ERange then
				DrawCircle2(myHero.x, myHero.y, myHero.z, E.range, 0xFF008000)
			end
		end
		if RREADY and not myHero.dead then
			if TalonM.Draws.RRange then
				DrawCircle2(myHero.x, myHero.y, myHero.z, R.range, 0xFF008000)
			end
		end
		if TalonM.Draws.Target and ValidTarget(target) then
			DrawCircle2(target.x, target.y, target.z, 80, ARGB(255, 10, 255, 10))
			DrawCircle2(target.x, target.y, target.z, 100, ARGB(255, 102, 204, 51))
		end
	else
		if WREADY and not myHero.dead then
			if TalonM.Draws.WRange then
				DrawCircle(myHero.x, myHero.y, myHero.z, W.range, 0xCCCCCC)
			end
		end
		if EREADY and not myHero.dead then
			if TalonM.Draws.ERange then
				DrawCircle(myHero.x, myHero.y, myHero.z, E.range, 0xCC0000)
			end
		end
		if RREADY and not myHero.dead then
			if TalonM.Draws.RRange then
				DrawCircle(myHero.x, myHero.y, myHero.z, R.range, 0x000099)
			end
		end
		if TalonM.Draws.Target and ValidTarget(target) then
			DrawCircle(target.x, target.y, target.z, 80, ARGB(255, 10, 255, 10))
			DrawCircle(target.x, target.y, target.z, 100, ARGB(255, 102, 204, 51))
		end
	end
   if  TalonM.Draws.drawHP then
			for i, enemy in ipairs(GetEnemyHeroes()) do
       			if ValidTarget(enemy) then
			       DrawIndicator(enemy)
			    end
	        end
	end		
   if TalonM.Draws.killtext then
      for i = 1, heroManager.iCount do
			local target = heroManager:GetHero(i)
			if ValidTarget(target) and target ~= nil then
			    if ValidTarget(target) and target ~= nil then
				local barPos = WorldToScreen(D3DXVECTOR3(target.x, target.y, target.z))
				local PosX = barPos.x - 35
				local PosY = barPos.y - 10
				
				DrawText(TextList[KillText[i]], 16, PosX, PosY, colorText)
			
			    end
			end
		end
   end
end
end
if myHero.charName == Hero[2] then

print (Hero[2].." script loaded.")

local Q = {range = 850}
local W = {range = 850}
local E = {range = 700}
local R = {range = 900}
local AA = {range = 550}
local ignite = nil
local iDmg = 0
local target = nil
local HPred = HPrediction()
local ts
local ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 1000, DAMAGE_MAGICAL, true)


function OnLoad()
	CMenu()
	IgniteCheck()
	    ItemNames				= {
		[3303]				= "ArchAngelsDummySpell",
		[3007]				= "ArchAngelsDummySpell",
		[3144]				= "BilgewaterCutlass",
		[3188]				= "ItemBlackfireTorch",
		[3153]				= "ItemSwordOfFeastAndFamine",
		[3405]				= "TrinketSweeperLvl1",
		[3411]				= "TrinketOrbLvl1",
		[3166]				= "TrinketTotemLvl1",
		[3450]				= "OdinTrinketRevive",
		[2041]				= "ItemCrystalFlask",
		[2054]				= "ItemKingPoroSnack",
		[2138]				= "ElixirOfIron",
		[2137]				= "ElixirOfRuin",
		[2139]				= "ElixirOfSorcery",
		[2140]				= "ElixirOfWrath",
		[3184]				= "OdinEntropicClaymore",
		[2050]				= "ItemMiniWard",
		[3401]				= "HealthBomb",
		[3363]				= "TrinketOrbLvl3",
		[3092]				= "ItemGlacialSpikeCast",
		[3460]				= "AscWarp",
		[3361]				= "TrinketTotemLvl3",
		[3362]				= "TrinketTotemLvl4",
		[3159]				= "HextechSweeper",
		[2051]				= "ItemHorn",
		--[2003]			= "RegenerationPotion",
		[3146]				= "HextechGunblade",
		[3187]				= "HextechSweeper",
		[3190]				= "IronStylus",
		[2004]				= "FlaskOfCrystalWater",
		[3139]				= "ItemMercurial",
		[3222]				= "ItemMorellosBane",
		[3042]				= "Muramana",
		[3043]				= "Muramana",
		[3180]				= "OdynsVeil",
		[3056]				= "ItemFaithShaker",
		[2047]				= "OracleExtractSight",
		[3364]				= "TrinketSweeperLvl3",
		[2052]				= "ItemPoroSnack",
		[3140]				= "QuicksilverSash",
		[3143]				= "RanduinsOmen",
		[3074]				= "ItemTiamatCleave",
		[3800]				= "ItemRighteousGlory",
		[2045]				= "ItemGhostWard",
		[3342]				= "TrinketOrbLvl1",
		[3040]				= "ItemSeraphsEmbrace",
		[3048]				= "ItemSeraphsEmbrace",
		[2049]				= "ItemGhostWard",
		[3345]				= "OdinTrinketRevive",
		[2044]				= "SightWard",
		[3341]				= "TrinketSweeperLvl1",
		[3069]				= "shurelyascrest",
		[3599]				= "KalistaPSpellCast",
		[3185]				= "HextechSweeper",
		[3077]				= "ItemTiamatCleave",
		[2009]				= "ItemMiniRegenPotion",
		[2010]				= "ItemMiniRegenPotion",
		[3023]				= "ItemWraithCollar",
		[3290]				= "ItemWraithCollar",
		[2043]				= "VisionWard",
		[3340]				= "TrinketTotemLvl1",
		[3090]				= "ZhonyasHourglass",-----We need this
		[3154]				= "wrigglelantern",
		[3142]				= "YoumusBlade",
		[3157]				= "ZhonyasHourglass",
		[3512]				= "ItemVoidGate",
		[3131]				= "ItemSoTD",
		[3137]				= "ItemDervishBlade",
		[3352]				= "RelicSpotter",
		[3350]				= "TrinketTotemLvl2",
	}
	_G.ITEM_1				= 06
	_G.ITEM_2				= 07
	_G.ITEM_3				= 08
	_G.ITEM_4				= 09
	_G.ITEM_5				= 10
	_G.ITEM_6				= 11
	_G.ITEM_7				= 12
	
	___GetInventorySlotItem	= rawget(_G, "GetInventorySlotItem")
	_G.GetInventorySlotItem	= GetSlotItem
	
end

function GetCustomTarget()
	ts:update()
	if _G.AutoCarry and ValidTarget(_G.AutoCarry.Crosshair:GetTarget()) then return _G.AutoCarry.Crosshair:GetTarget() end
	if not _G.Reborn_Loaded then return ts.target end
    if ValidTarget(SelectedTarget) then return SelectedTarget end
	return ts.target
end

function IgniteCheck()
	if myHero:GetSpellData(SUMMONER_1).name:find("summonerdot") then
		ignite = SUMMONER_1
	elseif myHero:GetSpellData(SUMMONER_2).name:find("summonerdot") then
		ignite = SUMMONER_2
	end
end

function AutoIgnite(enemy)
  	iDmg = ((IREADY and getDmg("IGNITE", enemy, myHero)) or 0) 
	if enemy.health <= iDmg and GetDistance(enemy) <= 600 and ignite ~= nil
		then
			if IREADY then CastSpell(ignite, enemy) end
	end
end

-----------------------------------------------------Target lock with Mouse----------------------------------


function OnWndMsg(Msg, Key)
	if Msg == WM_LBUTTONDOWN and CassM.Combo.Target then
		local dist = 0
		local Selecttarget = nil
		for i, enemy in ipairs(GetEnemyHeroes()) do
			if ValidTarget(enemy) and enemy.type == myHero.type then
				if GetDistance(enemy, mousePos) <= dist or Selecttarget == nil then
					dist = GetDistance(enemy, mousePos)
					Selecttarget = enemy
				end
			end
		end
		if Selecttarget and dist < 300 then
			if SelectedTarget and Selecttarget.charName == SelectedTarget.charName then
				SelectedTarget = nil
				if CassM.Combo.Target then 
					PrintChat("Target deselected: "..Selecttarget.charName) 
				end
			else
				SelectedTarget = Selecttarget
				if CassM.Combo.Target then
					PrintChat("New target selected: "..Selecttarget.charName) 
				end
			end
		end
	end
end

function Checks()
	IREADY = (ignite ~= nil and myHero:CanUseSpell(ignite) == READY)
	QREADY = (myHero:CanUseSpell(_Q) == READY)
	WREADY = (myHero:CanUseSpell(_W) == READY)
	EREADY = (myHero:CanUseSpell(_E) == READY)
	RREADY = (myHero:CanUseSpell(_R) == READY)
	
	calcDmg()
	if ValidTarget(target) then
		if CassM.Misc.KS then KS(target) end
		if CassM.Misc.Ignite then AutoIgnite(target) end
	end
	if CassM.combokey then
		Combo()
	end
	if CassM.harasskey then
		Poke()
	end
end

function OnTick()
	Zhonya()
	target = GetCustomTarget()	
	Checks()
	if _G.AutoCarry then
		_G.AutoCarry.Crosshair:ForceTarget(custom_target)
	end 
end

function CMenu()
	CassM = scriptConfig("Casseiopia","Casseiopia")
		CassM:addParam("combokey","Combo Key [defeault(Space)]",SCRIPT_PARAM_ONKEYDOWN,false,32)
		CassM:addParam("harasskey","Harass Key[defeault(C)]",SCRIPT_PARAM_ONKEYDOWN,false,string.byte("C"))
		
	CassM:addTS(ts)
		
	CassM:addSubMenu("Combo", "Combo")
		CassM.Combo:addParam("comboQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
		CassM.Combo:addParam("comboW", "Use W", SCRIPT_PARAM_ONOFF, true)
  		CassM.Combo:addParam("comboE", "Use E", SCRIPT_PARAM_ONOFF, true)
		CassM.Combo:addParam("comboR", "Use R", SCRIPT_PARAM_ONOFF, true)
		CassM.Combo:addParam("Comboing", "R/Q/W/E", SCRIPT_PARAM_ONOFF, true)-----------------change desc
        CassM.Combo:addParam("Target", "Left Click target Lock", SCRIPT_PARAM_ONOFF, true)
		
	CassM:addSubMenu("Harass", "Harass")
		CassM.Harass:addParam("Harass", "Harass", SCRIPT_PARAM_ONOFF, true)
		CassM.Harass:addParam("Mana", "Mana Manager %", SCRIPT_PARAM_SLICE, 50, 1, 100, 0)
		
	CassM:addSubMenu("Misc", "Misc")
		CassM.Misc:addParam("Ignite", "Use Auto Ignite", SCRIPT_PARAM_ONOFF, true)
		CassM.Misc:addParam("KS", "Use skills to KS", SCRIPT_PARAM_ONOFF, false)
		CassM.Misc:addParam("KSE", "Use E to KS", SCRIPT_PARAM_ONOFF, false)
		CassM.Misc:addParam("KSR", "Use R to KS", SCRIPT_PARAM_ONOFF, false)
		CassM.Misc:addParam("Pred2", "Use Hpred", SCRIPT_PARAM_ONOFF, true)
	
	CassM:addSubMenu("Draws", "Draws")
		CassM.Draws:addParam("QRange", "Draw Q Range", SCRIPT_PARAM_ONOFF, true)
  	    CassM.Draws:addParam("WRange", "Draw W Range", SCRIPT_PARAM_ONOFF, true)
        CassM.Draws:addParam("ERange", "Draw E Range", SCRIPT_PARAM_ONOFF, true)
		CassM.Draws:addParam("RRange", "Draw R Range", SCRIPT_PARAM_ONOFF, true)
  		CassM.Draws:addParam("Target", "Draw Circle on Target", SCRIPT_PARAM_ONOFF, true)
  		CassM.Draws:addParam("killtext", "Show if can kill enemy", SCRIPT_PARAM_ONOFF, true)		
  		CassM.Draws:addParam("drawHPb", "Draw Dmg on HPBar", SCRIPT_PARAM_ONOFF, false)
		
	CassM:addSubMenu("LFC", "LFC")
        CassM.LFC:addParam("LagFree", "Activate Lag Free Circles", SCRIPT_PARAM_ONOFF, false) 
        CassM.LFC:addParam("CL", "Length before Snapping", SCRIPT_PARAM_SLICE, 350, 75, 2000, 0) 
        CassM.LFC:addParam("CLinfo", "Higher length = Lower FPS Drops", SCRIPT_PARAM_INFO, "") 
		
	 CassM:addSubMenu("More", "More")
        CassM.More:addParam("Zhonya", "Auto Zhonya", SCRIPT_PARAM_ONOFF, true)
        CassM.More:addParam("ZhonyaHP", "Use Zhonyas at % health", SCRIPT_PARAM_SLICE, 20, 0, 100 , 0)
        CassM.More:addParam("Amount", "Zhonya if x Enemies", SCRIPT_PARAM_SLICE, 1, 0, 5, 0)
		
	if _G.Reborn_Loaded then
	DelayAction(function()
		PrintChat("<font color = \"#FFFFFF\">[Casseiopia] </font><font color = \"#FF0000\">SAC Status:</font> <font color = \"#FFFFFF\">Successfully integrated.</font> </font>")
		CassM:addParam("SACON","[Casseiopia] SAC:R support is active.", 5, "")
		isSAC = true
	end, 10)
	elseif not _G.Reborn_Loaded then
		PrintChat("<font color = \"#FFFFFF\">[Casseiopia] </font><font color = \"#FF0000\">Orbwalker not found:</font> <font color = \"#FFFFFF\">SxOrbWalk integrated.</font> </font>")
		CassM:addSubMenu("Orbwalker", "SxOrb")
		SxOrb:LoadToMenu(CassM.SxOrb)
		isSX = true
	end
	CassM:permaShow("combokey")
	CassM:permaShow("harasskey")
		
end


function Farm()
	
end

function KS(enemy)---change
	if CassM.Misc.KSE then
		if EREADY and getDmg("E", enemy, myHero) > enemy.health then
			if GetDistance(enemy) <= E.range then
				CastSpell(_E, target)
			end
		end
	elseif CassM.Misc.KSR then
		if RREADY and getDmg("R", enemy, myHero) > enemy.health then
			if GetDistance(enemy) <= R.range-150 then
				CastSpell(_R, enemy.x, enemy.z)
			end
		end
	end
end

function HPredQ(unit)
    local unit = target
    local QPos, QHitChance = HPred:GetPredict("Q", unit, myHero)
    if QHitChance >= 1 then
       CastSpell(_Q, QPos.x, QPos.z)
    end
end

function HPredW(unit)
    local unit = target
    local WPos, WHitChance = HPred:GetPredict("W", unit, myHero)
    if WHitChance >= 1 then
       CastSpell(_W, WPos.x, WPos.z)
    end
end

function Combo()--change
	if ValidTarget(target) then
		if RREADY and CassM.Combo.comboR and GetDistance(target) <= R.range-150 then
			CastSpell(_R, target.x, target.z)
		end
    	if EREADY and CassM.Combo.comboE and GetDistance(target) <= E.range then
			if QREADY and GetDistance(target) <= Q.range then
			if CassM.Misc.Pred2 then
			HPredQ()
			elseif not CassM.Misc.Pred then
			CastSpell(_Q, target.x, target.z)
			end
			elseif WREADY and GetDistance(target) <= W.range then
			if CassM.Misc.Pred2 then
			HPredW()
			elseif not CassM.Misc.Pred then
			CastSpell(_W, target.x, target.z)
			end
			end
			CastSpell(_E, target)
      	end
		if QREADY and CassM.Combo.comboQ and GetDistance(target) <= Q.range then
			if CassM.Misc.Pred2 then
			HPredQ()
			elseif not CassM.Misc.Pred then
			CastSpell(_Q, target.x, target.z)
			end
      	end
		if WREADY and CassM.Combo.comboW and GetDistance(target) <= W.range then
			if CassM.Misc.Pred2 then
			HPredW()
			elseif not CassM.Misc.Pred then
			CastSpell(_W, target.x, target.z)
			end
		end
	end
end

function Poke()--change
	if ValidTarget(target) and myHero.mana / myHero.maxMana > CassM.Harass.Mana / 100 then
    	if CassM.Harass.Harass then
			if WREADY and GetDistance(target) <= W.range then
				if CassM.Misc.Pred2 then
				HPredW()
				elseif not CassM.Misc.Pred then
				CastSpell(_W, target.x, target.z)
				end
				if EREADY and GetDistance(target) <= E.range then
					CastSpell(_E, target)
				end
			end
			if QREADY and GetDistance(target) <= Q.range then
				if CassM.Misc.Pred2 then
				HPredQ()
				elseif not CassM.Misc.Pred then
				CastSpell(_Q, target.x, target.z)
				end
				if EREADY and GetDistance(target) <= E.range then
					CastSpell(_E, target)
				end
			end
		end
	end
end

function calcDmg()
	for i=1, heroManager.iCount do
		local Target = heroManager:GetHero(i)
		if ValidTarget(Target) and Target ~= nil then
			qDmg = ((QREADY and getDmg("Q", Target, myHero)) or 0)
			wDmg = ((WREADY and getDmg("W", Target, myHero)) or 0)
			eDmg = ((EREADY and getDmg("E", Target, myHero)) or 0)
			rDmg = ((RREADY and getDmg("R", Target, myHero)) or 0)
			allDmg = (qDmg) + ((wDmg)*3) + (eDmg) + (rDmg)
			
			if Target.health > allDmg then
				KillText[i] = 1
			elseif Target.health <= allDmg then
				KillText[i] = 2
			end
		end
	end	
end

for i, enemy in ipairs(GetEnemyHeroes()) do
    enemy.barData = {PercentageOffset = {x = 0, y = 0} }
end

-----------------------------------------------------------------------LFC-----------------------------------

-- Barasia, vadash, viseversa
function DrawCircleNextLvl(x, y, z, radius, width, color, chordlength)
	radius = radius or 300
	quality = math.max(8,round(180/math.deg((math.asin((chordlength/(2*radius)))))))
	quality = 2 * math.pi / quality
	radius = radius*.92
	local points = {}
	for theta = 0, 2 * math.pi + quality, quality do
		local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
		points[#points + 1] = D3DXVECTOR2(c.x, c.y)
	end
	DrawLines2(points, width or 1, color or 4294967295)
end

function round(num)
	if num >= 0 then return math.floor(num+.5) else return math.ceil(num-.5) end
end

function DrawCircle2(x, y, z, radius, color)
	local vPos1 = Vector(x, y, z)
	local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
	local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
	local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
	if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y }) then
		DrawCircleNextLvl(x, y, z, radius, 1, color, 80)
	end
end

function GetEnemyHPBarPos(enemy)

    if not enemy.barData then
        return
    end

    local barPos = GetUnitHPBarPos(enemy)
    local barPosOffset = GetUnitHPBarOffset(enemy)
    local barOffset = Point(enemy.barData.PercentageOffset.x, enemy.barData.PercentageOffset.y)
    local barPosPercentageOffset = Point(enemy.barData.PercentageOffset.x, enemy.barData.PercentageOffset.y)

    local BarPosOffsetX = 169
    local BarPosOffsetY = 47
    local CorrectionX = 16
    local CorrectionY = 4

    barPos.x = barPos.x + (barPosOffset.x - 0.5 + barPosPercentageOffset.x) * BarPosOffsetX + CorrectionX
    barPos.y = barPos.y + (barPosOffset.y - 0.5 + barPosPercentageOffset.y) * BarPosOffsetY + CorrectionY 

    local StartPos = Point(barPos.x, barPos.y)
    local EndPos = Point(barPos.x + 103, barPos.y)

    return Point(StartPos.x, StartPos.y), Point(EndPos.x, EndPos.y)

end

function DrawIndicator(enemy)
	local Qdmg, Wdmg, Edmg, Rdmg, AAdmg = getDmg("Q", enemy, myHero), getDmg("W", enemy, myHero), getDmg("E", enemy, myHero), getDmg("R", enemy, myHero), getDmg("AD", enemy, myHero)
	
	Qdmg = ((QREADY and Qdmg) or 0)
	Edmg = ((EREADY and Edmg) or 0)
	Wdmg = ((WREADY and Wdmg) or 0)
	Rdmg = ((RREADY and Rdmg) or 0)
	--AAdmg = ((Aadmg) or 0)

    local damage = --[[AAdmg +]] Qdmg + Wdmg + Edmg + Rdmg 

    local SPos, EPos = GetEnemyHPBarPos(enemy)

    if not SPos then return end

    local barwidth = EPos.x - SPos.x
    local Position = SPos.x + math.max(0, (enemy.health - damage) / enemy.maxHealth) * barwidth

	DrawText("|", 16, math.floor(Position), math.floor(SPos.y + 8), ARGB(255,0,255,0))
    DrawText("HP: "..math.floor(enemy.health - damage), 12, math.floor(SPos.x + 25), math.floor(SPos.y - 15), (enemy.health - damage) > 0 and ARGB(255, 0, 255, 0) or  ARGB(255, 255, 0, 0))
end

--------------------------------------------------Auto Zhonyas---------------------------------------------

function GetSlotItem(id, unit)
	
	unit 		= unit or myHero

	if (not ItemNames[id]) then
		return ___GetInventorySlotItem(id, unit)
	end

	local name	= ItemNames[id]
	
	for slot = ITEM_1, ITEM_7 do
		local item = unit:GetSpellData(slot).name
		if ((#item > 0) and (item:lower() == name:lower())) then
			return slot
		end
	end

end



function Zhonya()
	local Slot = GetInventorySlotItem(3090)
		if Slot ~= nil and myHero:CanUseSpell(Slot) == READY then
			local Range = 900
			local Amount = CassM.More.Amount
			local health = myHero.health
			local maxHealth = myHero.maxHealth
				if ((myHero.health/myHero.maxHealth)*100) <= CassM.More.ZhonyaHP and CountEnemyHeroInRange(900) >= CassM.More.Amount then
			CastSpell(Slot)
				end
		end
end


function OnDraw()
	if CassM.LFC.LagFree then
		if WREADY and not myHero.dead then
			if CassM.Draws.WRange then
				DrawCircle2(myHero.x, myHero.y, myHero.z, W.range, 0xFF008000)
			end
		end
		if EREADY and not myHero.dead then
			if CassM.Draws.ERange then
				DrawCircle2(myHero.x, myHero.y, myHero.z, E.range, 0xFF008000)
			end
		end
		if RREADY and not myHero.dead then
			if CassM.Draws.RRange then
				DrawCircle2(myHero.x, myHero.y, myHero.z, R.range, 0xFF008000)
			end
		end
		if CassM.Draws.Target and ValidTarget(target) then
			DrawCircle2(target.x, target.y, target.z, 80, ARGB(255, 10, 255, 10))
			DrawCircle2(target.x, target.y, target.z, 100, ARGB(255, 102, 204, 51))
		end
	else
		if WREADY and not myHero.dead then
			if CassM.Draws.WRange then
				DrawCircle(myHero.x, myHero.y, myHero.z, W.range, RedColor)
			end
		end
		if EREADY and not myHero.dead then
			if CassM.Draws.ERange then
				DrawCircle(myHero.x, myHero.y, myHero.z, E.range, GreenColor)
			end
		end
		if RREADY and not myHero.dead then
			if CassM.Draws.RRange then
				DrawCircle(myHero.x, myHero.y, myHero.z, R.range, BlueColor)
			end
		end
		if CassM.Draws.Target and ValidTarget(target) then
			DrawCircle(target.x, target.y, target.z, 80, ARGB(255, 10, 255, 10))
			DrawCircle(target.x, target.y, target.z, 100, ARGB(255, 102, 204, 51))
		end
	end
   if  CassM.Draws.drawHPb then
			for i, enemy in ipairs(GetEnemyHeroes()) do
       			if ValidTarget(enemy) then
			       DrawIndicator(enemy)
			    end
	        end
	end		
   if CassM.Draws.killtext then
      for i = 1, heroManager.iCount do
			local target = heroManager:GetHero(i)
			if ValidTarget(target) and target ~= nil then
			    if ValidTarget(target) and target ~= nil then
				local barPos = WorldToScreen(D3DXVECTOR3(target.x, target.y, target.z))
				local PosX = barPos.x - 35
				local PosY = barPos.y - 10
				
				DrawText(TextList[KillText[i]], 16, PosX, PosY, colorText)
			
			    end
			end
		end
   end
end
end
if myHero.charName == Hero[3] then
print (Hero[3].." script loaded.")
--Akali
end
if myHero.charName == Hero[4] then
print (Hero[4].." script loaded.")

local Q = {range = 675}
local W = {range = 375}
local E = {range = 700}
local R = {range = 550}
local AA = {range = 125}
local ignite = nil
local iDmg = 0
local target = nil
local ts
local ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 1000, DAMAGE_MAGICAL, true)



function OnLoad()
	KMenu()
	IgniteCheck()
	    ItemNames				= {
		[3303]				= "ArchAngelsDummySpell",
		[3007]				= "ArchAngelsDummySpell",
		[3144]				= "BilgewaterCutlass",
		[3188]				= "ItemBlackfireTorch",
		[3153]				= "ItemSwordOfFeastAndFamine",
		[3405]				= "TrinketSweeperLvl1",
		[3411]				= "TrinketOrbLvl1",
		[3166]				= "TrinketTotemLvl1",
		[3450]				= "OdinTrinketRevive",
		[2041]				= "ItemCrystalFlask",
		[2054]				= "ItemKingPoroSnack",
		[2138]				= "ElixirOfIron",
		[2137]				= "ElixirOfRuin",
		[2139]				= "ElixirOfSorcery",
		[2140]				= "ElixirOfWrath",
		[3184]				= "OdinEntropicClaymore",
		[2050]				= "ItemMiniWard",
		[3401]				= "HealthBomb",
		[3363]				= "TrinketOrbLvl3",
		[3092]				= "ItemGlacialSpikeCast",
		[3460]				= "AscWarp",
		[3361]				= "TrinketTotemLvl3",
		[3362]				= "TrinketTotemLvl4",
		[3159]				= "HextechSweeper",
		[2051]				= "ItemHorn",
		--[2003]			= "RegenerationPotion",
		[3146]				= "HextechGunblade",
		[3187]				= "HextechSweeper",
		[3190]				= "IronStylus",
		[2004]				= "FlaskOfCrystalWater",
		[3139]				= "ItemMercurial",
		[3222]				= "ItemMorellosBane",
		[3042]				= "Muramana",
		[3043]				= "Muramana",
		[3180]				= "OdynsVeil",
		[3056]				= "ItemFaithShaker",
		[2047]				= "OracleExtractSight",
		[3364]				= "TrinketSweeperLvl3",
		[2052]				= "ItemPoroSnack",
		[3140]				= "QuicksilverSash",
		[3143]				= "RanduinsOmen",
		[3074]				= "ItemTiamatCleave",
		[3800]				= "ItemRighteousGlory",
		[2045]				= "ItemGhostWard",
		[3342]				= "TrinketOrbLvl1",
		[3040]				= "ItemSeraphsEmbrace",
		[3048]				= "ItemSeraphsEmbrace",
		[2049]				= "ItemGhostWard",
		[3345]				= "OdinTrinketRevive",
		[2044]				= "SightWard",
		[3341]				= "TrinketSweeperLvl1",
		[3069]				= "shurelyascrest",
		[3599]				= "KalistaPSpellCast",
		[3185]				= "HextechSweeper",
		[3077]				= "ItemTiamatCleave",
		[2009]				= "ItemMiniRegenPotion",
		[2010]				= "ItemMiniRegenPotion",
		[3023]				= "ItemWraithCollar",
		[3290]				= "ItemWraithCollar",
		[2043]				= "VisionWard",
		[3340]				= "TrinketTotemLvl1",
		[3090]				= "ZhonyasHourglass",-----We need this
		[3154]				= "wrigglelantern",
		[3142]				= "YoumusBlade",
		[3157]				= "ZhonyasHourglass",
		[3512]				= "ItemVoidGate",
		[3131]				= "ItemSoTD",
		[3137]				= "ItemDervishBlade",
		[3352]				= "RelicSpotter",
		[3350]				= "TrinketTotemLvl2",
	}
	_G.ITEM_1				= 06
	_G.ITEM_2				= 07
	_G.ITEM_3				= 08
	_G.ITEM_4				= 09
	_G.ITEM_5				= 10
	_G.ITEM_6				= 11
	_G.ITEM_7				= 12
	
	___GetInventorySlotItem	= rawget(_G, "GetInventorySlotItem")
	_G.GetInventorySlotItem	= GetSlotItem
	
end

function GetCustomTarget()
	ts:update()
	if _G.AutoCarry and ValidTarget(_G.AutoCarry.Crosshair:GetTarget()) then return _G.AutoCarry.Crosshair:GetTarget() end
	if not _G.Reborn_Loaded then return ts.target end
    if ValidTarget(SelectedTarget) then return SelectedTarget end
	return ts.target
end

function IgniteCheck()
	if myHero:GetSpellData(SUMMONER_1).name:find("summonerdot") then
		ignite = SUMMONER_1
	elseif myHero:GetSpellData(SUMMONER_2).name:find("summonerdot") then
		ignite = SUMMONER_2
	end
end

function AutoIgnite(enemy)
  	iDmg = ((IREADY and getDmg("IGNITE", enemy, myHero)) or 0) 
	if enemy.health <= iDmg and GetDistance(enemy) <= 600 and ignite ~= nil
		then
			if IREADY then CastSpell(ignite, enemy) end
	end
end

-----------------------------------------------------Target lock with Mouse----------------------------------


function OnWndMsg(Msg, Key)
	if Msg == WM_LBUTTONDOWN and KatarM.Combo.Target then
		local dist = 0
		local Selecttarget = nil
		for i, enemy in ipairs(GetEnemyHeroes()) do
			if ValidTarget(enemy) and enemy.type == myHero.type then
				if GetDistance(enemy, mousePos) <= dist or Selecttarget == nil then
					dist = GetDistance(enemy, mousePos)
					Selecttarget = enemy
				end
			end
		end
		if Selecttarget and dist < 300 then
			if SelectedTarget and Selecttarget.charName == SelectedTarget.charName then
				SelectedTarget = nil
				if KatarM.Combo.Target then 
					PrintChat("Target deselected: "..Selecttarget.charName) 
				end
			else
				SelectedTarget = Selecttarget
				if KatarM.Combo.Target then
					PrintChat("New target selected: "..Selecttarget.charName) 
				end
			end
		end
	end
end

function Checks()
	IREADY = (ignite ~= nil and myHero:CanUseSpell(ignite) == READY)
	QREADY = (myHero:CanUseSpell(_Q) == READY)
	WREADY = (myHero:CanUseSpell(_W) == READY)
	EREADY = (myHero:CanUseSpell(_E) == READY)
	RREADY = (myHero:CanUseSpell(_R) == READY)
	
	calcDmg()
	if ValidTarget(target) then
		if KatarM.Misc.KS then 
		if KatarM.Misc.KSQ then
			CastSpell(_Q, target)
		elseif KatarM.Misc.KSEW then
			CastSpell(_E, target)
			CastSpell(_W)
		end
		end
		if KatarM.Misc.Ignite then AutoIgnite(target) end
	end
	if KatarM.combokey then
		Combo()
	end
	if KatarM.harasskey then
		Poke()
	end
end

function OnTick()
	target = GetCustomTarget()	
	Checks()
	if _G.AutoCarry then
		_G.AutoCarry.Crosshair:ForceTarget(custom_target)
	end 
end

function KMenu()
	KatarM = scriptConfig("Katarina","Katarina")
		KatarM:addParam("combokey","Combo Key [defeault(Z)]",SCRIPT_PARAM_ONKEYDOWN,false,string.byte("Z"))
		KatarM:addParam("harasskey","Harass Key[defeault(C)]",SCRIPT_PARAM_ONKEYDOWN,false,string.byte("C"))
		
	KatarM:addTS(ts)
		
	KatarM:addSubMenu("Combo", "Combo")
		KatarM.Combo:addParam("comboQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
		KatarM.Combo:addParam("comboW", "Use W", SCRIPT_PARAM_ONOFF, true)
  		KatarM.Combo:addParam("comboE", "Use E", SCRIPT_PARAM_ONOFF, true)
		KatarM.Combo:addParam("comboR", "Use R", SCRIPT_PARAM_ONOFF, true)
		KatarM.Combo:addParam("Comboing", "Q/E/W/R", SCRIPT_PARAM_ONOFF, true)-----------------change desc
        KatarM.Combo:addParam("Target", "Left Click target Lock", SCRIPT_PARAM_ONOFF, true)
		
	KatarM:addSubMenu("Harass", "Harass")
		KatarM.Harass:addParam("Harass", "Harass", SCRIPT_PARAM_ONOFF, true)
		KatarM.Harass:addParam("Mana", "Mana Manager %", SCRIPT_PARAM_SLICE, 50, 1, 100, 0)
		
	KatarM:addSubMenu("Misc", "Misc")
		KatarM.Misc:addParam("Ignite", "Use Auto Ignite", SCRIPT_PARAM_ONOFF, true)
		KatarM.Misc:addParam("KS", "Use skills to KS", SCRIPT_PARAM_ONOFF, false)
		KatarM.Misc:addParam("KSQ", "Use Q to KS", SCRIPT_PARAM_ONOFF, false)
		KatarM.Misc:addParam("KSEW", "Use E>W to KS", SCRIPT_PARAM_ONOFF, false)
		KatarM.Misc:addParam("Pred2", "Use Hpred", SCRIPT_PARAM_ONOFF, true)
	
	KatarM:addSubMenu("Draws", "Draws")
		KatarM.Draws:addParam("QRange", "Draw Q Range", SCRIPT_PARAM_ONOFF, true)
  	    KatarM.Draws:addParam("WRange", "Draw W Range", SCRIPT_PARAM_ONOFF, true)
        KatarM.Draws:addParam("ERange", "Draw E Range", SCRIPT_PARAM_ONOFF, true)
		KatarM.Draws:addParam("RRange", "Draw R Range", SCRIPT_PARAM_ONOFF, true)
  		KatarM.Draws:addParam("Target", "Draw Circle on Target", SCRIPT_PARAM_ONOFF, true)
  		KatarM.Draws:addParam("killtext", "Show if can kill enemy", SCRIPT_PARAM_ONOFF, true)		
  		KatarM.Draws:addParam("drawHPb", "Draw Dmg on HPBar", SCRIPT_PARAM_ONOFF, false)
		
	KatarM:addSubMenu("LFC", "LFC")
        KatarM.LFC:addParam("LagFree", "Activate Lag Free Circles", SCRIPT_PARAM_ONOFF, false) 
        KatarM.LFC:addParam("CL", "Length before Snapping", SCRIPT_PARAM_SLICE, 350, 75, 2000, 0) 
        KatarM.LFC:addParam("CLinfo", "Higher length = Lower FPS Drops", SCRIPT_PARAM_INFO, "") 
		
	 KatarM:addSubMenu("More", "More")
        KatarM.More:addParam("Zhonya", "Auto Zhonya", SCRIPT_PARAM_ONOFF, true)
        KatarM.More:addParam("ZhonyaHP", "Use Zhonyas at % health", SCRIPT_PARAM_SLICE, 20, 0, 100 , 0)
        KatarM.More:addParam("Amount", "Zhonya if x Enemies", SCRIPT_PARAM_SLICE, 1, 0, 5, 0)
		
	if _G.Reborn_Loaded then
	DelayAction(function()
		PrintChat("<font color = \"#FFFFFF\">[Casseiopia] </font><font color = \"#FF0000\">SAC Status:</font> <font color = \"#FFFFFF\">Successfully integrated.</font> </font>")
		KatarM:addParam("SACON","[Casseiopia] SAC:R support is active.", 5, "")
		isSAC = true
	end, 10)
	elseif not _G.Reborn_Loaded then
		PrintChat("<font color = \"#FFFFFF\">[Casseiopia] </font><font color = \"#FF0000\">Orbwalker not found:</font> <font color = \"#FFFFFF\">SxOrbWalk integrated.</font> </font>")
		KatarM:addSubMenu("Orbwalker", "SxOrb")
		SxOrb:LoadToMenu(KatarM.SxOrb)
		isSX = true
	end
	KatarM:permaShow("combokey")
	KatarM:permaShow("harasskey")
		
end

function KS(enemy)---change
	if KatarM.Misc.KSQ then
		if QREADY and getDmg("Q", enemy, myHero) > enemy.health then
			if GetDistance(enemy) <= Q.range then
				CastSpell(_Q, enemy)
			end
		end
	elseif KatarM.Misc.KSEW then
		if EREADY and getDmg("E", enemy, myHero) > enemy.health then
			if GetDistance(enemy) <= E.range then
				CastSpell(_E, enemy)
				if WREADY then
				CastSpell(_W)
				end
			end
		end
	end
end

function Combo()--change
	if ValidTarget(target) then
    	if QREADY and KatarM.Combo.comboQ and GetDistance(target) <= Q.range then
			CastSpell(_Q,target)
		end
		
		if QREADY and EREADY and WREADY and KatarM.Combo.comboQ and KatarM.Combo.comboE and KatarM.Combo.comboW and GetDistance(target) <= Q.range then
			CastSpell(_Q,target)
			CastSpell(_E,target)
			CastSpell(_W)
		end
		if RREADY and KatarM.Combo.comboR and GetDistance(target) <= R.range-100 then
				DelayAction(function() if target then CastSpell(_R) end end)
			end
	end
end

function Poke()--change
	if ValidTarget(target) and myHero.mana / myHero.maxMana > KatarM.Harass.Mana / 100 then
    	if KatarM.Harass.Harass then
			if QREADY and GetDistance(target) <= Q.range then
				CastSpell(_Q,target)
			end
		end
	end
end

function calcDmg()
	for i=1, heroManager.iCount do
		local Target = heroManager:GetHero(i)
		if ValidTarget(Target) and Target ~= nil then
			qDmg = ((QREADY and getDmg("Q", Target, myHero)) or 0)
			wDmg = ((WREADY and getDmg("W", Target, myHero)) or 0)
			eDmg = ((EREADY and getDmg("E", Target, myHero)) or 0)
			rDmg = ((RREADY and getDmg("R", Target, myHero)) or 0)
			allDmg = (qDmg) + ((wDmg)*3) + (eDmg) + (rDmg)
			
			if Target.health > allDmg then
				KillText[i] = 1
			elseif Target.health <= allDmg then
				KillText[i] = 2
			end
		end
	end	
end

for i, enemy in ipairs(GetEnemyHeroes()) do
    enemy.barData = {PercentageOffset = {x = 0, y = 0} }
end

-----------------------------------------------------------------------LFC-----------------------------------

-- Barasia, vadash, viseversa
function DrawCircleNextLvl(x, y, z, radius, width, color, chordlength)
	radius = radius or 300
	quality = math.max(8,round(180/math.deg((math.asin((chordlength/(2*radius)))))))
	quality = 2 * math.pi / quality
	radius = radius*.92
	local points = {}
	for theta = 0, 2 * math.pi + quality, quality do
		local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
		points[#points + 1] = D3DXVECTOR2(c.x, c.y)
	end
	DrawLines2(points, width or 1, color or 4294967295)
end

function round(num)
	if num >= 0 then return math.floor(num+.5) else return math.ceil(num-.5) end
end

function DrawCircle2(x, y, z, radius, color)
	local vPos1 = Vector(x, y, z)
	local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
	local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
	local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
	if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y }) then
		DrawCircleNextLvl(x, y, z, radius, 1, color, 80)
	end
end

function GetEnemyHPBarPos(enemy)

    if not enemy.barData then
        return
    end

    local barPos = GetUnitHPBarPos(enemy)
    local barPosOffset = GetUnitHPBarOffset(enemy)
    local barOffset = Point(enemy.barData.PercentageOffset.x, enemy.barData.PercentageOffset.y)
    local barPosPercentageOffset = Point(enemy.barData.PercentageOffset.x, enemy.barData.PercentageOffset.y)

    local BarPosOffsetX = 169
    local BarPosOffsetY = 47
    local CorrectionX = 16
    local CorrectionY = 4

    barPos.x = barPos.x + (barPosOffset.x - 0.5 + barPosPercentageOffset.x) * BarPosOffsetX + CorrectionX
    barPos.y = barPos.y + (barPosOffset.y - 0.5 + barPosPercentageOffset.y) * BarPosOffsetY + CorrectionY 

    local StartPos = Point(barPos.x, barPos.y)
    local EndPos = Point(barPos.x + 103, barPos.y)

    return Point(StartPos.x, StartPos.y), Point(EndPos.x, EndPos.y)

end

function DrawIndicator(enemy)
	local Qdmg, Wdmg, Edmg, Rdmg, AAdmg = getDmg("Q", enemy, myHero), getDmg("W", enemy, myHero), getDmg("E", enemy, myHero), getDmg("R", enemy, myHero), getDmg("AD", enemy, myHero)
	
	Qdmg = ((QREADY and Qdmg) or 0)
	Edmg = ((EREADY and Edmg) or 0)
	Wdmg = ((WREADY and Wdmg) or 0)
	Rdmg = ((RREADY and Rdmg) or 0)
	--AAdmg = ((Aadmg) or 0)

    local damage = --[[AAdmg +]] Qdmg + Wdmg + Edmg + Rdmg 

    local SPos, EPos = GetEnemyHPBarPos(enemy)

    if not SPos then return end

    local barwidth = EPos.x - SPos.x
    local Position = SPos.x + math.max(0, (enemy.health - damage) / enemy.maxHealth) * barwidth

	DrawText("|", 16, math.floor(Position), math.floor(SPos.y + 8), ARGB(255,0,255,0))
    DrawText("HP: "..math.floor(enemy.health - damage), 12, math.floor(SPos.x + 25), math.floor(SPos.y - 15), (enemy.health - damage) > 0 and ARGB(255, 0, 255, 0) or  ARGB(255, 255, 0, 0))
end

--------------------------------------------------Auto Zhonyas---------------------------------------------

function GetSlotItem(id, unit)
	
	unit 		= unit or myHero

	if (not ItemNames[id]) then
		return ___GetInventorySlotItem(id, unit)
	end

	local name	= ItemNames[id]
	
	for slot = ITEM_1, ITEM_7 do
		local item = unit:GetSpellData(slot).name
		if ((#item > 0) and (item:lower() == name:lower())) then
			return slot
		end
	end

end



function Zhonya()
	local Slot = GetInventorySlotItem(3157)
		if Slot ~= nil and myHero:CanUseSpell(Slot) == READY then
			local Range = 900
			local Amount = KatarM.More.Amount
			local health = myHero.health
			local maxHealth = myHero.maxHealth
				if ((health/maxHealth)*100) <= KatarM.More.ZhonyaHP and CountEnemyHeroInRange(Range) >= Amount then
			CastSpell(Slot)
				end
		end
end


function OnDraw()
	if KatarM.LFC.LagFree then
		if WREADY and not myHero.dead then
			if KatarM.Draws.WRange then
				DrawCircle2(myHero.x, myHero.y, myHero.z, W.range, 0xFF008000)
			end
		end
		if EREADY and not myHero.dead then
			if KatarM.Draws.ERange then
				DrawCircle2(myHero.x, myHero.y, myHero.z, E.range, 0xFF008000)
			end
		end
		if RREADY and not myHero.dead then
			if KatarM.Draws.RRange then
				DrawCircle2(myHero.x, myHero.y, myHero.z, R.range, 0xFF008000)
			end
		end
		if KatarM.Draws.Target and ValidTarget(target) then
			DrawCircle2(target.x, target.y, target.z, 80, ARGB(255, 10, 255, 10))
			DrawCircle2(target.x, target.y, target.z, 100, ARGB(255, 102, 204, 51))
		end
	else
		if WREADY and not myHero.dead then
			if KatarM.Draws.WRange then
				DrawCircle(myHero.x, myHero.y, myHero.z, W.range, RedColor)
			end
		end
		if EREADY and not myHero.dead then
			if KatarM.Draws.ERange then
				DrawCircle(myHero.x, myHero.y, myHero.z, E.range, GreenColor)
			end
		end
		if RREADY and not myHero.dead then
			if KatarM.Draws.RRange then
				DrawCircle(myHero.x, myHero.y, myHero.z, R.range, RedColor)
			end
		end
		if KatarM.Draws.Target and ValidTarget(target) then
			DrawCircle(target.x, target.y, target.z, 80, ARGB(255, 10, 255, 10))
			DrawCircle(target.x, target.y, target.z, 100, ARGB(255, 102, 204, 51))
		end
	end
   if  KatarM.Draws.drawHPb then
			for i, enemy in ipairs(GetEnemyHeroes()) do
       			if ValidTarget(enemy) then
			       DrawIndicator(enemy)
			    end
	        end
	end		
   if KatarM.Draws.killtext then
      for i = 1, heroManager.iCount do
			local target = heroManager:GetHero(i)
			if ValidTarget(target) and target ~= nil then
			    if ValidTarget(target) and target ~= nil then
				local barPos = WorldToScreen(D3DXVECTOR3(target.x, target.y, target.z))
				local PosX = barPos.x - 35
				local PosY = barPos.y - 10
				
				DrawText(TextList[KillText[i]], 16, PosX, PosY, colorText)
			
			    end
			end
		end
   end
end
end
if myHero.charName == Hero[5] then
print (Hero[5].." script loaded.")
--Kennen
end




