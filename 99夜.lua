local TypeList = {
    y = 0,
    x = 0
}
local hungerThreshold = 75
local Chinese = {
    ['Coal'] = '煤炭',['Log'] = '木头',['Fuel Canister'] = '燃料罐',['Oil Barrel'] = '燃料桶',
    ['Chair'] = '椅子',['Sapling'] = '树苗',['Broken Microwave'] = '破旧微波炉',['Broken Fan'] = '旧风扇',
    ['Old Radio'] = '旧音响',['Bolt'] = '铁钉',['Sheet Metal'] = '废铁',['Tyre'] = '轮胎',['Washing Machine'] = '洗衣机',
    ['Metal Chair'] = '铁椅子',['UFO Junk'] = '外星残骸',['UFO Scrap'] = '外星残骸1',
    ['Old Car Engine'] = '引擎',['Carrot'] = '胡萝卜',['Cake'] = '蛋糕',['Berry'] = '浆果',
    ['Morsel'] = '生肉腿',['Steak'] = '生肉排',['Cooked Morsel'] = '熟肉腿',['Cooked Steak'] = '熟肉排',
    ['Rifle'] = '步枪',['Revolver'] = '手枪',['Rifle Ammo'] = '步枪子弹',['Revolver Ammo'] = '手枪子弹',
    ['Bandage'] = '绷带',['MedKit'] = '医疗包',['Old Flashlight'] = '旧手电',['Strong Flashlight'] = '强手电',
    ['Old Axe'] = '老斧头',['Good Axe'] = '好斧头',['Strong Axe'] = '强斧头',['Old Sack'] = '旧袋子',
    ['Good Sack'] = '好袋子',['Giant Sack'] = '巨大袋子',['Spear'] = '矛',
    ['Laser Fence Blueprint'] = '防御蓝图',['Leather Body'] = '皮革甲',['Iron Body'] = '铁甲',
    ['Bunny'] = '兔子',['Wolf'] = '狼',['Alpha Wolf'] = '阿尔法狼',['Bear'] = '熊'
}

local ItemList = {
    Item1 = "",
    Item2 = "",
    Item3 = "",
    Item4 = "",
    ItemTpPosition = "玩家",
    Pn = lp.Name
}

local tools = {
    KillTool = "Old Axe",
    CutTool = "Old Axe"
}
 
local St = {
    Kill = 50,
    Cut = 50
}

local dyzh = {
    ItemESPColor = Color3.fromRGB(0, 128, 255),
    CharacterESPColor = Color3.fromRGB(255, 0, 0),
    nt = 0.5,
    wt = 0
}

local espCache = {
    Items = {},
    Characters = {}
}

local function GetItem(Name, Type)
    local ItemState = false
    if Name == "" then
        WindUI:Notify({
            Title = "带来物品",
            Content = "请你选择物品",
            Icon = "notepad-text",
            IconThemed = true,
            Duration = 5  
        })
        return            
    end
    
    for _, Item in pairs(game.Workspace.Items:GetChildren()) do
        if Item.Name == Name then
            ItemState = true
            if Type == "玩家" then
                game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("RequestStartDraggingItem"):FireServer(Item)
                Item:PivotTo(hrp.CFrame * CFrame.new(TypeList.x, TypeList.y, 0))
            task.wait(0.1)
                game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents").StopDraggingItem:FireServer(Item)           
            elseif Type == "篝火" then
                game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("RequestStartDraggingItem"):FireServer(Item)
                Item:PivotTo(workspace.Map.Campground.MainFire.Center.CFrame * CFrame.new(TypeList.x, 20 + TypeList.y, 0))
            task.wait(0.1)
                game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents").StopDraggingItem:FireServer(Item)                
            elseif Type == "工作台" then
                game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("RequestStartDraggingItem"):FireServer(Item)
                Item:PivotTo(workspace.Map.Campground.Scrapper.Main.CFrame * CFrame.new(TypeList.x, 20 + TypeList.y, 0))
            task.wait(0.1)
                game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents").StopDraggingItem:FireServer(Item)                           
            elseif Type == "自定义位置" then
                if workspace:FindFirstChild("waypoint") then
                    game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("RequestStartDraggingItem"):FireServer(Item)
                    Item:PivotTo(workspace.waypoint.CFrame * CFrame.new(TypeList.x, 20 + TypeList.y, 0))
                    task.wait(0.1)
                    game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents").StopDraggingItem:FireServer(Item)                               
                else
                    WindUI:Notify({
                        Title = "带来物品",
                        Content = "未找到位置方块",
                        Icon = "notepad-text",
                        IconThemed = true,
                        Duration = 5  
                    })
                    return
                end                            
            elseif Type == "指定玩家" then
                local targetPlayer = game.Players:FindFirstChild(ItemList.Pn)
                if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local PlCFrame = targetPlayer.Character.HumanoidRootPart.CFrame
                    game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("RequestStartDraggingItem"):FireServer(Item)
                    Item:PivotTo(PlCFrame * CFrame.new(TypeList.x, TypeList.y, 0))
                    task.wait(0.1)
                    game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents").StopDraggingItem:FireServer(Item)                               
                else
                    WindUI:Notify({
                        Title = "带来物品",
                        Content = "未找到指定玩家或玩家无角色",
                        Icon = "notepad-text",
                        IconThemed = true,
                        Duration = 5  
                    })
                    return
                end            
            end
        end
    end
    
    if not ItemState then
        WindUI:Notify({
            Title = "带来物品",
            Content = "未找到物品: " .. Name,
            Icon = "notepad-text",
            IconThemed = true,
            Duration = 5  
        })           
    end
end

local function killCharacter(st)
    local axe = inventory:FindFirstChild("Strong Axe") or inventory:FindFirstChild("Spear") or inventory:FindFirstChild("Old Axe") or inventory:FindFirstChild("Good Axe") or inventory:FindFirstChild("Strong Axe") or inventory:FindFirstChild("Chainsaw")
    if not axe then return end
    for _, Child in pairs(workspace.Characters:GetChildren()) do
        local root = Child.PrimaryPart
        if root and hrp and (hrp.Position - root.Position).Magnitude < st then
            pcall(function()
                DamageRemote:InvokeServer(Child, axe, true, hrp.CFrame)
            end)
        end
    end
end

local function CreateEsp(object, config)
    if not object or not object.Parent then return end
    local eh = object:FindFirstChild('Esp')
    local eb = object:FindFirstChild('b')
    if eh then eh:Destroy() end
    if eb then eb:Destroy() end
    local h = Instance.new('Highlight')
    h.Parent = object
    h.FillColor = config.fillColor
    h.Name = 'Esp'
    h.FillTransparency = config.fillTransparency
    h.OutlineColor = Color3.new(1, 1, 1)
    h.OutlineTransparency = config.outlineTransparency
    local b = Instance.new('BillboardGui')
    b.Parent = object
    b.Size = UDim2.new(0, 100, 0, 20)
    b.Name = 'b'
    b.AlwaysOnTop = true
    local t = Instance.new('TextLabel')
    t.Parent = b
    t.Size = UDim2.new(1, 0, 1, 0)
    t.TextSize = 14
    t.Name = 'Label'
    t.TextStrokeColor3 = Color3.new(0, 0, 0)
    t.TextStrokeTransparency = 0
    t.BackgroundTransparency = 1
    t.Font = Enum.Font.SourceSansBold
    t.TextColor3 = config.textColor
    return h, b, t
end

local function GetDisplayName(n)
    return Chinese[n] or n
end

