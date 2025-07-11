' ***************************************************************************************
' * Filename: MainScene.brs
' * Description: This file will handle the logic for initializing and rendering the view.
' * Author: Samuel Tregea
' ***************************************************************************************

' Initialize the MainScene.
sub Init()
  m.top.backgroundUri= "pkg:/images/background.png"
  m.loadingIndicator = m.top.FindNode("loadingIndicator")

  InitView()
  InitGridScreen()
  FetchData()
end sub


' The OnKeyEvent() function receives remote control key events
function OnkeyEvent(key as String, press as Boolean) as Boolean
    result = false
    if press
        ' handle "back" key press
        if key = "back"
            numberOfScreens = m.viewStack.Count()
            ' close top screen if there are two or more screens in the screen stack
            if numberOfScreens > 1
                RemoveScreenFromView(invalid)
                result = true
            end if
        end if
    end if
    ' The OnKeyEvent() function must return true if the component handled the event,
    ' or false if it did not handle the event.
    return result
end function
