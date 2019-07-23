module ImgIX.Automatic exposing
    ( Automatic
    , compress, enhance, fileFormat, redEyeRemoval
    , toQueryParameter
    )

{-| The auto parameter helps you automate a baseline level of optimization across your entire image catalog. Currently, it has four different methods:

  - Compression
  - Visual enhancement
  - File format conversion
  - Redeye removal

[ImgIx documentation for Automatic](https://docs.imgix.com/apis/url/auto/auto)

@docs Automatic


# Available automatic optimizations

@docs compress, enhance, fileFormat, redEyeRemoval


# Applying

@docs toQueryParameter

-}

import Url.Builder as UrlBuilder exposing (QueryParameter, string)


{-| The Automatic type
-}
type Automatic
    = Compress
    | Enhance
    | FileFormat
    | RedEyeRemoval


{-| When compress is set, imgix will apply best-effort techniques to reduce the size of the image. This includes altering our normal processing algorithm to apply more aggressive image compression. auto=format is respected, so images will be served in a WebP format whenever possible. If the WebP format is not supported, images that contain transparency will be served in a PNG8 format, if supported, and all others will be served as JPEG. The quality standard (q) is set to 45.
-}
compress : Automatic
compress =
    Compress


{-| When enhance is set, the image is adjusted using the distribution of highlights, midtones, and shadows across all three channels—red, green, and blue (RGB). Overall, the enhancement gives images a more vibrant appearance.

The adjustment affects individual images differently, and works best with editorial photography, stock photography, and user-generated content for social media applications.

-}
enhance : Automatic
enhance =
    Enhance


{-| When fileFormat is set, imgix determines whether the image can be served in a better format by a process called automatic content negotiation.
-}
fileFormat : Automatic
fileFormat =
    FileFormat


{-| When redEyeRemoval is set, red-eye removal is applied to any detected faces.
-}
redEyeRemoval : Automatic
redEyeRemoval =
    RedEyeRemoval



-- Applying


{-| Takes a list of automatics and turns it in to a query parameters that ImgIX understands
-}
toQueryParameter : List Automatic -> UrlBuilder.QueryParameter
toQueryParameter automatics =
    List.map toQueryParameterValue automatics
        |> String.join ","
        |> UrlBuilder.string "auto"



-- Helpers


{-| Takes an automatic and turns it in to a string that ImgIX understands as a query parameter
-}
toQueryParameterValue : Automatic -> String
toQueryParameterValue automatic =
    case automatic of
        Compress ->
            "compress"

        Enhance ->
            "enhance"

        FileFormat ->
            "format"

        RedEyeRemoval ->
            "redeye"
