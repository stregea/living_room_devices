' ****************************************************************************************
' * Filename: DetailsScreen.brs
' * Description: This file serves as the main entry point for the DetailsScreen component.  
' * Author: Samuel Tregea
' ****************************************************************************************

' ***************************************
' Initialize the DetailsScreen component.
' ***************************************
sub Init()
    m.top.ObserveField("visible", "OnVisibilityChange")
    m.top.ObserveField("itemFocused", "OnItemFocusedChanged")

    m.poster = m.top.FindNode("poster") 
    
    m.titleLabel = m.top.FindNode("titleLabel")
    m.descriptionLabel = m.top.FindNode("descriptionLabel")

    m.poster.ObserveField("loadStatus", "OnLoadStatusChange")

    ' Begin the fade in animation.
    m.maskgroupanimation = m.top.findNode("MaskGroupAnimation")
    m.maskgroupanimation.control = "start"
end sub

' ********************************************************************
' Invoked when DetailsScreen "visible" field is changed,
' which is invoked when the user presses the "OK" button on a RowItem.
' ********************************************************************
sub OnVisibilityChange()
    ' set focus for buttons list when DetailsScreen become visible
    if m.top.visible = true
        m.buttons.SetFocus(true)
        m.top.itemFocused = m.top.jumpToItem
    end if
end sub


' ******************************************
' Invoked when another item is focused.
' @param event - The itemFocus change event.
' ******************************************
sub OnItemFocusedChanged(event as Object)
    focusedItem = event.GetData()
    content = m.top.content.GetChild(focusedItem)

    ' Populate DetailsScreen with item metadata.
    SetDetailsContent(content)
end sub


' ***************************************************************************************************
' Observer handler that is used to set the Poster's image to the default "image_not_found.png" image.
' ***************************************************************************************************
sub OnLoadStatusChange()
    if m.poster.loadStatus = "failed"
        m.poster.uri = "pkg:/images/image_not_found.png"
    end if
end sub


' **************************************************************
' Populate the details to display on the screen.
' @param content - The content to set within the Details Screen.
' **************************************************************
sub SetDetailsContent(content as Object)
    m.poster.uri = content.detailsImageURI
    m.titleLabel.text = content.detailsTitle
    m.descriptionLabel.text = content.description
end sub


' ***********************************************
' Invoked when the jumpToItem field is populated.
' ***********************************************
sub OnJumpToItem() 
    content = m.top.content

    ' Check if jumpToItem field has valid value.
    ' Should be set within interval from 0 to content.Getchildcount()
    if content <> invalid and m.top.jumpToItem >= 0 and content.GetChildCount() > m.top.jumpToItem
        m.top.itemFocused = m.top.jumpToItem
    end if
end sub


' ***************************************************************************************
' Event Handler for remote control key events within in the Details Screen.
' The user can press the left or right key to change the description for movies/TV shows.
' @param key - The key on the remote that was pressed.
' @param press - Boolean that indicated whether there was a button press or not.
' @return true or false based on a button press.
' ***************************************************************************************
function OnKeyEvent(key as String, press as Boolean) as Boolean
    result = false
    if press
        rowItemCount = m.top.content.GetChildCount()
        leftItemIndex = m.top.itemFocused - 1
        rightItemIndex = m.top.itemFocused + 1

        ' Navigate to the left item in case of "left" keypress.
        if key = "left"
            m.top.jumpToItem = leftItemIndex
            result = true

            ' Begin the fade in animation, don't animate if at the beginning of the row.
            if leftItemIndex <> - 1 then m.maskgroupanimation.control = "start"

        ' Navigate to the right item in case of "right" keypress.
        else if key = "right" 
            m.top.jumpToItem = rightItemIndex
            result = true

            ' Begin the fade in animation, don't animate if at the end of the row.
            if rightItemIndex < rowItemCount then m.maskgroupanimation.control = "start"

        end if
    end if
    return result
end function