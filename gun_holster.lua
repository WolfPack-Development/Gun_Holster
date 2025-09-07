-- ==========================
-- WolfPack Development Custom Holster Script
-- ==========================
-- This script handles the animation and logic for holstering weapons.
-- Author: WolfPack Development
-- ==========================

-- Variable Definitions
local holstered  = true
local blocked     = false
local PlayerData = {}

-- ==========================
-- Main Loop for Holstering
-- ==========================
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = PlayerPedId()

        -- Load Animation Dictionaries
        loadAnimDict("rcmjosh4")
        loadAnimDict("reaction@intimidation@cop@unarmed")

        -- Check if the player is not in a vehicle
        if not IsPedInAnyVehicle(ped, false) then
            -- Ensure the player is not trying to enter a vehicle or in free fall
            if GetVehiclePedIsTryingToEnter(ped) == 0 and 
               (GetPedParachuteState(ped) == -1 or GetPedParachuteState(ped) == 0) and 
               not IsPedInParachuteFreeFall(ped) then

                -- Check if the player is armed
                if CheckWeapon(ped) then
                    -- Holster the weapon
                    if holstered then
                        blocked = true
                        holsterWeapon(ped) -- Call to holster function
                    else
                        blocked = false
                    end
                else
                    -- Draw the weapon
                    if not holstered then
                        drawWeapon(ped) -- Call to draw function
                    end
                end
            else
                -- Prevent firing while entering a vehicle
                SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
            end
        else
            holstered = true
        end
    end
end)

-- ==========================
-- Holster and Draw Functions
-- ==========================
function holsterWeapon(ped)
    SetPedCurrentWeaponVisible(ped, 0, 1, 1, 1)
    TaskPlayAnim(ped, "reaction@intimidation@cop@unarmed", "intro", 8.0, 2.0, -1, 50, 0, 0, 0)
    Citizen.Wait(1000) -- Duration of the holster animation
    SetPedCurrentWeaponVisible(ped, 1, 1, 1, 1)
    Citizen.Wait(100) -- Cooldown before drawing again
    TaskPlayAnim(ped, "rcmjosh4", "josh_leadout_cop2", 8.0, 2.0, -1, 48, 10, 0, 0, 0)
    Citizen.Wait(400)
    ClearPedTasks(ped)
    holstered = false
end

function drawWeapon(ped)
    TaskPlayAnim(ped, "rcmjosh4", "josh_leadout_cop2", 8.0, 2.0, -1, 48, 10, 0, 0, 0)
    Citizen.Wait(500)
    TaskPlayAnim(ped, "reaction@intimidation@cop@unarmed", "outro", 8.0, 2.0, -1, 50, 0, 0, 0)
    Citizen.Wait(1000) -- Duration of the draw animation
    ClearPedTasks(ped)
    holstered = true
end

-- ==========================
-- Control Blocking Loop
-- ==========================
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if blocked then
            DisableControlAction(1, 25, true) -- Aim
            DisableControlAction(1, 140, true) -- Attack
            DisableControlAction(1, 141, true) -- Attack
            DisableControlAction(1, 142, true) -- Attack
            DisableControlAction(1, 23, true) -- Fire
            DisableControlAction(1, 37, true) -- Select Weapon
            DisablePlayerFiring(ped, true) -- Disable weapon firing
        end
    end
end)

-- ==========================
-- Check Weapon Function
-- ==========================
function CheckWeapon(ped)
    if IsEntityDead(ped) then
        blocked = false
        return false
    else
        local weaponHash = GetSelectedPedWeapon(ped)
        return IsPedArmed(ped, 6) and (weaponHash == GetHashKey("WEAPON_COMBATPISTOL"))
    end
end

-- ==========================
-- Animation Dictionary Loader
-- ==========================
function loadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Citizen.Wait(0)
    end
end

-- ==========================
-- End of Script
-- ==========================
-- MIT License
-- Copyright (c) 2024 WolfPack Development
-- Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), 
-- to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, 
-- and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
-- 
-- The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 
-- WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.