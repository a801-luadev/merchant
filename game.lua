tfm.exec.disableAutoNewGame(true)
tfm.exec.disableAutoShaman(true)
tfm.exec.disableAutoTimeLeft(true)

--game variables


local CONSTANTS = {
    HEALTH_BAR_WIDTH = 300, HEALTH_BAR_X = 150, STAT_BAR_Y = 30}

local players = {}
local healthPacks = {}


--creating the class Player

local Player = {}
Player.__index = Player
Player.__tostring = function(self)
    return "[name=" .. self.name .. ",money=" .. self.money .. ", health=" .. self.health .. "]"
end

setmetatable(Player, {
    __call = function (cls, name)
        return cls.new(name)
    end,
})

function Player.new(name)
    local self = setmetatable({}, Player)
    self.name = name
    self.money = 0
    self.health = 1.0
    self.healthBarId = 1000 + #players
    self.healthRate = 0.002
    ui.addTextArea(self.healthBarId, "", name, CONSTANTS.HEALTH_BAR_X, 30, CONSTANTS.HEALTH_BAR_WIDTH, 30, 0xff0000, 0xee0000, 1, true)
    return self
end

function Player:getName() return self.name end
function Player:getMoney() return self.money end
function Player:getHealth() return self.health end
function Player:getHealthBarId() return self.healthBarId end
function Player:getHealthRate() return self.healthRate end

function Player:work()
    if self.health > 0 then
        self.setHealth(self, -0.05, true)
        self:setMoney(10, true)
    end
end

function Player:setHealth(val, add)
    if add then
        self.health = self.health + val
    else
        self.health = val
    end
    self.health = self.health > 1  and 1 or self.health < 0 and 0 or self.health
    ui.addTextArea(self.healthBarId, "", name, CONSTANTS.HEALTH_BAR_X, 30, CONSTANTS.HEALTH_BAR_WIDTH * self.health, 30, 0xff0000, 0xee0000, 1, true)
    ui.addTextArea(2, "<p align='center'>" .. math.ceil(self.health * 100) .. "%</p>", self.name, CONSTANTS.HEALTH_BAR_X, CONSTANTS.STAT_BAR_Y, CONSTANTS.HEALTH_BAR_WIDTH, 40, nil, nil, 0.5, true)
end

function Player:setMoney(val, add)
    if add then
        self.money = self.money + val
    else
        self.money = val
    end
    self.money = self.money < 0 and 0 or self.money
    ui.updateTextArea(1, "Money : $" .. self.money, self.name)
end

function Player:useMed(med)
    if not (self.health >= 1) then
        self:setHealth(med:getRegain(), med:isAdding())
        print(tostring(med:isAdding()) .. " " .. med:getRegain())
    end

end


--class creation(Player) ends

--creating class HealthPacks

local HealthPacks = {}
HealthPacks.__index = HealthPacks
HealthPacks.__tostring = function(self)
    return "[name=" .. self.name .. ", price=" .. self.price .. ", regain=" .. self.regainVal .. ", add=" .. tostring(self.add) .. "]"
end
HealthPacks.__type = "HealthPacks"

setmetatable(HealthPacks, {
    __call = function (cls, name, price, regain, add, uid, desc)
        return cls.new(name, price, regain, add, uid, desc)
    end,
})

function HealthPacks.new(name, price, regainVal, add, uid, desc)
    local self = setmetatable({}, HealthPacks)
    self.name = name
    self.price = price
    self.regainVal = regainVal
    self.add = add
    self.uid = uid
    self.description =  desc
    return self
end


function HealthPacks:getName() return self.name end
function HealthPacks:getPrice() return self.price end
function HealthPacks:getRegain() return self.regainVal end
function HealthPacks:isAdding() return self.add end
function HealthPacks:getDescription() return self.description end
function HealthPacks:getUID() return self.uid end

--event handling

function eventNewPlayer(name)
    players[name] = Player(name)
end

function eventPlayerLeft(name)
    for n, player in ipairs(players) do
        if player:getName() == name then
            table.remove(players, n)
        end
    end
end

--function for the money clicker c:
function eventTextAreaCallback(id, name, evt)

    if evt == "work" then
        players[name]:work()
    elseif evt == "shop" then
        ui.addTextArea(100, "The Shop <br><br>" .. medicTxt, name, 200, 90, 400, 200, nil, nil, 1, true)
        for id, pack in ipairs(healthPacks) do print(tostring(pack)) end
    elseif string.sub(evt, 1, 6) == "health"and players[name]:getMoney() - healthPacks[string.sub(evt, 8)]:getPrice() >= 0 then
        local pack = healthPacks[string.sub(evt, 8)]
        players[name]:useMed(pack)
        players[name]:setMoney(-pack:getPrice(), true)
    end
end

function eventLoop(t,r)

    for name, player in pairs(players) do
        player:setHealth(player:getHealthRate(), true)
    end
end


--event handling ends

--game logic

healthPacks['cheese'] = HealthPacks("Cheese", 5, 0.01, true, "health:cheese", "Just a cheese! to refresh yourself")
healthPacks['pizza'] =  HealthPacks("Cheese Pizza", 30, 0.05, true, "health:pizza", "dsjfsdlkgjsdk")


print("type" .. type(HealthPacks("", 32, 5)))

for name, player in pairs(tfm.get.room.playerList) do
    players[name] = Player(name)
end

print('now printing myself')
for name, player in pairs(players) do
    print(name .. ':' .. tostring(player))
end

--textAreas
--work button
ui.addTextArea(0, "<a href='event:work'>Work!", nil, 7, 375, 36, 20, 0x324650, 0x000000, 1, true)
--stats
ui.addTextArea(1, "Money : $0", name, 6, CONSTANTS.STAT_BAR_Y, CONSTANTS.HEALTH_BAR_X - 15, 40, 0x324650, 0x000000, 1, true)
--health bar area
ui.addTextArea(2, "<p align='center'>100%</p>", nil, CONSTANTS.HEALTH_BAR_X, CONSTANTS.STAT_BAR_Y, CONSTANTS.HEALTH_BAR_WIDTH, 40, nil, nil, 0.5, true)
--shop buttons
medicTxt = ""
for id, medic in pairs(healthPacks) do
    --TODO: SET MEDICAL TEXT TO BE DISPLAYED IN THE SHOP
    medicTxt = medicTxt .. medic:getName() .. "     Power: " .. medic:getRegain()  .. " Price:" .. medic:getPrice() .. "<a href='event:" .. medic:getUID() .."'> Buy</a><br>"
end
print(medicTxt)
ui.addTextArea(40, "<a href='event:shop'>Shop</a>", nil, 740, 375, 36, 20, nil, nil, 1, true)