local function CalcDist(o)
    local p = o.PrimaryPart or o:FindFirstChildWhichIsA('BasePart')
    if not p or not hrp then return 0 end
    return (hrp.Position - p.Position).Magnitude
end

local function ModelHeight(m)
    local min, max = math.huge, -math.huge
    for _, v in ipairs(m:GetDescendants()) do
        if v:IsA("BasePart") then
            local y = v.CFrame.Y
            local s = v.Size.Y / 2
            min = math.min(min, y - s)
            max = math.max(max, y + s)
        end
    end
    return max > min and max - min or 5
end

local function EspItem(name)
    for _, v in ipairs(workspace.Items:GetChildren()) do
        if v.Name == name then
            local old = espCache.Items[v]
            if old then
                if old.conn then old.conn:Disconnect() end
                espCache.Items[v] = nil
            end
            local cfg = {fillColor = Color3.fromRGB(0, 128, 255), textColor = Color3.fromRGB(0, 128, 255), fillTransparency = dyzh.nt, outlineTransparency = dyzh.wt}
            local h, b, l = CreateEsp(v, cfg)
            b.StudsOffset = Vector3.new(0, ModelHeight(v) + 1.5, 0)
            l.Text = GetDisplayName(name) .. "[" .. math.floor(CalcDist(v) + 0.5) .. "米]"
            espCache.Items[v] = {highlight = h, billboard = b, textLabel = l, conn = nil}
        end
    end
end

local function EspCharacter(name)
    for _, v in ipairs(workspace.Characters:GetChildren()) do
        if v.Name == name then
            local old = espCache.Characters[v]
            if old then
                if old.conn then old.conn:Disconnect() end
                espCache.Characters[v] = nil
            end
            local cfg = {fillColor = Color3.fromRGB(0, 255, 0), textColor = Color3.fromRGB(0, 255, 0), fillTransparency = dyzh.nt, outlineTransparency = dyzh.wt}
            local h, b, l = CreateEsp(v, cfg)
            b.StudsOffset = Vector3.new(0, ModelHeight(v) + 1.5, 0)
            l.Text = GetDisplayName(name) .. "[" .. math.floor(CalcDist(v) + 0.5) .. "米]"
            espCache.Characters[v] = {highlight = h, billboard = b, textLabel = l, conn = nil}
        end
    end
end

local function RemoveEspItem(name)
    for _, v in ipairs(workspace.Items:GetChildren()) do
        if v.Name == name and espCache.Items[v] then
            local e = espCache.Items[v]
            if e.conn then e.conn:Disconnect() end
            if e.highlight then e.highlight:Destroy() end
            if e.billboard then e.billboard:Destroy() end
            espCache.Items[v] = nil
        end
    end
end

local function RemoveEspCharacter(name)
    for _, v in ipairs(workspace.Characters:GetChildren()) do
        if v.Name == name and espCache.Characters[v] then
            local e = espCache.Characters[v]
            if e.conn then e.conn:Disconnect() end
            if e.highlight then e.highlight:Destroy() end
            if e.billboard then e.billboard:Destroy() end
            espCache.Characters[v] = nil
        end
    end
end

local function ClearAllEsp()
    for _, e in pairs(espCache.Items) do
        if e.conn then e.conn:Disconnect() end
        if e.highlight then e.highlight:Destroy() end
        if e.billboard then e.billboard:Destroy() end
    end
    for _, e in pairs(espCache.Characters) do
        if e.conn then e.conn:Disconnect() end
        if e.highlight then e.highlight:Destroy() end
        if e.billboard then e.billboard:Destroy() end
    end
    espCache.Items = {}
    espCache.Characters = {}
end

local function OpenChestTme(Time)
    for _, Chest in pairs(workspace.Items:GetChildren()) do
        if Chest.Name:find("Chest") and Chest:FindFirstChild("Main") then
            local Main = Chest.Main
            if Main:FindFirstChild("ProximityAttachment") then
                local Attachment = Main.ProximityAttachment
                if Attachment:FindFirstChild("ProximityInteraction") then
                    Attachment.ProximityInteraction.HoldDuration = Time
                end
            end
        end
    end
end

local function OpenChest()
    for _, Chest in pairs(workspace.Items:GetChildren()) do
        if Chest.Name:find("Chest") then
            local Main = Chest:FindFirstChild("Main")
            if Main then
                local Attachment = Main:FindFirstChild("ProximityAttachment")
                if Attachment then
                    local Interaction = Attachment:FindFirstChild("ProximityInteraction")
                    if Interaction then
                        fireproximityprompt(Interaction)
                    end
                end
            end
        end
    end
end

local function AutoFire(Name)
    for _, Item in pairs(workspace.Items:GetChildren()) do
        if Item.Name == Name then
            game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("RequestStartDraggingItem"):FireServer(Item)
            Item:PivotTo(workspace.Map.Campground.MainFire.Center.CFrame * CFrame.new(0, 20, 0))
        end
    end
end

local function AutoScrapper(Name)
    for _, Item in pairs(workspace.Items:GetChildren()) do
        if Item.Name == Name then
            game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("RequestStartDraggingItem"):FireServer(Item)
            Item:PivotTo(workspace.Map.Campground.Scrapper.Main.CFrame * CFrame.new(0, 20, 0))
        end
    end
end

local function AutoCooking(ItemName)
    for _, Item in pairs(workspace.Items:GetChildren()) do
        if Item.Name == ItemName and Item.PrimaryPart then
            local success, errorMsg = pcall(function()
                local OldPos = Item.PrimaryPart.CFrame
                game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("RequestStartDraggingItem"):FireServer(Item)
                Item:PivotTo(workspace.Map.Campground.MainFire.Center.CFrame * CFrame.new(0, 4, 0))
                task.wait(0.1)
                
                game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents").StopDraggingItem:FireServer(Item)                   
                game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("RequestStartDraggingItem"):FireServer(Item)
                Item:PivotTo(OldPos)
                task.wait(0.1)
                game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents").StopDraggingItem:FireServer(Item)                           
            end)
        end
    end
end

function feed(nome)
    for _, item in ipairs(Workspace.Items:GetChildren()) do
        if item.Name == nome then
            rs.RemoteEvents.RequestConsumeItem:InvokeServer(item)
            break
        end
    end
end

function notifeed(nome)
    WindUI:Notify({
        Title = "自动食物停止",
        Content = "食物没了",
        Duration = 3
    })
end

function wiki(nome)
    local c = 0
    for _, i in ipairs(Workspace.Items:GetChildren()) do
        if i.Name == nome then
            c = c + 1
        end
    end
    return c
end

function ghn()
    return math.floor(lp.PlayerGui.Interface.StatBars.HungerBar.Bar.Size.X.Scale * 100)
end



local function getDeviceType()
    local UserInputService = game:GetService("UserInputService")
    if UserInputService.TouchEnabled then
        if UserInputService.KeyboardEnabled then
            return "平板"
        else
            return "手机"
        end
    else
        return "电脑"
    end
end

local deviceType = getDeviceType()
local uiSize, uiPosition

if deviceType == "手机" then
    uiSize = UDim2.fromOffset(500, 400)
elseif deviceType == "平板" then
    uiSize = UDim2.fromOffset(550, 450)
else
    uiSize = UDim2.fromOffset(600, 500)
end
uiPosition = UDim2.new(0.5, 0, 0.5, 0)

WindUI.TransparencyValue = 0.2
WindUI:SetTheme("Dark")

local playerName = lp.Name
local displayName = lp.DisplayName

WindUI:Notify({
    Title = "小作坊",
    Content = "小作坊--生存99天加载完成",
    Duration = 2
})

