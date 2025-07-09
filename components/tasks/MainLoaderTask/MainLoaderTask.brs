' *******************************************************************************************
' * Filename: MailLoaderTask.brs
' * Description: This file serves as the main task for fetching and parsing the JSON response
' *              data to then populate the content within the GridScreen.  
' * Author: Samuel Tregea
' *******************************************************************************************

sub Init()
    ' set the name of the function in the Task node component to be executed when the state field changes to RUN
    ' in our case this method executed after the following cmd: m.contentTask.control = "run"
    ' (see Init method in MainScene)
    m.top.functionName = "GetContent"
end sub


' Fetch and populate the content to display within the GridScene.
sub GetContent()
    rootChildren = []

    ' request the content feed from the API
    json = GetJSONResponse("https://cd-static.bamgrid.com/dp-117731241344/home.json")
    if json <> invalid

        ' parse the feed and build a tree of ContentNodes to populate the GridScene.
        containers = GetContainers(json)
        for each container in containers
            
            ' Add each of the row items to the row
            items = GetContainerItems(container)
            if container <> invalid AND items <> invalid
                row = {}
                row.title = GetContainerTitle(container)
                row.children = []
                
                ' Parse the data that will be passed into the RowListItems.
                for each item in items
                    data = GetItemData(item)
                    row.children.push(data)
                end for

                rootChildren.push(row)
            end if
        end for

        ' set up a root ContentNode to represent rowList on the GridScreen.
        rowListNode = CreateObject("roSGNode", "ContentNode")
        rowListNode.Update({
            children: rootChildren
        }, true)
        
        ' populate content field with root content node.
        ' Observer(see OnMainContentLoaded in MainScene.brs) is invoked at that moment
        m.top.content = rowListNode
    end if
end sub


' Construct the JSON response from the URL containing the Home Page data.
function GetJSONResponse(url as String) as Object
    ' Request the content feed from the API.
    urlXfer = CreateObject("roURLTransfer")
    urlXfer.SetCertificatesFile("common:/certs/ca-bundle.crt")
    urlXfer.SetURL(url)

    return ParseJson(urlXfer.GetToString())
end function


' Retrieve the list of ShelfContainers from the JSON response.
function GetContainers(json as Object) as Object
    return json.data.StandardCollection.containers
end function


' Retrieve the title of the ShelfContainer from the JSON response.
function GetContainerTitle(container as Object) as Object
    return container.set.text.title.full.set.default.content
end function


' Return the array of items from a ShelfContainer.
function GetContainerItems(container as Object) as Object
    return container.set.items
end function


' Read in the data from the JSON response to pass to the RowListItem.
function GetItemData(item as Object) as Object
    data = {}
    data.id = item.contentId
    data.hdPosterURL = GetImageURL(item.image, "1.78")
    data.title = GetVideoTitle(item.text.title)

    return data
end function


' Read in the image URL from an item within the list of the ShelfContainer's items.
function GetImageURL(image as Object, aspectRatio as String) as String
    tile = image.tile[aspectRatio]
    
    if tile = invalid then return "pkg:/images/splash_hd.jpg"
    
    for each key in tile
        url = tile[key].default.url

        if url <> invalid then return url
    end for

    print "here"
    return invalid
end function


' Read in the video title from an item within the list of the ShelfContainer's items.
function GetVideoTitle(title as Object) as String
    fullTitle = title.full

    if fullTitle = invalid then return invalid

    for each key in fullTitle
        titleText = fullTitle[key].default.content

        if titleText <> invalid then return titleText
    end for

    return invalid
end function