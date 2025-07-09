' ************************************************************************************
' * Filename: FetchData.brs
' * Description: This file will handle the logic for initializing the data load tasks. 
' * Author: Samuel Tregea
' ************************************************************************************

' Fetch and load the data into the view.
sub FetchData()
    m.contentTask = CreateObject("roSGNode", "MainLoaderTask") ' create task for feed retrieving
    ' observe content so we can know when feed content will be parsed
    m.contentTask.ObserveField("content", "OnMainContentLoadedObserver")
    m.contentTask.control = "run" ' GetContent(see MainLoaderTask.brs) method is executed
    m.loadingIndicator.visible = true ' show loading indicator while content is loading
end sub


sub OnMainContentLoadedObserver() ' invoked when content is ready to be used
    m.GridScreen.SetFocus(true) ' set focus to GridScreen
    m.loadingIndicator.visible = false ' hide loading indicator because content was retrieved
    m.GridScreen.content = m.contentTask.content ' populate GridScreen with content
end sub