local Window = WindUI:CreateWindow({
    Title = "好用二改森林99天",
    Icon = "crown",
    Author = "二改作者：千",
    Folder = "OrangeCHub",
    Size = uiSize,
    Position = uiPosition,
    Theme = "Dark",
    Transparent = true,
    User = {
        Enabled = true,
        Anonymous = false,
        Username = playerName,
        DisplayName = displayName,
        UserId = game.Players.LocalPlayer.UserId,
        ThumbnailType = "AvatarBust",
        Callback = function()
            WindUI:Notify({
                Title = "用户信息",
                Content = "玩家:" .. game.Players.LocalPlayer.Name,
                Duration = 3
            })
        end
    },
    SideBarWidth = deviceType == "手机" and 150 or 180,
    ScrollBarEnabled = true
})

Window:CreateTopbarButton("theme-switcher", "moon", function()
    WindUI:SetTheme(WindUI:GetCurrentTheme() == "Dark" and "Light" or "Dark")
    WindUI:Notify({
        Title = "提示",
        Content = "当前主题: "..WindUI:GetCurrentTheme(),
        Duration = 2
    })
end, 990)

Window:EditOpenButton({
    Title = "打开小作坊-生存99天",
    Icon = "crown",
})

local Tabs = {
    Pl = Window:Section({ Title = "玩家", Opened = false, Icon = "user"}),
    TP = Window:Section({ Title = "传送物品", Opened = false, Icon = "package-open"}),
    Kill = Window:Section({ Title = "击杀光环", Opened = false, Icon = "pocket-knife"}),
    Cut = Window:Section({ Title = "树", Opened = false, Icon = "tree-pine"}),
    ESP = Window:Section({ Title = "透视", Opened = false, Icon = "eye"}),
    Chest = Window:Section({ Title = "宝箱", Opened = false, Icon = "box"}),
    Auto = Window:Section({ Title = "自动", Opened = false, Icon = "hand"}),
    Get = Window:Section({ Title = "传送", Opened = false, Icon = "arrow-big-up-dash"})
}

local TabHandles = {
    Announcement = Tabs.Pl:Tab({ Title = "公告", Icon = "folder"}),
    Player = Tabs.Pl:Tab({ Title = "玩家", Icon = "user"}),
    TPItem = Tabs.TP:Tab({ Title = "传送物品", Icon = "folder"}),
    TPItemSettings = Tabs.TP:Tab({ Title = "传送物品设置", Icon = "folder"}),
    Kill1 = Tabs.Kill:Tab({ Title = "范围杀戳光环", Icon = "folder"}),
    Kill2 = Tabs.Kill:Tab({ Title = "全图杀戳光环", Icon = "folder"}),
    Cut1 = Tabs.Cut:Tab({ Title = "范围砍树光环", Icon = "folder"}),
    Cut2 = Tabs.Cut:Tab({ Title = "全图砍树光环", Icon = "folder"}),
    plant = Tabs.Cut:Tab({ Title = "种植树", Icon = "folder"}),
    ItemEsp = Tabs.ESP:Tab({ Title = "物品透视", Icon = "folder"}),
    CharacterEsp = Tabs.ESP:Tab({ Title = "动物透视", Icon = "folder"}),
    ESPSettings = Tabs.ESP:Tab({ Title = "透视设置", Icon = "folder"}),
    Chest1 = Tabs.Chest:Tab({ Title = "宝箱互动事件", Icon = "folder"}),
    Chest2 = Tabs.Chest:Tab({ Title = "自动宝箱", Icon = "folder"}),
    Auto1 = Tabs.Auto:Tab({ Title = "自动篝火", Icon = "folder"}),
    Auto2 = Tabs.Auto:Tab({ Title = "自动工作台", Icon = "folder"}),
    Auto3 = Tabs.Auto:Tab({ Title = "自动食物", Icon = "folder" }),
    Auto4 = Tabs.Auto:Tab({ Title = "自动鱼", Icon = "folder"}),
    Tp2 = Tabs.Get:Tab({ Title = "传送到家中设备", Icon = "folder" })
}

TabHandles.Announcement:Paragraph({
    Title = "欢迎尊贵的用户",
    Desc = "此脚本会一直更新 感谢白名单使用者",
    Image = "info",
    ImageSize = 15
})

TabHandles.Announcement:Paragraph({
    Title = "玩家",
    Desc = "尊敬的用户: " .. lp.Name .. "欢迎使用",
    Image = "user",
    ImageSize = 12
})

TabHandles.Announcement:Paragraph({
    Title = "设备",
    Desc = "你的使用设备: " .. deviceType,
    Image = "gamepad",
    ImageSize = 12
})

TabHandles.Announcement:Paragraph({
    Title = "设备",
    Desc = "你的注入器: " .. identifyexecutor(),
    Image = "syringe",
    ImageSize = 12
})

TabHandles.Announcement:Paragraph({
    Title = "卡密",
    Desc = "你的卡密: " .. readfile("DyzhKey.json"),
    Image = "key",
    ImageSize = 12
})

TabHandles.Player:Slider({
    Title = "玩家速度",
    Desc = "玩家的速度",
    Step = 1,
    Value = {
        Min = 16,
        Max = 200,
        Default = 16,
    },
    Callback = function(value)
        if Character and Character:FindFirstChild("Humanoid") then
            Character.Humanoid.WalkSpeed = value
        end
    end
})

TabHandles.Player:Slider({
    Title = "玩家跳跃高度",
    Desc = "玩家的跳跃高度",
    Step = 1,
    Value = {
        Min = 50,
        Max = 200,
        Default = 50,
    },
    Callback = function(value)
        if Character and Character:FindFirstChild("Humanoid") then
            Character.Humanoid.JumpHeight = value
        end
    end
})

TabHandles.Player:Slider({
    Title = "玩家镜头FOV",
    Desc = "玩家的镜头",
    Step = 1,
    Value = {
        Min = 70,
        Max = 120,
        Default = 70,
    },
    Callback = function(value)
        if camera then
            camera.FieldOfView = value
        end
    end
})

TabHandles.TPItem:Dropdown({
    Title = "铁质类物品下拉菜单",
    Desc = "带来物品",
    Values = {'洗衣机', '破旧微波炉', '旧风扇', '旧音响', '铁钉', '废铁', '轮胎', '铁椅子', '外星残骸', '外星残骸1', '外星残骸2', '引擎'},
    Value = "选择",
    Multi = false,
    AllowNone = false,
    Callback = function(Item)
       local GetItemList = { 
            ['破旧微波炉'] = 'Broken Microwave', 
            ['旧风扇'] = 'Broken Fan', 
            ['旧音响'] = 'Old Radio', 
            ['铁钉'] = 'Bolt', 
            ['废铁'] = 'Sheet Metal', 
            ['轮胎'] = 'Tyre', 
            ['铁椅子'] = 'Metal Chair', 
            ['外星残骸'] = 'UFO Junk', 
            ['外星残骸1'] = 'UFO Scrap',
            ['外星残骸2'] = 'UFO Component',
            ['洗衣机'] = 'Washing Machine',
            ['引擎'] = 'Old Car Engine' 
        }
        ItemList.Item1 = GetItemList[Item]
    end
})

TabHandles.TPItem:Button({
    Title = "带来",
    Desc = "带来物品",
    Locked = false,
    Callback = function()
        GetItem(ItemList.Item1, ItemList.ItemTpPosition)
    end
})

TabHandles.TPItem:Divider()

