local love = require("love")
ASTEROID_SIZE = 100
show_debugging = false
destroy_ast = false 

function love.conf(app)
    app.window.width = 1280
    app.window.height = 780
    app.window.title ="Asteroids"
    app.identity = "MYGAME"
 
end