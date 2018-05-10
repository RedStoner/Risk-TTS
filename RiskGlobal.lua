function onLoad()
  loadedObjects = 0
  tColor = {1,1,1}
  map = getObjectFromGUID("be2f30")
end
function objectLoadFinished(id)
  loadedObjects = loadedObjects + 1
  printToAll("Object " .. id[1] .. " finished loading.",tColor)
  if loadedObjects == 5 then
    printToAll("All Objects Finished Loading",tColor)
    map.call('finishedLoading', {})
  end
end