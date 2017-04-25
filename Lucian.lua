local menu = Menu("Lucian")
menu:DropDown("comboMode", "Chose Combo", 2, {  "full", "QEE" })

if GetObjectName(GetMyHero()) ~= "Lucian" then return end

local d = require 'DLib'
require 'OpenPredict'

local qRange = GetCastRange(myHero, _Q)
local eRange = GetCastRange(myHero, _E)
local wRange = GetCastRange(myHero, _W)

local isInQEECombo = false
local comboCounter = 0
local attacksafety = 10

local recentlyUsed = "nieks"
local recentlyStarted = ""
local waitForAA = true

comboMode = "QEE"

local RelentlessPursuit = { delay = 0.25, speed = 1450, width = 75, range = GetCastRange(myHero,_E), radius = 75}


OnTick(function(myHero)
          if IsDead(myHero) then return end
  
if _G.IOW then
  if IOW:Mode() == "Combo" then 
     Combo(GetCurrentTarget())
  end

  if IOW:Mode() == "Harass" then
      Combo(GetCurrentTarget()) 

  end
  
  if IOW:Mode() == "LaneClear" then
  LaneClear()
                JungleClear()
  end
elseif _G.DAC_Loaded then
  if DAC:Mode() == "Combo" then 
     Combo(GetCurrentTarget())
  end

  if DAC:Mode() == "Harass" then
     Combo(GetCurrentTarget())
  end
  
  if DAC:Mode() == "LaneClear" then
  LaneClear()
                JungleClear()

  end
elseif _G.PW then
  if PW:Mode() == "Combo" then 
     Combo(GetCurrentTarget())
  end

  if PW:Mode() == "Harass" then
     Combo(GetCurrentTarget())
  end
  
        if PW:Mode() == "LaneClear" then
                LaneClear()
                JungleClear()

        end  
end
ChooseCombo()
end)

function ChooseCombo()
	if menu.comboMode:Value() ~= comboMode then
		comboMode = menu.comboMode:Value()
	end
end

   
OnProcessSpell(function(unit, spell)
     if unit ~= GetMyHero() then return end 
            if spell.name == "LucianQ"  then
        recentlyStarted = "Q"
    elseif spell.name == "LucianW"  then
        recentlyStarted = "W"

    elseif spell.name == "LucianR" then
        recentlyStarted = "R"
    elseif spell.name == "LucianE"  then
        recentlyStarted = "E" 
            recentlyCompleted = "E"
    elseif spell.name == "LucianBasicAttack" or spell.name == "LucianBasicAttack2" or spell.name == "LucianCritAttack" or spell.name == "LucianCritAttack2" or spell.name == "LucianPassiveAttack" then
        recentlyStarted = "AA"  end
end)

OnProcessSpellComplete(function(unit, spell)
    if unit ~= GetMyHero() then return end 
        
    if spell.name == "LucianQ"  then
        recentlyCompleted = "Q"
            
    elseif spell.name == "LucianW"  then
        recentlyCompleted = "W"

    elseif spell.name == "LucianR" then
        recentlyCompleted = "R"
            
    elseif spell.name == "LucianBasicAttack" or spell.name == "LucianBasicAttack2" or spell.name == "LucianCritAttack" or spell.name == "LucianCritAttack2" or spell.name == "LucianPassiveAttack" then
        recentlyCompleted = "AA"
        waitForAA = false
    end           
end)

function Combo(unit)
        local target = unit  
    if comboMode == 1 then
       
        
        if IsInDistance(target,eRange + 500 - attacksafety) and CanUseSpell(myHero,_E) == READY and waitForAA == false then
            CastSkillShot(_E, GetMousePos())  
            waitForAA = true
            return
        end
        
        if IsInDistance(target,wRange - attacksafety) and CanUseSpell(myHero,_W) == READY and waitForAA == false then            
            local W = GetLinearAOEPrediction(target, RelentlessPursuit)
			CastSkillShot(_W, W.castPos)
            waitForAA = true
            return
        end
 
        if IsInDistance(target,qRange) and CanUseSpell(myHero,_Q) == READY and waitForAA == false then
            CastTargetSpell(target, _Q)
            waitForAA = true
            return
        end 
        elseif comboMode == 2 then
   

        if( IsInDistance(target,qRange) and CanUseSpell(myHero,_Q) == READY and waitForAA == false) then
            CastTargetSpell(target, _Q)
            waitForAA = true
        comboCounter = comboCounter + 1
            return
        end 
        
        if IsInDistance(target,eRange + 500 - attacksafety) and CanUseSpell(myHero,_E) == READY and waitForAA == false and comboCounter > 0 then
            CastSkillShot(_E, GetMousePos())          
            waitForAA = true
            comboCounter = comboCounter + 1
            if comboCounter > 2 then comboCounter = 0 end
            return
        end
        
        end
end

function LaneClear()
	for _, minion in pairs(minionManager.objects) do
		if GetTeam(minion) == MINION_ENEMY then
			Combo(minion)
		end
	end
end
function JungleClear()
	for i, mob in pairs(minionManager.objects) do
		if GetTeam(mob) == MINION_JUNGLE then
			Combo(mob)
		end
	end
end
