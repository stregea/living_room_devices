' *****************************************************************************************
' * Filename: GridScreen.brs
' * Description: This file will handle the logic for initializing the GridScreen component.  
' * Author: Samuel Tregea
' *****************************************************************************************

' Initialize the GridScreen, then show the View.
sub InitGridScreen()
    ' Construct the GridScreen component.
    m.GridScreen = CreateObject("roSGNode", "GridScreen")

    ' Display the GridScreen.
    AddScreenToView(m.GridScreen)
end sub