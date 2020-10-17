module ImgIX.PixelDensity exposing
    ( PixelDensity
    , dpr
    , toQueryParameters
    )

{-| Controls the output density of your image, so you can serve images at the correct density for every user's device from a single master image.

[ImgIX documentation for PixelDensity](https://docs.imgix.com/apis/rendering/pixel-density)

@docs PixelDensity


# Device Pixel Ratio

Device pixel ratio (DPR) is an easy way to convert between device-independent pixels and device pixels (also called "CSS pixels"), so that high-DPR images are only delivered to devices that can support them.
This makes images faster and saves bandwidth for users with lower-DPR devices, while delivering the expected crispness of high-DPR imagery to those devices.

@docs dpr


# Applying

@docs toQueryParameters

-}

import List.Extra as ListExtra exposing (groupWhile)
import Url.Builder as UrlBuilder exposing (QueryParameter, string)


{-| The PixelDensity type
-}
type PixelDensity
    = Dpr Int



-- Device Pixel Ratio


{-| The density of the output image.
-}
dpr : Int -> PixelDensity
dpr =
    Dpr



-- Applying


{-| Takes a list of pixel density operations and turns it in to a list of query parameters that ImgIX understands
-}
toQueryParameters : List PixelDensity -> List UrlBuilder.QueryParameter
toQueryParameters pixelDensityOperations =
    List.foldl (\a b -> toQueryParameters_ a ++ b) [] pixelDensityOperations
        |> ListExtra.groupWhile (\( a, _ ) ( b, _ ) -> a == b)
        |> List.map
            (\( ( a, b ), c ) ->
                ( a, String.join "," <| (b :: List.map Tuple.second c) )
            )
        |> List.map (\( a, b ) -> UrlBuilder.string a b)


toQueryParameters_ : PixelDensity -> List ( String, String )
toQueryParameters_ a =
    case a of
        Dpr density ->
            [ ( "dpr", String.fromInt density ) ]
