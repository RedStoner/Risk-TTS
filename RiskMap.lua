-----------------------
-- SETUP FUNCTIONS --
-----------------------
-- Country Info
function onLoad(save_state)
  tColor = {1,1,1}
  debugStart = false
  doBiasedStart = false
  --Config Options:
  config = {}
  config.longRangeStrategic = false
  config.allowSetAfterEnemyDefeat = false
  config.giveAllUnitsOnSetTerritories = false
  config.reshuffleCardsOnDeckEmpty = false
  boardMessages = {
    reinforce = "Select a territory to reinforce.",
    reinforceNeutral = "Select a neutral territory\nto reinforce.",
    amountToPlace = "Select amount of units to place. ",
    amountToMove = "Select amount of units to move.",
    attackFrom = "Select a target to attack from\nor press 'End Phase'.",
    attackTo = "Select where to attack to.",
    moveTo = "Select where to move to.",
    moveFrom = "Select a territory to move from\nor click End Phase.",
    repeatAttack = "Repeat the Attack?",
    roll = "Roll the dice.",
    matchingTerritory = "Which matching territory\ngains the 2 units.",
    tradeInSet = "Trade in a set, or hit 'End Phase'.",
    mustTradeIn = "You must trade in a set!",
    win = "WINNER! WINNER!\nCHICKEN DINNER!"
  }
  broadcastMessages = {
  
  }
  phaseNames = {
    PreGame = "Pre\nGame",
    strategic = "Strategic\nMove",
    setup = "Setup",
    tradeInSet = "Trade\nIn Set",
    reinforce = "Reinforce",
    attack = "Attack",
  }
  drawZone = getObjectFromGUID("9e0b1f")
  discardZone = getObjectFromGUID("972ddb")
  controllerBoard = getObjectFromGUID("df4b6c")
  cardZone = getObjectFromGUID("1398dd")
  diceAttack = getObjectFromGUID("31c96c")
  diceDefend = getObjectFromGUID("44e410")
  configMenu = getObjectFromGUID("b1749b")
  horse = getObjectFromGUID("ced8e2")
  gameClock = getObjectFromGUID("33bbef")
  deck = getObjectFromGUID("ff145c")
  gameClock.Clock.setValue(0)
  gameClock.interactable = false
  self.interactable = false
  horse.interactable = false
  configMenu.interactable = false
  --Game Core
  contReference = {
    alaska = "nAmerica",
    northwestterritory = "nAmerica",
    greenland = "nAmerica",
    alberta = "nAmerica",
    ontario = "nAmerica",
    quebec = "nAmerica",
    westernunitedstates = "nAmerica",
    easternunitedstates = "nAmerica",
    centralamerica = "nAmerica",
    venezuela = "sAmerica",
    brazil = "sAmerica",
    peru = "sAmerica",
    argentina = "sAmerica",
    iceland = "europe",
    scandinavia = "europe",
    ukrane = "europe",
    greatbritain = "europe",
    northerneurope = "europe",
    westerneurope = "europe",
    southerneurope = "europe",
    northafrica = "africa",
    egypt = "africa",
    eastafrica = "africa",
    congo = "africa",
    madagascar = "africa",
    southafrica = "africa",
    ural = "asia",
    siberia = "asia",
    yakutsk = "asia",
    kamchatka = "asia",
    irkutsk = "asia",
    mongolia = "asia",
    japan = "asia",
    afghanistan = "asia",
    china = "asia",
    middleeast = "asia",
    india = "asia",
    siam = "asia",
    indonesia = "australia",
    newguinea = "australia",
    westernaustralia = "australia",
    easternaustralia = "australia",
    }
  
  continents = newContinentData()
  pColors = {
  White = {{1,1,1},{0.25, 0.25, 0.25, 1}, getObjectFromGUID("a020ef"), getObjectFromGUID("e8afd4")},
  --Brown = {{0.443, 0.231, 0.09},{0.25, 0.25, 0.25, 1}, getObjectFromGUID("")},
  Red = {{0.856, 0.1, 0.094},{1, 1, 1, 1}, getObjectFromGUID("6eadcc"), getObjectFromGUID("29726c")},
  Orange = {{0.956, 0.392, 0.113},{1, 1, 1, 1}, getObjectFromGUID("f0e843"), getObjectFromGUID("450d2a")},
  Yellow = {{0.905, 0.898, 0.172},{0, 0, 0, 1}, getObjectFromGUID("0e2932")},
  Green = {{0.192, 0.701, 0.168},{1, 1, 1, 1}, getObjectFromGUID("c034e9"), getObjectFromGUID("2d66b3")},
  --Teal = {{0.129, 0.694, 0.607},{0.25, 0.25, 0.25, 1}, getObjectFromGUID("")},
  Blue = {{0.118, 0.53, 1},{1, 1, 1, 1}, getObjectFromGUID("1b4104"), getObjectFromGUID("d66b71")},
  --Purple = {{0.627, 0.125, 0.941},{0.25, 0.25, 0.25, 1}, getObjectFromGUID("")},
  Pink = {{0.96, 0.439, 0.807},{1, 1, 1, 1}, getObjectFromGUID("e0add8"), getObjectFromGUID("0ff3a5")}
  }
  pColors.Yellow[3].setScale({0,0,0})
  continentValues = {}
  continentValues["nAmerica"] = 5
  continentValues["sAmerica"] = 2
  continentValues["europe"] = 5
  continentValues["africa"] = 3
  continentValues["asia"] = 7
  continentValues["australia"] = 2
  neutralColor = "Yellow"
  pList = {}
  territoryCount = {}
  -- holder variables
  phase = "PreGame"
  phaseOption = "none"
  currentTurn = "none"
  selected = " "
  selectedSecondary = " "
  unitsLeft = {}
  territoryOwners = {}
  territoryUnitCounts = {}
  reinforced = {}
  reinforced.amount = 0
  reinforced.amountLeft = 0
  reinforced.usingNeutral = false
  reinforced.neutral = false
  reinforced.self = false
  attackAmount = 0
  defendAmount = 0
  attMax = 0
  defMax = 0
  attackRolls = {}
  defendRolls = {}
  tookTerritory = false
  amountMustMove = 0
  isLastCard = false
  lastCard = false
  specialReinforce = false
  triedloc = {}
  setsTurnedIn = 0
  setMatches = {}
  setMatchThisTurn = false
  horseLoc = {
    -39.48,
    -36.46,
    -32.68,
    -29.15,
    -24.95,
    -21.52,
    -17.95,
    -13.89,
    -9.75,
    -5.76,
    -2.38,
    1.77,
    5.97,
    9.70,
    13.38,
    17.29,
    20.86,
    24.90,
    28.78,
    32.88,
    36.51,
    42.25, 
    
  }
  startButton = {
    index = 42, click_function = 'setupTerritories', function_owner = self,
    label = 'Start Game', position = {x = 0.0, y = 1.0, z = 0.0}, rotation = {x = 0, y = 0, z = 0},
    scale = {x = 0.5, y = 1, z = 0.5}, width = 700, height = 120, font_size = 100,
    color = {r = 1, g = 1, b = 1, a = 1}, font_color = {r = 0, g = 0, b = 0, a = 1}
    }
  tempDiceData = {}
  contLabels = {}
  for k,v in pairs(contReference) do
    contLabels[k] = continents[v][k].button.label
  end
  createTerritoryButtons()
  
  
  loadedSave = false
  if save_state ~= nil then
    st("Found Save Data!")
    if loadFromSave(save_state) then
      loadedSave = true
    end
  end
--START LOADING DATA
  if loadedSave then
    st("Successfully Loaded from Save!")
  else
  --START NEW GAME STUFF
    st("Could Not Load From Save!")
    self.createButton(startButton)
    --setup turn clocks
    for k,v in pairs(pColors) do
      if v[4] ~= nil then
        v[4].Clock.startStopwatch()
        v[4].Clock.pauseStart()
        v[4].interactable = false
      end
      if v[3] ~= nil then
        v[3].interactable = false
      end
    end
  end
--STUFF TO DO EITHER WAY
  if debugStart ~= true then
    diceAttack.interactable = false
    diceDefend.interactable = false
    deck.interactable = false
    controllerBoard.interactable = false
  end
  Global.call('objectLoadFinished',{self.guid})
end

function onSave()
  local save_data = {
    debugStart = debugStart,
    doBiasedStart = doBiasedStart,
    config = config,
    deck = deck.guid,
    territoryOwners = territoryOwners,
    territoryUnitCounts = territoryUnitCounts,
    pList = pList,
    territoryCount = territoryCount,
    phase = phase,
    phaseOption = phaseOption,
    currentTurn = currentTurn,
    selected = selected,
    selectedSecondary = selectedSecondary,
    unitsLeft = unitsLeft,
    reinforced = reinforced,
    attackAmount = attackAmount,
    defendAmount = defendAmount,
    attMax = attMax,
    defMax = defMax,
    attackRolls = attackRolls,
    defendRolls = defendRolls,
    tookTerritory = tookTerritory,
    amountMustMove = amountMustMove,
    isLastCard = isLastCard,
    lastCard = lastCard,
    specialReinforce = specialReinforce,
    setsTurnedIn = setsTurnedIn,
    setMatches = setMatches,
    setMatchThisTurn = setMatchThisTurn,
    diceDataDefender = diceDefend.call('getSaveData',{}),
    diceDataAttacker = diceAttack.call('getSaveData',{}),
    defendAmount = defendAmount,
    defendRolls = defendRolls,
    attackAmount = attackAmount,
    attackRolls = attackRolls,
    
  }
  local serialized_data = JSON.encode_pretty(save_data)
  return serialized_data
end

function createTerritoryButtons()
  for i,c in pairs(continents) do
    for j,t in pairs(c) do
      continents[i][j].button.scale = {x= 0.0, y = 0.0, z = 0.0}
      self.createButton(t.button)
    end
  end
end

