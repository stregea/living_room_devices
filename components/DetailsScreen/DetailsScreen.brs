
' ****************************************************************************************
' * Filename: DetailsScreen.brs
' * Description: This file serves as the main entry point for the DetailsScreen component.  
' * Author: Samuel Tregea
' ****************************************************************************************

' Initialize the DetailsScreen component.
function Init()
    ' observe "visible" so we can know when DetailsScreen change visibility
    m.top.ObserveField("visible", "OnVisibleChange")
    ' observe "itemFocused" so we can know when another item gets in focus
    m.top.ObserveField("itemFocused", "OnItemFocusedChanged")
    ' save a references to the DetailsScreen child components in the m variable
    ' so we can access them easily from other functions
    m.buttons = m.top.FindNode("buttons")
    m.poster = m.top.FindNode("poster") 
    m.description = m.top.FindNode("descriptionLabel")
    m.timeLabel = m.top.FindNode("timeLabel")
    m.titleLabel = m.top.FindNode("titleLabel")
    m.releaseLabel = m.top.FindNode("releaseLabel")
    
    ' create buttons
    result = []
    for each button in ["Play"] ' buttons list contains only "Play" button for now
        result.Push({title : button})
    end for
    m.buttons.content = ContentListToSimpleNode(result) ' set list of buttons for DetailsScreen
end function


' Invoked when DetailsScreen "visible" field is changed,
' which is invoked when the user presses the "OK" button on a RowItem.
sub OnVisibleChange()
    ' set focus for buttons list when DetailsScreen become visible
    if m.top.visible = true
        m.buttons.SetFocus(true)
        m.top.itemFocused = m.top.jumpToItem
    end if
end sub


' Populate content details information
sub SetDetailsContent(content as Object)
    m.description.text = content.description ' set description of content
    m.poster.uri = content.hdPosterUrl ' set url of content poster
    m.timeLabel.text = GetTime(content.length) ' set length of content
    m.titleLabel.text = content.title ' set title of content
    m.releaseLabel.text = content.releaseDate ' set release date of content
end sub


' Invoked when jumpToItem field is populated
sub OnJumpToItem() 
    content = m.top.content

    ' Check if jumpToItem field has valid value.
    ' Should be set within interval from 0 to content.Getchildcount()
    if content <> invalid and m.top.jumpToItem >= 0 and content.GetChildCount() > m.top.jumpToItem
        m.top.itemFocused = m.top.jumpToItem
    end if
end sub


' Invoked when another item is focused.
sub OnItemFocusedChanged(event as Object)
    focusedItem = event.GetData()
    content = m.top.content.GetChild(focusedItem)

    ' Populate DetailsScreen with item metadata.
    SetDetailsContent(content)
end sub


' The OnKeyEvent() function receives remote control key events.
function OnkeyEvent(key as String, press as Boolean) as Boolean
    result = false
    if press
        currentItem = m.top.itemFocused 
        ' navigate to the left item in case of "left" keypress
        if key = "left"
            m.top.jumpToItem = currentItem - 1 
            result = true
        ' navigate to the right item in case of "right" keypress
        else if key = "right" 
            m.top.jumpToItem = currentItem + 1 
            result = true
        end if
    end if
    return result
end function


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


' Helper function convert seconds to mm:ss format
' getTime(138) returns 2:18
function GetTime(length as Integer) as String
    minutes = (length \ 60).ToStr()
    seconds = length MOD 60
    if seconds < 10
       seconds = "0" + seconds.ToStr()
    else
       seconds = seconds.ToStr()
    end if
    return minutes + ":" + seconds
end function