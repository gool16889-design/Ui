local Library = {}

local targetParent = (gethui and gethui()) or game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

function Library:CreateWindow(hubName)
    if targetParent:FindFirstChild("ModernCheatHub") then
        targetParent.ModernCheatHub:Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ModernCheatHub"
    ScreenGui.Parent = targetParent
    ScreenGui.IgnoreGuiInset = true

    local Main = Instance.new("CanvasGroup")
    Main.Name = "Main"
    Main.Size = UDim2.new(0, 580, 0, 420)
    Main.Position = UDim2.new(0.5, -290, 0.5, 600) 
    Main.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
    Main.BorderSizePixel = 0
    Main.GroupTransparency = 1
    Main.Parent = ScreenGui
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14)

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

    local Logo = Instance.new("TextLabel")
    Logo.Text = hubName
    Logo.RichText = true
    Logo.Size = UDim2.new(1, 0, 0, 60)
    Logo.BackgroundTransparency = 1
    Logo.TextColor3 = Color3.new(1, 1, 1)
    Logo.Font = Enum.Font.GothamBold
    Logo.TextSize = 20
    Logo.Parent = Sidebar

    local Pages = Instance.new("Frame")
    Pages.Size = UDim2.new(1, -200, 1, -40)
    Pages.Position = UDim2.new(0, 185, 0, 20)
    Pages.BackgroundTransparency = 1
    Pages.Parent = Main

    -- Драг-система
    local dStart, sPos, dragging
    Main.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true dStart = i.Position sPos = Main.Position end end)
    UIS.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then 
        local delta = i.Position - dStart
        Main.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + delta.X, sPos.Y.Scale, sPos.Y.Offset + delta.Y)
    end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

    -- Анимация
    TweenService:Create(Main, TweenInfo.new(0.8, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -290, 0.5, -210),
        GroupTransparency = 0
    }):Play()

    local Tabs = {}
    function Tabs:CreateTab(name, isDefault)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(0, 140, 0, 38)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = name
        TabBtn.TextColor3 = isDefault and Color3.new(1, 1, 1) or Color3.fromRGB(160, 160, 160)
        TabBtn.Font = Enum.Font.GothamBold
        TabBtn.TextSize = 14
        TabBtn.Parent = TabContainer

        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = isDefault
        Page.ScrollBarThickness = 0
        Page.Parent = Pages
        Instance.new("UIListLayout", Page).Padding = UDim.new(0, 10)

        TabBtn.MouseButton1Click:Connect(function()
            for _, p in pairs(Pages:GetChildren()) do p.Visible = false end
            for _, t in pairs(TabContainer:GetChildren()) do if t:IsA("TextButton") then t.TextColor3 = Color3.fromRGB(160, 160, 160) end end
            Page.Visible = true
            TabBtn.TextColor3 = Color3.new(1, 1, 1)
        end)

        local Elements = {}
        
        function Elements:AddButton(name, desc, callback)
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, -10, 0, 58)
            Btn.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
            Btn.Text = ""
            Btn.Parent = Page
            Instance.new("UICorner", Btn)
            
            local T = Instance.new("TextLabel")
            T.Text = name
            T.Size = UDim2.new(1, -20, 0, 25)
            T.Position = UDim2.new(0, 15, 0, 10)
            T.TextColor3 = Color3.new(1, 1, 1)
            T.Font = Enum.Font.GothamBold
            T.TextSize = 16
            T.BackgroundTransparency = 1
            T.TextXAlignment = Enum.TextXAlignment.Left
            T.Parent = Btn

            Btn.MouseButton1Click:Connect(callback)
        end

        function Elements:AddToggle(name, default, callback)
            local Tgl = Instance.new("Frame")
            Tgl.Size = UDim2.new(1, -10, 0, 48)
            Tgl.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
            Tgl.Parent = Page
            Instance.new("UICorner", Tgl)

            local L = Instance.new("TextLabel")
            L.Text = name
            L.Size = UDim2.new(1, 0, 1, 0)
            L.Position = UDim2.new(0, 15, 0, 0)
            L.TextColor3 = Color3.new(1, 1, 1)
            L.Font = Enum.Font.GothamSemibold
            L.TextSize = 15
            L.BackgroundTransparency = 1
            L.TextXAlignment = Enum.TextXAlignment.Left
            L.Parent = Tgl

            local B = Instance.new("TextButton")
            B.Size = UDim2.new(0, 40, 0, 22)
            B.Position = UDim2.new(1, -55, 0.5, -11)
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

        return Elements
    end
    return Tabs
end

return Library
