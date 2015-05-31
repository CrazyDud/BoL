if myHero.charName ~= "Fizz" then return end


--[[added E usage basic coz need more skills i tried it and is op but u can du it after coz the stuff there is working]]

--[[		Auto Update		]]
local sversion = "1.5"
local AUTOUPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/CrazyDud/BoL/master/Crazy Fizz.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH..GetCurrentEnv().FILE_NAME
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

function AutoupdaterMsg(msg) print("<font color = \"#0066CC\">[Crazy Fizz] </font> <font color = \"#fff8e7\">"..msg.."</font>") end
if AUTOUPDATE then
	local ServerData = GetWebResult(UPDATE_HOST, "/CrazyDud/BoL/maseter/version/Crazy Fizz.version")
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
require "VPrediction"
require "HPrediction"


local Q = {range = 550, IsReady = function() return myHero:CanUseSpell(_Q) == READY end}
local W = {range = 175, IsReady = function() return myHero:CanUseSpell(_W) == READY end}
local E = {delay = 0.5, speed = 1200, range = 400, width = 165, IsReady = function() return myHero:CanUseSpell(_E) == READY end}
local R = {delay = 0.5, speed = 1200, range = 1275, width = 80, IsReady = function() return myHero:CanUseSpell(_R) == READY end}
local ignite = nil
local iDmg = 0
local target = nil
local ts
local ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 1200, DAMAGE_MAGIC, true)
local HPred = HPrediction()
local lastPos = nil
local jumpSpot = nil
local informationTable = {}
local spellExpired = true 





TextList = {"", "Kill Him!"}
KillText = {}
colorText = ARGB(255,255,204,0)

function GetCustomTarget()
	ts:update()
	if _G.AutoCarry and ValidTarget(_G.AutoCarry.Crosshair:GetTarget()) then return _G.AutoCarry.Crosshair:GetTarget() end
	if not _G.Reborn_Loaded then return ts.target end
    if ValidTarget(SelectedTarget) then return SelectedTarget end
	return ts.target
end

function OnLoad()
	print("<font color = \"#0066CC\">Crazy Fizz</font> <font color = \"#fff8e7\">by CrazyDud v"..sversion.." loaded.</font>")
	
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
    myHero = GetMyHero()
	IgniteCheck()
	FLoadLib()
	
    HPred:AddSpell("R","Fizz", {collisionM = false, collisionH = true, delay = 0.25, range = 1275, speed = 1200, type = "DelayLine", width = 160, IsLowAccuracy = true})
	VP = VPrediction(true)
end

function OnTick()
	target = GetCustomTarget()
	Checks()
	if _G.AutoCarry then
		_G.AutoCarry.Crosshair:ForceTarget(custom_target)
	end 	
	
	
end

function Checks()
	IREADY = (ignite ~= nil and myHero:CanUseSpell(ignite) == READY)
	QREADY = (myHero:CanUseSpell(_Q) == READY)
	WREADY = (myHero:CanUseSpell(_W) == READY)
	EREADY = (myHero:CanUseSpell(_E) == READY)
	RREADY = (myHero:CanUseSpell(_R) == READY)
    calcDmg()
	SpellExpired()
	if FizzMenu.Harras.Mana then end
	if ValidTarget(target) then
		if FizzMenu.Misc.KS then KS(target) end
		if FizzMenu.Misc.Ignite then AutoIgnite(target) end
	end
	if FizzMenu.More.Zhonya then
     Zhonya()
    end
	if FizzMenu.combokey then
		Combo()
	end
	if FizzMenu.harasskey then
		Poke()
	end
end

function IgniteCheck()
	if myHero:GetSpellData(SUMMONER_1).name:find("summonerdot") then
		ignite = SUMMONER_1
	elseif myHero:GetSpellData(SUMMONER_2).name:find("summonerdot") then
		ignite = SUMMONER_2
	end
end

function FLoadLib()
	FMenu()
