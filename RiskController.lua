function onLoad()
  pColors = {
    White = {1,1,1},
    Red = {0.856, 0.1, 0.094},
    Orange = {0.956, 0.392, 0.113},
    Yellow = {0.905, 0.898, 0.172},
    Green = {0.192, 0.701, 0.168},
    Blue = {0.118, 0.53, 1},{0.25},
    Pink = {0.96, 0.439, 0.807},
    Grey = {0.5,0.5,0.5}
  }
  tColors = {
    White = {0.25, 0.25, 0.25, 1},
    Red = {1, 1, 1, 1}, 
    Orange = {1, 1, 1, 1},
    Yellow = {0.25, 0.25, 0.25, 1},
    Green = {1, 1, 1, 1},
    Blue = {1, 1, 1, 1}, 
    Pink = {1, 1, 1, 1},
    Grey = {1, 1, 1, 1},
  }
  data={}
  --data[1] = {index = 0, click_function = "doNothing",   function_owner = self, label = "Press Start", position = {-6, 0.6, -7.3}, scale = {1, 0.5, 1.6}, width = 2000, height = 400, font_size = 400, tooltip = "Turn"}
  data[1] = {index = 0, click_function = "doNothing", function_owner = self, label = "0", position = {2.1, 0.6, 7}, scale = {1, 0.5, 2}, width = 800, height = 500, font_size = 300, tooltip = "Amount Left Behind"}
  
  data[2] = {index = 1, click_function = "doNothing",   function_owner = self, label = "Pre\nGame", position = {-5.6, 0.6, -1.1}, scale = {1, 0.5, 2}, width = 2300, height = 900, font_size = 400, tooltip = "Phase"}
  data[3] = {index = 2, click_function = "endPhase",                 function_owner = self, label = "End phase", position = {5.9, 0.6, 0.1}, scale = {1, 0.5, 2}, width = 2000, height = 500, font_size = 400}
  data[4] = {index = 3, click_function = "doNothing",   function_owner = self, label = "Territory 1", position = {0.3, 0.6, -2.3}, scale = {1, 0.5, 2}, width = 3300, height = 500, font_size = 300}
  data[5] = {index = 4, click_function = "doNothing",   function_owner = self, label = "Territory 2", position = {0.3, 0.6, 0.1}, scale = {1, 0.5, 2}, width = 3300, height = 500, font_size = 300}
  data[6] = {index = 5, click_function = "confirm", function_owner = self, label = "Confirm", position = {5.9, 0.6, -2.3}, scale = {1, 0.5, 2}, width = 2000, height = 500, font_size = 400}
  data[7] = {index = 6, click_function = "doNothing",   function_owner = self, label = "0", position = {2.1, 0.6, 4.7}, scale = {1, 0.5, 2}, width = 800, height = 500, font_size = 300}
  data[8] = {index = 7, click_function = "addTen",      function_owner = self, label = "+ 10", position = {5.5, 0.6, 2.4}, scale = {1, 0.5, 2}, width = 800, height = 500, font_size = 300}
  data[9] = {index = 8, click_function = "addAll",        function_owner = self, label = "+ All", position = {7.2, 0.6, 2.4}, scale = {1, 0.5, 2}, width = 800, height = 500, font_size = 300}
  data[10] = {index = 9, click_function = "subTen",    function_owner = self, label = "- 10", position = {5.5, 0.6, 4.7}, scale = {1, 0.5, 2}, width = 800, height = 500, font_size = 300}
  data[11] = {index = 10, click_function = "subAll",      function_owner = self, label = "- All", position = {7.2, 0.6, 4.7}, scale = {1, 0.5, 2}, width = 800, height = 500, font_size = 300}
  data[12] = {index = 11, click_function = "doNothing", function_owner = self, label = "0", position = {2.1, 0.6, 2.4}, scale = {1, 0.5, 2}, width = 800, height = 500, font_size = 300}
  data[13] = {index = 12, click_function = "doNothing", function_owner = self, label = "Amount to Add", position = {-1, 0.6, 2.4}, scale = {1, 0.5, 2}, width = 2100, height = 500, font_size = 300}
  data[14] = {index = 13, click_function = "doNothing", function_owner = self, label = "Left to Place", position = {-1.0, 0.6, 4.7}, scale = {1, 0.5, 2}, width = 2100, height = 500, font_size = 300}
  data[15] = {index = 14, click_function = "doNothing", function_owner = self, label = "Push Start\nTo Begin", position = {-0.035, 0.6, -5.7}, scale = {1, 0.5, 2}, width = 7600, height = 1000, font_size = 500}
  data[16] = {index = 15, click_function = "card1", function_owner = self, label = "Card 1", position = {-5.6, 0.6, 2.4}, scale = {0, 0, 0}, width = 2300, height = 500, font_size = 250}
  data[17] = {index = 16, click_function = "card2", function_owner = self, label = "Card 2", position = {-5.6, 0.6, 4.7}, scale = {0, 0, 0}, width = 2300, height = 500, font_size = 250}
  data[18] = {index = 17, click_function = "card3", function_owner = self, label = "Card 3", position = {-5.6, 0.6, 7}, scale = {0, 0, 0}, width = 2300, height = 500, font_size = 250}
  data[19] = {index = 18, click_function = "doNothing", function_owner = self, label = "Left Behind", position = {-1, 0.6, 7}, scale = {1, 0.5, 2}, width = 2100, height = 500, font_size = 300}
  data[20] = {index = 19, click_function = "subOne", function_owner = self, label = "-", position = {3.8, 0.6, 4.7}, scale = {1, 0.5, 2}, width = 800, height = 500, font_size = 300, tooltip = "Subtract 1"}
  data[21] = {index = 20, click_function = "addOne", function_owner = self, label = "+", position = {3.8, 0.6, 2.4}, scale = {1, 0.5, 2}, width = 800, height = 500, font_size = 300, tooltip = "Add 1"}
  data[22] = {index = 21, click_function = "doNothing", function_owner = self, label = "Turn In Sets\nHere", position = {-5.6, 0.6, 4.7}, scale = {0, 0.5, 0}, width = 2300, height = 1600, font_size = 400}
  
  
  
  
  
  
  
  board = getObjectFromGUID("be2f30")
  for k,v in pairs(data) do
    self.createButton(v)
  end
  cardZone = getObjectFromGUID("1398dd")
  local _scale = {62.38, 1.0, 20.34}
  cardZone.setScale(_scale)
  updateZone()
