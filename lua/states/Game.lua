local love = require("love")
local Text = require("../components/Text")
local Asteroids = require "../objects/Asteroids"
local globals = require("globals")


function Game(save_data)
    return {
        level = 1,
        state = {
            menu = true,
            running =false,
            paused = false,
            ended =false
        },

        score = 0, -- set initial score on game start
        high_score = save_data.high_score, -- saved high score
        screen_text = {}, -- text to be displayed on screen
        game_over_showing = false, -- if game over is showing

       changeGameState =  function(self , state)
        self.state.menu = state== "menu"
        self.state.running = state == "running"
        self.state.paused = state =="paused"
        self.state.ended = state == "ended"
        self.game_over_showing = false
        
           
           
        
       if self.state.ended then
        -- once game has ended, do the game over screen
       self:gameOver()
       
    end
end,

-- we now have our game over
gameOver = function (self)
   
    self.screen_text = {Text(
        "GAME OVER",
        0,
        love.graphics.getHeight() * 0.4,
        "h1",
        true,
        true,
        love.graphics.getWidth(),
        "center"
    )}
    self.game_over_showing = true
end,
       draw = function(self ,faded)
        local opacity = 1
        if faded then 
            opacity = 0.5
        end
        for index, text in pairs(self.screen_text) do
            if self.game_over_showing then
                -- do this until return false
                self.game_over_showing = text:draw(self.screen_text, index)
                
                if not self.game_over_showing then
                    self:changeGameState("menu")
                end
            else
                --text:draw(self.screen_text, index)
            end
        end
        Text( -- show user score
                "SCORE: " .. self.score,
                -20,
                10,
                "h4",
                false,
                false,
                love.graphics.getWidth(),
                "right",
                faded and opacity or 0.6 -- if faded, use provided opacity, otherwise 0.6
            ):draw()

            Text( -- show user high score
                "HIGH SCORE: " .. self.high_score,
                0,
                10,
                "h5",
                false,
                false,
                love.graphics.getWidth(),
                "center",
                faded and opacity or 0.5
            ):draw()
        if faded then 
            Text(
                "PAUSED",
                0,
                love.graphics.getHeight()*0.4,
                "h1",
                false,
                false,
                love.graphics.getWidth(),
                "center",
                1
            ):draw()
        end
       end,
       startNewGame = function (self, player)
        self:changeGameState("running")
        asteroids = {}
        self.score = 0
        
        -- asteroid x and y
        ans = 1
        local as_x = math.floor(math.random(love.graphics.getWidth()))
        local as_y = math.floor(math.random(love.graphics.getHeight()))
         
        table.insert(asteroids, 1, Asteroids(as_x, as_y, 100, self.level, true))
    end 
    }
end

return Game