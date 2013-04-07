local storyboard = require("storyboard")
local scene = storyboard.newScene()
local physics = require "physics"
physics.start()
--physics.pause()

local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5

    
function scene:createScene(event)
    print(screenW)
    print(screenH)
    
    local background = display.newImage("glassbg.png", true)    
    
    local floor = display.newRect(0, screenH, 10, 10)  
--local lWall = display.newRect(0, 480, 320, 1)  
--local rWall = display.newRect(0, -1, 320, 1)  
staticMaterial = {density=2, friction=.3, bounce=.4}  
--physics.addBody(floor, "static", staticMaterial)  
--physics.addBody(lWall, "static", staticMaterial)  
--physics.addBody(rWall, "static", staticMaterial)  

end

function scene:enterScene( event )
	local group = self.view
end

function scene:exitScene( event )
	local group = self.view	
end

function scene:destroyScene( event )
	local group = self.view
end

function addEventListeners()
    scene:addEventListener( "createScene", scene )
    scene:addEventListener( "enterScene", scene )
    scene:addEventListener( "exitScene", scene )
    scene:addEventListener( "destroyScene", scene )
end

addEventListeners()

-- create a random new object
function newItem()	
    
	-- set the graphics 
	obj = display.newImage("rock.png");

	-- set the shape
	physics.addBody( obj, { density=1.0, friction=0.3, bounce=0.3 })	
	
	-- random start location
	obj.x = 60 + math.random( 160 )
	obj.y = -100
	
	-- add collision handler
   -- obj.collision = onLocalCollision
   -- obj:addEventListener( "collision", obj )
end

local dropCrates = timer.performWithDelay( 500, newItem, 100 )

return scene
