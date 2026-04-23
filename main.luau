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
    Main.Size = UDim2.new(0, 580, 0, 420)
    Main.Position = UDim2.new(0.5, -290, 0.5, 600)
    Main.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
    Main.GroupTransparency = 1
    Main.Parent = ScreenGui
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14)

    -- Сайдбар и Контейнеры (сокращено для ясности)
    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 170, 1, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    Sidebar.Parent = Main
    Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 14)

    local TabContainer = Instance.new("Frame")
    TabContainer.Size = UDim2.new(1, 0, 1, -130)
    TabContainer.Position = UDim2.new(0, 0, 0, 70)
    TabContainer.BackgroundTransparency = 1
    TabContainer.Parent = Sidebar
    Instance.new("UIListLayout", TabContainer).HorizontalAlignment = Enum.HorizontalAlignment.Center

    local Pages = Instance.new("Frame")
    Pages.Size = UDim2.new(1, -200, 1, -40)
    Pages.Position = UDim2.new(0, 185, 0, 20)
    Pages.BackgroundTransparency = 1
    Pages.Parent = Main

    TweenService:Create(Main, TweenInfo.new(0.8, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -290, 0.5, -210),
        GroupTransparency = 0
    }):Play()

    local Tabs = {}
    function Tabs:CreateTab(name, isDefault)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(0, 140, 0, 38)
        TabBtn.Text = name
        TabBtn.Parent = TabContainer

        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.Visible = isDefault
        Page.BackgroundTransparency = 1
        Page.ScrollBarThickness = 0
        Page.Parent = Pages
        Instance.new("UIListLayout", Page).Padding = UDim.new(0, 10)

        TabBtn.MouseButton1Click:Connect(function()
            for _, p in pairs(Pages:GetChildren()) do p.Visible = false end
            Page.Visible = true
        end)

        local Elements = {}

        -- МЕТОД КНОПКИ
        function Elements:AddButton(name, desc, callback)
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, -10, 0, 50)
            Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
            Btn.Text = name
            Btn.TextColor3 = Color3.new(1,1,1)
            Btn.Parent = Page
            Instance.new("UICorner", Btn)
            Btn.MouseButton1Click:Connect(callback)
        end

        -- МЕТОД ТУГЛА
        function Elements:AddToggle(name, default, callback)
            local Tgl = Instance.new("Frame")
            Tgl.Size = UDim2.new(1, -10, 0, 45)
            Tgl.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
            Tgl.Parent = Page
            Instance.new("UICorner", Tgl)

            local B = Instance.new("TextButton")
            B.Size = UDim2.new(0, 35, 0, 20)
            B.Position = UDim2.new(1, -45, 0.5, -10)
            B.BackgroundColor3 = default and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(50, 50, 55)
            B.Text = ""
            B.Parent = Tgl

            local enabled = default
            B.MouseButton1Click:Connect(function()
                enabled = not enabled
                B.BackgroundColor3 = enabled and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(50, 50, 55)
                callback(enabled)
            end)
        end

        -- МЕТОД СЛАЙДЕРА (ТО ЧТО ОТСУТСТВОВАЛО)
        function Elements:AddSlider(name, min, max, default, callback)
            local Sld = Instance.new("Frame")
            Sld.Size = UDim2.new(1, -10, 0, 55)
            Sld.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
            Sld.Parent = Page
            Instance.new("UICorner", Sld)

            local L = Instance.new("TextLabel")
            L.Text = name .. ": " .. default
            L.Size = UDim2.new(1, -20, 0, 25)
            L.Position = UDim2.new(0, 15, 0, 5)
            L.TextColor3 = Color3.new(1,1,1)
            L.BackgroundTransparency = 1
            L.Parent = Sld

            local Bar = Instance.new("TextButton")
            Bar.Size = UDim2.new(1, -30, 0, 6)
            Bar.Position = UDim2.new(0, 15, 0, 35)
            Bar.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
            Bar.Text = ""
            Bar.Parent = Sld

            local Fill = Instance.new("Frame")
            Fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
            Fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
            Fill.BorderSizePixel = 0
            Fill.Parent = Bar

            local drag = false
            local function update()
                local p = math.clamp((UIS:GetMouseLocation().X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                local v = math.floor(min + (max - min) * p)
                Fill.Size = UDim2.new(p, 0, 1, 0)
                L.Text = name .. ": " .. v
                callback(v)
            end
            Bar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = true end end)
            UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end end)
            UIS.InputChanged:Connect(function(i) if drag and i.UserInputType == Enum.UserInputType.MouseMovement then update() end end)
        end

        -- МЕТОД ДРОПДАУНА
        function Elements:AddDropdown(name, list, callback)
            local DFrame = Instance.new("Frame")
            DFrame.Size = UDim2.new(1, -10, 0, 40)
            DFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
            DFrame.ClipsDescendants = true
            DFrame.Parent = Page
            Instance.new("UICorner", DFrame)

            local B = Instance.new("TextButton")
            B.Size = UDim2.new(1, 0, 0, 40)
            B.BackgroundTransparency = 1
            B.Text = "  " .. name
            B.TextColor3 = Color3.new(1,1,1)
            B.TextXAlignment = Enum.TextXAlignment.Left
            B.Parent = DFrame

            local open = false
            B.MouseButton1Click:Connect(function()
                open = not open
                DFrame:TweenSize(open and UDim2.new(1, -10, 0, 40 + (#list * 25)) or UDim2.new(1, -10, 0, 40), "Out", "Quart", 0.3, true)
            end)

            for i, v in pairs(list) do
                local opt = Instance.new("TextButton")
                opt.Size = UDim2.new(1, 0, 0, 25)
                opt.Position = UDim2.new(0, 0, 0, 40 + (i-1)*25)
                opt.Text = v
                opt.Parent = DFrame
                opt.MouseButton1Click:Connect(function()
                    B.Text = "  " .. name .. ": " .. v
                    open = false
                    DFrame:TweenSize(UDim2.new(1, -10, 0, 40), "Out", "Quart", 0.3, true)
                    callback(v)
                end)
            end
        end

        return Elements
    end
    return Tabs
end

return Library
