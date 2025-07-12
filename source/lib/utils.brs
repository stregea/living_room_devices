' ************************************************************************************
' * Filename: utils.brs
' * Description: This file holds helper utility functions used throughout the project.
' * Author: Samuel Tregea
' ************************************************************************************


' Helper function convert seconds to Xh Ym format.
function GetTime(millis as Object) as Object

    if millis = invalid then return invalid

    seconds = millis / 1000

    ' Perform Integer division to calculate hours and minutes.
    hours = seconds \ 3600
    minutes = (seconds MOD 3600) \ 60

    if hours > 0 then return "%dh %dm".Format(hours, minutes)

    return "%dm".Format(minutes)
end function