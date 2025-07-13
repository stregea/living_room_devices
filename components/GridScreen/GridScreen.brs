' *************************************************************************************
' * Filename: GridScreen.brs
' * Description: This file serves as the main entry point for the GridScreen component.  
' * Author: Samuel Tregea
' *************************************************************************************

' ************************************
' Initialize the GridScreen component.
' ************************************
sub Init()
    m.rowList = m.top.FindNode("RowList")
    m.rowList.SetFocus(true)

    m.title = m.top.FindNode("title")

    ' Create and set an observer for the rowItemFocused attribute
    ' for items within the RowList.
    m.rowList.ObserveField("rowItemFocused", "OnItemFocusedObserver")
end sub


' *************************************************
' Observer that is invoked when an item is focused.
' *************************************************
sub OnItemFocusedObserver()
    focusedIndex = m.rowList.rowItemFocused
    row = m.rowList.content.GetChild(focusedIndex[0])
    item = row.GetChild(focusedIndex[1])
    if item <> invalid
        m.title.text = item.title
    end if
end sub