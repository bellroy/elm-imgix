module ImgIX.Format exposing
    ( Format
    , q
    , toQueryParameters
    )

{-| The format parameters give you control over the output properties of your image across several aspects.

[ImgIX documentation for Format](https://docs.imgix.com/apis/rendering/format)

@docs Format


# Output Quality

Controls the output quality of lossy file formats (jpg, pjpg, webp, or jxr).

Valid values are in the range 0 – 100 and the default is 75. Quality can often be set much lower than the default, especially when serving high-DPR images.

@docs q


# Applying

@docs toQueryParameters

-}

import List.Extra as ListExtra exposing (groupWhile)
import Url.Builder as UrlBuilder exposing (QueryParameter, string)


{-| The Format type
-}
type Format
    = OutputQuality Int



-- Device Pixel Ratio


{-| The output quality of lossy file formats.
-}
q : Int -> Format
q =
    OutputQuality



-- Applying


{-| Takes a list of format operations and turns it in to a list of query parameters that ImgIX understands
-}
toQueryParameters : List Format -> List UrlBuilder.QueryParameter
toQueryParameters formatOperations =
    List.foldl (\a b -> toQueryParameters_ a ++ b) [] formatOperations
        |> ListExtra.groupWhile (\( a, _ ) ( b, _ ) -> a == b)
        |> List.map
            (\( ( a, b ), c ) ->
                ( a, String.join "," <| (b :: List.map Tuple.second c) )
            )
        |> List.map (\( a, b ) -> UrlBuilder.string a b)


toQueryParameters_ : Format -> List ( String, String )
toQueryParameters_ (OutputQuality quality) =
    [ ( "q", String.fromInt quality ) ]
