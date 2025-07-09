' **************************************************************************************************
' * Filename: RowListItem.brs
' * Description: This file serves as the main entry point and handler for the RowListItem component.  
' * Author: Samuel Tregea
' **************************************************************************************************

' Handler that is invoked when item metadata is retrieved.
sub OnContentSet()
    content = m.top.itemContent

    ' set poster uri if content is valid
    if content <> invalid 
        m.top.FindNode("poster").uri = content.hdPosterUrl
    end if
end sub