TabHandles.TPItem:Dropdown({
    Title = "燃料类物品下拉菜单",
    Desc = "带来物品",
    Values = { '煤炭', '木头', '燃料罐', '燃料桶', '椅子', '树苗' },
    Value = "选择",
    Multi = false,
    AllowNone = false,
    Callback = function(Item)
       local GetItemList = { 
            ['煤炭'] = 'Coal', 
            ['木头'] = 'Log', 
            ['燃料罐'] = 'Fuel Canister', 
            ['燃料桶'] = 'Oil Barrel', 
            ['椅子'] = 'Chair', 
            ['树苗'] = 'Sapling'
        }
        ItemList.Item2 = GetItemList[Item]
    end
})

TabHandles.TPItem:Button({
    Title = "带来",
    Desc = "带来物品",
    Locked = false,
    Callback = function()
        GetItem(ItemList.Item2, ItemList.ItemTpPosition)
    end
})

TabHandles.TPItem:Divider()

TabHandles.TPItem:Dropdown({
    Title = "食物类物品下拉菜单",
    Desc = "带来物品",
    Values = {'胡萝卜', '蛋糕', '浆果', '生肉腿', '生肉排', '熟肉腿', '熟肉排'},
    Value = "选择",
    Multi = false,
    AllowNone = false,
    Callback = function(Item)
       local GetItemList = { 
            ['胡萝卜'] = 'Carrot', 
            ['蛋糕'] = 'Cake', 
            ['浆果'] = 'Berry', 
            ['生肉腿'] = 'Morsel', 
            ['生肉排'] = 'Steak', 
            ['熟肉腿'] = 'Cooked Morsel', 
            ['熟肉排'] = 'Cooked Steak'
        }
        ItemList.Item3 = GetItemList[Item]
    end
})

TabHandles.TPItem:Button({
    Title = "带来",
    Desc = "带来物品",
    Locked = false,
    Callback = function()
        GetItem(ItemList.Item3, ItemList.ItemTpPosition)
    end
})

TabHandles.TPItem:Paragraph({
    Title = "提示",
    Desc = "带来胡萝卜需要先带来浆果",
    Image = "info",
    ImageSize = 15,
})

TabHandles.TPItem:Divider()

TabHandles.TPItem:Dropdown({
    Title = "道具类物品下拉菜单",
    Desc = "带来物品",
    Values = { '步枪', '手枪', '外星炮', '手枪子弹', '步枪子弹', '绷带', '医疗包', '旧手电', '强手电', '老斧头', '好斧头', '强斧头', '旧袋子', '好袋子', '巨大袋子', '矛', '防御蓝图', '皮革甲', '铁甲' },
    Value = "选择",
    Multi = false,
    AllowNone = false,
    Callback = function(Item)
       local GetItemList = { 
            ['步枪'] = 'Rifle', 
            ['手枪'] = 'Revolver',
            ["外星炮"] = 'Laser Cannon',
            ['手枪子弹'] = 'Revolver Ammo', 
            ['步枪子弹'] = 'Rifle Ammo', 
            ['绷带'] = 'Bandage', 
            ['医疗包'] = 'MedKit', 
            ['旧手电'] = 'Old Flashlight', 
            ['强手电'] = 'Strong Flashlight', 
            ['老斧头'] = 'Old Axe', 
            ['好斧头'] = 'Good Axe', 
            ['强斧头'] = 'Strong Axe', 
            ['旧袋子'] = 'Old Sack', 
            ['好袋子'] = 'Good Sack', 
            ['巨大袋子'] = 'Giant Sack', 
            ['矛'] = 'Spear', 
            ['防御蓝图'] = 'Laser Fence Blueprint', 
            ['皮革甲'] = 'Leather Body', 
            ['铁甲'] = 'Iron Body'
        }
        ItemList.Item4 = GetItemList[Item]
    end
})

TabHandles.TPItem:Button({
    Title = "带来",
    Desc = "带来物品",
    Locked = false,
    Callback = function()
        GetItem(ItemList.Item4, ItemList.ItemTpPosition)
    end
})

TabHandles.TPItem:Divider()

TabHandles.TPItem:Button({
    Title = "传送全服物品",
    Desc = "OP",
    Callback = function()
        for _, Item in pairs(game.Workspace.Items:GetChildren()) do
            if not Item.Name:find("Chest") then
                if ItemList.ItemTpPosition == '玩家' then
                    game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("RequestStartDraggingItem"):FireServer(Item)
                    Item:PivotTo(hrp.CFrame * CFrame.new(ItemList.x, ItemList.y, 0))
                    task.wait(0.1)
                    game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents").StopDraggingItem:FireServer(Item)
                elseif ItemList.ItemTpPosition == '篝火' then
                    game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("RequestStartDraggingItem"):FireServer(Item)
                    Item:PivotTo(workspace.Map.Campground.MainFire.Center.CFrame * CFrame.new(ItemList.x, 20 + ItemList.y, 0))
                    task.wait(0.1)
                    game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents").StopDraggingItem:FireServer(Item)
                elseif ItemList.ItemTpPosition == '工作台' then
                    game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("RequestStartDraggingItem"):FireServer(Item)
                    Item:PivotTo(workspace.Map.Campground.Scrapper.Main.CFrame * CFrame.new(ItemList.x, 20 + ItemList.y, 0))
                    task.wait(0.1)
                    game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents").StopDraggingItem:FireServer(Item)
                elseif ItemList.ItemTpPosition == '自定义位置' then
                    game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("RequestStartDraggingItem"):FireServer(Item)
                    Item:PivotTo(workspace.waypoint.CFrame * CFrame.new(ItemList.x, 20 + ItemList.y, 0))
                    task.wait(0.1)
                    game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents").StopDraggingItem:FireServer(Item)
                elseif ItemList.ItemTpPosition == '指定玩家' then
                    game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents"):FindFirstChild("RequestStartDraggingItem"):FireServer(Item)
                    Item:PivotTo(workspace:FindFirstChild(ItemList.Pn):FindFirstChild('HumanoidRootPart').CFrame * CFrame.new(ItemList.x, 20 + ItemList.y, 0))
                    task.wait(0.1)
                    game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvents").StopDraggingItem:FireServer(Item)
                end
            end
        end
    end
})

TabHandles.TPItemSettings:Dropdown({
    Title = "下拉菜单",
    Desc = "物品传送位置",
    Values = {"玩家", "篝火", "工作台", "自定义位置", "指定玩家"},
    Value = "玩家",
    Multi = false,
    AllowNone = false,
    Callback = function(Value)
        if Value == "自定义位置" then
            if not workspace:FindFirstChild("waypoint") then
                WindUI:Notify({
                    Title = "带来物品",
                    Content = "你没有放置位置方块",
                    Icon = "notepad-text",
                    IconThemed = true,
                    Duration = 5  
                })
                return
            end        
        end
        ItemList.ItemTpPosition = Value
    end
})

TabHandles.TPItemSettings:Paragraph({
    Title = "提示",
    Desc = "这是物品传送位置",
    Image = "info",
    ImageSize = 15,
})

TabHandles.TPItemSettings:Divider()

TabHandles.TPItemSettings:Slider({
    Title = "右偏移度",
    Desc = "偏移度",
    Step = 1,
    Value = {
        Min = 0,
        Max = 20,
        Default = 0,
    },
    Callback = function(value)
        TypeList.x = value
    end
})

TabHandles.TPItemSettings:Slider({
    Title = "上偏移度",
    Desc = "偏移度",
    Step = 1,
    Value = {
        Min = 0,
        Max = 20,
        Default = 0,
    },
    Callback = function(value)
        TypeList.y = value
    end
})

TabHandles.TPItemSettings:Paragraph({
    Title = "提示",
    Desc = "每个位置都带有默认偏移高度 无法改变",
    Image = "info",
    ImageSize = 15,
})

