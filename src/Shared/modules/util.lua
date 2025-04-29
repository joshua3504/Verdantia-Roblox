local util = {}

function util.round(number, place)
    place = 10 ^ -place
    return math.round(number / place) * place
end

function util.ceil(number, place)
    place = 10 ^ -place
    return math.ceil(number / place) * place
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

    -- Checks to see if it's longer than 3 decimals
    if #string.sub(number, decimalIndex + 1) > 3 then
        number = string.sub(number, 1, decimalIndex + 3)
    else
        -- Finds the number of zeros that needed to be added
        local zerosToAdd = place - (#number - decimalIndex)
        
        -- Adds the zeros if necessary
        for i = 1, zerosToAdd do
            number = number .. "0"
        end
    end
        
    return number
end

function util.formatTime(minutes, includeSeconds)
    local totalSeconds = math.floor(minutes * 60)
    local hours = math.floor(totalSeconds / 3600)
    local mins = math.floor((totalSeconds % 3600) / 60)
    local seconds = totalSeconds % 60

    -- Format each part with two digits
    local formatted = string.format("%02d:%02d", hours, mins)

    if includeSeconds then
        formatted = string.format("%s:%02d", formatted, seconds)
    end

    return formatted
end

return util