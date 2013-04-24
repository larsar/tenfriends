local gravity = 2
local distanceToWall = 100


local storyboard = require("storyboard")
local scene = storyboard.newScene()
local physics = require "physics"
local physicsData = (require "shapedefs").physicsData(1.0)

local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5
local balls = {}
local ballIndex = 1

local activeBall
local score = 0
local scoreText
local equationText

function scene:createScene(event)
    setupPhysics()
    setupBackground()
    setupWalls()
    setupScorePanel()
    setupEquationPanel()
end

function setupPhysics()
    physics.start()
    physics.setGravity(0,gravity)
    physics.setDrawMode("normal")
end

function setupBackground()
    local background = display.newImage("glassbg.png", true)       
end

function setupWalls()
    staticMaterial = {density=2, friction=.3, bounce=.4}  

    local floor = display.newRect(0, screenH, screenW, screenH)  
    local lWall = display.newRect(0, 0, 0,  screenH)
    local rWall = display.newRect(screenW, 0, screenW, screenH)
    physics.addBody(floor, "static", staticMaterial)  
    physics.addBody(lWall, "static", staticMaterial)  
    physics.addBody(rWall, "static", staticMaterial)  
end

function setupScorePanel()
    scoreText = display.newText(score, 0, 0, native.systemFont, 12*2)
    scoreText:setReferencePoint(display.TopRightReferencePoint)
    scoreText.x = screenW - 5
end

function setupEquationPanel()
    equationText = display.newText("X + Y = 10", 0, 0, native.systemFont, 12*2)
    equationText:setReferencePoint(display.TopRightReferencePoint)
    equationText.x = screenW - 5
    equationText.y = 30
end

function addToScore(value)
    score = score + value
    scoreText.text = score
end

local ballPressed = function( event )
    local t = event.target
    local phase = event.phase
    
    if "began" == phase then
        local myIndex = t.myIndex
        local ball = balls[myIndex]
        if activeBall == nil then
            selectX(ball)
        elseif ball ~= activeBall then
            selectY(ball)
        end
        -- print( "removing ball #" .. myIndex )
        -- balls[myIndex]:removeSelf() -- destroy joint
    end
    
    -- Stop further propagation of touch event
    return true
end



function selectX(ball)
    activeBall = ball
    equationText.text = ball.value .. " + Y = 10"
end

function selectY(ball)
    if activeBall.value + ball.value == 10 then
        addToScore(1)
        activeBall:removeSelf()
        ball:removeSelf()
        equationText.text = activeBall.value .. " + " .. ball.value .. " = 10"
    else
        equationText.text = activeBall.value .. " + " .. ball.value .. " != 10"
    end
    activeBall = nil
end

function onCollision( event )
    if ( event.phase == "began" ) then

        print( "began: " .. event.selfElement.myName .. " & " .. event.otherElement.myName )
        
    elseif ( event.phase == "ended" ) then
        
        print( "ended: " .. event.selfElement.myName .. " & " .. event.otherElement.myName )
    end
end

-- create a random new object
function dropBall()
    num = math.random(1,9)
    obj = display.newImage(num..".png");
    physics.addBody( obj, physicsData:get("orange"))
    obj.isFixedRotation = true

    -- random start location
    obj.x = distanceToWall + math.random( screenW-distanceToWall )
    obj.y = -distanceToWall
    
    -- add collision handler
    -- obj.collision = onLocalCollision
    obj.myName = "Foobar"
    obj.value = num
    obj:addEventListener( "touch", ballPressed )
    --  obj:addEventListener( "collision", onCollision)
    balls[ballIndex] = obj
    obj.myIndex = ballIndex
    ballIndex = ballIndex + 1
end

function addEventListeners()
    scene:addEventListener( "createScene", scene )
end

function dropBalls()
    local dropCrates = timer.performWithDelay( 2000, dropBall, 30 )
end


-- Main script
dropBalls()
addEventListeners()
return scene
