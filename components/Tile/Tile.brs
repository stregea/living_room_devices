' *******************************************************************************************
' * Filename: Tile.brs
' * Description: This file serves as the main entry point and handler for the Tile component.  
' * Author: Samuel Tregea
' *******************************************************************************************

' ******************************
' Initialize the Tile component.
' ******************************
sub Init()
    m.poster = m.top.FindNode("poster")

    ' Create an observer to handle thumbnails that failed to load.
    m.poster.ObserveField("loadStatus", "OnLoadStatusChange")

    ' Begin the fade in animation.
    m.maskGroupAnimation = m.top.findNode("maskGroupAnimation")
    m.maskGroupAnimation.control = "start"
end sub


' ******************************************************************************************************************************
' Scale the Poster on focus.
' Reference: https://developer.roku.com/en-gb/docs/references/scenegraph/list-and-grid-nodes/overview.md#custom-focus-indicators
' ******************************************************************************************************************************
sub OnFocus() 
    scale = 1 + (m.top.focusPercent * 0.08) 
    m.poster.scale = [scale, scale] 
end sub


' ********************************************************
' Handler that is invoked when item metadata is retrieved.
' ********************************************************
sub OnContentSet()
    content = m.top.itemContent
    m.poster.uri = "pkg:/images/image_not_found.png"

    ' set poster uri if content is valid
    if content <> invalid and content.imageURI <> invalid 
        m.poster.uri = content.imageURI
    end if
end sub


' ****************************************************************************************************
' Observer to set the Poster's image to the default "image_not_found.png" image on loadStatus failure.
' ****************************************************************************************************
sub OnLoadStatusChange()
    if m.poster.loadStatus = "failed"
        m.poster.uri = "pkg:/images/image_not_found.png"
    end if
end sub