end
function onCollisionEnter(collision)
  if cardZone ~= nil then
    updateZone()
  end
end
function updateZone()
  cardZone.setRotation(self.getRotation())
  local _position = self.getPosition()
  _position.y = 1.9
  cardZone.setPosition(_position)
end

function endPhase(o,c) board.call('controlClicked',{"endPhase",c}) end
function confirm(o,c) board.call('controlClicked',{"confirm",c}) end
function addOne(o,c) board.call('controlClicked',{"add",c}) end
function addTen(o,c) board.call('controlClicked',{"addTen",c}) end
function addAll(o,c) board.call('controlClicked',{"addAll",c}) end
function subOne(o,c) board.call('controlClicked',{"sub",c}) end
function subTen(o,c) board.call('controlClicked',{"subTen",c}) end
function subAll(o,c) board.call('controlClicked',{"subAll",c}) end
function card1(o,c) board.call('controlClicked',{"card",c,1}) end
function card2(o,c) board.call('controlClicked',{"card",c,2}) end
function card3(o,c) board.call('controlClicked',{"card",c,3}) end
 -- phase out
function updateTurn(value)
  data[1].label = value[1]
  data[1].color = pColors[value[1]]
  self.editButton(data[1])
end
 
function updatePhase(value)
  data[2].label = value[1]
  self.editButton(data[2])
end
function updateEndPhase(value)
  data[3].label = value[1]
  self.editButton(data[3])
end
function updateTerritoryOne(value)
  data[4].color = pColors[value[2]]
  data[4].font_color = tColors[value[2]]
  data[4].label = value[1]
  self.editButton(data[4])
end
function updateTerritoryTwo(value)
  data[5].color = pColors[value[2]]
  data[5].font_color = tColors[value[2]]
  data[5].label = value[1]
  self.editButton(data[5])
end
function updateConfirm(value)
  data[6].label = value[1]
  self.editButton(data[6])
end
function updateUnitsLeft(value)
  data[7].label = value[1]
  self.editButton(data[7])
end
function updateUnitsToPlace(value)
  data[12].label = value[1]
  self.editButton(data[12])
end
function updateUnitsLeftBehind(value)
  data[1].label = value[1]
  self.editButton(data[1])
end
function updateInfo(value)
  data[15].label = value[1]
  data[15].color = pColors[value[2]]
  data[15].font_color = tColors[value[2]]
  self.editButton(data[15])
end
function updateCardsButtons(value)
  local enabled = #value
  showCardZone({false})
  local disabled = 3 - enabled
  for i=1, enabled do
    local str = string.gsub(value[i], "%s+", "\n")
    data[15+i].label = str
    data[15+i].scale = {1,0.5,2}
    self.editButton(data[15+i])
  end
  for i=1,disabled do
    data[15+i+enabled].label = ""
    data[15+i+enabled].scale = {0,0,0}
    self.editButton(data[15+i+enabled])
  end
end
function showCardZone(value)
  if value[1] == true then
    data[22].scale = {1,0.5,2}
  else
    data[22].scale = {0,0,0}
  end
  self.editButton(data[22])
  
end
function doNothing(value)
end