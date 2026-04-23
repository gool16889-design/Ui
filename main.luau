local Library = {}
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

function Library:CreateWindow(hubName)
    local targetParent = (gethui and gethui()) or game:GetService("CoreGui")
    if targetParent:FindFirstChild("ModernCheatHub") then targetParent.ModernCheatHub:Destroy() end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ModernCheatHub"
    ScreenGui.Parent = targetParent
    ScreenGui.IgnoreGuiInset = true

    local Main = Instance.new("CanvasGroup")
    Main.Size = UDim2.new(0, 560, 0, 400)
    Main.Position = UDim2.new(0.5, -280, 0.5, 600)
    Main.BackgroundColor3 = Color3.fromRGB(13, 13, 15)
    Main.Parent = ScreenGui
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

    -- Обводка всего окна
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(35, 35, 40)
    Stroke.Thickness = 1.5
    Stroke.Parent = Main

    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 160, 1, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = Main

    local Logo = Instance.new("TextLabel")
    Logo.Text = hubName
    Logo.RichText = true
    Logo.Size = UDim2.new(1, 0, 0, 50)
    Logo.TextColor3 = Color3.new(1, 1, 1)
    Logo.Font = Enum.Font.GothamBold
    Logo.TextSize = 18
    Logo.BackgroundTransparency = 1
    Logo.Parent = Sidebar

    local TabHolder = Instance.new("Frame")
    TabHolder.Size = UDim2.new(1, 0, 1, -60)
    TabHolder.Position = UDim2.new(0, 0, 0, 60)
    TabHolder.BackgroundTransparency = 1
    TabHolder.Parent = Sidebar
    local L1 = Instance.new("UIListLayout", TabHolder)
    L1.HorizontalAlignment = "Center"
    L1.Padding = UDim.new(0, 6)

    local Pages = Instance.new("Frame")
    Pages.Size = UDim2.new(1, -180, 1, -40)
    Pages.Position = UDim2.new(0, 170, 0, 20)
    Pages.BackgroundTransparency = 1
    Pages.Parent = Main

    -- Анимация появления
    TweenService:Create(Main, TweenInfo.new(0.8, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -280, 0.5, -200),
        GroupTransparency = 0
    }):Play()

    local Tabs = {}
    function Tabs:CreateTab(name, isDefault)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(0, 140, 0, 36)
        TabBtn.BackgroundColor3 = isDefault and Color3.fromRGB(30, 30, 35) or Color3.fromRGB(18, 18, 20)
        TabBtn.Text = name
        TabBtn.TextColor3 = isDefault and Color3.new(1, 1, 1) or Color3.fromRGB(150, 150, 150)
        TabBtn.Font = Enum.Font.GothamBold
        TabBtn.TextSize = 14
        TabBtn.AutoButtonColor = false
        TabBtn.Parent = TabHolder
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.Visible = isDefault
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 0
        Page.Parent = Pages
        
        local Layout = Instance.new("UIListLayout", Page)
        Layout.Padding = UDim.new(0, 10)

        TabBtn.MouseButton1Click:Connect(function()
            for _, p in pairs(Pages:GetChildren()) do p.Visible = false end
            for _, t in pairs(TabHolder:GetChildren()) do 
                if t:IsA("TextButton") then 
                    t.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
                    t.TextColor3 = Color3.fromRGB(150, 150, 150)
                end 
            end
            Page.Visible = true
            TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            TabBtn.TextColor3 = Color3.new(1, 1, 1)
        end)

        local Elements = {}

        function Elements:AddToggle(name, default, callback)
            local Tgl = Instance.new("Frame")
            Tgl.Size = UDim2.new(1, -5, 0, 48)
            Tgl.BackgroundColor3 = Color3.fromRGB(22, 22, 25)
            Tgl.Parent = Page
            Instance.new("UICorner", Tgl).CornerRadius = UDim.new(0, 8)

            local L = Instance.new("TextLabel")
            L.Text = "  " .. name
            L.Size = UDim2.new(1, 0, 1, 0)
            L.TextColor3 = Color3.fromRGB(220, 220, 220)
            L.Font = Enum.Font.GothamSemibold
            L.TextSize = 15
            L.TextXAlignment = "Left"
            L.BackgroundTransparency = 1
            L.Parent = Tgl

            local B = Instance.new("TextButton")
            B.Size = UDim2.new(0, 38, 0, 20)
            B.Position = UDim2.new(1, -50, 0.5, -10)
            B.BackgroundColor3 = default and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(45, 45, 50)
            B.Text = ""
            B.Parent = Tgl
            Instance.new("UICorner", B).CornerRadius = UDim.new(1, 0)

            local enabled = default
            B.MouseButton1Click:Connect(function()
                enabled = not enabled
                TweenService:Create(B, TweenInfo.new(0.2), {BackgroundColor3 = enabled and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(45, 45, 50)}):Play()
                callback(enabled)
            end)
        end

        function Elements:AddSlider(name, min, max, default, callback)
            local Sld = Instance.new("Frame")
            Sld.Size = UDim2.new(1, -5, 0, 58)
            Sld.BackgroundColor3 = Color3.fromRGB(22, 22, 25)
            Sld.Parent = Page
            Instance.new("UICorner", Sld).CornerRadius = UDim.new(0, 8)

            local L = Instance.new("TextLabel")
            L.Text = "  " .. name .. ": " .. default
            L.Size = UDim2.new(1, 0, 0, 30)
            L.TextColor3 = Color3.new(1,1,1)
            L.Font = Enum.Font.GothamSemibold
            L.TextSize = 14
            L.TextXAlignment = "Left"
            L.BackgroundTransparency = 1
            L.Parent = Sld

            local Bar = Instance.new("TextButton")
            Bar.Size = UDim2.new(1, -30, 0, 6)
            Bar.Position = UDim2.new(0, 15, 0, 40)
            Bar.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            Bar.Text = ""
            Bar.Parent = Sld
            Instance.new("UICorner", Bar)
            
            local Fill = Instance.new("Frame")
            Fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
            Fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
            Fill.Parent = Bar
            Instance.new("UICorner", Fill)

            local drag = false
            local function update()
                local p = math.clamp((UIS:GetMouseLocation().X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                local v = math.floor(min + (max - min) * p)
                Fill.Size = UDim2.new(p, 0, 1, 0)
                L.Text = "  " .. name .. ": " .. v
                callback(v)
            end
            Bar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = true end end)
            UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end end)
            UIS.InputChanged:Connect(function(i) if drag and i.UserInputType == Enum.UserInputType.MouseMovement then update() end end)
        end

        return Elements
    end

    -- Перетаскивание
    local dragStart, startPos, dragging
    Main.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true dragStart = i.Position startPos = Main.Position end end)
    UIS.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then 
        local delta = i.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

    return Tabs
end

return Library
