--Feel free to change anything you want :)

local Library = loadstring(game:HttpGet("https://pastebin.com/raw/vff1bQ9F"))()
local Window = Library.CreateLib("Fade Hub", "BloodTheme")

local Players = game:GetService("Players")

local function createNotification()
    local player = Players.LocalPlayer
    player:WaitForChild("PlayerGui")

    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "GUI Loaded",
        Text = "Made By ZhenX",
        Duration = 5,
        Icon = "rbxassetid://10878730168"
    })
end

createNotification()

local players = {}
local Select = nil
local killAllEnabled = false
local killPlayerEnabled = false
local keybindsDisabled = false
local loopJumpscarePlayerEnabled = false
local loopJumpscareAllEnabled = false
local killAllCrashEnabled = false

local function refreshPlayerList()
    players = {}
    for _, v in pairs(Players:GetPlayers()) do
        table.insert(players, v.Name)
    end
end

local killTab = Window:NewTab("Kill All")
local killSection = killTab:NewSection("Features")

refreshPlayerList() -- Initial population of the player list

local playerDropdown -- Variable to hold the dropdown

local function updateDropdown()
    if playerDropdown then
        playerDropdown:Refresh(players)
    else
        playerDropdown = killSection:NewDropdown("Select Player", "Select a player to target", players, function(abc)
            Select = abc
        end)
    end
end

updateDropdown()

killSection:NewButton("Refresh", "Refresh player list", function()
    refreshPlayerList()
    updateDropdown()
end)

local function killPlayer(playerName)
    while killPlayerEnabled do
        task.wait()
        local targetPlayer = Players:FindFirstChild(playerName)
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local args = { [1] = targetPlayer.Character }
            game:GetService("ReplicatedStorage").Characters.Combat.Remotes.Combo:FireServer(unpack(args))
        else
            print("Target player not found or does not have a character.")
            killPlayerEnabled = false
        end
    end
end

killSection:NewToggle("Kill Player", "Toggle to kill selected player", function(state)
    killPlayerEnabled = state
    if killPlayerEnabled then
        if Select then
            print("Killing player: " .. Select)
            killPlayer(Select)
        else
            print("No valid target player selected.")
            killPlayerEnabled = false
        end
    else
        print("Stopped killing selected player.")
    end
end)

local function killAllPlayers()
    while killAllEnabled do
        task.wait(0.3)
        pcall(function()
            for i, v in pairs(Players:GetPlayers()) do
                if v ~= Players.LocalPlayer then
                    v.Character:PivotTo(Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5))
                    game:GetService("ReplicatedStorage").Characters.Combat.Remotes.Combo:FireServer(v.Character)
                end
            end
        end)
    end
end

killSection:NewToggle("Kill All", "Toggle to kill all players", function(state)
    killAllEnabled = state
    if killAllEnabled then
        print("Killing all players.")
        killAllPlayers()
    else
        print("Stopped killing all players.")
    end
end)

local function killAllPlayersCrash()
    while killAllCrashEnabled do
        task.wait()
        pcall(function()
            for i, v in pairs(Players:GetPlayers()) do
                if v ~= Players.LocalPlayer then
                    v.Character:PivotTo(Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5))
                    game:GetService("ReplicatedStorage").Characters.Combat.Remotes.Combo:FireServer(v.Character)
                end
            end
        end)
    end
end

killSection:NewToggle("Kill All (Crashes the server)", "Toggle to kill all players (may crash the server)", function(state)
    killAllCrashEnabled = state
    if killAllCrashEnabled then
        print("Killing all players (may crash the server).")
        killAllPlayersCrash()
    else
        print("Stopped killing all players.")
    end
end)

local jumpscareTab = Window:NewTab("Jumpscare All")
local jumpscareSection = jumpscareTab:NewSection("Features")

local jumpscareDropdown

local function updateJumpscareDropdown()
    if jumpscareDropdown then
        jumpscareDropdown:Refresh(players)
    else
        jumpscareDropdown = jumpscareSection:NewDropdown("Select Player", "Select a player to jumpscare", players, function(abc)
            Select = abc
        end)
    end
end

updateJumpscareDropdown()

jumpscareSection:NewButton("Refresh", "Refresh player list", function()
    refreshPlayerList()
    updateJumpscareDropdown()
end)

local function jumpscarePlayer(playerName)
    local targetPlayer = Players:FindFirstChild(playerName)
    if targetPlayer and targetPlayer.Character then
        local args = { [1] = targetPlayer.Character }
        game:GetService("ReplicatedStorage"):WaitForChild("Characters"):WaitForChild("Jeffrey"):WaitForChild("Remotes"):WaitForChild("Picture"):FireServer(unpack(args))
    else
        print("Target player not found or does not have a character.")
    end
end

jumpscareSection:NewButton("Jumpscare Player (Press Option)", "Press to jumpscare selected player", function()
    if Select then
        jumpscarePlayer(Select)
    else
        print("No valid target player selected for jumpscare.")
    end
end)

local loopJumpscarePlayer = function()
    while loopJumpscarePlayerEnabled do
        task.wait(1.5)
        if Select then
            jumpscarePlayer(Select)
        end
    end
end

jumpscareSection:NewToggle("Loop Jumpscare Player", "Toggle to loop jumpscare selected player", function(state)
    loopJumpscarePlayerEnabled = state
    if loopJumpscarePlayerEnabled then
        print("Loop Jumpscare Player enabled.")
        loopJumpscarePlayer()
    else
        print("Loop Jumpscare Player disabled.")
    end
end)

jumpscareSection:NewButton("Jumpscare Yourself", "Press to jumpscare yourself", function()
    jumpscarePlayer(Players.LocalPlayer.Name)
end)

jumpscareSection:NewButton("Jumpscare All", "Press to jumpscare all players", function()
    for _, player in pairs(Players:GetPlayers()) do
        if player and player.Character and player ~= Players.LocalPlayer then
            jumpscarePlayer(player.Name)
        end
    end
end)

local loopJumpscareAll = function()
    while loopJumpscareAllEnabled do
        task.wait(1.5)
        for _, player in pairs(Players:GetPlayers()) do
            if player and player.Character and player ~= Players.LocalPlayer then
                jumpscarePlayer(player.Name)
            end
        end
    end
end

jumpscareSection:NewToggle("Loop Jumpscare All", "Toggle to loop jumpscare all players", function(state)
    loopJumpscareAllEnabled = state
    if loopJumpscareAllEnabled then
        print("Loop Jumpscare All enabled.")
        loopJumpscareAll()
    else
        print("Loop Jumpscare All disabled.")
    end
end)

jumpscareSection:NewToggle("Disable Keybinds", "Toggle to disable jumpscare keybinds", function(state)
    keybindsDisabled = state
    if keybindsDisabled then
        print("Jumpscare keybinds disabled.")
    else
        print("Jumpscare keybinds enabled.")
    end
end)

local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if not gameProcessedEvent then
        if input.KeyCode == keybindKey and not keybindsDisabled then
            if Select then
                jumpscarePlayer(Select)
            else
                print("No valid target player selected for jumpscare.")
            end
        end
    end
end)

local uiTab = Window:NewTab("UI")
local uiSection = uiTab:NewSection("UI")
uiSection:NewKeybind("Hide UI", "KeybindInfo", Enum.KeyCode.P, function()
    Library:ToggleUI()
end)
