' *******************************************************************************************
' * Filename: MainLoaderTask.brs
' * Description: This file serves as the main task for fetching and parsing the JSON response
' *              data to then populate the content within the GridScreen.  
' * Author: Samuel Tregea
' *******************************************************************************************

' ****************************************
' Initialize the MainLoaderTask component.
' ****************************************
sub Init()
    ' set the name of the function in the Task node component to be executed when the state field changes to RUN
    ' in our case this method executed after the following cmd: m.contentTask.control = "run"
    ' (see Init method in MainScene)
    m.top.functionName = "GetContent"
end sub


' ***************************************************************
' Fetch and populate the content to display within the GridScene.
' ***************************************************************
sub GetContent()
    rootChildren = []
    ' Request the content feed from the API.
    json = GetJSONResponse("https://cd-static.bamgrid.com/dp-117731241344/home.json")

    ' Parse the feed and build a tree of ContentNodes to populate the GridScene.
    if json <> invalid

        ' Parse and handle the metadata from the response from https://cd-static.bamgrid.com/dp-117731241344/home.json
        rootChildren.Append(GetStandardCollectionRows(json))

        ' Parse and handle metadata from the response from https://cd-static.bamgrid.com/dp-117731241344/sets/<refId>.json
        rootChildren.Append(GetReferencedSetRows(json))

        ' Set up a root ContentNode to represent RowList on the GridScreen.
        rowListNode = CreateObject("roSGNode", "ContentNode")
        rowListNode.Update({ children: rootChildren }, true)

        ' Populate content field with root content node.
        ' Observer(see OnMainContentLoaded in MainScene.brs) is invoked at that moment.
        m.top.content = rowListNode
    end if
end sub


' ***************************************************************
' Construct a title for a Tile within the GridScreen.
' @param item - The object containing the json metadata to parse.
' @returns a formated title in the format: "Title | Rating".
' ***************************************************************
function CreateTitle(item as Object) as String
    title = GetTitle(item)
    rating = GetTVRating(item)

    if title = invalid then return invalid
    if rating = invalid then return title

    return "%s | %s".Format(title, rating)
end function


' *****************************************************************************************************
' Construct a dynamic description string that will be displayed within the DetailsScreen.
' @param item - The object containing the json metadata to parse.
' @returns a dynamically created description in the format: "Release Year • Runtime • Format • Rating".
' *****************************************************************************************************
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


' *********************************************************************************************************
' Read in the data from the JSON response to pass to the Tile.
' @param item - The object containing the json metadata to parse.
' @returns an object containing parsed data to display to the user within the GridScreen and DetailsScreen.
' *********************************************************************************************************
function GetTileData(item as Object) as Object
    data = {
        id : item.contentId,
        imageURI : GetImageURL(item, "tile", "1.78"),
        title : CreateTitle(item) ' This is the title displayed on the GridScreen.
        detailsTitle : GetTitle(item) ' This is the title displayed within the DetailsScreen.
        detailsImageURI : GetImageURL(item, "tile", "1.78"),
        description : CreateDescription(item),
        videoURL : GetVideoArtURL(item)
    }
    
    return data
end function


' *******************************************************************
' Construct a row containing the metadata for Tile's.
' @param title - The title for the row.
' @param items - The items to place within the row of the GridScreen.
' @returns a row containing a list of Tile metadata.
' *******************************************************************
function ConstructRow(title as String, items as Object) as Object
    row = {}
    row.title = title
    row.children = []

    if items <> invalid
        for each item in items
            if item <> invalid
                tile = GetTileData(item)
                row.children.push(tile)   
            endif
        end for
    end if

    return row
end function


' *************************************************************************************
' Construct a list of RowItemData containing the data from a StandardCollection object.
' @param json - The json containing the StandardCollection metadata.
' @returns a list of Tile's populated with data from the StandardCollection.
' *************************************************************************************
function GetStandardCollectionRows(json as Object) as Object
    rows = []

    ' Read in the StandardCollection data.
    containers = GetStandardCollectionContainers(json)
    for each container in containers           
        
        ' Read in and parse the StandardCollection dataset.
        if container <> invalid
            row = ConstructRow(GetShelfContainerTitle(container), GetStandardCollectionItems(container))

            ' Only add the row if there is data available.
            if NOT row.children.IsEmpty() then rows.push(row)
        end if

    end for

    return rows
end function


' *********************************************************************************
' Construct a list of RowItemData containing the data from a referenced set object.
' @param json - The json containing the Referenced Set metadata.
' @returns a list of rows populated with data from the Referenced Sets.
' *********************************************************************************
function GetReferencedSetRows(json as Object) as Object
    rows = []

    ' Read in the Reference ID's data.
    refIds = GetReferenceIds(json)

    ' Read in and parse the curated dataset.
    if refIds <> invalid
        for each refId in refIds
            if refId <> invalid
                row = ConstructRow(refIds[refId], GetReferencedItems(refId))

                ' Only add the row if there is data available.
                if NOT row.children.IsEmpty() then rows.push(row)
            end if
        end for
    end if
    
    return rows
end function