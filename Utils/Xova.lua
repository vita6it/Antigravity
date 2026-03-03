local Library = {}

local Players = game:GetService('Players')
local RunService = game:GetService('RunService')
local UserInputService = game:GetService('UserInputService')
local TweenService = game:GetService('TweenService')
local CoreGui = game:GetService('CoreGui')

local Mobile = if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then true else false

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui

function Library:Parent()
    if not RunService:IsStudio() then
        return (gethui and gethui()) or CoreGui
    end
    return PlayerGui
end

function Library:Create(Class, Properties)
    local Creations = Instance.new(Class)
    for prop, value in Properties do
        Creations[prop] = value
    end
    return Creations
end

function Library:Draggable(a)
    local Dragging, DragInput, DragStart, StartPosition = nil, nil, nil, nil

    local function Update(input)
        local Delta = input.Position - DragStart
        local pos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
        TweenService:Create(a, TweenInfo.new(0.3), {Position = pos}):Play()
    end

    a.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPosition = a.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)

    a.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            Update(input)
        end
    end)
end

function Library:Button(Parent)
    return Library:Create("TextButton", {
        Name = "Click",
        Parent = Parent,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0),
        Font = Enum.Font.SourceSans,
        Text = "",
        TextColor3 = Color3.fromRGB(0, 0, 0),
        TextSize = 14,
        ZIndex = Parent.ZIndex + 3
    })
end

function Library:Tween(info)
    return TweenService:Create(info.v, TweenInfo.new(info.t, Enum.EasingStyle[info.s], Enum.EasingDirection[info.d]), info.g)
end

function Library:Effect(c, p)
    p.ClipsDescendants = true

    local Mouse = LocalPlayer:GetMouse()
    local relativeX = Mouse.X - c.AbsolutePosition.X
    local relativeY = Mouse.Y - c.AbsolutePosition.Y

    if relativeX < 0 or relativeY < 0 or relativeX > c.AbsoluteSize.X or relativeY > c.AbsoluteSize.Y then
        return
    end

    local ClickButtonCircle = Library:Create("Frame", {
        Parent = p,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.95,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0, relativeX, 0, relativeY),
        Size = UDim2.new(0, 0, 0, 0),
        ZIndex = p.ZIndex
    })

    Library:Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = ClickButtonCircle
    })

    local expandTween = TweenService:Create(ClickButtonCircle, TweenInfo.new(2.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, c.AbsoluteSize.X * 1.5, 0, c.AbsoluteSize.X * 1.5),
        BackgroundTransparency = 1
    })

    expandTween.Completed:Connect(function()
        ClickButtonCircle:Destroy()
    end)

    expandTween:Play()
end

function Library:Asset(rbx)
    if typeof(rbx) == 'number' then
        return "rbxassetid://" .. rbx
    end
    if typeof(rbx) == 'string' and rbx:find('rbxassetid://') then
        return rbx
    end
    return rbx
end