function loadFromSave(save_state)
  local data = JSON.decode(save_state)
  if debugStart then
    addNotebookTab({title = "Debug", body = save_state})
  end
  if save_state == "" then
    return false
  end
  if data.phase == "PreGame" or data.phase == nil then
    return false
  end
  debugStart = data.debugStart
  doBiasedStart = data.doBiasedStart
  config = data.config
  deck = getObjectFromGUID(data.deck)
  territoryOwners = data.territoryOwners
  territoryUnitCounts = data.territoryUnitCounts
  pList = data.pList
  territoryCount = data.territoryCount
  phase = data.phase
  phaseOption = data.phaseOption
  currentTurn = data.currentTurn
  selected = data.selected
  selectedSecondary = data.selectedSecondary
  unitsLeft = data.unitsLeft
  reinforced = data.reinforced
  attackAmount = data.attackAmount
  defendAmount = data.defendAmount
  defMax = data.defMax
  attMax = data.attMax
  attackRolls = data.attackRolls
  defendRolls = data.defendRolls
  tookTerritory = data.tookTerritory
  amountMustMove = data.amountMustMove
  isLastCard = data.isLastCard
  lastCard = data.lastCard
  specialReinforce = data.specialReinforce
  setsTurnedIn = data.setsTurnedIn
  setMatches = data.setMatches
  setMatchThisTurn = data.setMatchThisTurn
  tempDiceData = {data.diceDataAttacker, data.diceDataDefender}
  for k,v in pairs(contReference) do
    continents[v][k].button.label = territoryUnitCounts[k]
    continents[v][k].button.color = pColors[territoryOwners[k]][1]
    continents[v][k].button.font_color = pColors[territoryOwners[k]][2]
    continents[v][k].button.scale = {x= 0.5, y = 1.0, z = 0.5}
    self.editButton(continents[v][k].button)
  end
  
  st("Loaded Successfully From Save!")
  return true
end

function finishedLoading()
  if loadedSave ~= true then
    return
  end
  --update general controller board numbers
  controllerBoard.call('updateTurn',{currentTurn})
  controllerBoard.call('updatePhase',{phaseNames[phase]})
  refreshPlacementNumbers()
  setSelected(selected)
  setSelected(selectedSecondary,true)
  leftBehind()
  -- update dice boxes
  diceAttack.call("loadSaveData",{tempDiceData[1]})
  diceDefend.call("loadSaveData",{tempDiceData[2]})
  -- update config buttons
  configMenu.call("loadSaveData",{config})
-- Phase specific updates  
  if phase == "tradeInSet" then
    setupTurnInSet(true)
    return
  elseif phaseOption == "selectOwnTerritory" then
    updateInfo("reinforce")
    return
  elseif phaseOption == "selectNeutralTerritory" then
    updateInfo("reinforceNeutral")
    return
  elseif phaseOption == "gettingOwnAmount" or phaseOption == "gettingNeutralAmount" then
    updateInfo("amountToPlace")
    return
  elseif phaseOption == "selectAttackFromLocation" then
    setupAttack()
    return
  elseif phaseOption == "selectAttackToLocation" then
    updateInfo("attackTo")
    return
  elseif phaseOption == "selectAmountToMove" then
    updateInfo("amountToMove")
    return
  elseif phaseOption == "getDiceRolls" then
    updateInfo("roll")
    return
  elseif phaseOption == "askAttackAgain" then
    updateInfo("repeatAttack")
    controllerBoard.call('updateEndPhase',{"NO"})
    controllerBoard.call('updateConfirm',{"YES"})
    diceAttack.call('showAttackAgain',{true,currentTurn})
    return
  elseif phaseOption == "strategicSelectTo" then
    updateInfo("moveTo")
    return
  elseif phaseOption == "strategicSelectFrom" then
    updateInfo("moveFrom")
    return
  elseif phaseOption == "strategicSelectAmount" then
    updateInfo("amountToMove")
    return
  end
end
--------------------------
-- CONTROL FUNCTIONS --
--------------------------
 
function territoryClicked(territory,color)
  if color ~= currentTurn then
    broadcastToColor("It is not your turn.",color,pColor(color))
    return
  end
  if phase == "PreGame" then
    broadcastToColor("Cannot do that. The game has not been started.",color,pColor(color))
    return
  end  
  
  if phase == "setup" or phase == "reinforce" then
    -- create buttons to allow them to set how many units are to be added

    if phaseOption == "selectOwnTerritory" then
      if getOwner(territory) ~= color then
        broadcastToColor("That is not your territory.",color,pColor())
        return
      end
      setSelected(territory)
      broadcastToColor("Select how many units to place on " .. tLabel(selected) .. ".",color,pColor())
      updateInfo("amountToPlace")
      controllerBoard.call('updateConfirm',{"Confirm"})
      phaseOption = "gettingOwnAmount"
      return
    end
    if phaseOption == "gettingOwnAmount" or phaseOption == "gettingNeutralAmount" then 
      -- cancel selection
      if territory == selected then
        setSelected(" ")
        if phaseOption == "gettingOwnAmount" then
          broadcastToColor("Select a territory to reinforce.",currentTurn,pColor())
          updateInfo("reinforce")
          if phase == "reinforce" then
            controllerBoard.call('updateConfirm',{"Trade In"})
          end
          phaseOption = "selectOwnTerritory"
        else
          broadcastToColor("Select Neutral territory to reinforce.",currentTurn,pColor())
          updateInfo("reinforceNeutral")
          phaseOption = "selectNeutralTerritory"
        end
        -- remove amount selector buttons.
      end
      return
    end
    if phaseOption == "selectNeutralTerritory" then
      if getOwner(territory) ~= neutralColor then
        broadcastToColor("That is not one of the neutral player's territories.",color,pColor())
        return
      end
      setSelected(territory)
      broadcastToColor("Select how many units to place on " .. tLabel(selected) .. ".",color,pColor())
      updateInfo("amountToPlace")
      phaseOption = "gettingNeutralAmount"
      return
    end  
  end
  if phase == "attack" then
    if phaseOption == "selectAttackFromLocation" then
      if getOwner(territory) ~= currentTurn then
        broadcastToColor("You do not own that territory." , currentTurn,pColor())
        return
      end
      if hasTargetInRange(territory) ~= true then
        broadcastToColor("There are no valid attacks from " .. tLabel(territory) .. "." , currentTurn,pColor())
        return
      end
      if getUnitAmount(territory) < 2 then
        broadcastToColor("You do not have enough units on that territory to attack with it." , currentTurn,pColor())
        return
      end
      setSelected(territory)
      phaseOption = "selectAttackToLocation"
      broadcastToColor("Select where to attack too from " .. tLabel(selected) .. ".",color,pColor())
      updateInfo("attackTo")
      return
    end
    if phaseOption == "selectAttackToLocation" then
      --check for deselect
      if territory == selected then
        setupAttack()
        return
      end
      if getOwner(territory) == currentTurn then
        broadcastToColor("You cannot attack yourself." , currentTurn,pColor())
        return
      end
      if sharesBorders(selected,territory) ~= true then
        broadcastToColor("You cannot attack " .. tLabel(territory) .. " from " .. tLabel(selected) .. "." , currentTurn,pColor())
        return
      end
      setSelected(territory,true)
      setupDiceRoll()
      return
    end
  end
  if phase == "strategic" then
    if phaseOption == "strategicSelectFrom" then
      if getOwner(territory) ~= currentTurn then
        broadcastToColor("That is not your territory.",color,pColor())
        return
      end
      if getUnitAmount(territory) == 1 then
        broadcastToColor("Not enough units on that territory to move.",color,pColor())
        return
      end
      setSelected(territory)
      broadcastToColor("Select where to move too from " .. tLabel(selected) .. ".",color,pColor())
      updateInfo("moveTo")
      phaseOption = "strategicSelectTo"
      return
    end
    if phaseOption == "strategicSelectTo" then
      if getOwner(territory) ~= currentTurn then
        broadcastToColor("That is not your territory.",color,pColor())
        return
      end
      -- deselection
      if selected == territory then
        setSelected(" ")
        setupStrategic()
        return
      end
      triedloc = {}
      if config.longRangeStrategic then
        if findConnection(territory, selected, currentTurn) == false then
          broadcastToColor(tLabel(territory) .. " is not connected to " .. tLabel(selected) .. ".",color,pColor())
          return
        end
      else
        if sharesBorders(territory,selected) == false then
          broadcastToColor(tLabel(territory) .. " is not connected to " .. tLabel(selected) .. ".",color,pColor())
          return
        end
      end
      setSelected(territory,true)
      broadcastToColor("Select how many units to move from " .. tLabel(selected) .. " to " .. tLabel(selectedSecondary) .. ".",color,pColor())
      updateInfo("amountToMove")
      phaseOption = "strategicSelectAmount"
      reinforced.amount = getUnitAmount(selected) - 1
      reinforced.amountLeft = reinforced.amount
      refreshPlacementNumbers()
      leftBehind()
      return
    end
  end
end

