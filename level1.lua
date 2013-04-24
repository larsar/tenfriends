local storyboard = require("storyboard")
local scene = storyboard.newScene()
local physics = require "physics"
local physicsData = (require "shapedefs").physicsData(1.0)

physics.start()
physics.setGravity(0,2)

--physics.pause()

local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5
local balls = {}
local ballIndex = 1

local activeBall1 = nil

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

local activate = function( event )
    local t = event.target
    local phase = event.phase
    

    
    if "began" == phase then
        local myIndex = t.myIndex
        local ball = balls[myIndex]
        if activeBall1 == nil then
            activeBall1 = balls[myIndex]
        elseif ball ~= activeBall1 then
            
            if activeBall1.value + ball.value == 10 then
                print("Yey")
                activeBall1:removeSelf()
                ball:removeSelf()
            end
            activeBall1 = nil
        end
       -- print( "removing ball #" .. myIndex )
       -- balls[myIndex]:removeSelf() -- destroy joint
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

function onCollision( event )
    if ( event.phase == "began" ) then

        print( "began: " .. event.selfElement.myName .. " & " .. event.otherElement.myName )

    elseif ( event.phase == "ended" ) then

        print( "ended: " .. event.selfElement.myName .. " & " .. event.otherElement.myName )
    end
end

-- create a random new object
function newItem()	
    num = math.random(0,9)
    obj = display.newImage(num..".png");
    physics.addBody( obj, physicsData:get("orange"))	
    
    -- random start location
    obj.x = 60 + math.random( screenW-60 )
    obj.y = -60
    
    -- add collision handler
   -- obj.collision = onLocalCollision
    obj.myName = "Foobar"
    obj.value = num
    obj:addEventListener( "touch", activate )
  --  obj:addEventListener( "collision", onCollision)
    balls[ballIndex] = obj
    obj.myIndex = ballIndex
    ballIndex = ballIndex + 1
end

local dropCrates = timer.performWithDelay( 2000, newItem, 30 )

return scene
