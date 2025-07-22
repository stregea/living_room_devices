' **************************************************************************************************************
' * Filename: jsonutils.brs
' * Description: This file holds helper functions that help with parsing JSON data read from the following urls:
' *              https://cd-static.bamgrid.com/dp-117731241344/home.json
' *              https://cd-static.bamgrid.com/dp-117731241344/sets/<refId>.json
' * Author: Samuel Tregea
' **************************************************************************************************************

'************************************************************************
' Construct the JSON response from the URL containing the Home Page data.
' @param url - The url to make the request to.
' @return the response of the GET request.
'************************************************************************
function GetJSONResponse(url as String) as Object
    ' Request the content feed from the API.
    urlXfer = CreateObject("roURLTransfer")
    urlXfer.SetCertificatesFile("common:/certs/ca-bundle.crt")
    urlXfer.SetURL(url)

    return ParseJson(urlXfer.GetToString())
end function


'****************************************************************************
' Retrieve the list of StandardCollection ShelfContainers from JSON metadata.
' @param json - The object to parse.
' @returns a list of containers held within the StandardCollection objects.
'****************************************************************************
function GetStandardCollectionContainers(json as Object) as Object
    return json.data.StandardCollection.containers
end function


'*****************************************************************
' Retrieve the title of the ShelfContainer from the JSON response.
' @param json - The object to parse.
' @returns the title of the ShelfContainer
'*****************************************************************
function GetShelfContainerTitle(container as Object) as Object
    return container.set.text.title.full.set.default.content
end function


'*********************************************************************
' Get the array of StandardCollection items from a ShelfContainer.
' @param container - The container to parse.
' @return the array of StandardCollection items from a ShelfContainer.
'*********************************************************************
function GetStandardCollectionItems(container as Object) as Object
    return container.set.items
end function


'*******************************************************************************
' Read the image URL from an item within the list of the ShelfContainer's items.
' @param json - The object to parse.
' @param imageType - The type of image to be requested. 
'                    (hero_collection, hero_tile, logo, logo_layer, tile)
' @param aspectRatio - The requested aspectRatio within the imageType.
' @returns the url based on the imageType and aspectRatio parameters.
'********************************************************************************
function GetImageURL(json as Object, imageType as String, aspectRatio as String) as Object
    imageMetaData = json.image.tile
    
    if imageMetaData = invalid OR ImageMetaData[aspectRatio] = invalid then return invalid
    
    image = imageMetaData[aspectRatio]

    ' Key can be either "default", "program", or "series".
    for each key in image
        url = image[key].default.url
        if url <> invalid then return url
    end for

    return invalid
end function


'*************************************************************
' Read the title from an object containing the title metadata.
' @param json - The object to parse.
' @returns the title metadata.
'*************************************************************
function GetTitle(json as Object) as Object
    fullTitle = json.text.title.full

    if fullTitle = invalid then return invalid

    ' Key can be either "program", or "series".
    for each key in fullTitle
        titleText = fullTitle[key].default.content
        if titleText <> invalid then return titleText
    end for

    return invalid
end function


'*******************************************************************
' Read the TV rating from an object containing the ratings metadata.
' @param json - The object to parse.
' @returns the ratings metadata.
'*******************************************************************
function GetTVRating(json as Object) as Object
    ratings = json.ratings
    
    if ratings = invalid then return invalid
    
    return ratings[0].value
end function


'**********************************************************************
' Read the parameterized metadata from the mediaMetaData object.
' @param json - The object to parse.
' @param property - The propery to return.
'                   (format, mediaId, phase, playbackUrls, productType,
'                    runtimeMillis, state, type)
' @returns the media metadata based on a parameterized property.
'**********************************************************************
function GetMediaMetaData(json as Object, property as String) as Object
    mediaMetaData = json.mediaMetaData

    if mediaMetaData = invalid OR mediaMetaData[property] = invalid then return invalid

    return mediaMetaData[property]
end function


'*********************************************************************
' Read the parameterized metadata from the released object.
' @param json - The object to parse.
' @param property - The propery to return.
'                   (releaseDate, releaseType, releaseYear, territory)
' @returns the releases metadata based on a parameterized property.
'*********************************************************************
function GetReleaseMetaData(json as Object, property as String) as Object
    releaseMetaData = json.releases

    if releaseMetaData = invalid OR releaseMetaData[0] = invalid then return invalid

    return releaseMetaData[0][property]
end function


'*********************************************************************
' Read the url property from the videoArt object metadata.
' @param json - The object to parse.
' @returns the video art playback url.
'*********************************************************************
function GetVideoArtURL(json as Object) as object
    videoArt = json.videoArt

    if videoArt = invalid OR videoArt[0] = invalid then return invalid

    if videoArt[0].mediaMetaData = invalid OR videoArt[0].mediaMetaData.urls = invalid OR videoArt[0].mediaMetaData.urls[0] = invalid
         return invalid
    end if

    return videoArt[0].mediaMetaData.urls[0].url
end function


'**********************************************************************
' Construct a dictionary of Reference ID's and Titles.
' @param json - The object to parse.
' @returns a dictionary containing Reference ID's for the Curated Sets.
'**********************************************************************
function GetReferenceIds(container as Object) as Object
    refIds = {}

    if container <> invalid and container.set <> invalid and container.set.refId <> invalid
        ' Store the Reference ID as the key, and the Title as the value.
        refIds[container.set.refId] = container.set.text.title.full.set.default.content
    end if

    return refIds
end function


'********************************************************************
' Construct an array of Referenced Set items based on a Reference ID.
' @param refId - The Reference ID.
' @return an array of Referenced Set items.
'********************************************************************
function GetReferencedItems(refId as Object) as Object
    items = []

    json = GetJSONResponse("https://cd-static.bamgrid.com/dp-117731241344/sets/%s.json".Format(refId))
    
    if json <> invalid AND json.data <> invalid
        
        ' Types of sets:
        ' * BecauseYouSet
        ' * CuratedSet
        ' * TrendingSet
        ' * PersonalizedCuratedSet
        ' Using a loop to dynamically access the set type.
        for each key in json.data
            if json.data[key] <> invalid and json.data[key].items <> invalid
                for each item in json.data[key].items
                    if item <> invalid
                        items.Push(item)
                    end if
                end for
            end if
        end for

    end if

    return items
end function