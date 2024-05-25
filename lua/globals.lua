
local lunajson = require ("lunajson")
local love = require("love")

ASTEROID_SIZE = 100 -- here since we will use it in multiple files, but can also be an asteroid attribute
show_debugging = false
destroy_ast = false

function calculateDistance(x1, y1, x2, y2)
    return math.sqrt(((x2 - x1) ^ 2) + ((y2 - y1) ^ 2))
end

function readJSON(filename) 
    local path = love.filesystem.getSaveDirectory() .. "/" .. filename
   -- print("读取路径是" .. path)
    local file,size = love.filesystem.read(filename)
    if file then 
        local data, pos, err = lunajson.decode(file, 1, nil)
        if err then
            return {},err
        end
        return data
    else
        return {}
    end
end

function updateJSON(dat,filename)
    local path = love.filesystem.getSaveDirectory() .. "/" .. filename
   -- print("保存路径是：" .. path)
    local contents = lunajson.encode(dat)
    if not contents then
        print("错误无法编码数据为JSON。")
        return false
    end
    local success,mess = love.filesystem.write(filename,contents)
    if not success then
        print("写入文件失败：", mess)
        return false
    end
    return true
end

function checkJSON(filename)
    local path = love.filesystem.getSaveDirectory() .. "/" .. filename
   -- print("保存路径是：" .. path)
    local info = love.filesystem.getInfo(filename)
   
    if info ~=nil then 
      --  print("666",info)
        return true 
        
    else
    return info ~=nil
    end
end