TabHandles.TPItemSettings:Divider()

TabHandles.TPItemSettings:Button({
    Title = "在此放置位置方块",
    Desc = "位置表示",
    Callback = function()
        for _, part in pairs(workspace:GetChildren()) do
            if part.Name == "waypoint" then
                part:Destroy()
            end        
        end
        
        local waypoint = Instance.new("Part")
        waypoint.Name = "waypoint"
        waypoint.BrickColor = BrickColor.new("Bright red")
        waypoint.Material = Enum.Material.Neon
        waypoint.Transparency = 0.7
        waypoint.Size = Vector3.new(2, 2, 2)
        waypoint.Anchored = true
        waypoint.CanCollide = false        
        waypoint.Position = hrp.Position + Vector3.new(0, 3, 0)
        waypoint.Parent = workspace

        WindUI:Notify({
            Title = "自定义位置",
            Content = "放置完成",
            Icon = "notepad-text",
            IconThemed = true,
            Duration = 5  
        })
    end
})

TabHandles.TPItemSettings:Button({
    Title = "删除位置方块",
    Desc = "删除位置表示",
    Callback = function()
        if not workspace.waypoint then
            WindUI:Notify({
                Title = "自定义位置",
                Content = "未找到位置方块",
                Icon = "notepad-text",
                IconThemed = true,
                Duration = 5  
            })        
        end
        for _, part in pairs(workspace:GetChildren()) do
            if part.Name == "waypoint" then
                part:Destroy()
                WindUI:Notify({
                    Title = "自定义位置",
                    Content = "删除完成",
                    Icon = "notepad-text",
                    IconThemed = true,
                    Duration = 5  
                })                    
            end        
        end
    end
})

TabHandles.TPItemSettings:Paragraph({
    Title = "提示",
    Desc = "请打开传送模式的[自定义位置]",
    Image = "info",
    ImageSize = 15,
})

TabHandles.TPItemSettings:Divider()

TabHandles.TPItemSettings:Input({
    Title = "输入指定玩家名称",
    Desc = "玩家名",
    Value = lp.Name,
    Placeholder = "请输入",
    Type = "Input",
    Callback = function(text)
        ItemList.Pn = text
        WindUI:Notify({
            Title = "带来物品",
            Content = "修改完成: " .. text,
            Icon = "notepad-text",
            IconThemed = true,
            Duration = 5  
        })        
    end
})

local run = false
TabHandles.Kill1:Toggle({
    Title = "杀戮光环",
    Desc = "杀死",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        run = state
        if state then
            task.spawn(function()
                while run do
                    killCharacter(St.Kill * 1.1)
                    task.wait(0.1)
                end
            end)
        end 
    end
})

TabHandles.Kill1:Slider({
    Title = "杀戮范围",
    Desc = "范围大小",
    Step = 1,
    Value = {
        Min = 50,
        Max = 500,
        Default = 50,
    },
    Callback = function(value)
        St.Kill = value  
    end
})

local run1 = false
TabHandles.Kill2:Toggle({
    Title = "全图杀戮光环",
    Desc = "杀死",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        run1 = state
        if state then
            task.spawn(function()
                while run1 do
                    local axe = inventory:FindFirstChild(tools.KillTool)
                    for _, Child in pairs(workspace.Characters:GetChildren()) do
                        DamageRemote:InvokeServer(Child, axe, '1_' .. lp.CharacterAppearanceId, hrp.CFrame)        
                    end
                    task.wait(0.1)
                end
            end)
        end 
    end
})

ActiveAutoChopTree = false
TabHandles.Cut1:Toggle({
    Title = "砍树光环",
    Desc = "砍树",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        ActiveAutoChopTree = state
        task.spawn(function()
            while ActiveAutoChopTree do                
                local character = lp.Character or player.CharacterAdded:Wait()
                local hrp = character:FindFirstChild("HumanoidRootPart")
                local weapon = inventory:FindFirstChild("Old Axe") or inventory:FindFirstChild("Good Axe") or inventory:FindFirstChild("Strong Axe") or inventory:FindFirstChild("Chainsaw")
                
                task.spawn(function()
                    for _, tree in pairs(workspace.Map.Foliage:GetChildren()) do
                        if tree:IsA("Model") and (tree.Name == "Small Tree" or tree.Name == "TreeBig1" or tree.Name == "TreeBig2") and tree.PrimaryPart then
                            local distance = (tree.PrimaryPart.Position - hrp.Position).Magnitude
                            if distance <= St.Cut then
                                DamageRemote:InvokeServer(tree, weapon, 999, hrp.CFrame)
                            end
                        end
                    end
                end)
                
                task.spawn(function()
                    for _, tree in pairs(workspace.Map.Landmarks:GetChildren()) do
                        if tree:IsA("Model") and (tree.Name == "Small Tree" or tree.Name == "TreeBig1" or tree.Name == "TreeBig2") and tree.PrimaryPart then
                            local distance = (tree.PrimaryPart.Position - hrp.Position).Magnitude
                            if distance <= St.Cut then
                                DamageRemote:InvokeServer(tree, weapon, 999, hrp.CFrame)
                            end
                        end
                    end
                end)                
                task.wait(0.1)
            end
        end) 
    end
})

TabHandles.Cut1:Slider({
    Title = "砍树范围",
    Desc = "范围大小",
    Step = 1,
    Value = {
        Min = 50,
        Max = 500,
        Default = 50,
    },
    Callback = function(value)
        St.Cut = value  
    end
})

local run3 = false
TabHandles.Cut2:Toggle({
    Title = "全图砍树光环",
    Desc = "砍树",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        run3 = state
        if state then
            task.spawn(function()
                while run3 do
                    local tool = inventory:FindFirstChild(tools.CutTool)
                    for _, Tree in pairs(workspace.Map.Landmarks:GetChildren()) do
                        if Tree.Name ==  "Small Tree" or Tree.Name:find("Big") then
                            DamageRemote:InvokeServer(Tree, tool, true, hrp.CFrame)      
                        end
                    end
                    task.wait(0.1)
                end
            end)
        end 
    end
})
--种植
local plantShape = "圆形" 
local radius = 40
local spacing = 1
local isPlanting = false

TabHandles.plant:Dropdown({ 
    Title = "选择种植形状", 
    Values = {"圆形", "正方形"}, 
    Value = "圆形", 
    Callback = function(value) 
        plantShape = value 
    end 
})

TabHandles.plant:Slider({
    Title = "种植半径大小",
    Value = { Min = 1, Max = 150, Default = 50 },
    Callback = function(value)
     radius = value
     end
})

