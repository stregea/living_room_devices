' ***************************************************************************************
' * Filename: MainScene.brs
' * Description: This file will handle the logic for initializing and rendering the view.
' * Author: Samuel Tregea
' ***************************************************************************************

' *************************
' Initialize the MainScene.
' *************************
sub Init()
  m.top.backgroundUri= "pkg:/images/background.png"

  InitView()
  InitGridScreen()
  FetchAndLoadData()
end sub


' ***************************************************************************************
' Event Handler for remote control key events within in the Main Screen.
' The user can press the back button to change/exit scenes within the view.
' @param key - The key on the remote that was pressed.
' @param press - Boolean that indicated whether there was a button press or not.
' @return true or false based on a button press.
' ***************************************************************************************
function OnKeyEvent(key as String, press as Boolean) as Boolean
    result = false
    if press
        ' Handle "back" key press.
        if key = "back"
            numberOfScreens = m.viewStack.Count()
            ' Close the top screen if there are two or more screens within the view stack.
            if numberOfScreens > 1
                RemoveScreenFromView(invalid)
                result = true
            end if
        end if
    end if
    return result
end function