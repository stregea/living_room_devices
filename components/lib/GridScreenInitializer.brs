' *****************************************************************************************
' * Filename: GridScreenInitializer.brs
' * Description: This file will handle the logic for initializing the GridScreen component.  
' * Author: Samuel Tregea
' *****************************************************************************************

' Initialize the GridScreen, then show the View.
sub InitGridScreen()
    ' Construct the GridScreen component.
    m.GridScreen = CreateObject("roSGNode", "GridScreen")

    ' Allow for the Details Screen to open upon selection.
    m.GridScreen.ObserveField("rowItemSelected", "OnGridScreenItemSelected")

    ' Display the GridScreen.
    AddScreenToView(m.GridScreen)
end sub


' Event handler to open a Details Screen for the event when a RowItem is selected.
sub OnGridScreenItemSelected(event as Object)
    grid = event.GetRoSGNode()
    ' extract the row and column indexes of the item the user selected
    m.selectedIndex = event.GetData()
    ' the entire row from the RowList will be used by the Video node
    rowContent = grid.content.GetChild(m.selectedIndex[0])
    ShowDetailsScreen(rowContent, m.selectedIndex[1])
end sub