local storyboard = require("storyboard")
local scene = storyboard.newScene()

function scene:createScene(event)
    storyboard.gotoScene("level1")
    
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

return scene
