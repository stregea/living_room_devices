' ********************************************************************
' * Filename: Main.brs
' * Description: This file will serve as the main channel entry point. 
' * Author: Samuel Tregea
' ********************************************************************

' Main Method.
sub Main()
    ShowChannelRSGScreen()
end sub


' Display the Roku SceneGraph.
sub ShowChannelRSGScreen() 
    'Indicate this is a Roku SceneGraph application.
    screen = CreateObject("roSGScreen")
    m.port = CreateObject("roMessagePort")
    screen.setMessagePort(m.port)

    'Create a scene and load /components/MainScene.xml.
    _ = screen.CreateScene("MainScene")
    screen.show()

    ' Event loop.
    while(true)
        msg = wait(0, m.port)
        msgType = type(msg)
        if msgType = "roSGScreenEvent"
            if msg.isScreenClosed() then return
        end if
    end while
end sub