TabHandles.plant:Toggle({
    Title = "自动种植",
    Value = false,
    Callback = function(state)
        isPlanting = state
        if state then
            local Players = game:GetService("Players") 
            local ReplicatedStorage = game:GetService("ReplicatedStorage") 
            local RequestPlantItem = ReplicatedStorage:FindFirstChild("RemoteEvents"):FindFirstChild("RequestPlantItem") 
            local Sapling = workspace:FindFirstChild("Items"):FindFirstChild("Sapling")
            
            local player = Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            local fixedY = 1.216280221939087

            if plantShape == "圆形" then
                local circumference = 2 * math.pi * radius
                local numTrees = math.floor(circumference / spacing)
                local angleStep = 360 / numTrees
                
                local function plantAtAngle(angle)
                    if not isPlanting then return end
                    local angleRad = math.rad(angle)
                    local x = rootPart.Position.X + radius * math.cos(angleRad)
                    local z = rootPart.Position.Z + radius * math.sin(angleRad)
                    local position = Vector3.new(x, fixedY, z)
                    RequestPlantItem:InvokeServer(Sapling, position)
                end

                for i = 0, numTrees - 1 do
                    if not isPlanting then break end
                    local angle = i * angleStep
                    plantAtAngle(angle)
                    task.wait(0.1)
                end
            else
                local sideLength = radius * 2
                local numTreesPerSide = math.floor(sideLength / spacing)
                local step = sideLength / numTreesPerSide
                local halfSide = sideLength / 2
                
                for i = 0, numTreesPerSide do
                    if not isPlanting then break end
                    local x = rootPart.Position.X - halfSide + i * step
                    local z1 = rootPart.Position.Z - halfSide
                    local z2 = rootPart.Position.Z + halfSide
                    
                    RequestPlantItem:InvokeServer(Sapling, Vector3.new(x, fixedY, z1))
                    RequestPlantItem:InvokeServer(Sapling, Vector3.new(x, fixedY, z2))
                    task.wait(0.1)
                end
                
                for i = 1, numTreesPerSide - 1 do
                    if not isPlanting then break end
                    local z = rootPart.Position.Z - halfSide + i * step
                    local x1 = rootPart.Position.X - halfSide
                    local x2 = rootPart.Position.X + halfSide
                    
                    RequestPlantItem:InvokeServer(Sapling, Vector3.new(x1, fixedY, z))
                    RequestPlantItem:InvokeServer(Sapling, Vector3.new(x2, fixedY, z))
                    task.wait(0.1)
                end
            end
        end
    end
})

TabHandles.plant:Paragraph({
    Title = "提示",
    Desc = "圆圈和方框是以玩家为中心 在种植时不要移动 谢谢",
    Image = "info",
    ImageSize = 15,
})
TabHandles.plant:Paragraph({
    Title = "提示",
    Desc = "种植时务必有一个树苗 否则无效",
    Image = "info",
    ImageSize = 15,
})

local es, es2, es3, es4, es5, es6, es7, es8, es9, es10, es11, es12, es13, es14, es15, es16, es17 = false
local esd, esd1, esd2, esd3 = false

TabHandles.ItemEsp:Toggle({
    Title = "透视煤炭",
    Desc = "显示煤炭位置",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        es = state
        if state then
            task.spawn(function()
                while es do
                    EspItem("Coal")
                    task.wait(0.1)
                end
            end)
        else
            RemoveEspItem("Coal")
        end
    end
})

TabHandles.ItemEsp:Toggle({
    Title = "透视生肉",
    Desc = "显示生肉位置",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        es2 = state
        if state then
            task.spawn(function()
                while es2 do
                    EspItem("Steak")
                    EspItem("Morsel")
                    task.wait(0.1)
                end
            end)
        else
            RemoveEspItem("Morsel")
            RemoveEspItem("Steak")
        end
    end
})

TabHandles.ItemEsp:Toggle({
    Title = "透视熟肉",
    Desc = "显示熟肉位置",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        es3 = state
        if state then
            task.spawn(function()
                while es3 do
                    EspItem("Cooked Steak")
                    EspItem("Cooked Morsel")
                    task.wait(0.1)
                end
            end)
        else
            RemoveEspItem("Cooked Morsel")
            RemoveEspItem("Cooked Steak")
        end
    end
})

TabHandles.ItemEsp:Toggle({
    Title = "透视燃料罐",
    Desc = "显示燃料罐位置",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        es4 = state
        if state then
            task.spawn(function()
                while es4 do
                    EspItem("Fuel Canister")
                    task.wait(0.1)
                end
            end)
        else
            RemoveEspItem("Fuel Canister")
        end
    end
})

TabHandles.ItemEsp:Toggle({
    Title = "透视燃料桶",
    Desc = "显示燃料桶位置",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        es5 = state
        if state then
            task.spawn(function()
                while es5 do
                    EspItem("Oil Barrel")
                    task.wait(0.1)
                end
            end)
        else
            RemoveEspItem("Oil Barrel")
        end
    end
})

TabHandles.ItemEsp:Toggle({
    Title = "透视木头",
    Desc = "显示木头位置",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        es6 = state
        if state then
            task.spawn(function()
                while es6 do
                    EspItem("Log")
                    task.wait(0.1)
                end
            end)
        else
            RemoveEspItem("Log")
        end
    end
})

TabHandles.ItemEsp:Toggle({
    Title = "透视铁类物品",
    Desc = "显示铁类物品位置",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        es7 = state
        if state then
            task.spawn(function()
                while es7 do
                    EspItem("Old Car Engine")
                    EspItem("UFO Scrap")
                    EspItem("UFO Junk")
                    EspItem("Metal Chair")
                    EspItem("Tyre")
                    EspItem("Sheet Metal")
                    EspItem("Bolt")
                    EspItem("Old Radio")
                    EspItem("Broken Fan")
                    EspItem("Broken Microwave")
                    EspItem("Washing Machine") 
                    task.wait(0.1)
                end
            end)
        else
            RemoveEspItem("Old Car Engine")
            RemoveEspItem("UFO Scrap")
            RemoveEspItem("UFO Junk")
            RemoveEspItem("Metal Chair")
            RemoveEspItem("Tyre")
            RemoveEspItem("Sheet Metal")
            RemoveEspItem("Bolt")
            RemoveEspItem("Old Radio")
            RemoveEspItem("Broken Fan")
            RemoveEspItem("Broken Microwave")
            RemoveEspItem("Washing Machine")
        end
    end
})

TabHandles.ItemEsp:Toggle({
    Title = "透视胡萝卜",
    Desc = "显示胡萝卜位置",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        es8 = state
        if state then
            task.spawn(function()
                while es8 do
                    EspItem("Carrot")
                    task.wait(0.1)
                end
            end)
        else
            RemoveEspItem("Carrot")
        end
    end
})

TabHandles.ItemEsp:Toggle({
    Title = "透视浆果",
    Desc = "显示浆果位置",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        es9 = state
        if state then
            task.spawn(function()
                while es9 do
                    EspItem("Berry")
                    task.wait(0.1)
                end
            end)
        else
            RemoveEspItem("Berry")
        end
    end
})

TabHandles.ItemEsp:Toggle({
    Title = "透视枪",
    Desc = "显示枪支位置",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        es10 = state
        if state then
            task.spawn(function()
                while es10 do
                    EspItem("Revolver")
                    EspItem("Rifle")
                    task.wait(0.1)
                end
            end)
        else
            RemoveEspItem("Revolver")
            RemoveEspItem("Rifle")
        end
    end
})

TabHandles.ItemEsp:Toggle({
    Title = "透视弹药",
    Desc = "显示弹药位置",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        es11 = state
        if state then
            task.spawn(function()
                while es11 do
                    EspItem("Revolver Ammo")
                    EspItem("Rifle Ammo")
                    task.wait(0.1)
                end
            end)
        else
            RemoveEspItem("Revolver Ammo")
            RemoveEspItem("Rifle Ammo")
        end
    end
})

TabHandles.ItemEsp:Toggle({
    Title = "透视袋子",
    Desc = "显示袋子位置",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        es12 = state
        if state then
            task.spawn(function()
                while es12 do
                    EspItem("Old Sack")
                    EspItem("Good Sack")
                    EspItem("Giant Sack")
                    task.wait(0.1)
                end
            end)
        else
            RemoveEspItem("Old Sack")
            RemoveEspItem("Good Sack")
            RemoveEspItem("Giant Sack")            
        end
    end
})

