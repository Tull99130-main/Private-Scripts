
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Player = game.Players.LocalPlayer
local Window = OrionLib:MakeWindow({Name = "Key System", HidePremium = false, SaveConfig = true, IntroEnabled = false})

OrionLib:MakeNotification({
    Name = "Logged in!",
    Content = "You are logged in as " .. Player.Name .. ".",
    Image = "rbxassetid://4483345998",
    Time = 5
})

validKeys = {{
    "plFL91TEUZ6yq9tADAp9IEPBRf3Gpv8U"
}}
function MakeScriptHub()
    OrionLib:Destroy()
    print("Starting Phantom Hub V1")
    task.wait(1)
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Tull99130-main/RobloxScripts/refs/heads/main/Scripts/Arsenal2.lua", true))()
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

Tab:AddButton({
    Name = "Get Key",
    Callback = function()
        local success = false
    
        -- Attempt to open the Discord link
        if syn and syn.request then
            success = pcall(function()
                syn.request({
                    Url = "https://discord.gg/xunrunR4jN",
                    Method = "GET"
                })
            end)
        elseif request then
            success = pcall(function()
                request({
                    Url = "https://discord.gg/xunrunR4jN",
                    Method = "GET"
                })
            end)
        elseif http and http.request then
            success = pcall(function()
                http.request({
                    Url = "https://discord.gg/xunrunR4jN",
                    Method = "GET"
                })
            end)
        end
    
        -- If URL opening fails, copy the invite link to the clipboard
        if not success then
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
                    Name = "Action Failed",
                    Content = "Unable to open the link or copy it to clipboard.",
                    Image = "rbxassetid://4483345998",
                    Time = 5
                })
            end
        else
            OrionLib:MakeNotification({
                Name = "Discord Opened",
                Content = "Join the server for the key!",
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
OrionLib:Init()
