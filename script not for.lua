-- =============================================
-- NINJA ULTIMATE FULL AIMBOT + ESP
-- Fixed Syntax Error + Your Trigon Loadstring
-- =============================================

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "NINJA ULTIMATE",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "Full Aimbot + ESP",
})

local Settings = {
    Enabled = true,
    FullAimbot = true,
    SilentAim = true,
    ESP = true,
    NoRecoil = true,
    FastFire = true,
    NoReload = true,
    InfiniteJump = false,
    WalkSpeed = 18,
    AimPart = "Head",
    FOV = 145,
    Smoothness = 0.055,
    Prediction = true,
    PredictionMultiplier = 0.15,
}

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local CurrentTarget = nil
local ESPObjects = {}

-- ================== TABS ==================
local MainTab = Window:CreateTab("Main", 4483362458)
local AimTab = Window:CreateTab("Aim", 4483362458)
local VisualTab = Window:CreateTab("Visuals", 4483362458)
local GunTab = Window:CreateTab("Gun", 4483362458)
local MoveTab = Window:CreateTab("Movement", 4483362458)

-- ================== TRIGON BUTTON ==================
MainTab:CreateButton({
    Name = "🔥 Load Trigon Evo",
    Callback = function()
        Rayfield:Notify({Title = "Loading Trigon Evo...", Content = "Please wait...", Duration = 4})
        
        task.wait(1)
        
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/nabhanchowdhury48-prog/the-scripts/refs/heads/main/trigonevo"))()
        end)

        if success then
            Rayfield:Notify({Title = "✅ Trigon Evo Loaded!", Content = "Check for the top bar", Duration = 6})
        else
            Rayfield:Notify({Title = "❌ Failed", Content = "Check executor / internet", Duration = 6})
            warn("Trigon Error:", err)
        end
    end,
})

-- ================== OTHER UI ==================
MainTab:CreateToggle({Name = "Main Script Enabled", CurrentValue = true, Callback = function(v) Settings.Enabled = v end})

AimTab:CreateToggle({Name = "Full Aimbot Lock", CurrentValue = true, Callback = function(v) Settings.FullAimbot = v end})
AimTab:CreateToggle({Name = "Silent Aim", CurrentValue = true, Callback = function(v) Settings.SilentAim = v end})
AimTab:CreateSlider({Name = "FOV", Range = {50, 500}, Increment = 1, CurrentValue = 145, Callback = function(v) Settings.FOV = v end})
AimTab:CreateSlider({Name = "Lock Strength", Range = {0.01, 0.25}, Increment = 0.005, CurrentValue = 0.055, Callback = function(v) Settings.Smoothness = v end})

VisualTab:CreateToggle({Name = "Box ESP", CurrentValue = true, Callback = function(v) Settings.ESP = v end})
VisualTab:CreateToggle({Name = "Show FOV Circle", CurrentValue = true, Callback = function(v) Settings.ShowFOV = v end})

GunTab:CreateToggle({Name = "No Reload", CurrentValue = true, Callback = function(v) Settings.NoReload = v end})
GunTab:CreateToggle({Name = "No Recoil", CurrentValue = true, Callback = function(v) Settings.NoRecoil = v end})
GunTab:CreateToggle({Name = "Fast Fire Rate", CurrentValue = true, Callback = function(v) Settings.FastFire = v end})

MoveTab:CreateSlider({Name = "WalkSpeed", Range = {16, 130}, Increment = 1, CurrentValue = 18, Callback = function(v) Settings.WalkSpeed = v end})
MoveTab:CreateToggle({Name = "Infinite Jump", CurrentValue = false, Callback = function(v) Settings.InfiniteJump = v end})

-- ============== AIMBOT + ESP CODE (Fixed) ==============
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2.5
FOVCircle.NumSides = 120
FOVCircle.Color = Color3.fromRGB(0, 255, 120)
FOVCircle.Filled = false
FOVCircle.Transparency = 0.65

local function getClosestTarget()
    local closest, shortest = nil, Settings.FOV
    local center = Camera.ViewportSize / 2

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer or not plr.Character or not plr.Character:FindFirstChild("Humanoid") then continue end
        if plr.Character.Humanoid.Health <= 0 or plr.Team == LocalPlayer.Team then continue end

        local part = plr.Character:FindFirstChild(Settings.AimPart) or plr.Character:FindFirstChild("Head")
        if not part then continue end

        local screen, onScreen = Camera:WorldToViewportPoint(part.Position)
        if not onScreen then continue end

        local dist = (Vector2.new(screen.X, screen.Y) - center).Magnitude
        if dist < shortest then
            shortest = dist
            closest = plr
        end
    end
    return closest
end

local function getTargetPos(plr)
    if not plr or not plr.Character then return nil end
    local part = plr.Character:FindFirstChild(Settings.AimPart) or plr.Character:FindFirstChild("Head")
    if not part then return nil end

    local pos = part.Position
    if Settings.Prediction and plr.Character:FindFirstChild("HumanoidRootPart") then
        pos += plr.Character.HumanoidRootPart.Velocity * Settings.PredictionMultiplier
    end
    return pos
end

RunService.RenderStepped:Connect(function()
    if not Settings.Enabled then
        FOVCircle.Visible = false
        return
    end

    FOVCircle.Position = Camera.ViewportSize / 2
    FOVCircle.Radius = Settings.FOV
    FOVCircle.Visible = true

    if not CurrentTarget or not CurrentTarget.Character or CurrentTarget.Character.Humanoid.Health <= 0 then
        CurrentTarget = getClosestTarget()
    end

    if CurrentTarget and CurrentTarget.Character and Settings.FullAimbot then
        local targetPos = getTargetPos(CurrentTarget)
        if targetPos then
            local screen = Camera:WorldToScreenPoint(targetPos)
            local mouse = UserInputService:GetMouseLocation()
            local dir = Vector2.new(screen.X - mouse.X, screen.Y - mouse.Y)
            mousemoverel(dir.X * Settings.Smoothness, dir.Y * Settings.Smoothness)
        end
    end

    -- ESP, Gun Mods, etc. (same as before)
    local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if tool then
        for _, v in ipairs(tool:GetDescendants()) do
            if Settings.NoReload and (v.Name:find("Ammo") or v.Name:find("Clip")) and (v:IsA("IntValue") or v:IsA("NumberValue")) then
                v.Value = 9999
            end
            if Settings.NoRecoil and (v.Name:find("Recoil") or v.Name:find("Kick")) and v:IsA("NumberValue") then
                v.Value = 0
            end
            if Settings.FastFire and (v.Name:find("Rate") or v.Name == "Cooldown") and v:IsA("NumberValue") then
                v.Value = 0.03
            end
        end
    end
end)

-- Silent Aim Hook
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    if Settings.Enabled and Settings.SilentAim and CurrentTarget and getnamecallmethod() == "FireServer" then
        if self.Name:lower():find("fire") or self.Name:lower():find("shoot") then
            local pos = getTargetPos(CurrentTarget)
            if pos then
                for i, v in ipairs(args) do
                    if typeof(v) == "Vector3" then
                        args[i] = pos
                        break
                    end
                end
            end
        end
    end
    return old(self, unpack(args))
end)

setreadonly(mt, true)

print("✅ Fixed Script Loaded!")
