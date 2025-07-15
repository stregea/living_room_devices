' ************************************************************************************
' * Filename: ContentLoadLogic.brs
' * Description: This file will handle the logic for initializing the data load tasks. 
' * Author: Samuel Tregea
' ************************************************************************************

' **************************************
' Fetch and load the data into the view.
' **************************************
sub FetchAndLoadData()
    ' Setup and display the loading indicator while data is being fetched.
    m.loadingIndicator = m.top.FindNode("loadingIndicator")
    m.loadingIndicator.poster.uri = "pkg:/images/loader.png"
    m.loadingIndicator.poster.ObserveField("loadStatus", "ShowLoadingIndicator")

    ' Create task for feed retrieving.
    m.contentTask = CreateObject("roSGNode", "MainLoaderTask")
    ' Observe content so we can know when feed content will be parsed
    m.contentTask.ObserveField("content", "OnMainContentLoadedObserver")

    m.contentTask.control = "run" ' GetContent(see MainLoaderTask.brs) method is executed.
end sub


' **********************************************************
' Observer that is invoked when content is ready to be used.
' **********************************************************
sub OnMainContentLoadedObserver()
    m.GridScreen.SetFocus(true)
    m.loadingIndicator.visible = false ' hide loading indicator because content was retrieved.
    m.GridScreen.content = m.contentTask.content ' Populate GridScreen with content.
end sub


' ****************************************************************************************************
' Observer that is invoked to center and show the loading indicator animation.
' Reference: https://github.com/rokudev/samples/tree/master/ux%20components/widgets/BusySpinnerExample
' ****************************************************************************************************
sub ShowLoadingIndicator()
    if m.loadingIndicator.poster.loadStatus = "ready"
        centerX = (1280 - m.loadingIndicator.poster.bitmapWidth) / 2
        centerY = (720 - m.loadingIndicator.poster.bitmapHeight) / 2

        m.loadingIndicator.translation = [ centerX, centerY ]
        m.loadingIndicator.visible = true
    end if
end sub