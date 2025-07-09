' *******************************************************************************************
' * Filename: MainLoaderTask.brs
' * Description: This file serves as the main task for fetching and parsing the JSON response
' *              data to then populate the content within the GridScreen.  
' * Author: Samuel Tregea
' *******************************************************************************************

' Initialize the MainLoaderTask component.
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

    ' parse the feed and build a tree of ContentNodes to populate the GridScene.
    if json <> invalid

        ' Read in the Standalone data.
        containers = GetContainers(json)
        for each container in containers            
            items = GetStandaloneItems(container)
            row = {}
            row.title = GetContainerTitle(container)
            row.children = []
            
            ' Read in and parse the standalone dataset.
            for each item in items
                if item <> invalid
                    data = GetItemData(item)
                    row.children.push(data)
                endif
            end for

            ' Only add the row if there is data available.
            if NOT row.children.IsEmpty() then rootChildren.push(row)

        end for

        ' Read in the Curated data.
        refIds = GetReferenceIds(json)
        for each refId in refIds
            row = {}
            row.title = refIds[refId]
            row.children = []

            ' Read in and parse the curated dataset.
            items = GetCuratedItems(refId)
            for each item in items
                if item <> invalid
                    data = GetItemData(item)
                    row.children.push(data)   
                endif
            end for

            ' Only add the row if there is data available.
            if NOT row.children.IsEmpty() then rootChildren.push(row)

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


' Return the array of Standalone items from a ShelfContainer.
function GetStandaloneItems(container as Object) as Object
    return container.set.items
end function


' Retrieve a dictionary of Reference ID's and Titles.
function GetReferenceIds(json as Object) as Object
    refIds = {}

    for each container in json.data.StandardCollection.containers
        if container <> invalid and container.set <> invalid and container.set.refId <> invalid
            ' Store the Reference ID as the key, and the Title as the value.
            refIds[container.set.refId] = container.set.text.title.full.set.default.content
        end if
    end for

    return refIds
end function


' Retrieve a list of curated items based on a Reference ID.
function GetCuratedItems(refId as Object) as Object
    items = []
    json = GetJSONResponse("https://cd-static.bamgrid.com/dp-117731241344/sets/%s.json".Format(refId))
    
    if json <> invalid and json.data <> invalid and json.data.CuratedSet <> invalid and json.data.CuratedSet.items <> invalid
        for each item in json.data.CuratedSet.items
            if item <> invalid
                items.Push(item)
            end if
        end for
    end if

    return items
end function

' Read in the data from the JSON response to pass to the RowListItem.
function GetItemData(item as Object) as Object
    data = {}
    data.id = item.contentId
    data.imageURI = GetImageURL(item.image, "1.78")
    data.title = GetVideoTitle(item.text.title)

    return data
end function


' Read in the image URL from an item within the list of the ShelfContainer's items.
function GetImageURL(image as Object, aspectRatio as String) as String
    tile = image.tile[aspectRatio]
    
    if tile = invalid then return invalid
    
    for each key in tile
        url = tile[key].default.url
        if url <> invalid then return url
    end for

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