local storyboard = require("storyboard")
local scene = storyboard.newScene()
local physics = require "physics"
local physicsData = (require "shapedefs").physicsData(1.0)

physics.setGravity(20,0)
physics.start()
--physics.pause()

local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5
local balls = {}
local ballIndex = 1


function scene:createScene(event)
    print(screenW)
    print(screenH)
    
    local background = display.newImage("glassbg.png", true)    
    
    local floor = display.newRect(0, screenH, screenW, screenH)  
    local lWall = display.newRect(0, 0, 0,  screenH)
    local rWall = display.newRect(screenW, 0, screenW, screenH)  
    staticMaterial = {density=2, friction=.3, bounce=.4}  
    physics.addBody(floor, "static", staticMaterial)  
    physics.addBody(lWall, "static", staticMaterial)  
    physics.addBody(rWall, "static", staticMaterial)  
    
end

local removeObj = function( event )
    local t = event.target
    local phase = event.phase
    
    print(phase)
    
    if "began" == phase then
        local myIndex = t.myIndex
        print( "removing ball #" .. myIndex )
        balls[myIndex]:removeSelf() -- destroy joint
    end
    
    -- Stop further propagation of touch event
    return true
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
    obj = display.newImage("orange.png");
    
    -- set the shape
    physics.addBody( obj, physicsData:get("orange"))	
    
    -- random start location
    obj.x = 60 + math.random( 160 )
    obj.y = -100
    
    -- add collision handler
    -- obj.collision = onLocalCollision
    obj:addEventListener( "touch", removeObj )
    balls[ballIndex] = obj
    obj.myIndex = ballIndex
    ballIndex = ballIndex + 1
end

local dropCrates = timer.performWithDelay( 500, newItem, 100 )

return scene