TabHandles.ItemEsp:Toggle({
    Title = "透视斧头",
    Desc = "显示斧头位置",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        es13 = state
        if state then
            task.spawn(function()
                while es13 do
                    EspItem("Old Axe")
                    EspItem("Good Axe")
                    EspItem("Strong Axe")
                    task.wait(0.1)
                end
            end)
        else
            RemoveEspItem("Old Axe")
            RemoveEspItem("Good Axe")
            RemoveEspItem("Strong Axe")   
        end
    end
})

TabHandles.ItemEsp:Toggle({
    Title = "透视手电",
    Desc = "显示手电位置",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        es14 = state
        if state then
            task.spawn(function()
                while es14 do
                    EspItem("Old Flashlight")
                    EspItem("Strong Flashlight")
                    task.wait(0.1)
                end
            end)
        else
            RemoveEspItem("Old Flashlight")
            RemoveEspItem("Strong Flashlight")  
        end
    end
})

TabHandles.ItemEsp:Toggle({
    Title = "透视盔甲",
    Desc = "显示盔甲位置",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        es15 = state
        if state then
            task.spawn(function()
                while es15 do
                    EspItem("Leather Body")
                    EspItem("Iron Body")
                    task.wait(0.1)
                end
            end)
        else
            RemoveEspItem("Leather Body")
            RemoveEspItem("Iron Body")  
        end
    end
})

TabHandles.ItemEsp:Toggle({
    Title = "透视医疗用品",
    Desc = "显示医疗用品位置",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        es16 = state
        if state then
            task.spawn(function()
                while es16 do
                    EspItem("Bandage")
                    EspItem("MedKit")
                    task.wait(0.1)
                end
            end)
        else
            RemoveEspItem("Bandage")
            RemoveEspItem("MedKit")  
        end
    end
})

TabHandles.ItemEsp:Toggle({
    Title = "透视矛",
    Desc = "显示矛位置",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        es17 = state
        if state then
            task.spawn(function()
                while es17 do
                    EspItem("Spear")
                    task.wait(0.1)
                end
            end)
        else
            RemoveEspItem("Spear")
        end
    end
})

TabHandles.CharacterEsp:Toggle({
    Title = "透视兔子",
    Desc = "显示兔子位置",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        esd = state
        if state then
            task.spawn(function()
                while esd do
                    EspCharacter("Bunny")
                    task.wait(0.1)
                end
            end)
        else
            RemoveEspCharacter("Bunny")
        end
    end
})

TabHandles.CharacterEsp:Toggle({
    Title = "透视狼",
    Desc = "显示狼位置",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        esd1 = state
        if state then
            task.spawn(function()
                while esd1 do
                    EspCharacter("Wolf")
                    task.wait(0.1)
                end
            end)
        else
            RemoveEspCharacter("Wolf")
        end
    end
})

TabHandles.CharacterEsp:Toggle({
    Title = "透视阿尔法狼",
    Desc = "显示阿尔法狼位置",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        esd2 = state
        if state then
            task.spawn(function()
                while esd2 do
                    EspCharacter("Alpha Wolf")
                    task.wait(0.1)
                end
            end)
        else
            RemoveEspCharacter("Alpha Wolf")
        end
    end
})

TabHandles.CharacterEsp:Toggle({
    Title = "透视熊",
    Desc = "显示熊位置",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        esd3 = state
        if state then
            task.spawn(function()
                while esd3 do
                    EspCharacter("Bear")
                    task.wait(0.1)
                end
            end)
        else
            RemoveEspCharacter("Bear")
        end
    end
})

TabHandles.ESPSettings:Slider({
    Title = "ESP透明度",
    Desc = "设置高亮填充透明度",
    Step = 0.1,
    Value = {
        Min = 0,
        Max = 1,
        Default = 0.5,
    },
    Callback = function(value)
        dyzh.nt = value
        for _, cache in pairs(espCache.Items) do
            if cache.highlight then
                cache.highlight.FillTransparency = value
            end
        end
        for _, cache in pairs(espCache.Characters) do
            if cache.highlight then
                cache.highlight.FillTransparency = value
            end
        end
    end
})

TabHandles.ESPSettings:Slider({
    Title = "ESP透明度",
    Desc = "设置高轮廓透明度",
    Step = 0.1,
    Value = {
        Min = 0,
        Max = 1,
        Default = 0.5,
    },
    Callback = function(value)
        dyzh.wt = value
        for _, cache in pairs(espCache.Items) do
            if cache.highlight then
                cache.highlight.OutlineTransparency = value
            end
        end
        for _, cache in pairs(espCache.Characters) do
            if cache.highlight then
                cache.highlight.OutlineTransparency = value
            end
        end
    end
})
--宝箱
local OpenTime = 5.5
TabHandles.Chest1:Input({
    Title = "宝箱打开时间",
    Desc = "输入",
    Value = "5.5",
    Callback = function(text)
        OpenTime = tonumber(text)        
    end
})
TabHandles.Chest1:Toggle({
    Title = "开启自定义开启",
    Desc = "开启自定义时间",
    Value = false,
    Callback = function(state)
        if state then
            OpenChestTme(OpenTime)
        else
            OpenChestTme(5.5)
        end
    end
})

TabHandles.Chest2:Button({
    Title = "打开所有宝箱",
    Desc = "一键打开",
    Callback = function()
        OpenChest()
    end
})

local ChestRunState = false

TabHandles.Chest2:Toggle({
    Title = "自动打开宝箱",
    Desc = "自动",
    Value = false,
    Callback = function(state)
        ChestRunState = state
        if state then
            while ChestRunState do
                OpenChest()
                task.wait(0.1)        
            end
        end
    end
})

TabHandles.Chest2:Paragraph({
    Title = "提示",
    Desc = "需要你的注入器支持",
    Image = "info",
    ImageSize = 15,
})
--自动篝
local AutoState1 = false
TabHandles.Auto1:Toggle({
    Title = "自动篝火(煤炭)",
    Desc = "自动",
    Value = false,
    Callback = function(state)
        AutoState1 = state
        if state then
            while AutoState1 do
                AutoFire("Coal")
                task.wait(1)
            end
        end
    end
})
local AutoState2 = false
TabHandles.Auto1:Toggle({
    Title = "自动篝火(木头)",
    Desc = "自动",
    Value = false,
    Callback = function(state)
        AutoState2 = state
        if state then
            while AutoState2 do
                AutoFire("Log")
                task.wait(1)
            end
        end
    end
})
local AutoState3 = false
TabHandles.Auto1:Toggle({
    Title = "自动篝火(燃料罐)",
    Desc = "自动",
    Value = false,
    Callback = function(state)
        AutoState3 = state
        if state then
            while AutoState3 do
                AutoFire("Fuel Canister")
                task.wait(1)
            end
        end
    end
})
local AutoState4 = false
TabHandles.Auto1:Toggle({
    Title = "自动篝火(燃料罐)",
    Desc = "自动",
    Value = false,
    Callback = function(state)
        AutoState4 = state
        if state then
            while AutoState4 do
                AutoFire("Oil Barrel")
                task.wait(1)
            end
        end
    end
})
--自动工作台
local AutoState5 = false
TabHandles.Auto2:Toggle({
    Title = "自动工作台(木头)",
    Desc = "自动",
    Value = false,
    Callback = function(state)
        AutoState5 = state
        if state then
            while AutoState5 do
                AutoScrapper("Log")
                task.wait(1)
            end
        end
    end
})

local AutoState91 = false
TabHandles.Auto2:Toggle({
    Title = "自动工作台(洗衣机)",
    Desc = "自动",
    Value = false,
    Callback = function(state)
        AutoState91 = state
        if state then
            while AutoState91 do
                AutoScrapper("Washing Machine")
                task.wait(1)
            end
        end
    end
})

