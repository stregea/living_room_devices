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

    ' Allow for a video background to display (if available).
    setUpVideo()
end sub


' ***********************************************************************************
' Configure the Video component used as a background (if the video url is available).
' ***********************************************************************************
function setUpVideo() as void
  videoContent = createObject("RoSGNode", "ContentNode")
  videoContent.url = ""
  videoContent.streamformat = "mp4"

  m.video = m.top.findNode("videoBackground")
  m.video.content = videoContent
end function


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

    ' Don't display the video background if the URL isn't available.
    if content.videoURL  = invalid
        m.video.visible = false
    else
        m.video.visible = true
        m.video.control = "play"
    end if
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
    m.video.content.url = content.videoURL 
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
        firstItem = 0
        lastItem = m.top.content.GetChildCount() - 1
        
        leftItem = m.top.itemFocused - 1
        rightItem = m.top.itemFocused + 1

        ' if m.video.content.url = invalid
        '     m.video.visible = false' - set to false if url is null
        ' else
        '     m.video.visible = true
        ' end if

        ' Navigate to the left item in case of "left" keypress.
        if key = "left"
            m.top.jumpToItem = leftItem
            result = true

            ' If the left idex is out of bounds, set to the last item in the row.
            if leftItem = -1 then m.top.jumpToItem = lastItem

            ' Begin the fade in animation.
            m.maskgroupanimation.control = "start"

        ' Navigate to the right item in case of "right" keypress.
        else if key = "right" 
            m.top.jumpToItem = rightItem
            result = true

            ' If the right idex is out of bounds, set to the first item in the row.
            if rightItem > lastItem then m.top.jumpToItem = firstItem

            ' Begin the fade in animation.
            m.maskgroupanimation.control = "start"
        end if

    end if
    return result
end function