function controlClicked(params)
  buttonClicked = params[1] 
  color = params[2]
  if phase == "gameOver" and buttonClicked == "confirm" then
    --onStart()
    return
  end
  if color ~= currentTurn then
    broadcastToColor("It is not your turn.", color, pColor(color))
    return
  end
  if phase == "setup" or phase == "reinforce" or phaseOption == "selectAmountToMove" or phaseOption == "strategicSelectAmount" then
    if phaseOption == "gettingOwnAmount" or phaseOption == "gettingNeutralAmount" or phaseOption == "selectAmountToMove"  or phaseOption == "strategicSelectAmount" then
      if buttonClicked == "add" then
        if reinforced.amount + 1 > reinforced.amountLeft  then
          return
        end
        reinforced.amount = reinforced.amount + 1
        controllerBoard.call('updateUnitsToPlace',{reinforced.amount})
        leftBehind()
        return
      end
      if buttonClicked == "sub" then
        if reinforced.amount - 1 < 0 then
          return
        end
        reinforced.amount = reinforced.amount - 1
        controllerBoard.call('updateUnitsToPlace',{reinforced.amount})
        leftBehind()
        return
      end
      if buttonClicked == "subTen" then
        if reinforced.amount - 10 < 0 then
          reinforced.amount = 0
          controllerBoard.call('updateUnitsToPlace',{reinforced.amount})
          leftBehind()
          return
        end
        reinforced.amount = reinforced.amount - 10
        controllerBoard.call('updateUnitsToPlace',{reinforced.amount})
        leftBehind()
        return
      end
      if buttonClicked == "addTen" then
        if reinforced.amount + 10 > reinforced.amountLeft then
          reinforced.amount = reinforced.amountLeft
          controllerBoard.call('updateUnitsToPlace',{reinforced.amount})
          leftBehind()
          return
        end
        reinforced.amount = reinforced.amount + 10
        controllerBoard.call('updateUnitsToPlace',{reinforced.amount})
        leftBehind()
        return
      end
      if buttonClicked == "addAll" then
        reinforced.amount = reinforced.amountLeft
        controllerBoard.call('updateUnitsToPlace',{reinforced.amount})
        leftBehind()
        return
      end
      if buttonClicked == "subAll" then
        reinforced.amount = 0
        controllerBoard.call('updateUnitsToPlace',{reinforced.amount})
        leftBehind()
        return
      end
      if buttonClicked == "confirm" then
        --Confirm amount to move after an attack.
        if phaseOption == "selectAmountToMove" then
          if reinforced.amount < amountMustMove then
            broadcastToColor("You MUST move at least " .. amountMustMove .. " units.",currentTurn,pColor())
            return
          end
          amountMustMove = 0
          updateTroopCount(selectedSecondary,reinforced.amount)
          updateTroopCount(selected,getUnitAmount(selected) - reinforced.amount)
          
          -- check for special reinforce phase
          if specialReinforce then
            setupTurnInSet(false,true)
          else
            --setup for attack select phase again.
            setupAttack()
          end
          return
        end
        --Confirm amount to move for strategic move
        if phaseOption == "strategicSelectAmount" then
          updateTroopCount(selectedSecondary,getUnitAmount(selectedSecondary) + reinforced.amount)
          updateTroopCount(selected,getUnitAmount(selected) - reinforced.amount)
          setSelected(" ")
          setSelected(" ",true)
          setupEndTurn()
          return
        end
        local newAmount = getUnitAmount(selected) + reinforced.amount
        updateTroopCount(selected,newAmount)
        -- subtract from total units left to place for setup
        if phase == "setup" then
          if phaseOption == "gettingNeutralAmount" then
            unitsLeft[neutralColor] = unitsLeft[neutralColor] - reinforced.amount
          else
            unitsLeft[color] = unitsLeft[color] - reinforced.amount
          end
        end
        reinforced.amountLeft = reinforced.amountLeft - reinforced.amount
        broadcastToAll(currentTurn .. " added " .. reinforced.amount .. " units to " .. tLabel(selected) , pColor())
        setSelected(" ")
        --no more units to place this turn
        if reinforced.amountLeft == 0 then
          if phase == "setup" then
            if phaseOption == "gettingOwnAmount" then
              if reinforced.usingNeutral  then 
                reinforced.amount = 1
                reinforced.amountLeft = 1
                refreshPlacementNumbers()
                phaseOption = "selectNeutralTerritory"
                broadcastToColor("Select Neutral territory to reinforce.",color,pColor())
                updateInfo("reinforceNeutral")
              else
                playClock(currentTurn,false)
                currentTurn = getNextTurn()
                playClock(currentTurn,true)
                if unitsLeft[currentTurn] >= 3 then
                  reinforced.amount = 3
                  reinforced.amountLeft = 3
                else
                  reinforced.amount = unitsLeft[currentTurn]
                  reinforced.amountLeft = unitsLeft[currentTurn]
                end
                refreshPlacementNumbers()
                phaseOption = "selectOwnTerritory"
                if unitsLeft[currentTurn] <= 0 then
                  setupTurnInSet()
                else
                  broadcastToAll(currentTurn .. " has " .. unitsLeft[currentTurn] .. " total units to place.", pColor() )
                end
                broadcastToColor("Select a territory to reinforce.",currentTurn,pColor())
                updateInfo("reinforce")
              end
            else
              if reinforced.usingNeutral then
                playClock(currentTurn,false)
                currentTurn = getNextTurn()
                playClock(currentTurn,true)
                if unitsLeft[currentTurn] >= 2 then
                  reinforced.amount = 2
                  reinforced.amountLeft = 2
                else
                  reinforced.amount = unitsLeft[currentTurn]
                  reinforced.amountLeft = unitsLeft[currentTurn]
                end
                refreshPlacementNumbers()
                phaseOption = "selectOwnTerritory"
                if unitsLeft[currentTurn] <= 0 then
                  setupTurnInSet()
                else
                  broadcastToAll(currentTurn .. " has " .. unitsLeft[currentTurn] .. " total units to place.",pColor() )
                end
                broadcastToColor("Select a territory to reinforce.",currentTurn,pColor())
                updateInfo("reinforce")
              end
            end
            return
          end
          if phase == "reinforce" then
            setupAttack()
            return
          end
        else
          -- Did not place all available units
          reinforced.amount = reinforced.amountLeft
          phaseOption = "selectOwnTerritory"
          refreshPlacementNumbers()
          broadcastToColor("Select a territory to reinforce.",currentTurn,pColor())
          updateInfo("reinforce")
        end
      end
    end
    return
  end
  if phase == "tradeInSet" then
    if buttonClicked == "endPhase" and phaseOption ~= "getSpecialSetSelect" then
      if hasTooManyCards(currentTurn) then
        broadcastToColor("You have too many cards!. You must turn in a set.",currentTurn,pColor())
        return
      end
      setupReinforcement()
      return
    end
    if buttonClicked == "confirm" then
      if checkSet() then
        if specialReinforce == true and getCardAmount(currentTurn) < 5 and phaseOption ~= "getSpecialSetSelect" and config.allowSetAfterEnemyDefeat ~= true then
          setupReinforcement()
          return
        end
        if getCardAmount(currentTurn) < 3 and phaseOption ~= "getSpecialSetSelect" then
          setupReinforcement()
          return
        end
      end
      if phaseOption ~= "getSpecialSetSelect" then
        setupTurnInSet(true)
      end
      return
    end
    if buttonClicked == "card" and phaseOption == "getSpecialSetSelect" then
      updateTroopCount(setMatches[params[3]],getUnitAmount(setMatches[params[3]]) + 2)
      st("2 Units added to " .. tLabel(setMatches[params[3]]) .. " for controlling it when turning in a set.")
      setMatchThisTurn = true
      setMatches = {}
      controllerBoard.call('updateCardsButtons',{})
      if specialReinforce == true and getCardAmount(currentTurn) < 5 and config.allowSetAfterEnemyDefeat ~= true then
        setupReinforcement()
      else
        setupTurnInSet(true)
      end
      return
    end
    return
  end
  if phase == "attack" then
    if phaseOption == "askAttackAgain" then
      if buttonClicked == "endPhase" then
        diceAttack.call('showAttackAgain',{false})
        setupAttack()
        return
      end
      if buttonClicked == "confirm" then
        diceAttack.call('showAttackAgain',{false})
        setupDiceRoll()
        controllerBoard.call('updateEndPhase',{"End Phase"})
        controllerBoard.call('updateConfirm',{"Confirm"})
        return
      end
    end
    if phaseOption == "selectAttackFromLocation" and buttonClicked == "endPhase" then
      phase = "strategic"
      controllerBoard.call('updatePhase',{"Strategic\nMove"})
      setupStrategic()
      return
    end
  end
  if phaseOption == "strategicSelectFrom" and buttonClicked == "endPhase" then
    setupEndTurn()
    return
  end
end

function getDiceRolls(params)
  local defender = params[1]
  local inputRolls = params[2]
  local defPlayer = getOwner(selectedSecondary)
  --Set values for rolls
  if defender then
    defendAmount = #inputRolls
    defendRolls = inputRolls
    diceDefend.call('diceAmount',{0,"Grey"})
    local _dieDefender = defPlayer
    if reinforced.usingNeutral then
      if pList[1] == currentTurn then
        _dieDefender = pList[2]
      else
        _dieDefender = pList[1]
      end
    end
    playClock(_dieDefender,false)
  else
    attackAmount = #inputRolls
    attackRolls = inputRolls
    diceAttack.call('diceAmount',{0,"Grey"})
    playClock(currentTurn,false)
  end
  local wins = 0
  --Check if both attacker and defender have rolled.
  if defendAmount > 0 and attackAmount > 0 then
    playClock(currentTurn,true)
    local loopAmount = 0
    if defendAmount > attackAmount then
      loopAmount = attackAmount
    else
      loopAmount = defendAmount
    end
    --Check for attacker wins
    
    for i=1, loopAmount do
      if attackRolls[i] > defendRolls[i] then
        wins = wins + 1
      end
    end
    broadcastToAll(currentTurn .. " wins " .. wins .. " of " .. loopAmount, pColor())
    --Check if attacker lost units and remove them
    if loopAmount - wins > 0 then
      local troops = getUnitAmount(selected)
      updateTroopCount(selected,troops - (loopAmount - wins))
    end
    --Check if defence lost units and remove them
    if wins > 0 then
      local troops = getUnitAmount(selectedSecondary)
      updateTroopCount(selectedSecondary,troops - wins)
      --Check if defence was defeated
      if troops - wins == 0 then
        --Update territory counts and new owner
        territoryCount[defPlayer] = territoryCount[defPlayer] - 1
        updateTerritoryCount(defPlayer)
        territoryCount[currentTurn] = territoryCount[currentTurn] + 1
        updateTerritoryCount(currentTurn)
        updateOwner(selectedSecondary,currentTurn)
        amountMustMove = attackAmount
        --Check if defender has 0 territories left and remove them from game.
        if territoryCount[defPlayer] == 0 then
          broadcastToAll(defPlayer .. " no longer controls any territories. They have lost the game!" ,tColor)
          if defPlayer ~= neutralColor then
            local handObjs = Player[defPlayer].getHandObjects()
            -- check if defender has any cards, if so, move them to the player that attacked them.
            local defeatedPlayerCards = false
            local numDefeatedCards = #handObjs
            if numDefeatedCards > 0 then 
              defeatedPlayerCards = true
              -- add the two hands counts together to account for delay in movement.
              local cardCount = numDefeatedCards + getCardAmount(currentTurn)
              local handInfo = Player[currentTurn].getHandTransform()
              for k,v in pairs(handObjs) do
                handInfo.rotation.y = 180
                v.setPosition(handInfo.position)
                v.setRotation(handInfo.rotation) 
              end
            --check if attacker now has more than 5 cards in their hand to force them to play them.
              if cardCount > 5 or config.allowSetAfterEnemyDefeat then
                specialReinforce = true
              end
            end
            for i=1,#pList do
              if pList[i] == defPlayer then
                table.remove(pList,i)
                break
              end
            end
            -- Check for end game 
            if #pList == 1 then
              broadcastToAll(currentTurn .. " IS THE WINNER!",pColor())
              gameClock.Clock.paused = true
              phase = "gameOver"
              controllerBoard.call('updatePhase',{"Game\nOver"})
              updateInfo("win")
              playClock(currentTurn,false)
              --controllerBoard.call('updateConfirm',{"YES"})
              return
            end
          end
        end
        --Setup for unit movement to new territory.
        phaseOption = "selectAmountToMove"
        updateInfo("amountToMove")
        reinforced.amount = getUnitAmount(selected) - 1
        reinforced.amountLeft = reinforced.amount
        leftBehind()
        refreshPlacementNumbers()
        tookTerritory = true
        defendAmount = 0
        attackAmount = 0
        attackRolls = {}
        defendRolls = {}
        return
      end
    end
    --Check if attacker can attack again with this territory.
    if getUnitAmount(selected) == 1 then
      setSelected(" ")
      setSelected(" ",true)
      phaseOption = "selectAttackFromLocation"
      updateInfo("attackFrom")
      controllerBoard.call('updateEndPhase',{"End Phase"})
      controllerBoard.call('updateConfirm',{"Confirm"})
      defendAmount = 0
      attackAmount = 0
      attackRolls = {}
      defendRolls = {}
      return
    end
    phaseOption = "askAttackAgain"
    updateInfo("repeatAttack")
    controllerBoard.call('updateEndPhase',{"NO"})
    controllerBoard.call('updateConfirm',{"YES"})
    diceAttack.call('showAttackAgain',{true,currentTurn})
    defendAmount = 0
    attackAmount = 0
    attackRolls = {}
    defendRolls = {}
  end
