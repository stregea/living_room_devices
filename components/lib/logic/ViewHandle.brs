' ************************************************************************************************************
' * Filename: ViewHandle.brs
' * Description: This file will handle the logic for adding and removing screens to and from the current view.  
' * Author: Samuel Tregea
' ************************************************************************************************************


' Initialize a stack to contain screens that will be viewable within the current View.
sub InitView()
    m.screenStack = []
end sub


' Add a new screen to the stack and make it visible.
sub AddScreenToView(newScreenNode as Object)
    prev = m.screenStack.Peek()

    ' Hide the current screen if it exists.
    if prev <> invalid
        prev.visible = false
    end if

    ' Show a new screen.
    m.top.AppendChild(newScreenNode)
    newScreenNode.visible = true
    newScreenNode.SetFocus(true)

    ' Push the screen onto the stack.
    m.screenStack.Push(newScreenNode)
end sub


' Remove the current screen from the stack, display the previous screen.
sub RemoveScreenFromView(currentScreenNode as Object)
    prevScreen = m.screenStack.Peek()

    if currentScreenNode = invalid OR (prevScreen <> invalid AND prevScreen.IsSameNode(currentScreenNode))
        ' Remove the current screen from the stack and remove it from the scene.
        lastScreen = m.screenStack.Pop()
        lastScreen.visible = false
        m.top.RemoveChild(currentScreenNode)

        ' Take the previous screen from the stack and make it visible.
        prevScreen = m.screenStack.Peek()
        if prevScreen <> invalid
            prevScreen.visible = true
            prevScreen.SetFocus(true)
        end if

    end if
end sub