
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Player = game.Players.LocalPlayer
local Window = OrionLib:MakeWindow({Name = "Key System", HidePremium = false, SaveConfig = true, IntroEnabled = false})

OrionLib:MakeNotification({
    Name = "Logged in!",
    Content = "You are logged in as " .. Player.Name .. ".",
    Image = "rbxassetid://4483345998",
    Time = 5
})

-- List of valid keys
local validKeys = {
    "Kentuckyispro",
    "Wp0yMJrAmt5YnFa1TbpqP4xAWJX9FsWm"
}

local function MakeScriptHub()
    OrionLib:Destroy()
    print("Starting Phantom Hub V1")
    task.wait(1)
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Tull99130-main/RobloxScripts/refs/heads/main/Scripts/Arsenal2.lua", true))()
end

local function CorrectKeyNotification()
    OrionLib:MakeNotification({
        Name = "Correct Key!",
        Content = "You have entered a valid key.",
        Image = "rbxassetid://4483345998",
        Time = 5
    })
end

local function IncorrectKeyNotification()
    OrionLib:MakeNotification({
        Name = "Incorrect Key!",
        Content = "You have entered an invalid key.",
        Image = "rbxassetid://4483345998",
        Time = 5
    })
end

local Tab = Window:MakeTab({
    Name = "Key",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local KeyInput = ""

Tab:AddButton({
    Name = "Get Key",
    Callback = function()
        if setclipboard then
            setclipboard("https://discord.gg/xunrunR4jN")
            OrionLib:MakeNotification({
                Name = "Invite Link Copied",
                Content = "The Discord invite link has been copied to your clipboard!",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
        else
            OrionLib:MakeNotification({
                Name = "Clipboard Error",
                Content = "Unable to copy the invite link to clipboard.",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
        end
    end
})

Tab:AddSection({
    Name = "Check Key"
})

Tab:AddTextbox({
    Name = "Enter Key",
    Default = "",
    TextDisappear = true,
    Callback = function(Value)
        KeyInput = Value
    end
})

Tab:AddButton({
    Name = "Check Key",
    Callback = function()
        local isValidKey = table.find(validKeys, KeyInput) ~= nil

        if isValidKey then
            CorrectKeyNotification()
            MakeScriptHub()
        else
            IncorrectKeyNotification()
        end
    end
})

OrionLib:Init()