end

function attackAgain(params)
  diceAttack.call('showAttackAgain',{false})
  if params[1] then
    setupDiceRoll()
    controllerBoard.call('updateEndPhase',{"End Phase"})
    controllerBoard.call('updateConfirm',{"Confirm"})
    return
  else
    setupAttack()
    return
  end
end
------------------------------
-- PHASE SETUP FUNCTIONS --
------------------------------

function setupTerritories()
--count players and get colour and set starting unit count
  pList = getSeatedPlayers()
  for i,v in pairs(pList) do
    if (not pColors[v]) or v == "Yellow" then
      broadcastToAll("A player cannot be seated in color " .. v)
      return false
    end
    if debugStart and v == "Pink" then
      broadcastToAll("A player cannot be seated in color " .. v)
      return false
    end
  end
  if debugStart then
    table.insert(pList,"Pink")
  end
  local numPlayers = #pList
-- check for enough players
  if pList == nil or numPlayers <= 1 then
    broadcastToAll("Not enough players seated to start the game!",tColor)
    return false
  end
  self.removeButton(startButton.index)
  showButtons()
  deck.shuffle()
  controllerBoard = getObjectFromGUID("df4b6c")
  config = configMenu.call('getConfigValues',{})
  configMenu.call('toggleConfigButtons',{})
-- determine if there is a neutral player
  neutralPlayer = 0
  if numPlayers == 2 then
    neutralPlayer = 1
    table.insert(pList,neutralColor)
  end
  if neutralPlayer > 0 then
    pColors["Yellow"][3].setScale({1.5,1.5,1.5})
  end
  local territoryList = {}
-- initialize territory counts
  for i,v in pairs(pList) do
    territoryCount[v] = 0
  end
-- get a list of territories
  for i,v in pairs(contReference) do
    table.insert(territoryList,i)
  end
  local pIndex = 1
