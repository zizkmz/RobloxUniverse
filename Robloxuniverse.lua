local fetcher = {}

function fetcher.get(Url)
    local success, response = pcall(function()
        return game:HttpGet(Url)
    end)
    
    if success then
        return response
    else
        warn(`[ERROR] Failed to get: {Url}\n{response}`)
        return nil
    end
end

function fetcher.load(Url, concat)
    local raw = fetcher.get(Url)
    if not raw then return end
    
    if concat then
        raw = raw .. concat
    end
    
    local success, runFunction = pcall(loadstring, raw)
    
    if success and type(runFunction) == "function" then
        return runFunction
    else
        warn(`[SYNTAX ERROR] {Url}\n{runFunction}`)
        return nil
    end
end

-- مثال استفاده (برای Blox Fruits)
local Repository = "https://raw.githubusercontent.com/tlredz/Scripts/main/"   -- یا repo خودت

local Scripts = {
    {UrlPath = "main.luau"},   -- فایل اصلی
    -- می‌تونی چندتا بذاری
}

local function IsPlace(Script)
    if Script.PlacesIds and table.find(Script.PlacesIds, game.PlaceId) then
        return true
    elseif Script.GameId and Script.GameId == game.GameId then
        return true
    end
    return false
end

for _, Script in ipairs(Scripts) do
    if IsPlace(Script) then
        local func = fetcher.load(Repository .. Script.UrlPath)
        if func then
            func()   -- یا func(fetcher, ...)
        end
        break
    end
end
