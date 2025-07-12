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

        rootChildren.Append(GetStandaloneRows(json))

        rootChildren.Append(GetCuratedRows(json))

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


' Read in the data from the JSON response to pass to the RowListItem.
function GetItemData(item as Object) as Object
    data = {}
    data.id = item.contentId
    data.imageURI = GetImageURL(item, "tile", "1.78")
    data.title = CreateTitle(item) ' This is the title displayed on the GridScreen.
    data.videoTitle = GetVideoTitle(item) ' This is the title displayed within the DetailsScreen.
    data.detailsImageURI = GetImageURL(item, "tile", "1.78")
    data.description = CreateDescription(item)
    
    return data
end function


' Construct a Title for the main GridScreen in the format: Title | Rating.
function CreateTitle(item as Object) as String
    title = GetVideoTitle(item)
    rating = GetTVRating(item)

    if title = invalid then return invalid
    if rating = invalid then return title

    return "%s | %s".Format(title, rating)
end function


' Construct a dynamic Description string that will be displayed within the DetailsScreen.
function CreateDescription(item as Object) as String
    description = ""
    releaseYear = GetReleaseMetaData(item, "releaseYear")
    runtime = GetTime(GetMediaMetaData(item, "runtimeMillis"))
    format = GetMediaMetaData(item, "format")
    rating = GetTVRating(item)

    descriptionArray = [releaseYear, runtime, format, rating]
    
    ' Build the description based on the contents within the descriptionArray.
    validItemCount = 0
    for i = 0 to descriptionArray.Count()
        if descriptionArray[i] <> invalid

            if validItemCount = 0
                description = descriptionArray[i].ToStr()
            else
                description = "%s • %s".Format(description, descriptionArray[i].ToStr())
            end if

            validItemCount = validItemCount + 1
        end if
    end for

    return description
end function
    

' Construct a list of RowItemData containing the data from the Standalone JSON.
function GetStandaloneRows(json as Object) as Object
    rows = []

    ' Read in the Standalone data.
    containers = GetContainers(json)
    for each container in containers           
        
        ' Read in and parse the standalone dataset.
        if container <> invalid
            row = ConstructRowListItem(GetContainerTitle(container), GetStandaloneItems(container))

            ' Only add the row if there is data available.
            if NOT row.children.IsEmpty() then rows.push(row)
        end if

    end for

    return rows
end function


' Construct a list of RowListItem's containing the data from the Curated JSON.
function GetCuratedRows(json as Object) as Object
    rows = []

    ' Read in the Reference ID's data.
    refIds = GetReferenceIds(json)

    ' Read in and parse the curated dataset.
    if refIds <> invalid
        for each refId in refIds
            if refId <> invalid
                row = ConstructRowListItem(refIds[refId], GetCuratedItems(refId))

                ' Only add the row if there is data available.
                if NOT row.children.IsEmpty() then rows.push(row)
            end if
        end for
    end if
    
    return rows
end function


' Construct a RowListItem object.
function ConstructRowListItem(title as String, items as Object) as Object
    row = {}
    row.title = title
    row.children = []

    if items <> invalid
        for each item in items
            if item <> invalid
                data = GetItemData(item)
                row.children.push(data)   
            endif
        end for
    end if

    return row
end function