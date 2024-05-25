local love = require "love"

function Lazer(x, y, angle)
    local LAZER_SPEED = 500 -- lazer speed in pixel/second
    local EXPLODE_DUR = 0.2 
   
    return {
        x = x,
        y = y,
        x_vel = LAZER_SPEED * math.cos(angle) / love.timer.getFPS(),
        y_vel = -LAZER_SPEED * math.sin(angle) / love.timer.getFPS(),
        distance = 0, -- distance traveled
        exploading = 0,
        expload_time = 0, 

        draw = function (self, faded)
            local opacity = 1
            
            if faded then
                opacity = 0.2
            end
            if self.exploading <1 then
            love.graphics.setColor(1, 1, 1, opacity)
            -- set size of points in px (or dpi, idk)
            love.graphics.setPointSize(3)
            -- put point on screen
            love.graphics.points(self.x, self.y)
            else
                love.graphics.setColor(1, 104/255, 0, opacity)
                love.graphics.circle("fill", self.x, self.y, 7 * 1.5)

                love.graphics.setColor(1, 234/255, 0, opacity)
                love.graphics.circle("fill", self.x, self.y, 7 * 1)
            end
        end,

        move = function (self)
            self.x = self.x + self.x_vel
            self.y = self.y + self.y_vel

            if self.expload_time > 0 then
                self.exploading = 1
            end


            -- if the lazers go off screen, bring them back
            

            -- increase the distance traveled
            self.distance = self.distance + math.sqrt((self.x_vel ^ 2) + (self.y_vel ^ 2))
        end,

        expload = function (self)
            self.expload_time = math.ceil(EXPLODE_DUR * (love.timer.getFPS() / 100))

            if self.expload_time > EXPLODE_DUR then
                self.exploading = 2
            end
        end
    }
end

return Lazer