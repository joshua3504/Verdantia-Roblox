local util = {}

function util.round(number, place)
    place = 10 ^ -place
    return math.round(number / place) * place
end

-- Adds the specified number of zeros (place) to the end of a double
function util.formatDouble(number, place)
    number = tostring(number)
    local decimalIndex = string.find(number, "%.")

    -- Adds a decimal point if there isn't one
    if not decimalIndex then
        number = number .. "."
        decimalIndex = #number
    end
        
    -- Finds the number of zeros that needed to be added
    local zerosToAdd = place - (#number - decimalIndex)
    print(zerosToAdd)
        
    -- Add the zeros if necessary
    for i = 1, zerosToAdd do
        number = number .. "0"
    end
    -- if zerosToAdd > 0 then
    --     number = number .. string.rep("0", zerosToAdd)
    -- end
        
    return number
end

return util