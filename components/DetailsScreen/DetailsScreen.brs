' ****************************************************************************************
' * Filename: DetailsScreen.brs
' * Description: This file serves as the main entry point for the DetailsScreen component.  
' * Author: Samuel Tregea
' ****************************************************************************************

' Initialize the DetailsScreen component.
function Init()
    m.top.ObserveField("visible", "OnVisibleChange")
    m.top.ObserveField("itemFocused", "OnItemFocusedChanged")

    m.poster = m.top.FindNode("poster") 
    
    m.titleLabel = m.top.FindNode("titleLabel")
    m.descriptionLabel = m.top.FindNode("descriptionLabel")

    m.poster.ObserveField("loadStatus", "OnLoadStatusChange")
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


' Invoked when another item is focused.
sub OnItemFocusedChanged(event as Object)
    focusedItem = event.GetData()
    content = m.top.content.GetChild(focusedItem)

    ' Populate DetailsScreen with item metadata.
    SetDetailsContent(content)
end sub


' Observer handler that is used to set the Poster's image to the default "image_not_found.png" image.
sub OnLoadStatusChange()
    if m.poster.loadStatus = "failed"
        m.poster.uri = "pkg:/images/image_not_found.png"
    end if
end sub


' Populate the details to display on the screen.
sub SetDetailsContent(content as Object)
    m.poster.uri = content.detailsImageURI

    m.titleLabel.text = content.videoTitle
    m.descriptionLabel.text = content.description
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


' The OnKeyEvent() function receives remote control key events.
function OnkeyEvent(key as String, press as Boolean) as Boolean
    result = false
    if press
        previousItem = m.top.itemFocused - 1
        nextItem = m.top.itemFocused + 1
        ' navigate to the left item in case of "left" keypress
        if key = "left"
            m.top.jumpToItem = previousItem
            result = true
        ' navigate to the right item in case of "right" keypress
        else if key = "right" 
            m.top.jumpToItem = nextItem
            result = true
        end if
    end if
    return result
end function