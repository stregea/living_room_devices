  sub init()
    m.top.setFocus(true)
    m.myLabel = m.top.findNode("myLabel")
    
    'Set the font size
    m.myLabel.font.size=92

    'Set the color to light blue
    m.myLabel.color="0x72D7EEFF"

    '**
    '** The full list of editable attributes can be located at:
    '** http://sdkdocs.roku.com/display/sdkdoc/Label#Label-Fields
    '**
  end sub