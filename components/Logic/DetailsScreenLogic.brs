' ********************************************************************************************
' * Filename: DetailsScreenLogic.brs
' * Description: This file will handle the logic for initializing the DetailsScreen component.  
' * Author: Samuel Tregea
' ********************************************************************************************

' **************************************************************
' Create a new instance of a Details Screen and Add to the View.
' **************************************************************
sub ShowDetailsScreen(content as Object, selectedItem as Integer)
    detailsScreen = CreateObject("roSGNode", "DetailsScreen")
    detailsScreen.content = content
    detailsScreen.jumpToItem = selectedItem ' set index of item which should be focused
    detailsScreen.ObserveField("visible", "OnDetailsScreenVisibilityChanged")
    detailsScreen.ObserveField("buttonSelected", "OnButtonSelected")

    AddScreenToView(detailsScreen)
end sub


' *********************************************************
' Invoked when DetailsScreen "visible" field is changed,
' which is invoked when the user presses the 'back' button.
' @param event - The visibility change event.
' *********************************************************
sub OnDetailsScreenVisibilityChanged(event as Object) 
    visible = event.GetData()
    detailsScreen = event.GetRoSGNode()

    ' Update the GridScreen's focus when navigating back from the DetailsScreen.
    if visible = false
        m.GridScreen.jumpToRowItem = [m.selectedIndex[0], detailsScreen.itemFocused]
        m.top.FindNode("RowList").SetFocus(true)
    end if
end sub