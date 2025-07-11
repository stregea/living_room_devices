' ********************************************************************************************
' * Filename: DetailsScreenLogic.brs
' * Description: This file will handle the logic for initializing the DetailsScreen component.  
' * Author: Samuel Tregea
' ********************************************************************************************

' Create a new instance of a Details Screen and Add to the View.
sub ShowDetailsScreen(content as Object, selectedItem as Integer)
    detailsScreen = CreateObject("roSGNode", "DetailsScreen")
    detailsScreen.content = content
    detailsScreen.jumpToItem = selectedItem ' set index of item which should be focused
    detailsScreen.ObserveField("visible", "OnDetailsScreenVisibilityChanged")
    detailsScreen.ObserveField("buttonSelected", "OnButtonSelected")

    AddScreenToView(detailsScreen)
end sub


' todo: This is optional (remove?)
' sub OnButtonSelected(event) ' invoked when button in DetailsScreen is pressed
'     details = event.GetRoSGNode()
'     content = details.content
'     buttonIndex = event.getData() ' index of selected button
'     selectedItem = details.itemFocused
'     if buttonIndex = 0 ' check if "Play" button is pressed
'         ' create Video node and start playback
'         ' ShowVideoScreen(content, selectedItem)
'     end if
' end sub


' Invoked when DetailsScreen "visible" field is changed,
' which is invoked when the user presses the 'back' button.
sub OnDetailsScreenVisibilityChanged(event as Object) 
    visible = event.GetData()
    detailsScreen = event.GetRoSGNode()

    ' update GridScreen's focus when navigate back from DetailsScreen
    if visible = false
        m.GridScreen.jumpToRowItem = [m.selectedIndex[0], detailsScreen.itemFocused]
        m.top.FindNode("RowList").SetFocus(true)
    end if
end sub