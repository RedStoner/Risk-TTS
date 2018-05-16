function onLoad()
  gameStarted = false
  buttons = {}
  buttons[1] = {click_function = "strategicConfig", function_owner = self, label = "Long Range Strategic Moves", tooltip = "Allows You to move units during the strategic move phase to any territory \nso long as there is a path through territories you control.",
                    position = {0.28, 0.53, -0.82}, rotation = {0, 90, 0}, scale = {0.05, 0.05, 0.05}, width = 3240, height = 940, font_size = 200, alignment = 5, index = 1,value = false}
  buttons[2] = {click_function = "setTradeConfig", function_owner = self, label = "Turning in Sets after defeating \nan opponent and recieved cards.", 
                    position = {0.16, 0.53, -0.82}, rotation = {0, 90, 0}, scale = {0.05, 0.05, 0.05}, width = 3240, height = 940, font_size = 200, alignment = 3, index = 3,value = false}
  buttons[3] = {click_function = "setTerritoryConfig", function_owner = self, label = "Gain Units for every territory show\nwhen trading in a set", 
                    position = {0.04, 0.53, -0.82}, rotation = {0, 90, 0}, scale = {0.05, 0.05, 0.05}, width = 3240, height = 940, font_size = 200, alignment = 3, index = 5,value = false}
  buttons[4] = {click_function = "reshuffleConfig", function_owner = self, label = "Enable Reshuffle Cards When Empty", 
                    position = {-0.08, 0.53, -0.82}, rotation = {0, 90, 0}, scale = {0.05, 0.05, 0.05}, width = 3240, height = 940, font_size = 200, alignment = 3, index = 7,value = false}

  buttonsOutline = {}
  buttonsOutline[1] = {click_function = "none", function_owner = self, label = "",
                    position = {0.28, 0.51, -0.82}, rotation = {0, 90, 0}, scale = {0.05, 0.05, 0.05}, width = 3300, height = 1000, font_size = 200, alignment = 5, index = 0,value = false}
  buttonsOutline[2] = {click_function = "none", function_owner = self, label = "", 
                    position = {0.16, 0.51, -0.82}, rotation = {0, 90, 0}, scale = {0.05, 0.05, 0.05}, width = 3300, height = 1000, font_size = 200, alignment = 3, index = 2,value = false}
  buttonsOutline[3] = {click_function = "none", function_owner = self, label = "", 
                    position = {0.04, 0.51, -0.82}, rotation = {0, 90, 0}, scale = {0.05, 0.05, 0.05}, width = 3300, height = 1000, font_size = 200, alignment = 3, index = 4,value = false}
  buttonsOutline[4] = {click_function = "none", function_owner = self, label = "", 
                    position = {-0.08, 0.51, -0.82}, rotation = {0, 90, 0}, scale = {0.05, 0.05, 0.05}, width = 3300, height = 1000, font_size = 200, alignment = 3, index = 6,value = false}
 -- local data = {click_function = "INSERT_FUNCTION", function_owner = self, label = "Restart/Regen", 
 --                   position = {-0.0799999982118607, 0.509999990463257, 0.824}, rotation = {0, 90, 0}, scale = {0.0500000007450581, 0.0500000007450581, 0.0500000007450581}, width = 3300, height = 1000, font_size = 200, tooltip = "Restart/Regen", alignment = 3}
  for k,v in pairs(buttons) do
    if v.value == false then
      buttonsOutline[k].color = {0.856, 0.1, 0.094}
    else
      buttonsOutline[k].color = {0.192, 0.701, 0.168}
    end
    v.color = {1,1,1}
    self.createButton(buttonsOutline[k])
    self.createButton(v)
  end
  Global.call('objectLoadFinished',{self.guid})
end
function strategicConfig(o,c)
  if gameStarted then
    return
  end
  if buttons[1].value then
    buttons[1].value = false
    buttonsOutline[1].color = {0.856, 0.1, 0.094}
  else
    buttons[1].value = true
    buttonsOutline[1].color = {0.192, 0.701, 0.168}
  end
  self.editButton(buttonsOutline[1]) 
  self.editButton(buttons[1])
end
 
function setTradeConfig(o,c)
  if gameStarted then
    return
  end
  if buttons[2].value then
    buttons[2].value = false
    buttonsOutline[2].color = {0.856, 0.1, 0.094}
  else
    buttons[2].value = true
    buttonsOutline[2].color = {0.192, 0.701, 0.168}
  end
  self.editButton(buttonsOutline[2])
  self.editButton(buttons[2])
end

function setTerritoryConfig(o,c)
  if gameStarted then
    return
  end
  if buttons[3].value then
    buttons[3].value = false
    buttonsOutline[3].color = {0.856, 0.1, 0.094}
  else
    buttons[3].value = true
    buttonsOutline[3].color = {0.192, 0.701, 0.168}
  end
  self.editButton(buttonsOutline[3])
  self.editButton(buttons[3])
end

function reshuffleConfig(o,c)
  if gameStarted then
    return
  end
  if buttons[4].value then
    buttons[4].value = false
    buttonsOutline[4].color = {0.856, 0.1, 0.094}
  else
    buttons[4].value = true
    buttonsOutline[4].color = {0.192, 0.701, 0.168}
  end
  self.editButton(buttonsOutline[4])
  self.editButton(buttons[4])
end
function getConfigValues()
  local info = {}
  info.longRangeStrategic = buttons[1].value
  info.allowSetAfterEnemyDefeat = buttons[2].value
  info.giveAllUnitsOnSetTerritories = buttons[3].value
  info.reshuffleCardsOnDeckEmpty = buttons[4].value
  return info
end

function loadSaveData(config)
  if config.longRangeStrategic then strategicConfig() end
  if config.allowSetAfterEnemyDefeat then setTradeConfig() end
  if config.giveAllUnitsOnSetTerritories then setTerritoryConfig() end
  if config.reshuffleCardsOnDeckEmpty then reshuffleConfig() end
end

function toggleConfigButtons()
  if gameStarted then
    gameStarted = false
  else
    gameStarted = true
  end
end
function none()
  return
end