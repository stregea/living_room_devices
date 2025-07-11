' ************************************************************************************
' * Filename: utils.brs
' * Description: This file holds helper utility functions used throughout the project.
' * Author: Samuel Tregea
' ************************************************************************************

' Helper function convert AA to Node
function ContentListToSimpleNode(contentList as Object, nodeType = "ContentNode" as String) as Object
    result = CreateObject("roSGNode", nodeType) ' create node instance based on specified nodeType
    if result <> invalid
        ' go through contentList and create node instance for each item of list
        for each itemAA in contentList
            item = CreateObject("roSGNode", nodeType)
            item.SetFields(itemAA)
            result.AppendChild(item) 
        end for
    end if
    return result
end function


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