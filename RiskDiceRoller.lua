function onLoad()
  trackedDice = {}
  startedRolling = false
  defender = false
  if self.guid == "44e410" then
    defender = true
  end
  currentUser = "Grey"
  tColor = {1,1,1}
  buttons = {}
  buttons[1] = {click_function = "none", index = 0, function_owner = self, label = "Attack Again?", position = {0, -2.14, -3.2}, rotation = {0, 180, 0}, scale = {0, 0, 0}, width = 2000, height = 400, font_size = 330, attackAgain = false}
  buttons[2] = {click_function = "repeatYes", index = 1, function_owner = self, label = "Yes", position = {0.54, -2.14, -3.6}, rotation = {0, 180, 0}, scale = {0, 0, 0}, width = 998, height = 400, font_size = 400, on = false}
  buttons[3] = {click_function = "repeatNo", index = 2, function_owner = self, label = "No", position = {-0.54, -2.14, -3.6}, rotation = {0, 180, 0}, scale = {0, 0, 0}, width = 998, height = 400, font_size = 400, on = false}
  
  if defender then
    bag = getObjectFromGUID("27e50f")
    dieOffset = 45
    buttons[4] = {click_function = "rollDice1", index = 3, function_owner = self, label = "1", position = {0.54, -2.14, -2.8}, rotation = {0, 180, 0}, scale = {0.5, 0.5, 0.5}, width = 998, height = 400, font_size = 400, on = false}
    buttons[5] = {click_function = "rollDice2", index = 4, function_owner = self, label = "2", position = {-0.54, -2.14, -2.8}, rotation = {0, 180, 0}, scale = {0.5, 0.5, 0.5}, width = 998, height = 400, font_size = 400, on = false}
  else
    bag = getObjectFromGUID("82056b")
    dieOffset = -45
    buttons[4] = {click_function = "rollDice1", index = 3, function_owner = self, label = "1", position = {0.7, -2.14, -2.8}, rotation = {0, 180, 0}, scale = {0.5, 0.5, 0.5}, width = 666, height = 400, font_size = 400, on = false}
    buttons[5] = {click_function = "rollDice2", index = 4, function_owner = self, label = "2", position = {0, -2.14, -2.8}, rotation = {0, 180, 0}, scale = {0.5, 0.5, 0.5}, width = 666, height = 400, font_size = 400, on = false}
    buttons[6] = {click_function = "rollDice3", index = 5, function_owner = self, label = "3", position = {-0.7, -2.14, -2.8}, rotation = {0, 180, 0}, scale = {0.5, 0.5, 0.5}, width = 666, height = 400, font_size = 400, on = false}
  end
  for k,v in pairs(buttons) do
    self.createButton(v)
  end
  map = getObjectFromGUID("be2f30")
  bag.interactable = false
  pColors = {
    White = {1,1,1},
    Red = {0.856, 0.1, 0.094},
    Orange = {0.956, 0.392, 0.113},
    Yellow = {0.905, 0.898, 0.172},
    Green = {0.192, 0.701, 0.168},
    Blue = {0.118, 0.53, 1},{0.25},
    Pink = {0.96, 0.439, 0.807},
    Grey = {0.5,0.5,0.5},
  }
  tColors = {
    White = {0.25, 0.25, 0.25, 1},
    Red = {1, 1, 1, 1}, 
    Orange = {1, 1, 1, 1},
    Yellow = {0, 0, 0, 1},
    Green = {1, 1, 1, 1},
    Blue = {1, 1, 1, 1}, 
    Pink = {1, 1, 1, 1},
    Grey = {1, 1, 1, 1},
  }
  diceAmount({0})
  Global.call('objectLoadFinished',{self.guid})
end
function getSaveData()
  local data = {
    currentUser = currentUser,
    trackedDice = trackedDice,
    startedRolling = startedRolling,
    attackAgain = buttons[1].attackAgain,
    buttonStates = {}
  }
  
  for i=1, #buttons - 3 do
    --print("Button state for " .. i+3 .. " is " .. tostring(buttons[i+3].on) )
    data.buttonStates[i] = buttons[i+3].on
  end
  return data
