local love = require("love")
local Player = require("objects/Player")
local Game = require("states/Game")
math.randomseed(os.time())
require "globals"
local Menu = require "states/Menu"
local backgroundMusic

function love.load()
    newBackgroundImage = love.graphics.newImage("data/images.png")
    love.graphics.setDefaultFilter("linear", "linear")
   love.mouse.setVisible(false)
local save_data
if  checkJSON("saves.json")  then 
   -- print("csdcsa")
   save_data = readJSON("saves.json")
else
    local mygamedata = {
        high_score = 0
       }
      updateJSON(mygamedata,"saves.json")
     save_data = readJSON("saves.json")
end

   mouse_x,mouse_y= 0,0

   player = Player(3)
   game = Game(save_data)
   menu = Menu(game, player) 
   --播放音乐
   backgroundMusic = love.audio.newSource('data/music.mp3', 'stream')
    
    backgroundMusic:setLooping(true)


    love.audio.play(backgroundMusic)
    --位置变化
    textX = 10  -- 左边距
    textY = love.graphics.getHeight()- 20  -- 底边距

end
function love.quit()
    local mygamedata = {
    high_score = game.high_score
    }
   updateJSON(mygamedata,"saves.json")
end
-- 窗体变化
function love.resize(w, h)
    textY = h -20  -- 更新Y坐标
end
function love.keypressed(key)
    if game.state.running then
        if key == "w" or key == "up" or key == "kp8" then
            player.thrusting = true
        end
        if key == "space" or key == "down" or key == "kp5" then
            player:shootLazer()
        end
        if key == "escape" then
            game:changeGameState("paused")
        end
     elseif game.state.paused then
        if key == "escape" then
            game:changeGameState("running")
        end
    elseif game.state.ended then 
        if key == "s" then 
         game:changeGameState("menu")
    end
 end
  if key == "m" then 
    if backgroundMusic:isPlaying() then 
        backgroundMusic:pause()
    else
        backgroundMusic:play()
    end
  end
end

function love.keyreleased(key)
    if key == "w" or key == "up" or key == "kp8" then
        player.thrusting = false
    end
end



function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        if game.state.running then
            player:shootLazer()
        else
            clickedMouse = true -- set if mouse is clicked
        end
    end
end


function love.update(dt)
    mouse_x,mouse_y = love.mouse.getPosition()
  if game.state.running then 
    player:movePlayer()
    for ast_index, asteroid in pairs(asteroids) do
    if not player.exploading then
        if calculateDistance(player.x, player.y, asteroid.x, asteroid.y) < player.radius + asteroid.radius then
            -- check if ship and asteroid colided
            player:expload()
            destroy_ast = true
        end
    else
        player.expload_time = player.expload_time - 1
        if player.expload_time == 0 then
            if player.lives - 1 <= 0 then
                game:changeGameState("ended")
                return
            end
            player = Player(player.lives - 1)
        end
    end
end
    for ast_index, asteroid in pairs(asteroids) do
        for _, lazer in pairs(player.lazers) do
            if calculateDistance(lazer.x, lazer.y, asteroid.x, asteroid.y) < asteroid.radius then
                lazer:expload() -- delete lazer
                asteroid:destroy(asteroids, ast_index, game)
            end
        end

        if destroy_ast then
            if player.lives - 1 <= 0 then -- check if the player lives are less or = to 0
                --if player.expload_time == 0 then -- if expload time is up
                    -- wait for player to finish exploading before destroying any asteroids
                    destroy_ast = false
                    asteroid:destroy(asteroids, ast_index, game) -- delete asteroid and split into more asteroids
                    
               -- end
            else
                destroy_ast = false
                asteroid:destroy(asteroids, ast_index, game)
            end
        end

        asteroid:move(dt)
    end
elseif game.state.menu then -- check if in menu state
    menu:run(clickedMouse) -- run the menu
    clickedMouse = false -- set mouse cicked
    end
end

function love.draw()
    local windowWidth, windowHeight = love.graphics.getDimensions()
    local bgWidth, bgHeight = newBackgroundImage:getDimensions()
    local scaleX, scaleY = windowWidth / bgWidth, windowHeight / bgHeight
    love.graphics.draw(newBackgroundImage, 0, 0, 0, scaleX, scaleY)
    if game.state.running or game.state.paused then
        player:drawLives(game.state.paused) 
    player:draw(game.state.paused)
    for _, asteroid in pairs(asteroids) do
        asteroid:draw(game.state.paused)
    end
    game:draw(game.state.paused)
elseif game.state.menu then -- draw menu if in menu state
    menu:draw()
elseif game.state.ended then
    game:draw()
    end
    love.graphics.setColor(1,1,1,1)

    if not game.state.running then -- draw cursor if not in running state
        love.graphics.circle("fill", mouse_x, mouse_y, 10)
    end

    love.graphics.print(love.timer.getFPS(),10,10)

    local gameVersion = "1.1.2"
    local author = "zhuqingsen"
    
    -- 设置文本颜色为白色
    love.graphics.setColor(1, 1, 1)
    
    -- 在屏幕上打印
    love.graphics.print("Version: " .. gameVersion, textX, textY-20)
    love.graphics.print("Author: " .. author, textX, textY)


end