--deal territory to players add 1 to all of the player owned territory
  repeat
    local rand = math.random(#territoryList)
    updateTroopCount(territoryList[rand],1)
    if doBiasedStart then
      updateOwner(territoryList[rand],pList[1])
      territoryCount[pList[1]] = territoryCount[pList[1]] + 1
    else
      updateOwner(territoryList[rand],pList[pIndex])
      territoryCount[pList[pIndex]] = territoryCount[pList[pIndex]] + 1
    end
    pIndex = pIndex + 1
    if pIndex > numPlayers + neutralPlayer then
      pIndex = 1
    end
    table.remove(territoryList,rand)
  until #territoryList < 1 or #territoryList == nil
  if doBiasedStart then
    updateOwner("alaska","Pink")
    territoryCount["Pink"] = 1
    territoryCount[pList[1]] = territoryCount[pList[1]] - 1
    if neutralPlayer == 1 then
      updateOwner("alberta","Yellow")
      territoryCount["Yellow"] = 1
      territoryCount[pList[1]] = territoryCount[pList[1]] - 1
    end
      
  end
  local startUnits = {0,40,35,30,25,20}
  for i,v in pairs(pList) do
    unitsLeft[v] = startUnits[numPlayers] - territoryCount[v]
    broadcastToAll(v .. " has " .. unitsLeft[v] .. " units left to place in the setup phase.",pColor(v))
    updateTerritoryCount(v)
  end
--roll for who goes 1st
  rand = math.random(numPlayers)
  if debugStart then
    updateTerritoryCount("Pink")
    if neutralPlayer == 1 then
      updateTerritoryCount("Yellow")
    end
    currentTurn = pList[1]
  else
    currentTurn = pList[rand]
  end
  broadcastToAll(currentTurn .. " gets first placement.",pColor())
--players from 1st to last add  to a territory clockwise until  number for the game
  if neutralPlayer > 0 then
    reinforced.amount = 2
    reinforced.amountLeft = 2
    refreshPlacementNumbers()
    reinforced.usingNeutral = true
    table.remove(pList)
  else
    reinforced.amount = 3
    reinforced.amountLeft = 3
    refreshPlacementNumbers()
    reinforced.usingNeutral = false
  end
  setSelected("")
  setSelected("",true)
  controllerBoard.call('updateCardsButtons',{})
  if debugStart then
    setupTurnInSet()
  else
    phase = "setup"
    phaseOption = "selectOwnTerritory"
    controllerBoard.call('updatePhase',{"Setup"})
    broadcastToColor("Select a territory to reinforce.",currentTurn,pColor())
    updateInfo("reinforce")
  end
  gameClock.Clock.startStopwatch()
  playClock(currentTurn,true)
-- start up end
end

function setupTurnInSet(skipAmount,skipReinforce)
  if skipAmount ~= true then
    local _amtUnits = 0
    reinforced.amount = 0
    reinforced.amountLeft = 0
    if skipReinforce ~= true then
      _amtUnits = math.floor(territoryCount[currentTurn]/3)
      if _amtUnits < 3 then 
        _amtUnits = 3
      end
      reinforced.amountLeft = reinforced.amountLeft + _amtUnits
      checkForContinents()
      reinforced.amount = reinforced.amountLeft
    end
    refreshPlacementNumbers()
  end
  leftBehind(true)
  local _amt = getCardAmount(currentTurn)
  if _amt < 3 then
    setupReinforcement()
    return
  end
  local strBroadcast = "Trade in a set and hit 'Trade In' or hit 'End Phase'."
  local strInfo = "tradeInSet"
  if hasTooManyCards(currentTurn) then
    strBroadcast = "You have " .. _amt .. " cards! You MUST trade in a set"
    strInfo = "mustTradeIn"
  end
  broadcastToColor(strBroadcast,currentTurn,pColor())
  updateInfo(strInfo)
  controllerBoard.call('updateConfirm',{"Trade In"})
  controllerBoard.call('updatePhase',{"Trade\nIn Set"})
  controllerBoard.call('showCardZone',{true})
  phase = "tradeInSet"
  phaseOption = "tradeInSet"
  setSelected("")
  setSelected("",true)
end

function setupReinforcement()
  local _amt = 0
  if specialReinforce then
    specialReinforce = false
  end
  controllerBoard.call('showCardZone',{false})
  if reinforced.amountLeft == 0 then
    setupAttack()
    return
  end
  broadcastToColor("Select a territory to reinforce.",currentTurn,pColor())
  updateInfo("reinforce")
  controllerBoard.call('updateConfirm',{"Confirm"})
  controllerBoard.call('updatePhase',{"Reinforce"})
  controllerBoard.call('updateCardsButtons',{})
  phase = "reinforce"
  phaseOption = "selectOwnTerritory"
  
end

function setupAttack()
  reinforced.amount = 0
  reinforced.amountLeft = 0
  setSelected(" ")
  setSelected(" ",true)
  phaseOption = "selectAttackFromLocation"
  phase = "attack"
  updateInfo("attackFrom")
  controllerBoard.call('updateEndPhase',{"End Phase"})
  controllerBoard.call('updateConfirm',{"Confirm"})
  controllerBoard.call('updatePhase',{"Attack"})
  refreshPlacementNumbers()
  leftBehind(true)
end

function setupDiceRoll()
  
  defendingPlayer = getOwner(selectedSecondary)
  if reinforced.usingNeutral and defendingPlayer == neutralColor then
    if pList[1] == currentTurn then
      defendingPlayer = pList[2]
    else
      defendingPlayer = pList[1]
    end
  end
  
  if attackAmount == 0 then
    local attMax = 0
    local attCount = getUnitAmount(selected)
    if attCount >= 4 then
      attMax = 3
    else
      attMax = attCount - 1
    end
    diceAttack.call('diceAmount',{attMax,getOwner(selected)})
    broadcastToColor("Roll the dice to attack " .. tLabel(selectedSecondary) .. ".",currentTurn,pColor())
  end
  if defendAmount == 0 then 
    local defMax = 0
    local defCount = getUnitAmount(selectedSecondary)
    if defCount >= 2 then
      defMax = 2
    else
      defMax = defCount
    end
    if reinforced.usingNeutral then
      diceDefend.call('diceAmount',{defMax,defendingPlayer})
    else
      diceDefend.call('diceAmount',{defMax,getOwner(selectedSecondary)})
    end
    broadcastToColor("Roll the dice to defend " .. tLabel(selectedSecondary) .. ".",defendingPlayer,pColor(defendingPlayer))
    playClock(defendingPlayer,true)
  end
  
  phaseOption = "getDiceRolls"
  updateInfo("roll")
end

function setupStrategic()
  phaseOption = "strategicSelectFrom"
  broadcastToColor("Select a territory to make a strategic move from with or click End Phase.",currentTurn,pColor())
  updateInfo("moveFrom")
end

function setupEndTurn()
  if tookTerritory then
    --give the player a card for a successfull attack
    if isLastCard == false then
      if deck.getQuantity() == 2 then
        lastCard = deck.getObjects()[2].guid
      end
    end
    if lastCard ~= "Dealt" then
      if isLastCard  and lastCard ~= "Dealt" then
        local tLastCard = getObjectFromGUID(lastCard)
        local handInfo = Player[currentTurn].getHandTransform()
        tLastCard.setPosition(handInfo.position)
        tLastCard.setRotation({0.00, 180.00, 0.00}) 
        broadcastToAll("Last card was dealt!",tColor)
        lastCard = "Dealt"
        -- do reshuffle if config is enabled
        if config.reshuffleCardsOnDeckEmpty then
          local _objs = discardZone.getObjects()
          for k,v in pairs(_objs) do
            if v.tag == "Deck" then
              v.setRotation({0.00, 180.00, 180.00})
              v.setPosition({-37.82, 1.27, -7.98})
              deck = v
              lastCard = false
              isLastCard = false
              break
            end
          end
          if lastCard then
            st("Unable to reshuffle deck!!!!")
          end
        end
      else
        deck.deal(1,currentTurn)
        if lastCard ~= false then
          broadcastToAll("Only once card left!",tColor)
          isLastCard = true
          deck = getObjectFromGUID(lastCard)
        end
      end
      broadcastToAll(currentTurn .. " successfully attacked on their turn. They are rewarded a card.",pColor())
    end
    tookTerritory = false
  end
  playClock(currentTurn,false)
  currentTurn = getNextTurn()
  setMatchThisTurn = false
  setupTurnInSet()
  playClock(currentTurn,true)
  updateTerritoryCount(currentTurn)

  
end


--------------------------
-- SUPPORT FUNCTIONS --
--------------------------

function leftBehind(reset)
  local num = 0
  if reset ~= true then
    if phaseOption == "selectAmountToMove"  or phaseOption == "strategicSelectAmount" then
      num = reinforced.amountLeft - reinforced.amount + 1
    end
  end
  controllerBoard.call('updateUnitsLeftBehind',{num})
end

function getCardAmount(_player)
  local handData = Player[currentTurn].getHandObjects()
  return #handData
end

function hasTooManyCards(_player,special)
  local _amt = #(Player[_player].getHandObjects())
  if special then
    if _amt > 5 then
      return true
    end
  elseif _amt > 4 then
    return true
  end
  return false
end

function checkForContinents()
  for contKey, cont in pairs(continents) do
    -- Check each continent and break out if a territory is found they dont owned
    local passed = true
    for tKey, terr in pairs(cont) do
      if getOwner(tKey) ~= currentTurn then
        passed = false
        break
      end
    end
    if passed then
      -- add reinforcement value for this continent
      reinforced.amountLeft = reinforced.amountLeft + continentValues[contKey]
      st("Added " .. continentValues[contKey] .. " to reinforcement count for owning all of " .. contKey)
    end
  end  
end

function setSelected(sel,isSecond)
  local _owner = "Grey"
  if sel ~= "" and sel ~= " " then
    _owner = getOwner(sel)
  end
  if isSecond then
    selectedSecondary = sel
    controllerBoard.call('updateTerritoryTwo',{tLabel(sel),_owner})
  else
    selected = sel
    controllerBoard.call('updateTerritoryOne',{tLabel(sel),_owner})
  end
end

function playClock(player,active)
  pColors[player][4].Clock.pauseStart()
end

function isWaterAttack(fromLoc,toLoc)
  local _data = continents[contReference[fromLoc]][fromLoc]
  for k,v in pairs(_data.borders) do
    if toLoc == v then
      return _data.byWater[k]
    end
  end
  return false
end
function updateTerritoryCount(player)
  pColors[player][3].setValue(territoryCount[player])
end
function hasTargetInRange(territory)
  for k,v in pairs(getBorders(territory)) do
    if getOwner(v) ~= currentTurn then
      return true
    end
  end
  return false
end
function sharesBorders(territory,target)
  if contains(getBorders(territory),target) then
    return true
  end
  return false
end
function hideButtons()
  for k,v in pairs(contReference) do
    continents[v][k].button.scale = {x= 0.0, y = 0.0, z = 0.0}
    self.editButton(continents[v][k].button)
  end
end
function showButtons()
  for k,v in pairs(contReference) do
    continents[v][k].button.scale = {x= 0.5, y = 1.0, z = 0.5}
    self.editButton(continents[v][k].button)
  end
end
function checkSet()
  foundObjects = cardZone.getObjects()
  local cards = {}
  -- get cards only from the zone
  for _objKey,_obj in pairs(foundObjects) do
    local desc = _obj.getDescription()
    if desc ==  "infantry" or desc == "calvary" or desc == "artillery" or desc == "wild" then
      table.insert(cards,_obj)
    end
  end
  -- check if there is enough cards to make a set
  if #cards < 3 then
    broadcastToColor("Not enough cards found to make a set.",currentTurn,pColor())
    return false
  end
  if #cards > 3 then
    broadcastToColor("Too many cards found. Please remove some.",currentTurn,pColor())
    return false
  end
  -- Check for a matching set begins
  local _territories = {}
  local cTypes = {}
  local numWild = 0
  -- get number of wild cards and territory names on the cards
  for k,v in pairs(cards) do
    table.insert(cTypes,v.getDescription())
    if v.getName() == "wild" then
      numWild = numWild + 1
    else 
      table.insert(_territories,v.getName())
    end
  end
  local match = false
  -- if they have at least one wild, they have a set.
  if numWild > 0 then
    match = true
  -- check for 3 of a kind
  elseif cTypes[1] == cTypes[2] and cTypes[2] == cTypes[3] then
    match = true
  -- check for 1 of each
  elseif cTypes[1] ~= cTypes[2] and cTypes[1] ~= cTypes[3] and cTypes[2] ~= cTypes[3] then
    match = true
  -- otherwise tell em they didnt place a proper set
  else 
    broadcastToColor("Sorry, that does not make a set.",currentTurn,pColor())
    return false
  end
  -- increment sets turned in
  local _value = 0
  setsTurnedIn = setsTurnedIn + 1
  -- get the value for the set
  if setsTurnedIn < 6 then
    _value = 2 + (setsTurnedIn * 2)
  else
    _value = 5 * (setsTurnedIn - 3)
  end
  --move horse
  local _pos = {horseLoc[setsTurnedIn], 0.98, 23.03}
  horse.setPositionSmooth(_pos,false,true)
  -- move cards to discard pile
  local discardLoc = {x=-31.8060092926025, y=1.03171360492706, z=-7.97233295440674}
  for k,v in pairs(cards) do
    v.setPositionSmooth(discardLoc,false,true)
  end
  if setMatchThisTurn ~= true then
    local ownedTerritories = {}
    -- get a list of territories they control that match cards.
    for k,v in pairs(_territories) do
      if getOwner(v) == currentTurn then
        table.insert(ownedTerritories,v)
      end
    end
    -- check if they have any matches
    if #ownedTerritories > 0 then
      -- put units on the territory or if config option is enabled, all of them
      if #ownedTerritories == 1 or config.giveAllUnitsOnSetTerritories then
        for k,v in pairs(ownedTerritories) do
          updateTroopCount(v,getUnitAmount(v) + 2)
          st("2 Units added to " .. tLabel(v) .. " for controlling it when turning in a set.")
        end
      -- if they matched more than one, and the config is not enabled
      else
        phaseOption = "getSpecialSetSelect"
        local formatedTerritories = {}
        for k,v in pairs(ownedTerritories) do
          table.insert(formatedTerritories,tLabel(v))
        end
        controllerBoard.call('updateCardsButtons',formatedTerritories)
        setMatches = ownedTerritories
        updateInfo("matchingTerritory")
        broadcastToColor("Select which matching territory gains an additional 2 units for trading in this set.",currentTurn,pColor())
      end
    end
  end 
  -- set new values.
  reinforced.amountLeft = reinforced.amountLeft + _value
  reinforced.amount = reinforced.amountLeft
  refreshPlacementNumbers()
  return true
end
function findConnection(current, dest, _pColor)
  if current == dest and getOwner(current) == _pColor then
    return true
  end
  if getOwner(current) ~= _pColor then
    table.insert(triedloc, current)
    return false
  end
  
  if getOwner(current) == _pColor then
    table.insert(triedloc, current)
  end
  borders = getBorders(current)
  for k,v in pairs(borders) do
    if not contains(triedloc, v) then
      if findConnection(v, dest, _pColor) then
         return true                 
      end
    end
  end
  return false
end
function contains(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end
function st(t)
  broadcastToAll(t,tColor)
end
function updateTroopCount(territory,amount)
  continents[contReference[territory]][territory].button.label = amount
  territoryUnitCounts[territory] = amount
  self.editButton(continents[contReference[territory]][territory].button)
end
function updateOwner(territory,owner)
  territoryOwners[territory] = owner
  continents[contReference[territory]][territory].button.color = pColors[owner][1]
  continents[contReference[territory]][territory].button.font_color = pColors[owner][2]
  self.editButton(continents[contReference[territory]][territory].button)
end
function getNextTurn()
  local _t = 0
  for k,v in pairs(pList) do
    if v == currentTurn then
      _t = k
      break
    end
  end
  if _t  == #pList then
    _t = 1
  else 
    _t = _t + 1
  end
  return pList[_t]      
end
function getOwner(territory)
  return territoryOwners[territory]
end
function getUnitAmount(territory)
  return territoryUnitCounts[territory]
end
function getBorders(territory)
  return continents[contReference[territory]][territory].borders
end
function getButton(territory)
  return continents[contReference[territory]][territory].button
end
function tLabel(territory)
  return contLabels[territory]
end
function pColor(_player)
  if _player ~= nil then
    return pColors[_player][1]
  else
    return pColors[currentTurn][1]
  end
end
function refreshPlacementNumbers()
  controllerBoard.call('updateUnitsLeft',{reinforced.amountLeft})
  controllerBoard.call('updateUnitsToPlace',{reinforced.amount})
end
function updateInfo(mType)
  controllerBoard.call('updateInfo',{boardMessages[mType],currentTurn})
end
function newContinentData()
  newContinents = {
    nAmerica = {
      alaska = {
        borders = {"northwestterritory","alberta","kamchatka"},
        byWater = {false,false,true},
        owner = "test",
        units = 0,
        buttonindex = 0,
        button = {
          index = 0, click_function = 'alaska', function_owner = self,
          tooltip = "Alaska",
          label = 'Alaska', position = {x = -1.2, y = 1, z = -0.62}, rotation = {x = 0, y = 0, z = 0},
          scale = {x = 0.5, y = 1, z = 0.5}, width = 80, height = 54, font_size = 50,
          color = {r = 1, g = 1, b = 1, a = 1}, font_color = {r = 0, g = 0, b = 0, a = 1}
          }
        },
      northwestterritory = {
        borders = {"alaska","alberta","ontario","greenland"},
        byWater = {false,false,false,true},
        owner = nil,
        units = 0,
        buttonindex = 1,
        button = {
          index = 1, click_function = 'northwestterritory', function_owner = self,
          tooltip = "North-West Territory",
          label = 'North-West Territory', position = {x = -0.94, y = 1, z = -0.62}, rotation = {x = 0, y = 0, z = 0},
          scale = {x = 0.5, y = 1, z = 0.5}, width = 80, height = 54, font_size = 50,
          color = {r = 1, g = 1, b = 1, a = 1}, font_color = {r = 0, g = 0, b = 0, a = 1}
          }
        },
      greenland = {
        borders = {"northwestterritory","ontario","quebec","iceland"},
        byWater = {true,true,true,true},
        owner = nil,
        units = 0,
        buttonindex = 2,
        button = {
          index = 2, click_function = 'greenland', function_owner = self,
          tooltip = "Greenland",
          label = 'Greenland', position = {x = -0.41, y = 1, z = -0.72}, rotation = {x = 0, y = 0, z = 0},
          scale = {x = 0.5, y = 1, z = 0.5}, width = 80, height = 54, font_size = 50,
          color = {r = 1, g = 1, b = 1, a = 1}, font_color = {r = 0, g = 0, b = 0, a = 1}
          }
        },
      alberta = {
        borders = {"alaska","northwestterritory","ontario","westernunitedstates"},
        byWater = {false,false,false,false},
        owner = nil,
        units = 0,
        buttonindex = 3,
        button = {
          index = 3, click_function = 'alberta', function_owner = self,
          tooltip = "Alberta",
          label = 'Alberta', position = {x = -0.96, y = 1, z = -0.47}, rotation = {x = 0, y = 0, z = 0},
          scale = {x = 0.5, y = 1, z = 0.5}, width = 80, height = 54, font_size = 50,
          color = {r = 1, g = 1, b = 1, a = 1}, font_color = {r = 0, g = 0, b = 0, a = 1}
          }
        },
      ontario = {
        borders = {"northwestterritory","alberta","westernunitedstates","easternunitedstates","quebec","greenland"},
        byWater = {false,false,false,false,false,true},
        owner = nil,
        units = 0,
        buttonindex = 4,
        button = {
          index = 4, click_function = 'ontario', function_owner = self,
          tooltip = "Ontario",
          label = 'Ontario', position = {x = -0.78, y = 1, z = -0.43}, rotation = {x = 0, y = 0, z = 0},
          scale = {x = 0.5, y = 1, z = 0.5}, width = 80, height = 54, font_size = 50,
          color = {r = 1, g = 1, b = 1, a = 1}, font_color = {r = 0, g = 0, b = 0, a = 1}}
        },
      quebec = {
        borders = {"ontario","easternunitedstates","greenland"},
        byWater = {false,false,true},
        owner = nil,
        units = 0,
        buttonindex = 5,
        button = {
          index = 5, click_function = 'quebec', function_owner = self,
          tooltip = "Quebec",
          label = 'Quebec', position = {x = -0.59, y = 1, z = -0.43}, rotation = {x = 0, y = 0, z = 0},
          scale = {x = 0.5, y = 1, z = 0.5}, width = 80, height = 54, font_size = 50,
          color = {r = 1, g = 1, b = 1, a = 1}, font_color = {r = 0, g = 0, b = 0, a = 1}}
        },
      westernunitedstates = {
        borders = {"alberta","ontario","easternunitedstates","centralamerica"},
        byWater = {false,false,false,false},
        owner = nil,
        units = 0,
        buttonindex = 6,
        button = {
          index = 6, click_function = 'westernunitedstates', function_owner = self,
          tooltip = "Western United States",
          label = 'Western United States', position = {x = -0.95, y = 1, z = -0.27}, rotation = {x = 0, y = 0, z = 0},
          scale = {x = 0.5, y = 1, z = 0.5}, width = 80, height = 54, font_size = 50,
          color = {r = 1, g = 1, b = 1, a = 1}, font_color = {r = 0, g = 0, b = 0, a = 1}}
        },
      easternunitedstates = {
        borders = {"ontario","quebec","westernunitedstates","centralamerica"},
        byWater = {false,false,false,false},
        owner = nil,
        units = 0,
        buttonindex = 7,
        button = {
          index = 7, click_function = 'easternunitedstates', function_owner = self,
          tooltip = "Eastern United States",
          label = 'Eastern United States', position = {x = -0.76, y = 1, z = -0.18}, rotation = {x = 0, y = 0, z = 0},
          scale = {x = 0.5, y = 1, z = 0.5}, width = 80, height = 54, font_size = 50,
          color = {r = 1, g = 1, b = 1, a = 1}, font_color = {r = 0, g = 0, b = 0, a = 1}}
        },
      centralamerica = {
        borders = {"westernunitedstates","easternunitedstates","venezuela"},
        byWater = {false,false,false},
        owner = nil,
        units = 0,
        buttonindex = 8,
        button = {
          index = 8, click_function = 'centralamerica', function_owner = self,
          tooltip = "Central America",
          label = 'Central America', position = {x = -0.87, y = 1, z = 0.01}, rotation = {x = 0, y = 0, z = 0},
          scale = {x = 0.5, y = 1, z = 0.5}, width = 80, height = 54, font_size = 50,
          color = {r = 1, g = 1, b = 1, a = 1}, font_color = {r = 0, g = 0, b = 0, a = 1}}
        },
      },
    sAmerica = {
      venezuela = {
        borders = {"centralamerica","peru","brazil"},
        byWater = {false,false,false},
        owner = nil,
        units = 0,
        buttonindex = 9,
        button = {
          index = 9, click_function = 'venezuela', function_owner = self,
          tooltip = "enezuela",
          label = 'Venezuela', position = {x = -0.75, y = 1, z = 0.14}, rotation = {x = 0, y = 0, z = 0},
          scale = {x = 0.5, y = 1, z = 0.5}, width = 80, height = 54, font_size = 50,
          color = {r = 1, g = 1, b = 1, a = 1}, font_color = {r = 0, g = 0, b = 0, a = 1}}
        },
      peru = {
        borders = {"venezuela","brazil","argentina"},
        byWater = {false,false,false},
        owner = nil,
        units = 0,
        buttonindex = 10,
        button = {
          index = 10, click_function = 'peru', function_owner = self,
          tooltip = "Peru",
          label = 'Peru', position = {x = -0.68, y = 1, z = 0.39}, rotation = {x = 0, y = 0, z = 0},
          scale = {x = 0.5, y = 1, z = 0.5}, width = 80, height = 54, font_size = 50,
          color = {r = 1, g = 1, b = 1, a = 1}, font_color = {r = 0, g = 0, b = 0, a = 1}}
        },
      brazil = {
        borders = {"venezuela","peru","argentina","northafrica"},
        byWater = {false,false,false,true},
        owner = nil,
        units = 0,
        buttonindex = 11,
        button = {
          index = 11, click_function = 'brazil', function_owner = self,
          tooltip = "Brazil",
          label = 'Brazil', position = {x = -0.53, y = 1, z = 0.31}, rotation = {x = 0, y = 0, z = 0},
          scale = {x = 0.5, y = 1, z = 0.5}, width = 80, height = 54, font_size = 50,
          color = {r = 1, g = 1, b = 1, a = 1}, font_color = {r = 0, g = 0, b = 0, a = 1}}
        },
      argentina = {
        borders = {"peru","brazil"},
        byWater = {false,false},
        owner = nil,
        units = 0,
        buttonindex = 12,
        button = {
          index = 12, click_function = 'argentina', function_owner = self,
          tooltip = "Argentina",
          label = 'Argentina', position = {x = -0.64, y = 1, z = 0.58}, rotation = {x = 0, y = 0, z = 0},
          scale = {x = 0.5, y = 1, z = 0.5}, width = 80, height = 54, font_size = 50,
          color = {r = 1, g = 1, b = 1, a = 1}, font_color = {r = 0, g = 0, b = 0, a = 1}}
        },
      },
    europe = {
      iceland = {
        borders = {"greenland","scandinavia","greatbritain"},
        byWater = {true,true,true},
        owner = nil,
        units = 0,
        buttonindex = 13,
        button = {
          index = 13, click_function = 'iceland', function_owner = self,
          tooltip = "Iceland",
          label = 'Iceland', position = {x = -0.19, y = 1, z = -0.53}, rotation = {x = 0, y = 0, z = 0},
          scale = {x = 0.5, y = 1, z = 0.5}, width = 80, height = 54, font_size = 50,
          color = {r = 1, g = 1, b = 1, a = 1}, font_color = {r = 0, g = 0, b = 0, a = 1}}
        },
      scandinavia = {
        borders = {"iceland","ukrane","greatbritain","northerneurope"},
        byWater = {true,false,true,false},
        owner = nil,
        units = 0,
        buttonindex = 14,
        button = {
          index = 14, click_function = 'scandinavia', function_owner = self,
          tooltip = "Scandinavia",
          label = 'Scandinavia', position = {x = 0.04, y = 1, z = -0.59}, rotation = {x = 0, y = 0, z = 0},
          scale = {x = 0.5, y = 1, z = 0.5}, width = 80, height = 54, font_size = 50,
          color = {r = 1, g = 1, b = 1, a = 1}, font_color = {r = 0, g = 0, b = 0, a = 1}}
        },
      ukrane = {
        borders = {"scandinavia","northerneurope","southerneurope","middleeast","afghanistan","ural"},
        byWater = {false,false,false,false,false,false},
        owner = nil,
        units = 0,
        buttonindex = 15,
        button = {
          index = 15, click_function = 'ukrane', function_owner = self,
          tooltip = "Ukrane",
          label = 'Ukrane', position = {x = 0.29, y = 1, z = -0.41}, rotation = {x = 0, y = 0, z = 0},
          scale = {x = 0.5, y = 1, z = 0.5}, width = 80, height = 54, font_size = 50,
          color = {r = 1, g = 1, b = 1, a = 1}, font_color = {r = 0, g = 0, b = 0, a = 1}}
        },
      greatbritain = {
        borders = {"iceland","scandinavia","northerneurope","westerneurope"},
        byWater = {true,true,true,true},
        owner = nil,
        units = 0,
        buttonindex = 16,
        button = {
          index = 16, click_function = 'greatbritain', function_owner = self,
          tooltip = "Great Britain",
          label = 'Great Britain', position = {x = -0.23, y = 1, z = -0.3}, rotation = {x = 0, y = 0, z = 0},
          scale = {x = 0.5, y = 1, z = 0.5}, width = 80, height = 54, font_size = 50,
          color = {r = 1, g = 1, b = 1, a = 1}, font_color = {r = 0, g = 0, b = 0, a = 1}}
        },
      northerneurope = {
        borders = {"greatbritain","westerneurope","southerneurope","ukrane","scandinavia"},
        byWater = {true,false,false,false,false},
        owner = nil,
        units = 0,
        buttonindex = 17,
        button = {
          index = 17, click_function = 'northerneurope', function_owner = self,
          tooltip = "Northern Europe",
          label = 'Northern Europe', position = {x = 0.07, y = 1, z = -0.26}, rotation = {x = 0, y = 0, z = 0},
          scale = {x = 0.5, y = 1, z = 0.5}, width = 80, height = 54, font_size = 50,
          color = {r = 1, g = 1, b = 1, a = 1}, font_color = {r = 0, g = 0, b = 0, a = 1}}
        },
      westerneurope = {
        borders = {"greatbritain","northafrica","southerneurope","northerneurope"},
        byWater = {true,false,false,false},
        owner = nil,
        units = 0,
        buttonindex = 18,
        button = {
          index = 18, click_function = 'westerneurope', function_owner = self,
          tooltip = "Western Europe",
          label = 'Western Europe', position = {x = -0.19, y = 1, z = 0}, rotation = {x = 0, y = 0, z = 0},
          scale = {x = 0.5, y = 1, z = 0.5}, width = 80, height = 54, font_size = 50,
          color = {r = 1, g = 1, b = 1, a = 1}, font_color = {r = 0, g = 0, b = 0, a = 1}}
        },
      southerneurope = {
        borders = {"northerneurope","westerneurope","northafrica","egypt","middleeast","ukrane"},
        byWater = {false,false,false,true,false,false},
        owner = nil,
        units = 0,
        buttonindex = 19,
        button = {
          index = 19, click_function = 'southerneurope', function_owner = self,
          tooltip = "Southern Europe",
          label = 'Southern Europe', position = {x = 0.07, y = 1, z = -0.12}, rotation = {x = 0, y = 0, z = 0},
          scale = {x = 0.5, y = 1, z = 0.5}, width = 80, height = 54, font_size = 50,
          color = {r = 1, g = 1, b = 1, a = 1}, font_color = {r = 0, g = 0, b = 0, a = 1}}
        },
      },
    africa = {
      northafrica = {
        borders = {"westerneurope","brazil","congo","eastafrica","egypt","southerneurope"},
        byWater = {false,true,false,false,false,false},
        owner = nil,
        units = 0,
        buttonindex = 20,
        button = {
          index = 20, click_function = 'northafrica', function_owner = self,
          tooltip = "North Africa",
          label = 'North Africa', position = {x = -0.07, y = 1, z = 0.28}, rotation = {x = 0, y = 0, z = 0},
          scale = {x = 0.5, y = 1, z = 0.5}, width = 80, height = 54, font_size = 50,
          color = {r = 1, g = 1, b = 1, a = 1}, font_color = {r = 0, g = 0, b = 0, a = 1}}
        },
      egypt = {
        borders = {"southerneurope","northafrica","eastafrica","middleeast"},
        byWater = {true,false,false,false},
        owner = nil,
        units = 0,
        buttonindex = 21,
        button = {
          index = 21, click_function = 'egypt', function_owner = self,
          tooltip = "Egypt",
          label = 'Egypt', position = {x = 0.13, y = 1, z = 0.18}, rotation = {x = 0, y = 0, z = 0},
          scale = {x = 0.5, y = 1, z = 0.5}, width = 80, height = 54, font_size = 50,
          color = {r = 1, g = 1, b = 1, a = 1}, font_color = {r = 0, g = 0, b = 0, a = 1}}
        },
      eastafrica = {
        borders = {"egypt","northafrica","congo","southafrica","madagascar","middleeast"},
        byWater = {false,false,false,false,true,true},
        owner = nil,
        units = 0,
        buttonindex = 22,
        button = {
          index = 22, click_function = 'eastafrica', function_owner = self,
          tooltip = "East Africa",
          label = 'East Africa', position = {x = 0.26, y = 1, z = 0.39}, rotation = {x = 0, y = 0, z = 0},
          scale = {x = 0.5, y = 1, z = 0.5}, width = 80, height = 54, font_size = 50,
          color = {r = 1, g = 1, b = 1, a = 1}, font_color = {r = 0, g = 0, b = 0, a = 1}}
        },
      congo = {
        borders = {"northafrica","southafrica","eastafrica"},
        byWater = {false,false,false},
        owner = nil,
        units = 0,
        buttonindex = 23,
        button = {
          index = 23, click_function = 'congo', function_owner = self,
          tooltip = "Congo",
          label = 'Congo', position = {x = 0.14, y = 1, z = 0.5}, rotation = {x = 0, y = 0, z = 0},
          scale = {x = 0.5, y = 1, z = 0.5}, width = 80, height = 54, font_size = 50,
          color = {r = 1, g = 1, b = 1, a = 1}, font_color = {r = 0, g = 0, b = 0, a = 1}}
        },
      southafrica = {
        borders = {"congo","madagascar","eastafrica"},
        byWater = {false,true,false},
        owner = nil,
        units = 0,
        buttonindex = 24,
        button = {
          index = 24, click_function = 'southafrica', function_owner = self,
          tooltip = "South Africa",
          label = 'South Africa', position = {x = 0.15, y = 1, z = 0.78}, rotation = {x = 0, y = 0, z = 0},
          scale = {x = 0.5, y = 1, z = 0.5}, width = 80, height = 54, font_size = 50,
          color = {r = 1, g = 1, b = 1, a = 1}, font_color = {r = 0, g = 0, b = 0, a = 1}}
        },
      madagascar = {
        borders = {"southafrica","eastafrica"},
        byWater = {true,true},
        owner = nil,
        units = 0,
        buttonindex = 25,
        button = {
          index = 25, click_function = 'madagascar', function_owner = self,
          tooltip = "Madagascar",
          label = 'Madagascar', position = {x = 0.38, y = 1, z = 0.69}, rotation = {x = 0, y = 0, z = 0},
          scale = {x = 0.5, y = 1, z = 0.5}, width = 80, height = 54, font_size = 50,
          color = {r = 1, g = 1, b = 1, a = 1}, font_color = {r = 0, g = 0, b = 0, a = 1}}
        },
      },
    asia = {
      ural = {
        borders = {"ukrane","afghanistan","china","siberia"},
        byWater = {false,false,false,false},
        owner = nil,
        units = 0,
        buttonindex = 26,
        button = {
          index = 26, click_function = 'ural', function_owner = self,
          tooltip = "Ural",
          label = 'Ural', position = {x = 0.56, y = 1, z = -0.48}, rotation = {x = 0, y = 0, z = 0},
          scale = {x = 0.5, y = 1, z = 0.5}, width = 80, height = 54, font_size = 50,
          color = {r = 1, g = 1, b = 1, a = 1}, font_color = {r = 0, g = 0, b = 0, a = 1}}
        },
      siberia = {
        borders = {"ural","china","mongolia","irkutsk","yakutsk"},
        byWater = {false,false,false,false,false},
        owner = nil,
        units = 0,
        buttonindex = 27,
        button = {
          index = 27, click_function = 'siberia', function_owner = self,
          tooltip = "Siberia",
          label = 'Siberia', position = {x = 0.7, y = 1, z = -0.58}, rotation = {x = 0, y = 0, z = 0},
          scale = {x = 0.5, y = 1, z = 0.5}, width = 80, height = 54, font_size = 50,
          color = {r = 1, g = 1, b = 1, a = 1}, font_color = {r = 0, g = 0, b = 0, a = 1}}
        },
      yakutsk = {
        borders = {"siberia","irkutsk","kamchatka"},
        byWater = {false,false,false,},
        owner = nil,
        units = 0,
        buttonindex = 28,
        button = {
          index = 28, click_function = 'yakutsk', function_owner = self,
          tooltip = "Yakutsk",
          label = 'Yakutsk', position = {x = 0.91, y = 1, z = -0.67}, rotation = {x = 0, y = 0, z = 0},
          scale = {x = 0.5, y = 1, z = 0.5}, width = 80, height = 54, font_size = 50,
          color = {r = 1, g = 1, b = 1, a = 1}, font_color = {r = 0, g = 0, b = 0, a = 1}}
        },
      kamchatka = {
        borders = {"yakutsk","irkutsk","mongolia","japan","alaska"},
        byWater = {false,false,false,true,true},
        owner = nil,
        units = 0,
        buttonindex = 29,
        button = {
          index = 29, click_function = 'kamchatka', function_owner = self,
          tooltip = "Kamchatka",
          label = 'Kamchatka', position = {x = 1.12, y = 1, z = -0.65}, rotation = {x = 0, y = 0, z = 0},
          scale = {x = 0.5, y = 1, z = 0.5}, width = 80, height = 54, font_size = 50,
          color = {r = 1, g = 1, b = 1, a = 1}, font_color = {r = 0, g = 0, b = 0, a = 1}}
        },
      irkutsk = {
        borders = {"yakutsk","siberia","mongolia","kamchatka","yakutsk"},
        byWater = {false,false,false,false,false},
        owner = nil,
        units = 0,
        buttonindex = 30,
        button = {
          index = 30, click_function = 'irkutsk', function_owner = self,
          tooltip = "Irkutsk",
          label = 'Irkutsk', position = {x = 0.88, y = 1, z = -0.43}, rotation = {x = 0, y = 0, z = 0},
          scale = {x = 0.5, y = 1, z = 0.5}, width = 80, height = 54, font_size = 50,
          color = {r = 1, g = 1, b = 1, a = 1}, font_color = {r = 0, g = 0, b = 0, a = 1}}
        },
      mongolia = {
        borders = {"irkutsk","siberia","china","japan","kamchatka"},
        byWater = {false,false,false,true,false},
        owner = nil,
        units = 0,
        buttonindex = 31,
        button = {
          index = 31, click_function = 'mongolia', function_owner = self,
          tooltip = "Mongolia",
          label = 'Mongolia', position = {x = 0.9, y = 1, z = -0.26}, rotation = {x = 0, y = 0, z = 0},
          scale = {x = 0.5, y = 1, z = 0.5}, width = 80, height = 54, font_size = 50,
          color = {r = 1, g = 1, b = 1, a = 1}, font_color = {r = 0, g = 0, b = 0, a = 1}}
        },
      afghanistan = {
        borders = {"ukrane","middleeast","india","china","ural"},
        byWater = {false,false,false,false,false},
        owner = nil,
        units = 0,
        buttonindex = 32,
        button = {
          index = 32, click_function = 'afghanistan', function_owner = self,
          tooltip = "Afghanistan",
          label = 'Afghanistan', position = {x = 0.52, y = 1, z = -0.21}, rotation = {x = 0, y = 0, z = 0},
          scale = {x = 0.5, y = 1, z = 0.5}, width = 80, height = 54, font_size = 50,
          color = {r = 1, g = 1, b = 1, a = 1}, font_color = {r = 0, g = 0, b = 0, a = 1}}
        },
      japan = {
        borders = {"mongolia","kamchatka"},
        byWater = {true,true},
        owner = nil,
        units = 0,
        buttonindex = 33,
        button = {
          index = 33, click_function = 'japan', function_owner = self,
          tooltip = "Japan",
          label = 'Japan', position = {x = 1.21, y = 1, z = -0.3}, rotation = {x = 0, y = 0, z = 0},
          scale = {x = 0.5, y = 1, z = 0.5}, width = 80, height = 54, font_size = 50,
          color = {r = 1, g = 1, b = 1, a = 1}, font_color = {r = 0, g = 0, b = 0, a = 1}}
        },
      china = {
        borders = {"siberia","ural","afghanistan","india","siam","mongolia"},
        byWater = {false,false,false,false,false,false},
        owner = nil,
        units = 0,
        buttonindex = 34,
        button = {
          index = 34, click_function = 'china', function_owner = self,
          tooltip = "China",
          label = 'China', position = {x = 0.83, y = 1, z = -0.08}, rotation = {x = 0, y = 0, z = 0},
          scale = {x = 0.5, y = 1, z = 0.5}, width = 80, height = 54, font_size = 50,
          color = {r = 1, g = 1, b = 1, a = 1}, font_color = {r = 0, g = 0, b = 0, a = 1}}
        },
      middleeast = {
        borders = {"ukrane","southerneurope","egypt","eastafrica","india","afghanistan"},
        byWater = {false,false,false,true,false,false},
        owner = nil,
        units = 0,
        buttonindex = 35,
        button = {
          index = 35, click_function = 'middleeast', function_owner = self,
          tooltip = "Middle East",
          label = 'Middle East', position = {x = 0.38, y = 1, z = 0.02}, rotation = {x = 0, y = 0, z = 0},
          scale = {x = 0.5, y = 1, z = 0.5}, width = 80, height = 54, font_size = 50,
          color = {r = 1, g = 1, b = 1, a = 1}, font_color = {r = 0, g = 0, b = 0, a = 1}}
        },
      india = {
        borders = {"afghanistan","middleeast","siam","china"},
        byWater = {false,false,false,false},
        owner = nil,
        units = 0,
        buttonindex = 36,
        button = {
          index = 36, click_function = 'india', function_owner = self,
          tooltip = "India",
          label = 'India', position = {x = 0.66, y = 1, z = 0.06}, rotation = {x = 0, y = 0, z = 0},
          scale = {x = 0.5, y = 1, z = 0.5}, width = 80, height = 54, font_size = 50,
          color = {r = 1, g = 1, b = 1, a = 1}, font_color = {r = 0, g = 0, b = 0, a = 1}}
        },
      siam = {
        borders = {"india","china","indonesia"},
        byWater = {false,false,true},
        owner = nil,
        units = 0,
        buttonindex = 37,
        button = {
          index = 37, click_function = 'siam', function_owner = self,
          tooltip = "Siam",
          label = 'Siam', position = {x = 0.9, y = 1, z = 0.16}, rotation = {x = 0, y = 0, z = 0},
          scale = {x = 0.5, y = 1, z = 0.5}, width = 80, height = 54, font_size = 50,
          color = {r = 1, g = 1, b = 1, a = 1}, font_color = {r = 0, g = 0, b = 0, a = 1}}
        },
      },
    australia = {
      indonesia = {
        borders = {"siam","westernaustralia","newguinea"},
        byWater = {true,true,true},
        owner = nil,
        units = 0,
        buttonindex = 38,
        button = {
          index = 38, click_function = 'indonesia', function_owner = self,
          tooltip = "Indonesia",
          label = 'Indonesia', position = {x = 1.02, y = 1, z = 0.48}, rotation = {x = 0, y = 0, z = 0},
          scale = {x = 0.5, y = 1, z = 0.5}, width = 80, height = 54, font_size = 50,
          color = {r = 1, g = 1, b = 1, a = 1}, font_color = {r = 0, g = 0, b = 0, a = 1}}
        },
      newguinea = {
        borders = {"indonesia","easternaustralia"},
        byWater = {true,true},
        owner = nil,
        units = 0,
        buttonindex = 39,
        button = {
          index = 39, click_function = 'newguinea', function_owner = self,
          tooltip = "New Guinea",
          label = 'New Guinea', position = {x = 1.26, y = 1, z = 0.42}, rotation = {x = 0, y = 0, z = 0},
          scale = {x = 0.5, y = 1, z = 0.5}, width = 80, height = 54, font_size = 50,
          color = {r = 1, g = 1, b = 1, a = 1}, font_color = {r = 0, g = 0, b = 0, a = 1}}
        },
      westernaustralia = {
        borders = {"indonesia","easternaustralia"},
        byWater = {true,false},
        owner = nil,
        units = 0,
        buttonindex = 40,
        button = {
          index = 40, click_function = 'westernaustralia', function_owner = self,
          tooltip = "Western Austrailia",
          label = 'Western Austrailia', position = {x = 1.06, y = 1, z = 0.64}, rotation = {x = 0, y = 0, z = 0},
          scale = {x = 0.5, y = 1, z = 0.5}, width = 80, height = 54, font_size = 50,
          color = {r = 1, g = 1, b = 1, a = 1}, font_color = {r = 0, g = 0, b = 0, a = 1}}
        },
      easternaustralia = {
        borders = {"newguinea","westernaustralia"},
        byWater = {true,false},
        owner = nil,
        units = 0,
        buttonindex = 41,
        button = {
          index = 41, click_function = 'easternaustralia', function_owner = self,
          tooltip = "Eastern Austrailia",
          label = 'Eastern Austrailia', position = {x = 1.28, y = 1, z = 0.68}, rotation = {x = 0, y = 0, z = 0},
          scale = {x = 0.5, y = 1, z = 0.5}, width = 80, height = 54, font_size = 50,
          color = {r = 1, g = 1, b = 1, a = 1}, font_color = {r = 0, g = 0, b = 0, a = 1}}
        }
      }
    }
  
  return newContinents
end
-- Button click re-reference functions
  --Territories
function alaska(o,c) territoryClicked("alaska",c) end
function northwestterritory(o,c) territoryClicked("northwestterritory",c) end
function greenland(o,c) territoryClicked("greenland",c) end
function alberta(o,c) territoryClicked("alberta",c) end
function ontario(o,c) territoryClicked("ontario",c) end
function quebec(o,c) territoryClicked("quebec",c) end
function westernunitedstates(o,c) territoryClicked("westernunitedstates",c) end
function easternunitedstates(o,c) territoryClicked("easternunitedstates",c) end
function centralamerica(o,c) territoryClicked("centralamerica",c) end
function venezuela(o,c) territoryClicked("venezuela",c) end
function brazil(o,c) territoryClicked("brazil",c) end
function peru(o,c) territoryClicked("peru",c) end
function argentina(o,c) territoryClicked("argentina",c) end
function iceland(o,c) territoryClicked("iceland",c) end
function scandinavia(o,c) territoryClicked("scandinavia",c) end
function ukrane(o,c) territoryClicked("ukrane",c) end
function greatbritain(o,c) territoryClicked("greatbritain",c) end
function northerneurope(o,c) territoryClicked("northerneurope",c) end
function westerneurope(o,c) territoryClicked("westerneurope",c) end
function southerneurope(o,c) territoryClicked("southerneurope",c) end
function northafrica(o,c) territoryClicked("northafrica",c) end
function egypt(o,c) territoryClicked("egypt",c) end
function eastafrica(o,c) territoryClicked("eastafrica",c) end
function congo(o,c) territoryClicked("congo",c) end
function madagascar(o,c) territoryClicked("madagascar",c) end
function southafrica(o,c) territoryClicked("southafrica",c) end
function ural(o,c) territoryClicked("ural",c) end
function siberia(o,c) territoryClicked("siberia",c) end
function yakutsk(o,c) territoryClicked("yakutsk",c) end
function kamchatka(o,c) territoryClicked("kamchatka",c) end
function irkutsk(o,c) territoryClicked("irkutsk",c) end
function mongolia(o,c) territoryClicked("mongolia",c) end
function japan(o,c) territoryClicked("japan",c) end
function afghanistan(o,c) territoryClicked("afghanistan",c) end
function china(o,c) territoryClicked("china",c) end
function middleeast(o,c) territoryClicked("middleeast",c) end
function india(o,c) territoryClicked("india",c) end
function siam(o,c) territoryClicked("siam",c) end
function indonesia(o,c) territoryClicked("indonesia",c) end
function newguinea(o,c) territoryClicked("newguinea",c) end
function westernaustralia(o,c) territoryClicked("westernaustralia",c) end
function easternaustralia(o,c) territoryClicked("easternaustralia",c) end