end
function loadSaveData(d)
  data = d[1]
  addNotebookTab({title = "roller", body = JSON.encode_pretty(data)})
  currentUser = data.currentUser
  trackedDice = data.trackedDice
  startedRolling = data.startedRolling
  --update attack again button
  showAttackAgain({data.attackAgain,currentUser})
  --update the amount to roll buttons
  for i=1,#data.buttonStates do
    broadcastToAll("State for button " .. i .. " is " .. tostring(data.buttonStates[i]),tColor)
    if data.buttonStates[i]  then
      buttons[i+3].color = pColors[currentUser]
      buttons[i+3].font_color = tColors[currentUser]
      buttons[i+3].on = true
    else
      buttons[i+3].color = pColors["Grey"]
      buttons[i+3].font_color = pColors["Grey"]
      buttons[i+3].on = false
    end
    self.editButton(buttons[i+3])
  end
end
function onUpdate()
  if #trackedDice > 0 and startedRolling then
    for k,v in pairs(trackedDice) do
      local obj = getObjectFromGUID(v)
      if obj.resting ~= true then
        --broadcastToColor("Dice are still moving. ",c,tColor)
        return
      end
    end
    startedRolling = false
    doneRoll()
  end
end
function repeatNo(o,c) map.call('attackAgain',{false}) end
function repeatYes(o,c) map.call('attackAgain',{true}) end
function rollDice1(o,c) rollDice(1,c) end
function rollDice2(o,c) rollDice(2,c) end
function rollDice3(o,c) rollDice(3,c) end
function rollDice(num,c)
  if startedRolling then
    return false
  end
  if buttons[num+3].on == false then
    return
  end
  if c ~= currentUser then
    broadcastToColor("It is not your turn to roll the dice.",c,tColor)
    return
  end
  startedRolling = true
  diceAmount({0,currentUser})
  for i=1,num do
    local loc = {dieOffset + (math.random(200)/100 - 1), 35 +(i*2), 47 + (math.random(200)/100 - 1)}
    local params = {}
    params.position = loc
    params.callback = "callback"
    params.callback_owner = self
    bag.takeObject(params)
  end
end
function doneRoll(b,c)
  local str = ""
  if defender then
    str = "Defender Rolled - "
  else
    str = "Attacker Rolled - "
  end
  local values = {}
  for k,v in pairs(trackedDice) do
    local obj = getObjectFromGUID(v)
    --str = str .. obj.getValue() .. " "
    table.insert(values,obj.getValue())
    obj.destruct()
  end
  table.sort(values,function(a,b) return a > b end)
  --str = str .. "   Sorted - "
  for k,v in ipairs(values) do
    str = str .. v .. " "
  end
  broadcastToAll(str,tColor)
  trackedDice = {}
  map.call('getDiceRolls',{defender, values})
end
function callback(o,p)
  table.insert(trackedDice,o.guid)
  --o.interactable = false
  o.setRotation({math.random(359),math.random(359),math.random(359)})
  o.roll()
end
function diceAmount(data)
  num = data[1]
  currentUser = data[2]
  for i=1,num do
    buttons[i+3].color = pColors[currentUser]
    buttons[i+3].font_color = tColors[currentUser]
    buttons[i+3].on = true
    self.editButton(buttons[i +3])
  end
  local numButtons = #buttons - 3
  if num < numButtons then
    local offset = numButtons - num
    for i=1,offset do
      buttons[num + i + 3].color = pColors["Grey"]
      buttons[num + i + 3].font_color = pColors["Grey"]
      buttons[num + i + 3].on = false
      self.editButton(buttons[num + i + 3])
    end
  end
end

function showAttackAgain(data)
  local activate = data[1]
  for i=1,3 do
    if activate then
      buttons[i].scale = {0.5,0.5,0.5}
      buttons[i].color = pColors[data[2]]
      if i == 1 then
        buttons[i].attackAgain = true
      end
    else
      buttons[i].scale = {0,0,0}
      if i == 1 then
        buttons[i].attackAgain = false
      end
    end
    self.editButton(buttons[i])
  end
end
function none()

end