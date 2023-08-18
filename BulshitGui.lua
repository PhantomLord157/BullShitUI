local throw_away = {}

local SCRIPT_TO_OBFUSCATE = [[
-- Your actual script here
print("Hello from the obfuscated script!")
]]

function GetBytes()
    for num = 1, #SCRIPT_TO_OBFUSCATE do
        throw_away[num] = string.byte(SCRIPT_TO_OBFUSCATE, num)
    end
end

function ConvertString()
    local string_buffer = ""
    for obj = 1, #throw_away do
        string_buffer = string_buffer .. "\\" .. throw_away[obj]
    end
    return string_buffer
end

function Obfuscate()
    GetBytes()
    local str = ConvertString()
    return print('loadstring("' .. str .. '")()')
end

Obfuscate()

loadstring("\112\114\105\110\116\40\34\32\89\79\85\82\32\83\67\82\73\80\84\32\72\69\82\69\33\33\32\34\41\10")()