end

function FMenu()
	FizzMenu = scriptConfig("Fizz", "Fizz")
		FizzMenu:addParam("combokey", "Combo key(Space)", SCRIPT_PARAM_ONKEYDOWN, false, 32)
		FizzMenu:addParam("harasskey", "Harass key(C)", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
  	--	FizzMenu:addParam("escapekey", "Escape key(Z)", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("Z"))
		
	FizzMenu:addTS(ts)
		
	FizzMenu:addSubMenu("Combo", "Combo")
		FizzMenu.Combo:addParam("comboQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
		FizzMenu.Combo:addParam("comboW", "Use W", SCRIPT_PARAM_ONOFF, true)
  		FizzMenu.Combo:addParam("comboE", "Use E", SCRIPT_PARAM_ONOFF, true)
		FizzMenu.Combo:addParam("comboR", "Use R", SCRIPT_PARAM_ONOFF, true)
		FizzMenu.Combo:addParam("Ganking", "W/Q/R/E Gank combo", SCRIPT_PARAM_LIST, 2, {"R/Q/W/E", "W/Q/R/E"})
        FizzMenu.Combo:addParam("Target", "Left Click target Lock", SCRIPT_PARAM_ONOFF, true)
  
	FizzMenu:addSubMenu("Harras", "Harras")
		FizzMenu.Harras:addParam("combo", "Harras type", SCRIPT_PARAM_LIST, 2, {"Q > W", "Q > E return"})
		FizzMenu.Harras:addParam("Mana", "Mana Manager %", SCRIPT_PARAM_SLICE, 50, 1, 100, 0)
		
	FizzMenu:addSubMenu("Misc", "Misc")
		FizzMenu.Misc:addParam("KS", "KillSteal with Q", SCRIPT_PARAM_ONOFF, true)
		FizzMenu.Misc:addParam("Ignite", "Use Auto Ignite", SCRIPT_PARAM_ONOFF, true)
	    FizzMenu.Misc:addParam("Pred", "Use Hpred", SCRIPT_PARAM_ONOFF, true)
  		FizzMenu.Misc:addParam("Pred2", "Use Vpred", SCRIPT_PARAM_ONOFF, false)
  
    FizzMenu:addSubMenu("More", "More")
        FizzMenu.More:addParam("Zhonya", "Auto Zhonya", SCRIPT_PARAM_ONOFF, true)
        FizzMenu.More:addParam("ZhonyaHP", "Use Zhonyas at % health", SCRIPT_PARAM_SLICE, 20, 0, 100 , 0)
        FizzMenu.More:addParam("Amount", "Zhonya if x Enemies", SCRIPT_PARAM_SLICE, 1, 0, 5, 0)
        FizzMenu.More:addParam("AutoE", "Auto E dodge", SCRIPT_PARAM_ONOFF, true)
		
    FizzMenu:addSubMenu("Draws", "Draws")
        FizzMenu.Draws:addParam("QRange", "Draw Q Range", SCRIPT_PARAM_ONOFF, true)
  	    FizzMenu.Draws:addParam("ERange", "Draw E Range", SCRIPT_PARAM_ONOFF, true)
        FizzMenu.Draws:addParam("RRange", "Draw R Max Range", SCRIPT_PARAM_ONOFF, true)
  		FizzMenu.Draws:addParam("Target", "Draw Circle on Target", SCRIPT_PARAM_ONOFF, true)
  		FizzMenu.Draws:addParam("killtext", "Show if can kill enemy", SCRIPT_PARAM_ONOFF, true)		
  		FizzMenu.Draws:addParam("drawHP", "Draw Dmg on HPBar", SCRIPT_PARAM_ONOFF, false)
		
    FizzMenu:addSubMenu("LFC", "LFC")
        FizzMenu.LFC:addParam("LagFree", "Activate Lag Free Circles", SCRIPT_PARAM_ONOFF, false) 
        FizzMenu.LFC:addParam("CL", "Length before Snapping", SCRIPT_PARAM_SLICE, 350, 75, 2000, 0) 
        FizzMenu.LFC:addParam("CLinfo", "Higher length = Lower FPS Drops", SCRIPT_PARAM_INFO, "") 
  
  
	if _G.Reborn_Loaded then
	DelayAction(function()
		PrintChat("<font color = \"#FFFFFF\">[Fizz] </font><font color = \"#FF0000\">SAC Status:</font> <font color = \"#FFFFFF\">Successfully integrated.</font> </font>")
		FizzMenu:addParam("SACON","[Fizz] SAC:R support is active.", 5, "")
		isSAC = true
	end, 10)
	elseif not _G.Reborn_Loaded then
		PrintChat("<font color = \"#FFFFFF\">[Fizz] </font><font color = \"#FF0000\">Orbwalker not found:</font> <font color = \"#FFFFFF\">SxOrbWalk integrated.</font> </font>")
		FizzMenu:addSubMenu("Orbwalker", "SxOrb")
		SxOrb:LoadToMenu(FizzMenu.SxOrb)
		isSX = true
	end
	FizzMenu:permaShow("combokey")
	FizzMenu:permaShow("harasskey")
end

function KS(enemy)
	if QREADY and getDmg("Q", enemy, myHero) > enemy.health then
		if GetDistance(enemy) <= Q.range and FizzMenu.Misc.KS then
			CastSpell(_Q, enemy.x, enemy.z)
		end
	end
end

function AutoIgnite(enemy)
  	iDmg = ((IREADY and getDmg("IGNITE", enemy, myHero)) or 0) 
	if enemy.health <= iDmg and GetDistance(enemy) <= 600 and ignite ~= nil
		then
			if IREADY then CastSpell(ignite, enemy) end
	end
end

function Combo()
	if ValidTarget(target) then
		if FizzMenu.Combo.Ganking == 2 then
			if WREADY and FizzMenu.Combo.comboW and GetDistance(target) <= W.range then
			CastSpell(_W)
		end
				if QREADY and FizzMenu.Combo.comboQ and GetDistance(target) <= Q.range then
			CastSpell(_Q, target)
		end
		if RREADY and FizzMenu.Combo.comboR then
			if FizzMenu.Combo.Ganking then
               if FizzMenu.Misc.Pred then
                 DelayAction(function() if target then HPredR(target) end end, 2.5)
               elseif not FizzMenu.Misc.Pred then
                  DelayAction(function() CastR() end, 1.5)
               end
            end
		end
    	if EREADY and FizzMenu.Combo.comboE and GetDistance(target) <= Q.range then
			DelayAction(function() if target then CastSpell(_E, target.x, target.z) end end, 2.5)
      	end
		else
				if RREADY and FizzMenu.Combo.comboR then
			if FizzMenu.Combo.Ganking then
               if FizzMenu.Misc.Pred then
                  HPredR(unit)
               elseif not FizzMenu.Misc.Pred then
                  castR()
               end
            end
		end
		if QREADY and FizzMenu.Combo.comboQ and GetDistance(target) <= Q.range then
			CastSpell(_Q, target)
		end
		if WREADY and FizzMenu.Combo.comboW and GetDistance(target) <= W.range then
			CastSpell(_W)
		end
    	if EREADY and FizzMenu.Combo.comboE and GetDistance(target) <= Q.range then
			CastSpell(_E, target.x, target.z)
      	end
		end
	end
end

function Poke()
	if ValidTarget(target) and myHero.mana / myHero.maxMana > FizzMenu.Harras.Mana / 100 then
    	if FizzMenu.Harras.combo == 1 then
			if QREADY and GetDistance(target) <= Q.range then
				CastSpell(_Q, target)
			end
			if WREADY and GetDistance(target) <= W.range then
				CastSpell(_W)
			end
		else
			if QREADY and GetDistance(target) <= Q.range then
				lastPos = myHero.pos
				if WREADY then
				CastSpell(_W)
				end
				CastSpell(_Q, target)
			end
			if EREADY and GetDistance(target) <= Q.range then
				jumpSpot = Vector(myHero) + (Vector(lastPos) - Vector(myHero)):normalized() * E.range
				DelayAction(function() if jumpSpot then CastSpell(_E, jumpSpot.x, jumpSpot.z) end end, 1)
				--CastSpell(_E, jumpSpot.x, jumpSpot.z)
				DelayAction(function() jumpSpot = nil lastPos = nil end, 2)
			end
		end
	end
end

------------------------------------------casting R--------------------------------------------------------------

function castR()
    if ValidTarget(target) then
    	local CastPosition, HitChance, CastPos = VP:GetLineCastPosition(target, R.delay, R.width, R.range, R.speed, myHero, false)
		if HitChance >= 2 and GetDistance(CastPosition) <= Rrange and RREADY then
		   CastSpell(_R, CastPosition.x, CastPosition.z)
	    end
	end
end
   

function HPredR(unit)
    local unit = target
    local RPos, RHitChance = HPred:GetPredict("R", unit, myHero)
    if RHitChance >= 1 then
       CastSpell(_R, RPos.x, RPos.z)
    end
end

--------------------------------------------------------ONPROCESSSTUFF------------------------------------------

function OnProcessSpell(unit, spell)
	if spell.name:lower():find("UrchinStrike") and spell.target == target then
       if RREADY and FizzMenu.Combo.comboR then
		 if not FizzMenu.Combo.Ganking then
            if FizzMenu.Misc.Pred then
               HPredR(unit)
            elseif not FizzMenu.Misc.Pred then
               castR()
            end
         end
		end 
    end
    
    if FizzMenu.More.AutoE and E.IsReady() then
	        local jarvanAddition = unit.charName == "JarvanIV" and unit:CanUseSpell(_Q) ~= READY and _R or _Q
			local isUnit = {
				['Aatrox']      = {true, spell = _Q,                  range = 1000,  projSpeed = 1200, },
				['Aatrox']      = {true, spell = _E,                  range = 1000,  projSpeed = 1000, },
				['Ahri']        = {true, spell = _E,                  range = 950,   projSpeed = 1500, },
				['Amumu']       = {true, spell = _Q,                  range = 1100,  projSpeed = 2000, },
				['Amumu']       = {true, spell = _R,                  range = 550,   projSpeed = math.huge, },
				['Anivia']      = {true, spell = _Q,                  range = 1075,  projSpeed = 850, },
				['Annie']       = {true, spell = _Q,                  range = 625,   projSpeed = math.huge, },
				['Annie']       = {true, spell = _W,                  range = 625,   projSpeed = math.huge, },
				['Akali']       = {true, spell = _R,                  range = 800,   projSpeed = 2200, }, 
				['Alistar']     = {true, spell = _W,                  range = 650,   projSpeed = 2000, }, 
				['Ashe']        = {true, spell = _R,                  range = 20000, projSpeed = 1600, },
				['Azir']        = {true, spell = _R,                  range = 500,   projSpeed = 1600, },
				['Blitzcrank']  = {true, spell = _Q,                  range = 925,   projSpeed = 1800, },
				['Brand']       = {true, spell = _R,                  range = 750,   projSpeed = 780, },
				['Braum']       = {true, spell = _R,                  range = 1250,  projSpeed = 1600, },
				['Caitlyn']     = {true, spell = _R,                  range = 3000,  projSpeed = math.huge, },
				['Cassiopeia']  = {true, spell = _R,                  range = 825,   projSpeed = math.huge, },
				['Chogath']     = {true, spell = _Q,                  range = 950,   projSpeed = math.huge, },
				['Corki']       = {true, spell = _Q,                  range = 825,   projSpeed = 1125, },
				['Diana']       = {true, spell = _R,                  range = 825,   projSpeed = 2000, }, 
				['Darius']      = {true, spell = _E,                  range = 540,   projSpeed = 1500, },
				['Darius']      = {true, spell = _R,                  range = 480,   projSpeed = math.huge, },
				['Ezrael']      = {true, spell = _R,                  range = 20000, projSpeed = 2000, },
				['Fiora']       = {true, spell = _R,                  range = 400,   projSpeed = math.huge, },
				['Fizz']        = {true, spell = _R,                  range = 1200,  projSpeed = 1200, },
				['Gangplank']   = {true, spell = _Q,                  range = 620,   projSpeed = math.huge, },
				['Gragas']      = {true, spell = _E,                  range = 600,   projSpeed = 2000, },
				['Gragas']      = {true, spell = _R,                  range = 800,   projSpeed = 1300, },
				['Graves']      = {true, spell = _R,                  range = 1100,  projSpeed = 2100, },
				['Hecarim']     = {true, spell = _R,                  range = 1000,  projSpeed = 1200, },
				--['Irelia']      = {true, spell = _Q,                  range = 650,   projSpeed = 2200, }, 
				['Irelia']      = {true, spell = _E,                  range = 425,   projSpeed = math.huge, },
				['JarvanIV']    = {true, spell = jarvanAddition,      range = 770,   projSpeed = 2000, }, 
				['Jax']         = {true, spell = _E,                  range = 250,   projSpeed = math.huge, }, 
				['Jayce']       = {true, spell = 'JayceToTheSkies',   range = 600,   projSpeed = 2000, }, 
				['Jinx']        = {true, spell = _R,                  range = 20000, projSpeed = 1700, },
				['Kayle']       = {true, spell = _Q,                  range = 600,   projSpeed = math.huge, },
				['Kennen']      = {true, spell = _Q,                  range = 1000,  projSpeed = 1700, },
				['Khazix']      = {true, spell = _E,                  range = 900,   projSpeed = 2000, },
				['Leblanc']     = {true, spell = _W,                  range = 600,   projSpeed = 2000, },
				['LeeSin']      = {true, spell = 'blindmonkqtwo',     range = 1300,  projSpeed = 1800, },
				['Leona']       = {true, spell = _E,                  range = 900,   projSpeed = 2000, },
				['Leona']       = {true, spell = _R,                  range = 1100,  projSpeed = math.huge, },
				['Lulu']        = {true, spell = _Q,                  range = 950,   projSpeed = 1600, },
				['Lux']         = {true, spell = _Q,                  range = 1300,  projSpeed = 1200, },
				['Malphite']    = {true, spell = _R,                  range = 1000,  projSpeed = 1500 + unit.ms},
				['Maokai']      = {true, spell = _Q,                  range = 600,   projSpeed = 1200, }, 
				['MonkeyKing']  = {true, spell = _E,                  range = 650,   projSpeed = 2200, }, 
				['Morgana']     = {true, spell = _Q,                  range = 1175,  projSpeed = 1200, },
				['Nocturne']    = {true, spell = _R,                  range = 2000,  projSpeed = 500, },
				['Orianna']     = {true, spell = _Q,                  range = 825,   projSpeed = 1200, },
				['Pantheon']    = {true, spell = _W,                  range = 600,   projSpeed = 2000, }, 
				['Poppy']       = {true, spell = _E,                  range = 525,   projSpeed = 2000, }, 
				['Renekton']    = {true, spell = _E,                  range = 450,   projSpeed = 2000, },
				['Sejuani']     = {true, spell = _Q,                  range = 650,   projSpeed = 2000, },
				['Shen']        = {true, spell = _E,                  range = 575,   projSpeed = 2000, },
				['Tristana']    = {true, spell = _W,                  range = 900,   projSpeed = 2000, },
				['Tryndamere']  = {true, spell = 'Slash',             range = 650,   projSpeed = 1450, },
				['Twistedfate'] = {true, spell = _W,                  range = 525,   projSpeed = math.huge, },
				['Vayne']       = {true, spell = _E,                  range = 550,   projSpeed = math.huge, },
				['Veigar']      = {true, spell = _R,                  range = 700,   projSpeed = math.huge, },
				['Vi']          = {true, spell = _R,                  range = 600,   projSpeed = 1200, },
				['Xerath']      = {true, spell = _E,                  range = 1000,  projSpeed = 1200, },
				['XinZhao']     = {true, spell = _E,                  range = 650,   projSpeed = 2000, }, 
				['Zyra']        = {true, spell = _E,                  range = 1175,  projSpeed = 1400, },
			}
			if unit.type == myHero.type and unit.team ~= myHero.team and isUnit[unit.charName] and GetDistance(unit) < 2000 and spell ~= nil then
				if spell.name == (type(isUnit[unit.charName].spell) == 'number' and unit:GetSpellData(isUnit[unit.charName].spell).name or isUnit[unit.charName].spell) then
					if spell.target ~= nil and spell.target.isMe or isUnit[unit.charName].spell == 'blindmonkqtwo' then
						if E.IsReady() then
							E.target = unit
							CastSpell(_E)
						end
					else
						spellExpired = false
						informationTable = {
							spellSource = unit,
							spellCastedTick = GetTickCount(),
							spellStartPos = Point(spell.startPos.x, spell.startPos.z),
							spellEndPos = Point(spell.endPos.x, spell.endPos.z),
							spellRange = isUnit[unit.charName].range,
							spellSpeed = isUnit[unit.charName].projSpeed
						}
					end
				end
			end
		
    end
end
   

function SpellExpired()
	if ValidTarget(target) then
	if FizzMenu.More.AutoE and not spellExpired and (GetTickCount() - informationTable.spellCastedTick) <= (informationTable.spellRange / informationTable.spellSpeed) * 1000 then
		local spellDirection     = (informationTable.spellEndPos - informationTable.spellStartPos):normalized()
		local spellStartPosition = informationTable.spellStartPos + spellDirection
		local spellEndPosition   = informationTable.spellStartPos + spellDirection * informationTable.spellRange
		local heroPosition = Point(myHero.x, myHero.z)
		local lineSegment = LineSegment(Point(spellStartPosition.x, spellStartPosition.y), Point(spellEndPosition.x, spellEndPosition.y))
	
			local lineSegment = LineSegment(Point(spellStartPosition.x, spellStartPosition.y), Point(spellEndPosition.x, spellEndPosition.y))
			
        
			if lineSegment:distance(heroPosition) <= 400 and E.IsReady() then
				
				CastSpell(_E)
			end

		else
			spellExpired = true
			informationTable = {}
		end
     end   
               
               
    
end	   
-----------------------------------------------------Target lock with Mouse----------------------------------


function OnWndMsg(Msg, Key)
	if Msg == WM_LBUTTONDOWN and FizzMenu.Combo.Target then
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
				if FizzMenu.Combo.Target then 
					PrintChat("Target deselected: "..Selecttarget.charName) 
				end
			else
				SelectedTarget = Selecttarget
				if FizzMenu.Combo.Target then
					PrintChat("New target selected: "..Selecttarget.charName) 
				end
			end
		end
	end
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
			local Amount = FizzMenu.More.Amount
			local health = myHero.health
			local maxHealth = myHero.maxHealth
				if ((health/maxHealth)*100) <= FizzMenu.More.ZhonyaHP and CountEnemyHeroInRange(Range) >= Amount then
			CastSpell(Slot)
		end
	end
end


function CountEnemyHeroInRange(range)
	local enemyInRange = 0
		for i = 1, heroManager.iCount, 1 do
			local hero = heroManager:getHero(i)
				if ValidTarget(hero,range) then
			enemyInRange = enemyInRange + 1
			end
		end
	return enemyInRange
end


function OnDraw()
	if FizzMenu.LFC.LagFree then
		if QREADY and not myHero.dead then
			if FizzMenu.Draws.QRange then
				DrawCircle2(myHero.x, myHero.y, myHero.z, Q.range, 0xFF008000)
			end
		end
		if EREADY and not myHero.dead then
			if FizzMenu.Draws.ERange then
				DrawCircle2(myHero.x, myHero.y, myHero.z, E.range, 0xFF008000)
			end
		end
		if RREADY and not myHero.dead then
			if FizzMenu.Draws.RRange then
				DrawCircle2(myHero.x, myHero.y, myHero.z, R.range, 0xFF008000)
			end
		end
		if FizzMenu.Draws.Target and ValidTarget(target) then
			DrawCircle2(target.x, target.y, target.z, 80, ARGB(255, 10, 255, 10))
			DrawCircle2(target.x, target.y, target.z, 100, ARGB(255, 102, 204, 51))
		end
	else
		if QREADY and not myHero.dead then
			if FizzMenu.Draws.QRange then
				DrawCircle(myHero.x, myHero.y, myHero.z, Q.range, 0x0066CC)
			end
		end
		if EREADY and not myHero.dead then
			if FizzMenu.Draws.ERange then
				DrawCircle(myHero.x, myHero.y, myHero.z, E.range, 0x33CCFF)
			end
		end
		if RREADY and not myHero.dead then
			if FizzMenu.Draws.RRange then
				DrawCircle(myHero.x, myHero.y, myHero.z, R.range, 0x003399)
			end
		end
		if FizzMenu.Draws.Target and ValidTarget(target) then
			DrawCircle(target.x, target.y, target.z, 80, ARGB(255, 10, 255, 10))
			DrawCircle(target.x, target.y, target.z, 100, ARGB(255, 102, 204, 51))
		end
	end
   if  FizzMenu.Draws.drawHP then
			for i, enemy in ipairs(GetEnemyHeroes()) do
       			if ValidTarget(enemy) then
			       DrawIndicator(enemy)
			    end
	        end
	end		
   if FizzMenu.Draws.killtext then
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

----------------------------------------------------------DMG Calc-----------------------------------------------------------

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

---------------------------------------------------------------------------Draws enemy HPbar--------------------------------------------


for i, enemy in ipairs(GetEnemyHeroes()) do
    enemy.barData = {PercentageOffset = {x = 0, y = 0} }
end

--[[function GetEnemyHPBarPos(enemy)

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
    return Point(StartPos.x, StartPos.y), Point(EndPos.x, EndPos.y)
end]]

function DrawIndicator(enemy)
	local Qdmg, Wdmg, Edmg, Rdmg, AAdmg = getDmg("Q", enemy, myHero), getDmg("W", enemy, myHero), getDmg("E", enemy, myHero), getDmg("R", enemy, myHero), getDmg("AD", enemy, myHero)
	
	Qdmg = ((Q.IsReady and Qdmg) or 0)
	Edmg = ((E.IsReady and Edmg) or 0)
	Rdmg = ((R.IsReady and Rdmg) or 0)
	AAdmg = ((Aadmg) or 0)

    local damage = Qdmg + Edmg + Rdmg 

    local SPos, EPos = GetEnemyHPBarPos(enemy)

    if not SPos then return end

    local barwidth = EPos.x - SPos.x
    local Position = SPos.x + math.max(0, (enemy.health - damage) / enemy.maxHealth) * barwidth

	DrawText("|", 16, math.floor(Position), math.floor(SPos.y + 8), ARGB(255,0,255,0))
    DrawText("HP: "..math.floor(enemy.health - damage), 12, math.floor(SPos.x + 25), math.floor(SPos.y - 15), (enemy.health - damage) > 0 and ARGB(255, 0, 255, 0) or  ARGB(255, 255, 0, 0))
end
