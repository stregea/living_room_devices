' **************************************************************************************************
' * Filename: GridScreen.brs
' * Description: This file serves as the main entry point and handler for the RowListItem component.  
' * Author: Samuel Tregea
' **************************************************************************************************

function Init()
    m.poster = m.top.FindNode("poster")
end function

' Handle the increase in size of the Poster as it gains focus.
sub OnPosterFocus()
    ' This increases the size of the tile as it gains more focus
    ' Note: focusPercent is obtained from the ZoomRowList
    ' todo: find documentation where this was found.
    scale = 1 + (m.top.focusPercent * 0.08)
    m.poster.scale = [scale, scale]
end sub

' Handle the size of the Poster on Row Focus.
sub OnRowFocus()
    width = 220
    height = 144

    ' Note: These values were found based on trial and error.
    focusOffsetWidth = 132
    focusOffsetHeight = 55

    ' Note: rowFocusPercent value is obtained from the ZoomRowList.
    ' This calculation is required for scaling the image up and
    ' down based on row selection.
    m.poster.width = width + (focusOffsetWidth * m.top.rowFocusPercent)
    m.poster.height = height + (focusOffsetHeight * m.top.rowFocusPercent)
end sub

' Handler that is invoked when item metadata is retrieved.
sub OnContentSet()
    content = m.top.itemContent

    ' set poster uri if content is valid
    if content <> invalid 
        m.poster.uri = content.hdPosterUrl
    end if
end sub