local AutoState6 = false
TabHandles.Auto2:Toggle({
    Title = "自动工作台(破旧微波炉)",
    Desc = "自动",
    Value = false,
    Callback = function(state)
        AutoState6 = state
        if state then
            while AutoState6 do
                AutoScrapper("Broken Microwave")
                task.wait(1)
            end
        end
    end
})
local AutoState7 = false
TabHandles.Auto2:Toggle({
    Title = "自动工作台(风扇)",
    Desc = "自动",
    Value = false,
    Callback = function(state)
        AutoState7 = state
        if state then
            while AutoState7 do
                AutoScrapper("Broken Fan")
                task.wait(1)
            end
        end
    end
})
local AutoState8 = false
TabHandles.Auto2:Toggle({
    Title = "自动工作台(旧音响)",
    Desc = "自动",
    Value = false,
    Callback = function(state)
        AutoState8 = state
        if state then
            while AutoState8 do
                AutoScrapper("Old Radio")
                task.wait(1)
            end
        end
    end
})
local AutoState9 = false
TabHandles.Auto2:Toggle({
    Title = "自动工作台(铁钉)",
    Desc = "自动",
    Value = false,
    Callback = function(state)
        AutoState9 = state
        if state then
            while AutoState9 do
                AutoScrapper("Bolt")
                task.wait(1)
            end
        end
    end
})
local AutoState10 = false
TabHandles.Auto2:Toggle({
    Title = "自动工作台(废铁)",
    Desc = "自动",
    Value = false,
    Callback = function(state)
        AutoState10 = state
        if state then
            while AutoState10 do
                AutoScrapper("Sheet Metal")
                task.wait(1)
            end
        end
    end
})
local AutoState11 = false
TabHandles.Auto2:Toggle({
    Title = "自动工作台(轮胎)",
    Desc = "自动",
    Value = false,
    Callback = function(state)
        AutoState11 = state
        if state then
            while AutoState11 do
                AutoScrapper("Tyre")
                task.wait(1)
            end
        end
    end
})
local AutoState12 = false
TabHandles.Auto2:Toggle({
    Title = "自动工作台(铁椅子)",
    Desc = "自动",
    Value = false,
    Callback = function(state)
        AutoState12 = state
        if state then
            while AutoState12 do
                AutoScrapper("Metal Chair")
                task.wait(1)
            end
        end
    end
})

local AutoState78 = false
TabHandles.Auto2:Toggle({
    Title = "自动工作台(外星残骸)",
    Desc = "自动",
    Value = false,
    Callback = function(state)
        AutoState78 = state
        if state then
            while AutoState78 do
                AutoScrapper("UFO Component")
                task.wait(1)
            end
        end
    end
})

local AutoState13 = false
TabHandles.Auto2:Toggle({
    Title = "自动工作台(外星残骸1)",
    Desc = "自动",
    Value = false,
    Callback = function(state)
        AutoState13 = state
        if state then
            while AutoState13 do
                AutoScrapper("UFO Junk")
                task.wait(1)
            end
        end
    end
})
local AutoState14 = false
TabHandles.Auto2:Toggle({
    Title = "自动工作台(外星残骸2)",
    Desc = "自动",
    Value = false,
    Callback = function(state)
        AutoState14 = state
        if state then
            while AutoState14 do
                AutoScrapper("UFO Scrap")
                task.wait(1)
            end
        end
    end
})
local AutoState15 = false
TabHandles.Auto2:Toggle({
    Title = "自动工作台(引擎)",
    Desc = "自动",
    Value = false,
    Callback = function(state)
        AutoState15 = state
        if state then
            while AutoState15 do
                AutoScrapper("Old Car Engine")
                task.wait(1)
            end
        end
    end
})
local Cooking = false
TabHandles.Auto3:Toggle({
    Title = "自动煎烤食物",
    Desc = "自动",
    Value = false,
    Callback = function(state)
        Cooking = state
        if state then
            while Cooking do
                AutoCooking("Morsel")
                AutoCooking("Mackerel")
                AutoCooking("Steak")
                task.wait(0.1)
            end
        end
    end
})

TabHandles.Auto3:Paragraph({
    Title = "提示",
    Desc = "使用前请确保篝火存在",
    Image = "info",
    ImageSize = 15,
})
TabHandles.Auto3:Divider()

local n
TabHandles.Auto3:Dropdown({
    Title = "选择食物",
    Desc = "自己选择",
    Values = {"蛋糕", "熟肉腿", "熟肉排", "生肉腿", "生肉排", "浆果", "胡萝卜"},
    Value = "胡萝卜",
    Multi = false,
    Callback = function(value)
        local GetFoodList = {
            ["蛋糕"] = "Cake",
            ["熟肉腿"] = "Cooked Steak",
            ["熟肉排"] = "Cooked Morsel",
            ["生肉腿"] = "Morsel",
            ["生肉排"] = "Steak",
            ["浆果"] = "Berry",
            ["胡萝卜"] = "Carrot",
        }
        Food = GetFoodList[value]
    end
})


TabHandles.Auto3:Input({
    Title = "饥饿设置",
    Desc = "当饥饿达到多少时进食",
    Value = tostring(hungerThreshold),
    Placeholder = "75",
    Numeric = true,
    Callback = function(value)
        local n = tonumber(value)
        if n then
            hungerThreshold = math.clamp(n, 0, 100)
        end
    end
})

local autoFeed

TabHandles.Auto3:Toggle({
    Title = "自动进食",
    Value = false,
    Callback = function(state)
        autoFeed = state
        if state then
            task.spawn(function()
                while autoFeed do
                    task.wait(0.075)
                    if wiki(Food) == 0 then
                        autoFeed = false
                        notifeed(Food)
                        break
                    end
                    if ghn() <= hungerThreshold then
                        feed(Food)
                    end
                end
            end)
        end
    end
})

--鱼

local AutoFish = false
TabHandles.Auto4:Toggle({
    Title = "自动钓鱼",
    Value = false,
    Callback = function(state)
        AutoFish = state
        if state then
            task.spawn(function()
                while AutoFish do
                    local bar  = lp.PlayerGui.Interface.FishingCatchFrame.TimingBar.Bar
                    local zone = lp.PlayerGui.Interface.FishingCatchFrame.TimingBar.SuccessArea
                    if bar and zone and math.abs(bar.AbsolutePosition.Y - zone.AbsolutePosition.Y) < 1 then
                        local vim = game:GetService("VirtualInputManager")
                        vim:SendMouseButtonEvent(0,0,0,true,game,0)
                        vim:SendMouseButtonEvent(0,0,0,false,game,0)
                    end
                    task.wait(0.03)
                end
            end)
        end
    end
})


--家
TabHandles.Tp2:Button({
    Title = "传送到篝火",
    Desc = "传送",
    Callback = function()
        local fireCenter = workspace.Map.Campground.MainFire:FindFirstChild("Center")
        if not fireCenter then
            WindUI:Notify({
                Title = "提示",
                Content = "未找到篝火",
                Duration = 2
            })
            return
        end
        hrp.CFrame = fireCenter.CFrame + Vector3.new(0, 3, 0)
    end
})

TabHandles.Tp2:Button({
    Title = "传送到工作台",
    Desc = "传送",
    Callback = function()
        local scrapper = workspace.Map.Campground.Scrapper:FindFirstChild("Main")
        if not scrapper then
            WindUI:Notify({
                Title = "提示",
                Content = "未找到工作台",
                Duration = 2
            })
            return
        end
        hrp.CFrame = scrapper.CFrame + Vector3.new(0, 3, 0)
    end
})