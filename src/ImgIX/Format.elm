module ImgIX.Format exposing
    ( Format, empty
    , q
    , lossless
    , toQueryParameters
    )

{-| The format parameters give you control over the output properties of your image across several aspects.

[ImgIX documentation for Format](https://docs.imgix.com/apis/rendering/format)

@docs Format, empty


# Output Quality

Controls the output quality of lossy file formats (jpg, pjpg, webp, or jxr).

Valid values are in the range 0 – 100 and the default is 75. Quality can often be set much lower than the default, especially when serving high-DPR images.

@docs q


# Lossless

The lossless parameter enables delivery of lossless images in formats that support lossless compression (JPEG XR and WEBP).

Valid values are 1/true and 0/false. When unset or set to an invalid value, lossless defaults to false.

@docs lossless


# Applying

@docs toQueryParameters

-}

import Maybe.Extra as Maybe
import Url.Builder as UrlBuilder


{-| The Format type
-}
type alias Format =
    { outputQuality : Maybe Int
    , useLossless : Maybe Bool
    }


{-| -}
empty : Format
empty =
    { outputQuality = Nothing
    , useLossless = Nothing
    }



-- Output Quality


{-| Set the output quality of lossy file formats.
-}
q : Int -> Format -> Format
q quality format =
    { format | outputQuality = Just quality }



-- Lossless


{-| Set to enable/disable the delivery of lossless images in formats that support lossless compression (JPEG XR and WEBP).
-}
lossless : Bool -> Format -> Format
lossless b format =
    { format | useLossless = Just b }



-- Applying


{-| Takes format operations and turns them to a list of URL query parameters that ImgIX understands
-}
toQueryParameters : Format -> List UrlBuilder.QueryParameter
toQueryParameters format =
    [ toQueryParameter "q" String.fromInt <| format.outputQuality
    , toQueryParameter "lossless" fromBool <| format.useLossless
    ]
        |> Maybe.values


toQueryParameter : String -> (a -> String) -> Maybe a -> Maybe UrlBuilder.QueryParameter
toQueryParameter parameterName f =
    Maybe.map (\a -> UrlBuilder.string parameterName (f a))


fromBool : Bool -> String
fromBool b =
    if b then
        "1"

    else
        "0"
