' ***************************************************************************************
' * Filename: MainScene.brs
' * Description: This file will handle the logic for initializing and rendering the view.
' * Author: Samuel Tregea
' ***************************************************************************************

' Initialize the MainScene.
sub Init()
  ' set background color for scene. Applied only if backgroundUri has empty value
  m.top.backgroundColor = "0x662D91"
  m.top.backgroundUri= "pkg:/images/background.jpg"
  m.loadingIndicator = m.top.FindNode("loadingIndicator") ' store loadingIndicator node to m

  InitView()
  InitGridScreen()
  FetchData()
end sub