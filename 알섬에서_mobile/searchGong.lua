-----------------------------------------------------------------------------------------
--
-- searchGong.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

function scene:create( event )
	local sceneGroup = self.view
	
	--배경
	local background = display.newRect( display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight )
	background:setFillColor( 0 )
	--진짜 배경
	local bg = display.newImage("content/image/Gong/room.png")
	bg.x, bg.y = display.contentCenterX, display.contentCenterY
	local frame = display.newImage("content/image/Gong/room_frame.png")
	frame.x, frame.y = display.contentCenterX, display.contentCenterY
	--문
	local door = display.newImage("content/image/Gong/door.png")
	door.x, door.y = display.contentWidth*0.09, display.contentHeight*0.57
	--책상
	local desk = display.newImage("content/image/Gong/room_desk.png")
	desk.x, desk.y = display.contentWidth*0.523, display.contentHeight*0.655
	--책장
	local bookshelf = display.newImage("content/image/Gong/room_bookshelf.png")
	bookshelf.x, bookshelf.y = display.contentWidth*0.83, display.contentHeight*0.515
	--가구3
	--가구4
	--가구5
	--텍스트상자
	local textBox = display.newImage("content/image/narration/textbox.png")
	textBox.x, textBox.y = display.contentWidth/2,display.contentHeight*0.82
	textBox.alpha = 0
	
	--이름
	local textParams = { text = "송은주", 
						x =  textBox.x*0.34, 
						y = textBox.y*0.85,
						font = "content/font/NanumBarunGothic.ttf", 
						fontSize = 27, 
						align = "center" }
	local speaker = display.newText(textParams)
	speaker:setFillColor(1)
	speaker.alpha = 0
	--대사
	local newTextParams = { text = "여기에는 아무것도 없는 것 같아.", 
						x = textBox.x,
						y = textBox.y*1.03,
						width =  display.contentWidth*0.75,
						height = 150,
						font = "content/font/NanumBarunGothic.ttf", fontSize = 35, 
						align = "left" }
	local script =  display.newText(newTextParams)
	script:setFillColor(0.61, 0.31, 0)
	script.alpha = 0

	--단서노트버튼
	local note = display.newImage("content/image/note/note_s.png")
	note.x = 100
	note.y = 100
	
	--단서 찾는 곳에서 방으로
	local gongHome = composer.getVariable("gongHome")
	local count = 0
	if composer.getVariable("clue8")==1 then
		composer.setVariable("found8",1);
	end
	if composer.getVariable("clue7")==1 and composer.getVariable("clue8")==1 then
		count = 2
	end
	--은주
	local eunjooSheet = graphics.newImageSheet("content/image/character/eunjoo_walkLR.png", { width = 720 / 4, height = 600/2, numFrames = 16})
	local sequenceData = {
		{
			name = "right",
			frames = {1,2,3,4,5,6,7,8},
			time = 500,
			loopCount = 0,
			loopDirection = "forward"
		},
		{
			name = "left",
			frames = {9,10,11,12,13,14,15,16},
			time = 500,
			loopCount = 0,
			loopDirection = "forward"
		}
	}
	local eunjoo = display.newSprite(eunjooSheet, sequenceData)
	local eunjoo2 = display.newImage("content/image/character/eunjoo.png")
	local eunjoo3 = display.newImage("content/image/character/eunjoo2.png")
	eunjoo.alpha = 0

	if(composer.getVariable("gongHome")==0) then
		eunjoo2.alpha = 1
		eunjoo3.alpha = 0
		script.alpha = 0
		textBox.alpha = 0
		speaker.alpha = 0
		composer.setVariable("didGong",1)
	elseif(composer.getVariable("gongDir")==-1)then
		eunjoo2.alpha = 0
		eunjoo3.alpha = 1
	else
		eunjoo2.alpha = 1
		eunjoo3.alpha = 0
	end

	if gongHome == 0 then
		eunjoo.x = display.contentWidth * 0.185
	elseif gongHome==1 then
		eunjoo.x = desk.x
	elseif gongHome==2 then
		eunjoo.x = bookshelf.x
	else
		eunjoo.x = composer.getVariable("gongHome");
	end
	eunjoo.y = display.contentHeight*0.64
	eunjoo2.x,eunjoo2.y = eunjoo.x, eunjoo.y
	eunjoo3.x,eunjoo3.y = eunjoo.x, eunjoo.y

	

	--이동 버튼
	--이동 버튼
	local leftB = display.newImage("content/image/button/leftB.png");
	leftB.x, leftB.y= display.contentWidth*0.7,display.contentHeight*0.9
	leftB.alpha = 0.7
	local rightB = display.newImage("content/image/button/rightB.png");
	rightB.x, rightB.y= display.contentWidth*0.8,display.contentHeight*0.9
	rightB.alpha = 0.7
	local enterB = display.newImage("content/image/button/enterB.png");
	enterB.x, enterB.y= display.contentWidth-display.contentHeight*0.1,display.contentHeight*0.9
	enterB.alpha = 0.7

	local goBack = display.newImage("content/image/narration/returnB.png")
	goBack.x, goBack.y = display.contentWidth * 0.85, display.contentHeight * 0.89
	goBack.alpha = 0
	
	local function moving(event)
		leftB.alpha = 0.7
		rightB.alpha = 0.7
		enterB.alpha = 0.7

	    if(event.phase=="began" or event.phase=="moved")then
			eunjoo.alpha = 1
			eunjoo2.alpha = 0
			eunjoo3.alpha = 0
			if(event.target == rightB)then
				rightB.alpha = 1
				composer.setVariable("gongDir", 1)
				eunjoo:setSequence("right")
				eunjoo:play()
				transition.moveBy( eunjoo, { x= display.contentWidth-eunjoo.x, time = (display.contentWidth - eunjoo.x)*2} )
			else
				leftB.alpha = 1
				eunjoo:setSequence("left")
				eunjoo:play()
				composer.setVariable("gongDir", -1)
				if (eunjoo.x >= 0) then
					transition.moveBy( eunjoo, { x= -eunjoo.x, time = eunjoo.x * 2} )
				end
		    end
	   else
		  transition.cancel(eunjoo)
		  eunjoo:pause()
		  eunjoo.alpha = 0
		  if(event.target == rightB)then
			 eunjoo2.x = eunjoo.x
			 eunjoo2.y = eunjoo.y
			 eunjoo2.alpha = 1
		  else
			 eunjoo3.x = eunjoo.x
			 eunjoo3.y = eunjoo.y
			 eunjoo3.alpha = 1
		  end
	   end
	end
	rightB:addEventListener("touch", moving)
	leftB:addEventListener("touch", moving)

	local function tapEnter(event)
		if(event.phase=="began")then
			enterB.alpha= 1
		else
			enterB.alpha =0.7
		end
		--상호작용
		if (eunjoo.x >= desk.x-144 and eunjoo.x <=desk.x+144) then
			composer.removeScene("searchGong")
			composer.gotoScene("gongDesk")
		elseif (eunjoo.x >= bookshelf.x-114 and eunjoo.x <=bookshelf.x+114) then
				composer.removeScene("searchGong")
				composer.gotoScene("gongBookshelf")
		elseif (eunjoo.x >= door.x-119 and eunjoo.x <=door.x+119) then
			--단서 찾았으면 나가고 아니면 못 나감
			if count==2 then
				print("나가기")
				composer.setVariable("goToMap4", 1)
				composer.setVariable("didGong",1)
				composer.removeScene("searchGong")
				composer.gotoScene("map4")
			else
				if(eunjoo.x ~= display.contentWidth * 0.185)then
					textBox.alpha = 1
					speaker.alpha = 1
					script.text = "아직 단서를 모두 찾지 않았어."
					script.alpha = 1
					goBack.alpha = 1
				end
			end
		else
			if(eunjoo.x < display.contentWidth * 0.18 or eunjoo.x >= display.contentWidth * 0.2)then
				textBox.alpha = 1
				speaker.alpha = 1
				script.alpha = 1
				goBack.alpha = 1
			end
			if (eunjoo.x >door.x+200 and eunjoo.x < desk.x-144) then
				script.text = "식물이 많네."
			elseif (eunjoo.x > desk.x) then
				script.text = "여기에는 아무것도 없는 것 같아."
			end
		end
		if(textBox.alpha == 1) then
			leftB.alpha = 0
			rightB.alpha = 0
			enterB.alpha = 0
		end
	end
	enterB:addEventListener("touch", tapEnter)

	local function closeTextbox(event)
		textBox.alpha = 0
		speaker.alpha = 0
		script.alpha = 0
		goBack.alpha = 0
		leftB.alpha = 0.7
		rightB.alpha = 0.7
		enterB.alpha = 0.7
	end
	goBack:addEventListener("tap", closeTextbox)
	
	--단서노트
	local function gotoNote(event)
		composer.setVariable("gongHome", eunjoo.x)
		composer.setVariable("scene",8);
		composer.removeScene("searchGong")
		composer.gotoScene("note")
	end
	note:addEventListener("tap",gotoNote)
	--레이어정리
	sceneGroup:insert(background)
	sceneGroup:insert(bg)
	sceneGroup:insert(door)
	sceneGroup:insert(desk)
	sceneGroup:insert(bookshelf)
	sceneGroup:insert(eunjoo)
	sceneGroup:insert(eunjoo2)
	sceneGroup:insert(eunjoo3)
	sceneGroup:insert(textBox)
	sceneGroup:insert(script)
	sceneGroup:insert(speaker)
	sceneGroup:insert(goBack)
	sceneGroup:insert(frame)
	sceneGroup:insert(note)
	sceneGroup:insert(leftB)
	sceneGroup:insert(rightB)
	sceneGroup:insert(enterB)
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
	end	
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then
		-- Called when the scene is now off screen
		composer.removeScene("searchGong")
	end
end

function scene:destroy( event )
	local sceneGroup = self.view
	
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene
