local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Player = game.Players.LocalPlayer
local Window = OrionLib:MakeWindow({Name = "Key System", HidePremium = false, SaveConfig = true, IntroEnabled = false})

OrionLib:MakeNotification({
    Name = "Logged in!",
    Content = "You are logged in as " .. Player.Name .. ".",
    Image = "rbxassetid://4483345998",
    Time = 5
})

local validKeys = {
    "MxknTcBgdyXLBJJdOwnVlgOaSAtsiLNM",
    "ADMINKEYTULL",
    "AdminKeyTull",
    "adminkeytull",
    "ADMINKEYKENTUCKY",
    "AdminKeyKentucky",
    "adminkeykentucky"
}


function MakeScriptHub()
    OrionLib:Destroy()
    print("Starting Phantom Hub V1")
    task.wait(1)
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Tull99130-main/Private-Scripts/refs/heads/main/Phantom%20Hub.lua", true))()
end

function CorrectKeyNotification()
    OrionLib:MakeNotification({
        Name = "Correct Key!",
        Content = "You have entered a valid key.",
        Image = "rbxassetid://4483345998",
        Time = 5
    })
end

function IncorrectKeyNotification()
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

local KeyInput = "" -- Declare KeyInput variable

Tab:AddTextbox({
    Name = "Enter Key",
    Default = "",
    TextDisappear = true,
    Callback = function(Value)
        KeyInput = Value -- Assign Value to KeyInput
    end
})

Tab:AddButton({
    Name = "Check Key",
    Callback = function()
        local isValidKey = false
        for _, key in ipairs(validKeys) do
            if KeyInput == key then
                isValidKey = true
                break
            end
        end

        if isValidKey then
            MakeScriptHub()
            CorrectKeyNotification()
        else
            IncorrectKeyNotification()
        end
    end
})