local function NewTemplate(p, t, d)
    local Template = Library:Create("Frame", {
        Name = "Template",
        Parent = p,
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        BackgroundTransparency = 0.5,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Size = UDim2.new(0.98, 0, 0, 40)
    })

    Library:Create("UICorner", {
        Parent = Template,
        CornerRadius = UDim.new(0, 3)
    })

    Library:Create("UIStroke", {
        Parent = Template,
        Color = Color3.fromRGB(255, 255, 255),
        Thickness = 0.5,
        Transparency = 0.9
    })

    local Text_1 = Library:Create("Frame", {
        Name = "Text",
        Parent = Template,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(1, 0, 1, 0)
    })

    Library:Create("UIListLayout", {
        Parent = Text_1,
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center
    })

    Library:Create("UIPadding", {
        Parent = Template,
        PaddingLeft = UDim.new(0, 12),
        PaddingRight = UDim.new(0, 10),
        PaddingBottom = UDim.new(0, 2)
    })

    Library:Create("TextLabel", {
        Name = "Title",
        Parent = Text_1,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Size = UDim2.new(0, 200, 0, 14),
        FontFace = Font.new("rbxassetid://12187374537", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
        RichText = true,
        Text = t,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        TextTransparency = 0.3,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = -999
    })

    if d then
        Library:Create("TextLabel", {
            Name = "Desc",
            Parent = Text_1,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 0,
            Size = UDim2.new(0.9, 0, 0, 10),
            FontFace = Font.new("rbxassetid://12187374537", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
            RichText = true,
            TextColor3 = Color3.fromRGB(145, 145, 145),
            TextSize = 10,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            Text = d
        })
    end

    local Scaling_1 = Library:Create("Frame", {
        Name = "Scaling",
        Parent = Template,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0)
    })

    Library:Create("UIListLayout", {
        Parent = Scaling_1,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center
    })

    return Template
end

function Library:Window(options)
    local Title = options.Title or "Xova"
    local SubTitle = options.Desc or "Made by s1nve"

    local SCALER = Mobile and 0.9 or 1.1

    local Xova = Library:Create("ScreenGui", {
        Name = "Xova",
        Parent = Library:Parent(),
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        IgnoreGuiInset = true
    })

    local UIScale_1 = Library:Create("UIScale", {
        Parent = Xova,
        Scale = SCALER
    })

    local Background_1 = Library:Create("Frame", {
        Name = "Background",
        Parent = Xova,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(11, 11, 11),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 500, 0, 350)
    })

    Library:Create("UICorner", {
        Parent = Background_1
    })

    Library:Create("ImageLabel", {
        Name = "Shadow",
        Parent = Background_1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 1,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(1, 120, 1, 120),
        ZIndex = 0,
        Image = "rbxassetid://8992230677",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.5,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(99, 99, 99, 99)
    })

    Library:Create("ImageLabel", {
        Name = "ShadowCorner",
        Parent = Background_1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 1,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, 0, 0.5, 3),
        Size = UDim2.new(1, 24, 1, 24),
        ZIndex = 0,
        Image = "rbxassetid://138260268144845",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.5,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(99, 99, 99, 99)
    })

    -- Toggle UI
    local sToggle = Library:Create("ScreenGui", {
        Name = "Liquid",
        Parent = Library:Parent(),
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        IgnoreGuiInset = true
    })

    local Toggle = Library:Create("ImageLabel", {
        Name = "Toggle",
        Parent = sToggle,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, 0, 0.025, 0),
        Size = UDim2.new(0, 200, 0, 7),
        Image = "rbxassetid://80999662900595",
        ImageTransparency = 0.699999988079071,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(256, 256, 256, 256),
        SliceScale = 0.38671875
    })

    local ToggleInput = Library:Create("TextButton", {
        Name = "Input",
        Parent = Toggle,
        Active = true,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(1, 30, 1, 30),
        Font = Enum.Font.SourceSans,
        Text = "",
        TextSize = 14,
        ZIndex = 99
    })

    ToggleInput.MouseButton1Click:Connect(function()
        Background_1.Visible = not Background_1.Visible
    end)

    -- Header
    local Header = Library:Create("Frame", {
        Name = "Header",
        Parent = Background_1,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 45)
    })

    local Window_1 = Library:Create("Frame", {
        Name = "Window",
        Parent = Header,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0)
    })

    Library:Create("UIListLayout", {
        Parent = Window_1,
        Padding = UDim.new(0, 5),
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center
    })

    Library:Create("UIPadding", {
        Parent = Window_1,
        PaddingLeft = UDim.new(0, 4),
        PaddingRight = UDim.new(0, 5),
        PaddingTop = UDim.new(0, 3)
    })

    local Corner_1 = Library:Create("Frame", {
        Name = "Corner",
        Parent = Window_1,
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = Color3.fromRGB(29, 29, 28),
        BackgroundTransparency = 1,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0.5, 0),
        Size = UDim2.new(1, 0, 0, 40)
    })

    local Info_1 = Library:Create("Frame", {
        Name = "Info",
        Parent = Corner_1,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0)
    })

    Library:Create("UIListLayout", {
        Parent = Info_1,
        Padding = UDim.new(0, 10),
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center
    })

    Library:Create("UIPadding", {
        Parent = Info_1,
        PaddingLeft = UDim.new(0, 10)
    })

    local Text_1 = Library:Create("Frame", {
        Name = "Text",
        Parent = Info_1,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0.1, 0),
        Size = UDim2.new(0, 111, 0, 32)
    })

    Library:Create("UIListLayout", {
        Parent = Text_1,
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center
    })

    Library:Create("TextLabel", {
        Name = "Title",
        Parent = Text_1,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Size = UDim2.new(0, 200, 0, 14),
        FontFace = Font.new("rbxassetid://12187374537", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
        RichText = true,
        Text = Title,
        TextColor3 = Color3.fromRGB(255, 0, 127),
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    Library:Create("TextLabel", {
        Name = "Desc",
        Parent = Text_1,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Size = UDim2.new(0, 200, 0, 10),
        FontFace = Font.new("rbxassetid://12187374537", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
        RichText = true,
        Text = SubTitle,
        TextColor3 = Color3.fromRGB(145, 145, 145),
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    -- Head (right side of header)
    local Head_1 = Library:Create("Frame", {
        Name = "Head",
        Parent = Corner_1,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0)
    })

    Library:Create("UIListLayout", {
        Parent = Head_1,
        Padding = UDim.new(0, 7),
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center
    })

    Library:Create("UIPadding", {
        Parent = Head_1,
        PaddingRight = UDim.new(0, 8)
    })

    local Profile_1 = Library:Create("Frame", {
        Name = "Profile",
        Parent = Head_1,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        LayoutOrder = 995,
        Size = UDim2.new(0, 30, 0, 30)
    })

    local content = Players:GetUserThumbnailAsync(
        LocalPlayer.UserId,
        Enum.ThumbnailType.HeadShot,
        Enum.ThumbnailSize.Size420x420
    )

    local asset_1 = Library:Create("ImageLabel", {
        Name = "asset",
        Parent = Profile_1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.9,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(1, 0, 1, 0),
        Image = content
    })

    Library:Create("UICorner", {
        Parent = asset_1,
        CornerRadius = UDim.new(1, 0)
    })

    local Text_2 = Library:Create("Frame", {
        Name = "Text",
        Parent = Head_1,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0.1, 0),
        Size = UDim2.new(0, 111, 0, 32)
    })

    Library:Create("UIListLayout", {
        Parent = Text_2,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center
    })

    local Title_2 = Library:Create("TextLabel", {
        Name = "Title",
        Parent = Text_2,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Size = UDim2.new(0, 32, 0, 14),
        FontFace = Font.new("rbxassetid://12187374537", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
        RichText = true,
        Text = "Unknown",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 13,
        TextTransparency = 0.15,
        TextXAlignment = Enum.TextXAlignment.Right
    })

    local Desc_2 = Library:Create("TextLabel", {
        Name = "Desc",
        Parent = Text_2,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Size = UDim2.new(0, 32, 0, 10),
        FontFace = Font.new("rbxassetid://12187374537", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
        RichText = true,
        Text = "",
        TextColor3 = Color3.fromRGB(145, 145, 145),
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Right
    })

    local function MaskName(name)
        local s, e = 2, 2
        
        if #name > s + e then
            return string.sub(name, 1, s) .. string.rep("*", #name - s - e) .. string.sub(name, -e)
        end
        
        return name
    end

    Title_2.Text = "@" .. MaskName(LocalPlayer.Name)
    Desc_2.Text = "Expires at " .. "00:00:00"

    local Return_1 = Library:Create("Frame", {
        Name = "Return",
        Parent = Head_1,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.95,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        LayoutOrder = 1000,
        Size = UDim2.new(0, 75, 0, 25),
        Visible = false
    })

    Library:Create("TextLabel", {
        Name = "Title",
        Parent = Return_1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 32, 0, 14),
        FontFace = Font.new("rbxassetid://12187374537", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
        RichText = true,
        Text = "Return",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 13,
        TextTransparency = 0.15
    })

    Library:Create("UIStroke", {
        Parent = Return_1,
        Color = Color3.fromRGB(255, 255, 255),
        Thickness = 0.5,
        Transparency = 0.85
    })

    Library:Create("UICorner", {
        Parent = Return_1,
        CornerRadius = UDim.new(0, 5)
    })

    -- Page layout
    local Scaler = Library:Create("Frame", {
        Name = "Scaler",
        Parent = Background_1,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0)
    })

    Library:Create("UIPadding", {
        Parent = Scaler,
        PaddingBottom = UDim.new(0, 7),
        PaddingLeft = UDim.new(0, 1),
        PaddingRight = UDim.new(0, 1),
        PaddingTop = UDim.new(0, 45)
    })

    local Page_1 = Library:Create("Frame", {
        Name = "Page",
        Parent = Scaler,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(1, 0, 1, 0),
        ClipsDescendants = true
    })

    local UIPageLayout_1 = Library:Create("UIPageLayout", {
        Parent = Page_1,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        TweenTime = 0.5
    })

    -- Main tab container
    local Main = Library:Create("Frame", {
        Name = "Main",
        Parent = Page_1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(1, 0, 1, 0)
    })

    local TabsScrolling_1 = Library:Create("ScrollingFrame", {
        Name = "TabsScrolling",
        Parent = Main,
        Active = true,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0),
        ClipsDescendants = true,
        AutomaticCanvasSize = Enum.AutomaticSize.None,
        BottomImage = "rbxasset://textures/ui/Scroll/scroll-bottom.png",
        CanvasPosition = Vector2.new(0, 0),
        ElasticBehavior = Enum.ElasticBehavior.WhenScrollable,
        MidImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
        ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0),
        ScrollBarImageTransparency = 0,
        ScrollBarThickness = 0,
        ScrollingDirection = Enum.ScrollingDirection.XY,
        TopImage = "rbxasset://textures/ui/Scroll/scroll-top.png",
        VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
    })

    local TabsLayout = Library:Create("UIListLayout", {
        Parent = TabsScrolling_1,
        Padding = UDim.new(0, 5),
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Wraps = true
    })

    Library:Create("UIPadding", {
        Parent = TabsScrolling_1,
        PaddingBottom = UDim.new(0, 5),
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
        PaddingTop = UDim.new(0, 5)
    })

    local Window = {}

    function Window:Tabs(options)
        local Title = options.Title
        local Desc = options.Desc
        local Icon = options.Icon

        local AddTabs = Library:Create("Frame", {
            Name = "AddTabs",
            Parent = TabsScrolling_1,
            BackgroundColor3 = Color3.fromRGB(10, 10, 10),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 0,
            Size = UDim2.new(0, 236, 0, 55)
        })

        Library:Create("UICorner", {
            Parent = AddTabs,
            CornerRadius = UDim.new(0, 5)
        })

        local Banner_1 = Library:Create("ImageLabel", {
            Name = "Banner",
            Parent = AddTabs,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 1, 0),
            Image = "rbxassetid://125411502674016",
            ImageColor3 = Color3.fromRGB(255, 0, 128),
            ScaleType = Enum.ScaleType.Crop
        })

        Library:Create("UICorner", {
            Parent = Banner_1,
            CornerRadius = UDim.new(0, 5)
        })

        local Info_1 = Library:Create("Frame", {
            Name = "Info",
            Parent = AddTabs,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 1, 0)
        })

        Library:Create("UIListLayout", {
            Parent = Info_1,
            Padding = UDim.new(0, 10),
            FillDirection = Enum.FillDirection.Horizontal,
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center
        })

        Library:Create("UIPadding", {
            Parent = Info_1,
            PaddingLeft = UDim.new(0, 15)
        })

        Library:Create("ImageLabel", {
            Name = "Logo",
            Parent = Info_1,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 0,
            LayoutOrder = -1,
            Size = UDim2.new(0, 25, 0, 25),
            Image = Library:Asset(Icon),
            ImageColor3 = Color3.fromRGB(255, 0, 127)
        })

        local Text_1 = Library:Create("Frame", {
            Name = "Text",
            Parent = Info_1,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 0,
            Position = UDim2.new(0.140350878, 0, 0.209090903, 0),
            Size = UDim2.new(0, 150, 0, 32)
        })

        Library:Create("UIListLayout", {
            Parent = Text_1,
            Padding = UDim.new(0, 2),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center
        })

        Library:Create("TextLabel", {
            Name = "Title",
            Parent = Text_1,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 0,
            Size = UDim2.new(0, 150, 0, 14),
            FontFace = Font.new("rbxassetid://12187374537", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
            RichText = true,
            Text = Title,
            TextColor3 = Color3.fromRGB(255, 0, 127),
            TextSize = 18,
            TextXAlignment = Enum.TextXAlignment.Left
        })

        Library:Create("TextLabel", {
            Name = "Desc",
            Parent = Text_1,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 0,
            Size = UDim2.new(0.9, 0, 0, 10),
            FontFace = Font.new("rbxassetid://12187374537", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
            RichText = true,
            Text = Desc,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextTransparency = 0.2,
            TextSize = 10,
            TextXAlignment = Enum.TextXAlignment.Left
        })

        Library:Create("UIStroke", {
            Parent = AddTabs,
            Color = Color3.fromRGB(75, 0, 38),
            Thickness = 1
        })

        local Button = Library:Button(AddTabs)

        local AddPage = Library:Create("Frame", {
            Name = "AddPage",
            Parent = Page_1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 0,
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Size = UDim2.new(1, 0, 1, 0),
            Visible = false
        })

        local Left_1 = Library:Create("ScrollingFrame", {
            Name = "Left",
            Parent = AddPage,
            Active = true,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 1, 0),
            ClipsDescendants = true,
            AutomaticCanvasSize = Enum.AutomaticSize.None,
            BottomImage = "rbxasset://textures/ui/Scroll/scroll-bottom.png",
            CanvasPosition = Vector2.new(0, 0),
            ElasticBehavior = Enum.ElasticBehavior.WhenScrollable,
            MidImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
            ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0),
            ScrollBarImageTransparency = 0,
            ScrollBarThickness = 0,
            ScrollingDirection = Enum.ScrollingDirection.XY,
            TopImage = "rbxasset://textures/ui/Scroll/scroll-top.png",
            VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
        })

        local LeftLayout = Library:Create("UIListLayout", {
            Parent = Left_1,
            Padding = UDim.new(0, 10),
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder
        })

        Library:Create("UIPadding", {
            Parent = Left_1,
            PaddingBottom = UDim.new(0, 1),
            PaddingTop = UDim.new(0, 1)
        })

        Library:Create("UIListLayout", {
            Parent = AddPage,
            FillDirection = Enum.FillDirection.Horizontal,
            SortOrder = Enum.SortOrder.LayoutOrder
        })

        local function updateSizes()
            local scale = UIScale_1.Scale or 1
            Left_1.CanvasSize = UDim2.new(0, 0, 0, (LeftLayout.AbsoluteContentSize.Y + 15) / scale)
        end

        LeftLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateSizes)
        updateSizes()

        local function OnSelectPage()
            for _, v in pairs(Page_1:GetChildren()) do
                if v:IsA("Frame") then
                    v.Visible = false
                end
            end
            Return_1.Visible = true
            AddPage.Visible = true
            UIPageLayout_1:JumpTo(AddPage)
        end

        Button.MouseButton1Click:Connect(OnSelectPage)

        local Section = {}

        function Section:Section(options)
            local Title = options.Title

            local SectionFrame = Library:Create("Frame", {
                Name = "Section",
                Parent = Left_1,
                BackgroundColor3 = Color3.fromRGB(20, 20, 20),
                BorderColor3 = Color3.fromRGB(0, 0, 0),
                BorderSizePixel = 0,
                Size = UDim2.new(0.95, 0, 0, 300)
            })

            Library:Create("UICorner", {
                Parent = SectionFrame,
                CornerRadius = UDim.new(0, 3)
            })

            Library:Create("UIStroke", {
                Parent = SectionFrame,
                Color = Color3.fromRGB(255, 255, 255),
                Thickness = 1,
                Transparency = 0.93
            })

            local SectionLayout = Library:Create("UIListLayout", {
                Parent = SectionFrame,
                Padding = UDim.new(0, 5),
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                SortOrder = Enum.SortOrder.LayoutOrder
            })

            local HeadSection_1 = Library:Create("Frame", {
                Name = "HeadSection",
                Parent = SectionFrame,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 1,
                BorderColor3 = Color3.fromRGB(0, 0, 0),
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 30)
            })

            Library:Create("Frame", {
                Name = "Line",
                Parent = HeadSection_1,
                AnchorPoint = Vector2.new(0, 1),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 0.93,
                BorderColor3 = Color3.fromRGB(0, 0, 0),
                BorderSizePixel = 0,
                Position = UDim2.new(0, 0, 1, 0),
                Size = UDim2.new(1, 0, 0, 1)
            })

            Library:Create("TextLabel", {
                Name = "Title",
                Parent = HeadSection_1,
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 1,
                BorderColor3 = Color3.fromRGB(0, 0, 0),
                BorderSizePixel = 0,
                Position = UDim2.new(0.5, 0, 0.5, 0),
                Size = UDim2.new(0.95, 0, 1, 0),
                FontFace = Font.new("rbxassetid://12187374537", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
                RichText = true,
                Text = Title,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 14,
                TextTransparency = 0.3,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            SectionLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
                local scale = UIScale_1.Scale or 1
                SectionFrame.Size = UDim2.new(0.95, 0, 0, (SectionLayout.AbsoluteContentSize.Y + 5) / scale)
            end)

            local Class = {}

            function Class:Toggle(options)
                local Value = options.Value or false
                local Callback = options.Callback or function(...) return ... end

                local Base = NewTemplate(SectionFrame, options.Title or "???", options.Desc or nil)
                local Button = Library:Button(Base)

                local Background = Library:Create("Frame", {
                    Name = "Background",
                    Parent = Base.Scaling,
                    BackgroundColor3 = Color3.fromRGB(10, 10, 10),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    Size = UDim2.new(0, 20, 0, 20)
                })

                Library:Create("UICorner", {
                    Parent = Background,
                    CornerRadius = UDim.new(0, 5)
                })

                local Highligh_1 = Library:Create("Frame", {
                    Name = "Highligh",
                    Parent = Background,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundColor3 = Color3.fromRGB(255, 0, 127),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    Size = UDim2.new(0, 20, 0, 20)
                })

                Library:Create("UICorner", {
                    Parent = Highligh_1,
                    CornerRadius = UDim.new(0, 5)
                })

                Library:Create("UIGradient", {
                    Parent = Highligh_1,
                    Color = ColorSequence.new{
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(56, 56, 56))
                    },
                    Rotation = 90
                })

                local ImageLabel_1 = Library:Create("ImageLabel", {
                    Parent = Highligh_1,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 1,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    Size = UDim2.new(0.45, 0, 0.45, 0),
                    Image = "rbxassetid://86682186031062"
                })

                local BaseTitle = Base.Text.Title

                local function OnChanged(value)
                    if value then
                        ImageLabel_1.Size = UDim2.new(0.85, 0, 0.85, 0)
                        BaseTitle.TextColor3 = Color3.fromRGB(255, 0, 127)
                        Callback(Value)
                        Library:Tween({ v = Highligh_1, t = 0.5, s = "Exponential", d = "Out", g = { BackgroundTransparency = 0 } }):Play()
                        Library:Tween({ v = ImageLabel_1, t = 0.5, s = "Exponential", d = "Out", g = { ImageTransparency = 0 } }):Play()
                        Library:Tween({ v = ImageLabel_1, t = 0.3, s = "Exponential", d = "Out", g = { Size = UDim2.new(0.5, 0, 0.5, 0) } }):Play()
                    else
                        BaseTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
                        Callback(Value)
                        Library:Tween({ v = Highligh_1, t = 0.5, s = "Exponential", d = "Out", g = { BackgroundTransparency = 1 } }):Play()
                        Library:Tween({ v = ImageLabel_1, t = 0.5, s = "Exponential", d = "Out", g = { ImageTransparency = 1 } }):Play()
                    end
                    Library:Effect(Button, Base)
                end

                local function Init()
                    Value = not Value
                    OnChanged(Value)
                end

                Button.MouseButton1Click:Connect(function()
                    for _, v in pairs(Background_1:GetChildren()) do
                        if v.Name == "Dropdown" and v.Visible then return end
                    end
                    Init()
                end)

                OnChanged(Value)
            end

            function Class:Button(options)
                local Title = options.Title
                local Callback = options.Callback

                local ButtonFrame = Library:Create("Frame", {
                    Name = "Button",
                    Parent = SectionFrame,
                    BackgroundColor3 = Color3.fromRGB(255, 0, 127),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    Size = UDim2.new(0.98, 0, 0, 25)
                })

                Library:Create("UICorner", {
                    Parent = ButtonFrame,
                    CornerRadius = UDim.new(0, 3)
                })

                Library:Create("UIGradient", {
                    Parent = ButtonFrame,
                    Color = ColorSequence.new{
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 60, 60))
                    },
                    Rotation = -90
                })

                Library:Create("TextLabel", {
                    Name = "Title",
                    Parent = ButtonFrame,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 1,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    Size = UDim2.new(0.9, 0, 1, 0),
                    FontFace = Font.new("rbxassetid://12187374537", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
                    RichText = true,
                    Text = Title,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    TextSize = 14,
                    TextTransparency = 0.15,
                    TextStrokeTransparency = 0.7
                })

                local ButtonC = Library:Button(ButtonFrame)

                ButtonC.MouseButton1Click:Connect(function()
                    for _, v in pairs(Background_1:GetChildren()) do
                        if v.Name == "Dropdown" and v.Visible then return end
                    end
                    Callback()
                    Library:Effect(ButtonC, ButtonFrame)
                end)
            end

            function Class:Slider(options)
                local Title = options.Title
                local Min = options.Min or 1
                local Max = options.Max or 10
                local Value = options.Value or Min
                local Rounding = options.Rounding or 0
                local Callback = options.Callback or function(...) return ... end

                local Slider = Library:Create("Frame", {
                    Name = "Slider",
                    Parent = SectionFrame,
                    BackgroundColor3 = Color3.fromRGB(25, 25, 25),
                    BackgroundTransparency = 0.5,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    Size = UDim2.new(0.98, 0, 0, 43)
                })

                Library:Create("UICorner", {
                    Parent = Slider,
                    CornerRadius = UDim.new(0, 3)
                })

                Library:Create("UIStroke", {
                    Parent = Slider,
                    Color = Color3.fromRGB(255, 255, 255),
                    Thickness = 0.5,
                    Transparency = 0.9
                })

                local Text_1 = Library:Create("Frame", {
                    Name = "Text",
                    Parent = Slider,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 1,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 0, 0.1, 0),
                    Size = UDim2.new(0, 111, 0, 22)
                })

                Library:Create("UIListLayout", {
                    Parent = Text_1,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    VerticalAlignment = Enum.VerticalAlignment.Center
                })

                Library:Create("TextLabel", {
                    Name = "Title",
                    Parent = Text_1,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 1,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    Size = UDim2.new(0, 200, 0, 14),
                    FontFace = Font.new("rbxassetid://12187374537", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
                    RichText = true,
                    Text = Title,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    TextSize = 14,
                    TextTransparency = 0.3,
                    TextXAlignment = Enum.TextXAlignment.Left
                })

                Library:Create("UIPadding", {
                    Parent = Slider,
                    PaddingBottom = UDim.new(0, 1),
                    PaddingLeft = UDim.new(0, 10),
                    PaddingRight = UDim.new(0, 10)
                })

                local Scaling_1 = Library:Create("Frame", {
                    Name = "Scaling",
                    Parent = Slider,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 1,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 1, 0)
                })

                local Slide_1 = Library:Create("Frame", {
                    Name = "Slide",
                    Parent = Scaling_1,
                    AnchorPoint = Vector2.new(0, 1),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 1,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 0, 1, 0),
                    Size = UDim2.new(1, 0, 0, 23)
                })

                local ColorBar_1 = Library:Create("Frame", {
                    Name = "ColorBar",
                    Parent = Slide_1,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundColor3 = Color3.fromRGB(10, 10, 10),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    Size = UDim2.new(1, 0, 0, 5)
                })

                Library:Create("UICorner", {
                    Parent = ColorBar_1,
                    CornerRadius = UDim.new(0, 3)
                })

                local ColorBar_2 = Library:Create("Frame", {
                    Name = "ColorBar",
                    Parent = ColorBar_1,
                    BackgroundColor3 = Color3.fromRGB(255, 0, 127),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 0, 5)
                })

                Library:Create("UICorner", {
                    Parent = ColorBar_2,
                    CornerRadius = UDim.new(0, 3)
                })

                Library:Create("UIGradient", {
                    Parent = ColorBar_2,
                    Color = ColorSequence.new{
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(47, 47, 47))
                    },
                    Rotation = 90
                })

                Library:Create("Frame", {
                    Name = "Circle",
                    Parent = ColorBar_2,
                    AnchorPoint = Vector2.new(1, 0.5),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    Position = UDim2.new(1, 0, 0.5, 0),
                    Size = UDim2.new(0, 5, 0, 11)
                })

                local Boxvalue_1 = Library:Create("TextBox", {
                    Name = "Boxvalue",
                    Parent = Scaling_1,
                    Active = true,
                    AnchorPoint = Vector2.new(1, 0.5),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 1,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    Position = UDim2.new(1, -5, 0.449, -2),
                    Size = UDim2.new(0, 60, 0, 19),
                    FontFace = Font.new("rbxassetid://12187374537", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
                    PlaceholderText = "",
                    Text = tostring(Value),
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    TextSize = 11,
                    TextTransparency = 0.5,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    TextTruncate = Enum.TextTruncate.AtEnd
                })

                local function roundToDecimal(value, decimals)
                    local factor = 10 ^ decimals
                    return math.floor(value * factor + 0.5) / factor
                end

                local function updateSlider(value)
                    value = math.clamp(value, Min, Max)
                    value = roundToDecimal(value, Rounding)
                    Library:Tween({ v = ColorBar_2, t = 0.5, s = "Exponential", d = "Out", g = { Size = UDim2.new((value - Min) / (Max - Min), 0, 1, 0) } }):Play()

                    local startValue = tonumber(Boxvalue_1.Text) or 0
                    local steps = 5
                    local currentValue = startValue
                    for i = 1, steps do
                        task.wait(0.01 / steps)
                        currentValue = currentValue + (value - startValue) / steps
                        Boxvalue_1.Text = tostring(roundToDecimal(currentValue, Rounding))
                    end
                    Boxvalue_1.Text = tostring(roundToDecimal(value, Rounding))
                    Callback(value)
                end

                updateSlider(Value or 0)

                local function move(input)
                    local relativeX = math.clamp((input.Position.X - ColorBar_1.AbsolutePosition.X) / ColorBar_1.AbsoluteSize.X, 0, 1)
                    updateSlider(relativeX * (Max - Min) + Min)
                end

                local dragging = false
                local Button = Library:Button(Slider)
                Boxvalue_1.ZIndex = Button.ZIndex + 1

                Boxvalue_1.FocusLost:Connect(function()
                    updateSlider(tonumber(Boxvalue_1.Text) or Min)
                end)

                Button.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        for _, v in pairs(Background_1:GetChildren()) do
                            if v.Name == "Dropdown" and v.Visible then return end
                        end
                        dragging = true
                        move(input)
                    end
                end)

                Button.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                    end
                end)

                UserInputService.InputChanged:Connect(function(input)
                    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        move(input)
                    end
                end)
            end

            function Class:Textbox(options)
                local Callback = options.Callback

                local Template = Library:Create("Frame", {
                    Name = "Template",
                    Parent = SectionFrame,
                    BackgroundColor3 = Color3.fromRGB(15, 15, 15),
                    BackgroundTransparency = 0.5,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    Size = UDim2.new(0.98, 0, 0, 25),
                    ClipsDescendants = true
                })

                Library:Create("UICorner", {
                    Parent = Template,
                    CornerRadius = UDim.new(0, 3)
                })

                Library:Create("UIStroke", {
                    Parent = Template,
                    Color = Color3.fromRGB(255, 255, 255),
                    Thickness = 0.5,
                    Transparency = 0.9
                })

                Library:Create("UIPadding", {
                    Parent = Template,
                    PaddingLeft = UDim.new(0, 15),
                    PaddingRight = UDim.new(0, 10)
                })

                local TextBox_1 = Library:Create("TextBox", {
                    Parent = Template,
                    Active = true,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 1,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    CursorPosition = -1,
                    Size = UDim2.new(1, 0, 1, 0),
                    FontFace = Font.new("rbxassetid://12187374537", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
                    PlaceholderColor3 = Color3.fromRGB(178, 178, 178),
                    PlaceholderText = "...",
                    Text = tostring(options.Text),
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    TextSize = 12,
                    TextTransparency = 0.5,
                    TextTruncate = Enum.TextTruncate.AtEnd
                })

                TextBox_1.FocusLost:Connect(function()
                    Callback(TextBox_1.Text)
                end)
            end

            function Class:Label(options)
                local Template = NewTemplate(SectionFrame, options.Title, options.Desc or nil)
                local BaseTitle = Template.Text.Title
                local BaseDesc = Template.Text.Desc

                local attribute = {}
                function attribute:Title(t) BaseTitle.Text = tostring(t) end
                function attribute:Sub(t) BaseDesc.Text = tostring(t) end
                return attribute
            end

            function Class:Line()
                return Library:Create("Frame", {
                    Name = "Line",
                    Parent = SectionFrame,
                    AnchorPoint = Vector2.new(0, 1),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 0.93,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 0, 1, 0),
                    Size = UDim2.new(1, 0, 0, 1)
                })
            end

            function Class:List(options)
                local Title = options.Title or "Title"
                local List = options.List or {}
                local Value = options.Value or List[1] or "N/A"
                local Multi = options.Multi or false
                local Callback = options.Callback or function(...) return ... end

                local Template = Library:Create("Frame", {
                    Name = "Template",
                    Parent = SectionFrame,
                    BackgroundColor3 = Color3.fromRGB(25, 25, 25),
                    BackgroundTransparency = 0.5,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    Size = UDim2.new(0.98, 0, 0, 40),
                    ClipsDescendants = true
                })

                Library:Create("UICorner", {
                    Parent = Template,
                    CornerRadius = UDim.new(0, 3)
                })

                Library:Create("UIStroke", {
                    Parent = Template,
                    Color = Color3.fromRGB(255, 255, 255),
                    Thickness = 0.5,
                    Transparency = 0.9
                })

                local Text_1 = Library:Create("Frame", {
                    Name = "Text",
                    Parent = Template,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 1,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 1, 0)
                })

                Library:Create("UIListLayout", {
                    Parent = Text_1,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    VerticalAlignment = Enum.VerticalAlignment.Center
                })

                Library:Create("TextLabel", {
                    Name = "Title",
                    Parent = Text_1,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 1,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    Size = UDim2.new(0, 200, 0, 14),
                    FontFace = Font.new("rbxassetid://12187374537", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
                    RichText = true,
                    Text = Title,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    TextSize = 14,
                    TextTransparency = 0.3,
                    TextXAlignment = Enum.TextXAlignment.Left
                })

                local Desc_1 = Library:Create("TextLabel", {
                    Name = "Desc",
                    Parent = Text_1,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 1,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    Size = UDim2.new(0.9, 0, 0, 10),
                    FontFace = Font.new("rbxassetid://12187374537", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
                    RichText = true,
                    TextColor3 = Color3.fromRGB(145, 145, 145),
                    TextSize = 10,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    Text = ""
                })

                local function Settext()
                    if typeof(Value) == 'table' then
                        Desc_1.Text = table.concat(Value, ", ")
                    else
                        Desc_1.Text = tostring(Value)
                    end
                end

                Settext()

                Library:Create("UIPadding", {
                    Parent = Template,
                    PaddingBottom = UDim.new(0, 2),
                    PaddingLeft = UDim.new(0, 12),
                    PaddingRight = UDim.new(0, 10)
                })

                local Scaling_1 = Library:Create("Frame", {
                    Name = "Scaling",
                    Parent = Template,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 1,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 1, 0)
                })

                Library:Create("UIListLayout", {
                    Parent = Scaling_1,
                    HorizontalAlignment = Enum.HorizontalAlignment.Right,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    VerticalAlignment = Enum.VerticalAlignment.Center
                })

                Library:Create("ImageLabel", {
                    Parent = Scaling_1,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 1,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    Size = UDim2.new(0, 20, 0, 20),
                    Image = "rbxassetid://132291592681506",
                    ImageTransparency = 0.5
                })

                local Button = Library:Button(Template)

                -- Dropdown
                local Dropdown = Library:Create("Frame", {
                    Name = "Dropdown",
                    Parent = Background_1,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundColor3 = Color3.fromRGB(15, 15, 15),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    Position = UDim2.new(0.5, 0, 0.35, 0),
                    Size = UDim2.new(0, 200, 0, 250),
                    ZIndex = 56,
                    Visible = false
                })

                Library:Create("UIStroke", {
                    Parent = Dropdown,
                    Color = Color3.fromRGB(255, 255, 255),
                    Thickness = 1,
                    Transparency = 0.9
                })

                Library:Create("UICorner", {
                    Parent = Dropdown,
                    CornerRadius = UDim.new(0, 3)
                })

                Library:Create("ImageLabel", {
                    Name = "Shadow",
                    Parent = Dropdown,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                    BackgroundTransparency = 1,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    Size = UDim2.new(1, 120, 1, 120),
                    Image = "rbxassetid://8992230677",
                    ImageColor3 = Color3.fromRGB(0, 0, 0),
                    ScaleType = Enum.ScaleType.Slice,
                    SliceCenter = Rect.new(99, 99, 99, 99)
                })

                local Scaler_1 = Library:Create("Frame", {
                    Name = "Scaler",
                    Parent = Dropdown,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 1,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 1, 0),
                    ZIndex = 56
                })

                local Search_1 = Library:Create("Frame", {
                    Name = "Search",
                    Parent = Scaler_1,
                    BackgroundColor3 = Color3.fromRGB(10, 10, 10),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 0, 20),
                    ZIndex = 56
                })

                Library:Create("UIStroke", {
                    Parent = Search_1,
                    Color = Color3.fromRGB(255, 255, 255),
                    Thickness = 0.5,
                    Transparency = 0.9
                })

                Library:Create("UICorner", {
                    Parent = Search_1,
                    CornerRadius = UDim.new(0, 3)
                })

                local TextBox_1 = Library:Create("TextBox", {
                    Parent = Search_1,
                    Active = true,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 1,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 1, 0),
                    ZIndex = 56,
                    FontFace = Font.new("rbxassetid://12187374537", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
                    PlaceholderColor3 = Color3.fromRGB(178, 178, 178),
                    PlaceholderText = "Search",
                    Text = "",
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    TextSize = 12,
                    TextTransparency = 0.5
                })

                Library:Create("UIListLayout", {
                    Parent = Scaler_1,
                    Padding = UDim.new(0, 5),
                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Library:Create("UIPadding", {
                    Parent = Scaler_1,
                    PaddingBottom = UDim.new(0, 5),
                    PaddingLeft = UDim.new(0, 5),
                    PaddingRight = UDim.new(0, 5),
                    PaddingTop = UDim.new(0, 5)
                })

                local Scrolling_1 = Library:Create("ScrollingFrame", {
                    Name = "Scrolling",
                    Parent = Scaler_1,
                    Active = true,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 1,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 0, 215),
                    ZIndex = 56,
                    ClipsDescendants = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.None,
                    BottomImage = "rbxasset://textures/ui/Scroll/scroll-bottom.png",
                    CanvasPosition = Vector2.new(0, 0),
                    ElasticBehavior = Enum.ElasticBehavior.WhenScrollable,
                    MidImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
                    ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0),
                    ScrollBarImageTransparency = 0,
                    ScrollBarThickness = 0,
                    ScrollingDirection = Enum.ScrollingDirection.XY,
                    TopImage = "rbxasset://textures/ui/Scroll/scroll-top.png",
                    VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
                })

                local ScrollLayout = Library:Create("UIListLayout", {
                    Parent = Scrolling_1,
                    Padding = UDim.new(0, 3),
                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                ScrollLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
                    Scrolling_1.CanvasSize = UDim2.new(0, 0, 0, (ScrollLayout.AbsoluteContentSize.Y + 15 / UIScale_1.Scale))
                end)

                local isOpen = false

                UserInputService.InputBegan:Connect(function(A)
                    local mouse = LocalPlayer:GetMouse()
                    local mx, my = mouse.X, mouse.Y
                    local DBP, DBS = Dropdown.AbsolutePosition, Dropdown.AbsoluteSize

                    if A.UserInputType == Enum.UserInputType.MouseButton1 or A.UserInputType == Enum.UserInputType.Touch then
                        if not (mx >= DBP.X and mx <= DBP.X + DBS.X and my >= DBP.Y and my <= DBP.Y + DBS.Y) then
                            isOpen = false
                            Dropdown.Visible = false
                            Dropdown.Position = UDim2.new(0.5, 0, 0.35, 0)
                        end
                    end
                end)

                Button.MouseButton1Click:Connect(function()
                    for _, v in pairs(Background_1:GetChildren()) do
                        if v.Name == "Dropdown" and v.Visible then return end
                    end

                    isOpen = not isOpen
                    Library:Effect(Button, Template)

                    if isOpen then
                        Dropdown.Visible = true
                        Library:Tween({ v = Dropdown, t = 0.3, s = "Back", d = "Out", g = { Position = UDim2.new(0.5, 0, 0.5, 0) } }):Play()
                    else
                        Dropdown.Visible = false
                        Dropdown.Position = UDim2.new(0.5, 0, 0.3, 0)
                    end
                end)

                TextBox_1.Changed:Connect(function()
                    local SearchT = string.lower(TextBox_1.Text)
                    for _, v in pairs(Scrolling_1:GetChildren()) do
                        if v:IsA("Frame") and v.Name == 'AddList' then
                            v.Visible = string.find(string.lower(v.Title.Text), SearchT, 1, true) ~= nil
                        end
                    end
                end)

                local selectedValues = {}

                local function isValueInTable(val, tbl)
                    if type(tbl) ~= "table" then return false end
                    for _, v in pairs(tbl) do
                        if v == val then return true end
                    end
                    return false
                end

                local Setting = {}

                function Setting:Clear(a)
                    for _, v in ipairs(Scrolling_1:GetChildren()) do
                        if v:IsA("Frame") then
                            local shouldClear = a == nil
                                or (type(a) == "string" and v.Title.Text == a)
                                or (type(a) == "table" and isValueInTable(v.Title.Text, a))

                            if shouldClear then
                                v:Destroy()
                            end
                        end
                    end

                    if a == nil then
                        Value = nil
                        Desc_1.Text = "N/A"
                    end
                end

                function Setting:AddList(Name)
                    local AddList = Library:Create("Frame", {
                        Name = "AddList",
                        Parent = Scrolling_1,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        BackgroundTransparency = 1,
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        BorderSizePixel = 0,
                        Size = UDim2.new(1, 0, 0, 25),
                        ZIndex = 56
                    })

                    local Click = Library:Button(AddList)

                    Library:Create("UICorner", {
                        Parent = AddList,
                        CornerRadius = UDim.new(0, 3)
                    })

                    local Title_1: TextLabel = Library:Create("TextLabel", {
                        Name = "Title",
                        Parent = AddList,
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        BackgroundTransparency = 1,
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        BorderSizePixel = 0,
                        Position = UDim2.new(0.5, 0, 0.5, 0),
                        Size = UDim2.new(0.9, 0, 1, 0),
                        ZIndex = 56,
                        FontFace = Font.new("rbxassetid://12187374537", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
                        RichText = true,
                        Text = Name,
                        TextColor3 = Color3.fromRGB(255, 255, 255),
                        TextSize = 13,
                        TextTransparency = 0.3
                    })

                    Library:Create("Frame", {
                        Name = "Line",
                        Parent = AddList,
                        AnchorPoint = Vector2.new(0.5, 1),
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        BackgroundTransparency = 0.93,
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        BorderSizePixel = 0,
                        Position = UDim2.new(0.5, 0, 1, 0),
                        Size = UDim2.new(0, Title_1.TextBounds.X + 10, 0, 1),
                        ZIndex = 56
                    })

                    local function OnValue(value)
                        Title_1.TextColor3 = value and Color3.fromRGB(255, 0, 127) or Color3.fromRGB(255, 255, 255)
                    end

                    local function OnSelected()
                        if Multi then
                            if selectedValues[Name] then
                                selectedValues[Name] = nil
                                OnValue(false)
                            else
                                selectedValues[Name] = true
                                OnValue(true)
                            end

                            local selectedList = {}
                            for i in pairs(selectedValues) do table.insert(selectedList, i) end

                            if #selectedList > 0 then
                                table.sort(selectedList)
                                Value = selectedList
                                Settext()
                            else
                                Desc_1.Text = "N/A"
                            end

                            pcall(Callback, selectedList)
                        else
                            for _, v in pairs(Scrolling_1:GetChildren()) do
                                if v:IsA("Frame") and v.Name == 'AddList' then
                                    v.Title.TextColor3 = Color3.fromRGB(255, 255, 255)
                                end
                            end
                            OnValue(true)
                            Value = Name
                            Settext()
                            pcall(Callback, Value)
                        end
                    end

                    delay(0, function()
                        if Multi then
                            if isValueInTable(Name, Value) then
                                selectedValues[Name] = true
                                OnValue(true)
                                local selectedList = {}
                                for i in pairs(selectedValues) do table.insert(selectedList, i) end
                                if #selectedList > 0 then Settext() else Desc_1.Text = "N/A" end
                                pcall(Callback, selectedList)
                            end
                        else
                            if Name == Value then
                                OnValue(true)
                                Settext()
                                pcall(Callback, Value)
                            end
                        end
                    end)

                    Click.MouseButton1Click:Connect(OnSelected)
                end

                for _, name in ipairs(List) do
                    Setting:AddList(name)
                end

                return Setting
            end

            return Class
        end

        return Section
    end

    -- Return button
    local ClicKReturn = Library:Button(Return_1)
    
    ClicKReturn.MouseButton1Click:Connect(function()
        Return_1.Visible = false
        for _, v in pairs(Page_1:GetChildren()) do
            if v:IsA("Frame") then v.Visible = false end
        end
        Main.Visible = true
        UIPageLayout_1:JumpTo(Main)
    end)

    Library:Draggable(Background_1)

    TabsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabsScrolling_1.CanvasSize = UDim2.new(0, 0, 0, (TabsLayout.AbsoluteContentSize.Y + 30 / UIScale_1.Scale))
    end)

    UIPageLayout_1:JumpTo(Main)

    local Large = 1.1
    local Medium = 0.945
    local Small = 0.875

    local function TweenScale(size)
        local target = size == "Large" and Large or size == "Medium" and Medium or Small
        SCALER = target
        Library:Tween({ v = UIScale_1, t = 0.3, s = "Back", d = "Out", g = { Scale = SCALER } }):Play()
    end

    function Window:Size(tab)
        return tab:List({
            Title = 'Interface Size',
            List = {"Large", "Medium", "Small"},
            Value = "Medium",
            Multi = false,
            Callback = TweenScale,
        })
    end
    
    function Window:SetExpires(Time)
        Desc_2.Text = "Expires at " .. Time
    end

    return Window
end

return Library
