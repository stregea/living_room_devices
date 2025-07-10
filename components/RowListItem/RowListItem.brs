' **************************************************************************************************
' * Filename: RowListItem.brs
' * Description: This file serves as the main entry point and handler for the RowListItem component.  
' * Author: Samuel Tregea
' **************************************************************************************************

' Initialize the MainLoaderTask component.
sub Init()
    m.poster = m.top.FindNode("poster")

    ' Create an observer to handle thumbnails that failed to load.
    m.poster.ObserveField("loadStatus", "OnLoadStatusChange")
end sub


' Handler that is invoked when item metadata is retrieved.
sub OnContentSet()
    content = m.top.itemContent
    m.poster.uri = "pkg:/images/image_not_found.png"

    ' print poster.loadStatus
    ' set poster uri if content is valid
    if content <> invalid and content.imageURI <> invalid 
        m.poster.uri = content.imageURI
    end if
end sub


' Observer to set the Poster's image to the default "image_not_found.png" image.
sub OnLoadStatusChange()
    if m.poster.loadStatus = "failed"
        m.poster.uri = "pkg:/images/image_not_found.png"
    end if
end sub
