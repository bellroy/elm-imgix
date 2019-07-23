module ImgIX.Size exposing
    ( Size
    , width, height, relativeWidth, relativeHeight, maxWidth, maxHeight, minWidth, minHeight
    , fitClamp, fitClip, fitCrop, fitFaceArea, fitFaceAreaWithOptions, fitFill, fitFillMax, fitMax, fitMin, fitScale
    , sourceRectangleRegion, sourcePositionX, sourcePositionXRelative, sourcePositionXLeft, sourcePositionXCenter, sourcePositionXRight, sourcePositionY, sourcePositionYRelative, sourcePositionYTop, sourcePositionYMiddle, sourcePositionYBottom
    , aspectRatio
    , cropModeTop, cropModeBottom, cropModeLeft, cropModeRight
    , cropModeFaces
    , cropModeFocalPoint
    , cropModeEdges, cropModeEntropy
    , toQueryParameters
    )

{-| The size parameters allow you to control all aspects of resizing, cropping, and the fit-to-crop behavior of your image.

[ImgIx documentation for Size](hhttps://docs.imgix.com/apis/url/size)

@docs Size


# Dimensions

If fit is set to clip `fitClip` or max `fitMax` then the actual output height may be equal to or less than the dimensions you specify.
If you'd like to resize using only height, please use `fitClip` to ensure that the other dimension will be accurately calculated.

@docs width, height, relativeWidth, relativeHeight, maxWidth, maxHeight, minWidth, minHeight


# Resize Fit Mode

The fit parameter controls how the output image is fit to its target dimensions after resizing, and how any background areas will be filled.

The default mode is `fitClip`.

@docs fitClamp, fitClip, fitCrop, fitFaceArea, fitFaceAreaWithOptions, fitFill, fitFillMax, fitMax, fitMin, fitScale


# Source Rectangle Region

@docs sourceRectangleRegion, sourcePositionX, sourcePositionXRelative, sourcePositionXLeft, sourcePositionXCenter, sourcePositionXRight, sourcePositionY, sourcePositionYRelative, sourcePositionYTop, sourcePositionYMiddle, sourcePositionYBottom


# AspectRatio

@docs aspectRatio


# Crop Mode

Crop mode controls how the image is aligned when resizeFitModeCrop is set

The Width and Height should also be set, so that the crop behavior is defined within specific image dimensions.

Multiple Crop Modes can be used


# Directional Cropping

The top, bottom, left, and right values allow you to specify the starting location of the crop.
If no value is explicitly set, the default behavior is to crop from the center of the image.

Image dimensions will be calculated from this starting point outward.

@docs cropModeTop, cropModeBottom, cropModeLeft, cropModeRight


# Face Croping

The example will crop to faces, and if there are no faces, then crops to the top right corner.

    ImgIX.fromUrl imageSrc
        |> ImgIX.sizes [ width 200, height 200, cropModeFaces, cropModeTop, cropModeRight ]
        |> ImgIX.toHtml

@docs cropModeFaces


# Focal Point Cropping

Focal Point Cropping allows you to target and zoom to a portion of the image using a relative vertical, horizontal and zoom value.

@docs cropModeFocalPoint


# Entropy and Edge Detection Cropping

@docs cropModeEdges, cropModeEntropy


# Applying

@docs toQueryParameters

-}

import Color as Color exposing (Color, toRgba)
import List.Extra as ListExtra exposing (group)
import Url.Builder as UrlBuilder exposing (QueryParameter, string)


{-| The Size type
-}
type Size
    = AspectRatio { width : Float, height : Float }
    | CropMode CropMode
    | Fit ResizeFitMode
    | Height Int
    | RelativeHeight Float
    | Width Int
    | RelativeWidth Float
    | MaxHeight Int
    | MaxWidth Int
    | MinHeight Int
    | MinWidth Int
    | SourceRectangleRegion { x : SourcePositionX, y : SourcePositionY, width : Int, height : Int }



-- Dimensions


{-| The width of the output image.
-}
width : Int -> Size
width =
    Width


{-| The height of the output image.
-}
height : Int -> Size
height =
    Height


{-| The relative width of the output image, interpreted as a ratio in relation to the source image size.
-}
relativeWidth : Float -> Size
relativeWidth =
    RelativeWidth


{-| The relative height of the output image, interpreted as a ratio in relation to the source image size.
-}
relativeHeight : Float -> Size
relativeHeight =
    RelativeHeight


{-| The maximum allowed width of the output image.

Must be an integer greater than 0. This parameter will only work if `fitCrop` is present.

-}
maxWidth : Int -> Size
maxWidth =
    MaxWidth


{-| The maximum allowed height of the output image.

Must be an integer greater than 0. This parameter will only work if `fitCrop` is present.

-}
maxHeight : Int -> Size
maxHeight =
    MaxHeight


{-| The minimum allowed width of the output image.

Must be an integer greater than 0. This parameter will only work if `fitCrop` is present.

-}
minWidth : Int -> Size
minWidth =
    MinWidth


{-| The minimum allowed height of the output image.

Must be an integer greater than 0. This parameter will only work if `fitCrop` is present.

-}
minHeight : Int -> Size
minHeight =
    MinHeight



-- Fit Modes


{-| Resizes the image to fit within the width and height dimensions without cropping or distorting the image, and the remaining space is filled with extended pixels from the edge of the image. The resulting image will match the constraining dimensions.

The pixel extension is called an affine clamp, hence the value name, "clamp".

![clamp](https://assets.imgix.net/docs/imgix-fitmodes.pdf?page=8&fm=png&w=640&h=176&crop=top&fit=crop&bg=ffffff&auto=enhance&con=10)

-}
fitClamp : Size
fitClamp =
    Fit Clamp


{-| Resizes the image to fit within the width and height boundaries without cropping or distorting the image. The resulting image will match one of the constraining dimensions, while the other dimension is altered to maintain the same aspect ratio of the input image.

![clip](https://assets.imgix.net/docs/imgix-fitmodes.pdf?page=1&fm=png&w=640&h=176&crop=top&fit=crop&bg=ffffff&auto=enhance&con=10)

-}
fitClip : Size
fitClip =
    Fit Clip


{-| Resizes the image to fill the width and height dimensions and crops any excess image data. The resulting image will match the width and height constraints without distorting the image. It's used in conjunction with the the crop parameter, which controls how the image is cropped.

Both the `width` and `height` parameters will also need to be set.

![crop](https://assets.imgix.net/docs/imgix-fitmodes.pdf?page=2&fm=png&w=640&h=176&crop=top&fit=crop&bg=ffffff&auto=enhance&con=10)

-}
fitCrop : Size
fitCrop =
    Fit Crop


{-| Finds the area containing all faces, or a specific face in an image, and scales it to specified width and height dimensions.

![facearea](https://assets.imgix.net/docs/imgix-fitmodes.pdf?page=7&fm=png&w=640&bg=fff)

-}
fitFaceArea : Size
fitFaceArea =
    Fit <| FaceArea Nothing


{-| Finds the area containing all faces, or a specific face in an image, and scales it to specified width and height dimensions.

Use in conjunction with index to identify a specific face, as well as padding to include additional padded area around the face to zoom out from the immediate area around the faces.

-}
fitFaceAreaWithOptions : { index : Int, padding : Int } -> Size
fitFaceAreaWithOptions =
    Fit << FaceArea << Just


{-| Resizes the image to fit within the requested width and height dimensions while preserving the original aspect ratio and without discarding any original image data.

Excess space is filled with a solid color or when no colour is suplied a blurred version of the image.

The resulting image exactly matches the requested dimensions.

To achieve these characteristics while also preventing an image from being sized beyond its original dimensions, see `fitFillMax`.

-}
fitFill : Maybe Color.Color -> Size
fitFill =
    Fit << Fill


{-| Resizes the image to fit within the requested width and height dimensions while preserving the original aspect ratio and without discarding any original image data. If the requested width or height exceeds that of the original, the original image remains the same size.

The excess space is filled with a solid color or blurred version of the image.

The resulting image exactly matches the requested dimensions.

Note that `fitFillMax` places constraints on upscaling the original image; `fitFill` does not, which may sometimes result in lower image quality.

-}
fitFillMax : Maybe Color.Color -> Size
fitFillMax =
    Fit << FillMax


{-| Resizes the image to fit within the width and height dimensions without cropping or distorting the image, but will not increase the size of the image if it is smaller than the output size.

The resulting image will maintain the same aspect ratio of the input image.

-}
fitMax : Size
fitMax =
    Fit Max


{-| Resizes and crops the image to match the aspect ratio of the requested width and height.

Will not exceed the original width and height of the image.

-}
fitMin : Size
fitMin =
    Fit Min


{-| Scales the image to fit the constraining dimensions exactly.

The resulting image will fill the dimensions, and will not maintain the aspect ratio of the input image.

-}
fitScale : Size
fitScale =
    Fit Scale



-- Source Rectangle Region


{-| By default, the entire image is used as the area for processing. The rect parameter selects a sub-region of the source image to use for processing before applying other resize operations.
-}
sourceRectangleRegion : { x : SourcePositionX, y : SourcePositionY, width : Int, height : Int } -> Size
sourceRectangleRegion =
    SourceRectangleRegion


{-| The starting position of x
-}
sourcePositionX : Int -> SourcePositionX
sourcePositionX =
    SourcePositionX


{-| The relative starting position of x
-}
sourcePositionXRelative : Float -> SourcePositionX
sourcePositionXRelative =
    SourcePositionXRelative


{-| Start from the left
-}
sourcePositionXLeft : SourcePositionX
sourcePositionXLeft =
    SourcePositionXLeft


{-| Start from the center
-}
sourcePositionXCenter : SourcePositionX
sourcePositionXCenter =
    SourcePositionXCenter


{-| Start from the right
-}
sourcePositionXRight : SourcePositionX
sourcePositionXRight =
    SourcePositionXRight


{-| The starting position of y
-}
sourcePositionY : Int -> SourcePositionY
sourcePositionY =
    SourcePositionY


{-| The relative starting position of y
-}
sourcePositionYRelative : Float -> SourcePositionY
sourcePositionYRelative =
    SourcePositionYRelative


{-| Start from the top
-}
sourcePositionYTop : SourcePositionY
sourcePositionYTop =
    SourcePositionYTop


{-| Start from the middle
-}
sourcePositionYMiddle : SourcePositionY
sourcePositionYMiddle =
    SourcePositionYMiddle


{-| Start from the bottom
-}
sourcePositionYBottom : SourcePositionY
sourcePositionYBottom =
    SourcePositionYBottom



-- AspectRatio


{-| Resizes and crops the original image to match a specified aspect ratio.

**This will only work when crop is set.**

-}
aspectRatio : { width : Float, height : Float } -> Size
aspectRatio =
    AspectRatio



-- CropMode


{-| Crop from the top of the image, down.
-}
cropModeTop : Size
cropModeTop =
    CropMode CropModeTop


{-| Crop from the bottom of the image, up.
-}
cropModeBottom : Size
cropModeBottom =
    CropMode CropModeBottom


{-| Crop from the left of the image, right.
-}
cropModeLeft : Size
cropModeLeft =
    CropMode CropModeLeft


{-| Crop from the right of the image, left.
-}
cropModeRight : Size
cropModeRight =
    CropMode CropModeRight


{-| Crop to faces

Default crop

![default crop](https://static-c.imgix.net/woman.jpg?w=120&h=120&fit=crop)

Crop to faces

![crop to faces](https://static-c.imgix.net/woman.jpg?w=120&h=120&fit=crop&crop=faces)

-}
cropModeFaces : Size
cropModeFaces =
    CropMode CropModeFaces


{-| The following example illustrates the difference between the default centered crop and one made with focal point parameters to target and zoom to a portion of the image.

Default crop

![default crop](https://assets.imgix.net/unsplash/walrus.jpg?w=150&fit=crop)

Vertical 1.2, Horizontal 0.35, Zoom 2

![Vertical 1.2, Horizontal 0.35, Zoom 2](https://assets.imgix.net/unsplash/walrus.jpg?h=150&w=150&fit=crop&crop=focalpoint&fp-x=1.2&fp-y=.35&fp-z=2)

-}
cropModeFocalPoint : { vertical : Float, horizontal : Float, zoom : Float } -> Size
cropModeFocalPoint =
    CropMode << CropModeFocalPoint


{-| The edges crop automatically finds and crops to an area of interest by performing edge detection, looking for objects within the image.

Default crop

![default crop](https://assets.imgix.net/unsplash/kayak.jpg?w=150)

Edges crop

![edges crop](https://assets.imgix.net/unsplash/kayak.jpg?w=300&h=150&fit=crop&crop=edges)

-}
cropModeEdges : Size
cropModeEdges =
    CropMode CropModeEdges


{-| The entropy crop automatically finds and crops to an area of interest by looking for busy sections of the image.

Default crop

![default crop](https://assets.imgix.net/unsplash/kayak.jpg?w=150)

Entropy crop

![entropy crop](https://assets.imgix.net/unsplash/kayak.jpg?w=300&h=150&fit=crop&crop=entropy)

-}
cropModeEntropy : Size
cropModeEntropy =
    CropMode CropModeEntropy



-- Applying


{-| Takes a list of sizes and turns it in to a list of query parameters that ImgIX understands
-}
toQueryParameters : List Size -> List UrlBuilder.QueryParameter
toQueryParameters sizes =
    List.foldl (\a b -> toQueryParameters_ a ++ b) [] sizes
        |> ListExtra.groupWhile (\( a, _ ) ( b, _ ) -> a == b)
        |> List.map
            (\( ( a, b ), c ) ->
                ( a, String.join "," <| (b :: List.map Tuple.second c) )
            )
        |> List.map (\( a, b ) -> UrlBuilder.string a b)


toQueryParameters_ : Size -> List ( String, String )
toQueryParameters_ a =
    case a of
        AspectRatio ar ->
            [ ( "ar", String.join ":" [ String.fromFloat ar.width, String.fromFloat ar.height ] ) ]

        CropMode cropMode ->
            case cropMode of
                CropModeTop ->
                    [ ( "crop", "top" ) ]

                CropModeBottom ->
                    [ ( "crop", "bottom" ) ]

                CropModeLeft ->
                    [ ( "crop", "left" ) ]

                CropModeRight ->
                    [ ( "crop", "right" ) ]

                CropModeFaces ->
                    [ ( "crop", "faces" ) ]

                CropModeFocalPoint { vertical, horizontal, zoom } ->
                    [ ( "fp-x", String.fromFloat vertical )
                    , ( "fp-y", String.fromFloat horizontal )
                    , ( "fp-z", String.fromFloat zoom )
                    ]

                CropModeEdges ->
                    [ ( "crop", "edges" ) ]

                CropModeEntropy ->
                    [ ( "crop", "entropy" ) ]

        Fit resizeFitMode ->
            case resizeFitMode of
                Clamp ->
                    [ ( "fit", "clamp" ) ]

                Clip ->
                    [ ( "fit", "clip" ) ]

                Crop ->
                    [ ( "fit", "crop" ) ]

                FaceArea Nothing ->
                    [ ( "fit", "facearea" ) ]

                FaceArea (Just { index, padding }) ->
                    [ ( "fit", "facearea" )
                    , ( "faceindex ", String.fromInt index )
                    , ( "facepad", String.fromInt padding )
                    ]

                Fill Nothing ->
                    [ ( "fit", "fill" )
                    , ( "fill", "blur" )
                    ]

                Fill (Just color) ->
                    let
                        { alpha } =
                            Color.toRgba color
                    in
                    if alpha == 0 then
                        [ ( "fit", "fill" )
                        ]

                    else
                        [ ( "fit", "fill" )
                        , ( "fill", "solid" )
                        , ( "fill-color", colorToHex color )
                        ]

                FillMax Nothing ->
                    [ ( "fit", "fillmax" ) ]

                FillMax (Just color) ->
                    let
                        { alpha } =
                            Color.toRgba color
                    in
                    if alpha == 0 then
                        [ ( "fit", "fill" )
                        ]

                    else
                        [ ( "fit", "fillmax" )
                        , ( "fill", "solid" )
                        , ( "fill-color", colorToHex color )
                        ]

                Max ->
                    [ ( "fit", "max" ) ]

                Min ->
                    [ ( "fit", "min" ) ]

                Scale ->
                    [ ( "fit", "scale" ) ]

        Height int ->
            [ ( "h", String.fromInt int ) ]

        RelativeHeight float ->
            [ ( "h", String.fromFloat float ) ]

        Width int ->
            [ ( "w", String.fromInt int ) ]

        RelativeWidth float ->
            [ ( "w", String.fromFloat float ) ]

        MaxHeight int ->
            [ ( "max-h", String.fromInt int ) ]

        MaxWidth int ->
            [ ( "max-w", String.fromInt int ) ]

        MinHeight int ->
            [ ( "min-h", String.fromInt int ) ]

        MinWidth int ->
            [ ( "min-w", String.fromInt int ) ]

        SourceRectangleRegion rect ->
            let
                x =
                    case rect.x of
                        SourcePositionX int ->
                            String.fromInt int

                        SourcePositionXRelative float ->
                            String.fromFloat float

                        SourcePositionXLeft ->
                            "left"

                        SourcePositionXCenter ->
                            "center"

                        SourcePositionXRight ->
                            "right"

                y =
                    case rect.y of
                        SourcePositionY int ->
                            String.fromInt int

                        SourcePositionYRelative float ->
                            String.fromFloat float

                        SourcePositionYTop ->
                            "top"

                        SourcePositionYMiddle ->
                            "middle"

                        SourcePositionYBottom ->
                            "bottom"
            in
            [ ( "rect"
              , String.join ","
                    [ x
                    , y
                    , String.fromInt rect.width
                    , String.fromInt rect.height
                    ]
              )
            ]



-- Types


type CropMode
    = CropModeTop
    | CropModeBottom
    | CropModeLeft
    | CropModeRight
    | CropModeFaces
    | CropModeFocalPoint { vertical : Float, horizontal : Float, zoom : Float }
    | CropModeEdges
    | CropModeEntropy


type ResizeFitMode
    = Clamp
    | Clip
    | Crop
    | FaceArea (Maybe { index : Int, padding : Int })
    | Fill (Maybe Color.Color)
    | FillMax (Maybe Color.Color)
    | Max
    | Min
    | Scale


type SourcePositionX
    = SourcePositionX Int
    | SourcePositionXRelative Float
    | SourcePositionXLeft
    | SourcePositionXCenter
    | SourcePositionXRight


type SourcePositionY
    = SourcePositionY Int
    | SourcePositionYRelative Float
    | SourcePositionYTop
    | SourcePositionYMiddle
    | SourcePositionYBottom



-- Helpers


{-| Converts a color to a hexadecimal string.
-}
colorToHex : Color.Color -> String
colorToHex color =
    let
        { red, green, blue } =
            Color.toRgba color
    in
    List.map toHex [ round red, round green, round blue ]
        |> String.join ""


toHex : Int -> String
toHex =
    toRadix >> String.padLeft 2 '0'


toRadix : Int -> String
toRadix n =
    let
        getChr c =
            if c < 10 then
                String.fromInt c

            else
                String.fromChar <| Char.fromCode (87 + c)
    in
    if n < 16 then
        getChr n

    else
        toRadix (n // 16) ++ getChr (modBy 16 n)
