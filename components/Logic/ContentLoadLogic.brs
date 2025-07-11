' ************************************************************************************
' * Filename: ContentLoadLogic.brs
' * Description: This file will handle the logic for initializing the data load tasks. 
' * Author: Samuel Tregea
' ************************************************************************************

' Fetch and load the data into the view.
sub FetchAndLoadData()
     ' Create task for feed retrieving.
    m.contentTask = CreateObject("roSGNode", "MainLoaderTask")
    ' Observe content so we can know when feed content will be parsed
    m.contentTask.ObserveField("content", "OnMainContentLoadedObserver")
    m.contentTask.control = "run" ' GetContent(see MainLoaderTask.brs) method is executed.
    m.loadingIndicator.visible = true
end sub


' Observer that is invoked when content is ready to be used.
sub OnMainContentLoadedObserver()
    m.GridScreen.SetFocus(true)
    m.loadingIndicator.visible = false ' hide loading indicator because content was retrieved
    m.GridScreen.content = m.contentTask.content ' populate GridScreen with content
end sub