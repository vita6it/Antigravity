local Components = {}

local UserInputService = game:GetService('UserInputService')

Components.ClassButton = {
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 1, 0),
    Text = ""
}

function Components:Button(Parent)
    local TextButton = Instance.new("TextButton")

    for index, value in self.ClassButton do
        TextButton[index] = value
    end

    TextButton.Parent = Parent
    TextButton.ZIndex = Parent.ZIndex + 3

    return TextButton
end

function Components:Draggable(frame, gui)
    local isDragging = false
    local dragStart
    local startPosition

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then

            isDragging = true

            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragStart = UserInputService:GetMouseLocation()
            else
                dragStart = input.Position
            end

            startPosition = gui.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    isDragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if isDragging and
            (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then

            local currentPosition

            if input.UserInputType == Enum.UserInputType.MouseMovement then
                currentPosition = UserInputService:GetMouseLocation()
            else
                currentPosition = input.Position
            end

            local delta = currentPosition - dragStart

            gui.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale,
                startPosition.Y.Offset + delta.Y)
        end
    end)
end

Components.Antigravity = function(self)
    local Toggle = {}

    local Antigravity = Instance.new("ScreenGui")
    local Background_1 = Instance.new("Frame")
    local UICorner_1 = Instance.new("UICorner")
    local Asset_1 = Instance.new("ImageLabel")
    local Button = self:Button(Background_1)

    Antigravity.Name = "Antigravity"
    Antigravity.Parent = game:GetService('CoreGui')
    Antigravity.ZIndexBehavior = Enum.ZIndexBehavior.Global
    Antigravity.IgnoreGuiInset = true

    Background_1.Name = "Background"
    Background_1.Parent = Antigravity
    Background_1.AnchorPoint = Vector2.new(0.5, 0.5)
    Background_1.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Background_1.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Background_1.BorderSizePixel = 0
    Background_1.Position = UDim2.new(0.1, 0, 0.25, 0)
    Background_1.Size = UDim2.new(0, 60, 0, 60)

    UICorner_1.Parent = Background_1
    UICorner_1.CornerRadius = UDim.new(1, 0)

    Asset_1.Name = "Asset"
    Asset_1.Parent = Background_1
    Asset_1.AnchorPoint = Vector2.new(0.5, 0.5)
    Asset_1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Asset_1.BackgroundTransparency = 1
    Asset_1.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Asset_1.BorderSizePixel = 0
    Asset_1.Position = UDim2.new(0.5, 0, 0.5, 0)
    Asset_1.Size = UDim2.new(0.5, 0, 0.5, 0)
    Asset_1.Image = "rbxassetid://98821199435102"

    function Toggle:SetColor(Colors)
        Background_1.BackgroundColor3 = Colors
    end

    function Toggle:Callback(Action)
        return Button.MouseButton1Click:Connect(Action)
    end

    do
        self:Draggable(Button, Background_1)
    end

    return Toggle
end

return Components
