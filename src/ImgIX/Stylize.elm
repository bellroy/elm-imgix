module ImgIX.Stylize exposing
    ( Stylize
    , duotone, gaussianBlur, blur, halftone, monochrome, pixelate, sepia
    , toQueryParameters
    )

{-| The stylize parameters allow you to apply basic artistic effects to your images.

@docs Stylize


# Stylize

@docs duotone, gaussianBlur, blur, halftone, monochrome, pixelate, sepia


# Applying

@docs toQueryParameters

-}

import ImgIX.Internals.Color as Color exposing (Alpha, Color)
import Url.Builder as UrlBuilder exposing (QueryParameter, int, string)


{-| The Stylize type
-}
type Stylize
    = Duotone Color.Color Color.Color Color.Alpha
    | GaussianBlur Int
    | Halftone Int
    | Monochrome Color.Color
    | Pixelate Int
    | Sepia Int


{-| Applies a duotone effect—a gradient with two different colors as its endpoints—to the image.

To achieve this effect, the image is first converted to greyscale. Two colors, usually contrasting, are then mapped to that gradient.

ColorA is mapped to the darker parts of the image, and colorB to the lighter parts.

If you were to set a light color as colorA and a dark color as colorB, you would create a duotone with a photo negative effect.

**original**

![original](https://bellroy.imgix.net/dynamic-assets/W1siZnUiLCJodHRwczovL3MzLmFtYXpvbmF3cy5jb20vcHJvZHVjdC5pbWFnZXMuYmVsbHJveS5jb20vcHJvZHVjdF9pbWFnZXMvaW1hZ2VzLzAwMC8wMDMvODMzL29yaWdpbmFsLzc5ZmM2MGNkZmNkMjM5YWFjZGU3OWU4YTc2OTQ1NWZhOWJkN2MyODU3NGQ3Mzk0NDQxYTMyYmRmOGU4ZTdmOTUuanBnIl1d/5460fe0f4301a507/79fc60cdfcd239aacde79e8a769455fa9bd7c28574d7394441a32bdf8e8e7f95.jpg?fit=crop&w=150&h=150)

**duotone { colorA: #ff0000, colorB: #00ff00, alpha: 0.2 }**

![duotone](https://bellroy.imgix.net/dynamic-assets/W1siZnUiLCJodHRwczovL3MzLmFtYXpvbmF3cy5jb20vcHJvZHVjdC5pbWFnZXMuYmVsbHJveS5jb20vcHJvZHVjdF9pbWFnZXMvaW1hZ2VzLzAwMC8wMDMvODMzL29yaWdpbmFsLzc5ZmM2MGNkZmNkMjM5YWFjZGU3OWU4YTc2OTQ1NWZhOWJkN2MyODU3NGQ3Mzk0NDQxYTMyYmRmOGU4ZTdmOTUuanBnIl1d/5460fe0f4301a507/79fc60cdfcd239aacde79e8a769455fa9bd7c28574d7394441a32bdf8e8e7f95.jpg?fit=crop&w=150&h=150&duotone=ff0000,00ff00&duotone-alpha=20)

-}
duotone : { colorA : Color.Color, colorB : Color.Color, alpha : Float } -> Stylize
duotone { colorA, colorB, alpha } =
    Duotone colorA colorB alpha


{-| Applies a [Gaussian style](https://en.wikipedia.org/wiki/Gaussian_blur) blur to your image, smoothing out image noise.

Valid values are in the range from 0 – 2000.

**original**

![original](https://bellroy.imgix.net/dynamic-assets/W1siZnUiLCJodHRwczovL3MzLmFtYXpvbmF3cy5jb20vcHJvZHVjdC5pbWFnZXMuYmVsbHJveS5jb20vcHJvZHVjdF9pbWFnZXMvaW1hZ2VzLzAwMC8wMDMvODMzL29yaWdpbmFsLzc5ZmM2MGNkZmNkMjM5YWFjZGU3OWU4YTc2OTQ1NWZhOWJkN2MyODU3NGQ3Mzk0NDQxYTMyYmRmOGU4ZTdmOTUuanBnIl1d/5460fe0f4301a507/79fc60cdfcd239aacde79e8a769455fa9bd7c28574d7394441a32bdf8e8e7f95.jpg?fit=crop&w=150&h=150)

**gaussianBlur 10**

![gaussianBlur](https://bellroy.imgix.net/dynamic-assets/W1siZnUiLCJodHRwczovL3MzLmFtYXpvbmF3cy5jb20vcHJvZHVjdC5pbWFnZXMuYmVsbHJveS5jb20vcHJvZHVjdF9pbWFnZXMvaW1hZ2VzLzAwMC8wMDMvODMzL29yaWdpbmFsLzc5ZmM2MGNkZmNkMjM5YWFjZGU3OWU4YTc2OTQ1NWZhOWJkN2MyODU3NGQ3Mzk0NDQxYTMyYmRmOGU4ZTdmOTUuanBnIl1d/5460fe0f4301a507/79fc60cdfcd239aacde79e8a769455fa9bd7c28574d7394441a32bdf8e8e7f95.jpg?fit=crop&w=150&h=150&blur=10)

-}
gaussianBlur : Int -> Stylize
gaussianBlur =
    GaussianBlur << betweenZeroAndTwoThousand


{-| Same as gaussianBlur
-}
blur : Int -> Stylize
blur =
    gaussianBlur


{-| Applies a [half-toning](https://en.wikipedia.org/wiki/Halftone) effect to the image.

Valid values are in the range 0 – 100. The default value is 0, which leaves the image unchanged. The value represents the width of the halftone dots.

**original**

![original](https://bellroy.imgix.net/dynamic-assets/W1siZnUiLCJodHRwczovL3MzLmFtYXpvbmF3cy5jb20vcHJvZHVjdC5pbWFnZXMuYmVsbHJveS5jb20vcHJvZHVjdF9pbWFnZXMvaW1hZ2VzLzAwMC8wMDMvODMzL29yaWdpbmFsLzc5ZmM2MGNkZmNkMjM5YWFjZGU3OWU4YTc2OTQ1NWZhOWJkN2MyODU3NGQ3Mzk0NDQxYTMyYmRmOGU4ZTdmOTUuanBnIl1d/5460fe0f4301a507/79fc60cdfcd239aacde79e8a769455fa9bd7c28574d7394441a32bdf8e8e7f95.jpg?fit=crop&w=150&h=150)

**halftone 10**

![halftone](https://bellroy.imgix.net/dynamic-assets/W1siZnUiLCJodHRwczovL3MzLmFtYXpvbmF3cy5jb20vcHJvZHVjdC5pbWFnZXMuYmVsbHJveS5jb20vcHJvZHVjdF9pbWFnZXMvaW1hZ2VzLzAwMC8wMDMvODMzL29yaWdpbmFsLzc5ZmM2MGNkZmNkMjM5YWFjZGU3OWU4YTc2OTQ1NWZhOWJkN2MyODU3NGQ3Mzk0NDQxYTMyYmRmOGU4ZTdmOTUuanBnIl1d/5460fe0f4301a507/79fc60cdfcd239aacde79e8a769455fa9bd7c28574d7394441a32bdf8e8e7f95.jpg?fit=crop&w=150&h=150&htn=10)

-}
halftone : Int -> Stylize
halftone =
    Halftone << betweenZeroAndHundred


{-| Applies an overall monochromatic hue change.

The higher the intensity defined by the alpha channel, the closer you will get to a duotone effect.

**original**

![original](https://bellroy.imgix.net/dynamic-assets/W1siZnUiLCJodHRwczovL3MzLmFtYXpvbmF3cy5jb20vcHJvZHVjdC5pbWFnZXMuYmVsbHJveS5jb20vcHJvZHVjdF9pbWFnZXMvaW1hZ2VzLzAwMC8wMDMvODMzL29yaWdpbmFsLzc5ZmM2MGNkZmNkMjM5YWFjZGU3OWU4YTc2OTQ1NWZhOWJkN2MyODU3NGQ3Mzk0NDQxYTMyYmRmOGU4ZTdmOTUuanBnIl1d/5460fe0f4301a507/79fc60cdfcd239aacde79e8a769455fa9bd7c28574d7394441a32bdf8e8e7f95.jpg?fit=crop&w=150&h=150)

**monochrome #33ff0000**

![monochrome](https://bellroy.imgix.net/dynamic-assets/W1siZnUiLCJodHRwczovL3MzLmFtYXpvbmF3cy5jb20vcHJvZHVjdC5pbWFnZXMuYmVsbHJveS5jb20vcHJvZHVjdF9pbWFnZXMvaW1hZ2VzLzAwMC8wMDMvODMzL29yaWdpbmFsLzc5ZmM2MGNkZmNkMjM5YWFjZGU3OWU4YTc2OTQ1NWZhOWJkN2MyODU3NGQ3Mzk0NDQxYTMyYmRmOGU4ZTdmOTUuanBnIl1d/5460fe0f4301a507/79fc60cdfcd239aacde79e8a769455fa9bd7c28574d7394441a32bdf8e8e7f95.jpg?fit=crop&w=150&h=150&mono=33ff0000)

-}
monochrome : Color.Color -> Stylize
monochrome =
    Monochrome


{-| Applies a square pixellation effect to the image.

Valid values are in the range 0 – 100. The default value is 0, which leaves the image unchanged.

**original**

![original](https://bellroy.imgix.net/dynamic-assets/W1siZnUiLCJodHRwczovL3MzLmFtYXpvbmF3cy5jb20vcHJvZHVjdC5pbWFnZXMuYmVsbHJveS5jb20vcHJvZHVjdF9pbWFnZXMvaW1hZ2VzLzAwMC8wMDMvODMzL29yaWdpbmFsLzc5ZmM2MGNkZmNkMjM5YWFjZGU3OWU4YTc2OTQ1NWZhOWJkN2MyODU3NGQ3Mzk0NDQxYTMyYmRmOGU4ZTdmOTUuanBnIl1d/5460fe0f4301a507/79fc60cdfcd239aacde79e8a769455fa9bd7c28574d7394441a32bdf8e8e7f95.jpg?fit=crop&w=150&h=150)

**pixelate 10**

![pixelate](https://bellroy.imgix.net/dynamic-assets/W1siZnUiLCJodHRwczovL3MzLmFtYXpvbmF3cy5jb20vcHJvZHVjdC5pbWFnZXMuYmVsbHJveS5jb20vcHJvZHVjdF9pbWFnZXMvaW1hZ2VzLzAwMC8wMDMvODMzL29yaWdpbmFsLzc5ZmM2MGNkZmNkMjM5YWFjZGU3OWU4YTc2OTQ1NWZhOWJkN2MyODU3NGQ3Mzk0NDQxYTMyYmRmOGU4ZTdmOTUuanBnIl1d/5460fe0f4301a507/79fc60cdfcd239aacde79e8a769455fa9bd7c28574d7394441a32bdf8e8e7f95.jpg?fit=crop&w=150&h=150&px=10)

-}
pixelate : Int -> Stylize
pixelate =
    Pixelate << betweenZeroAndHundred


{-| Applies a sepia-toning effect to the image.

Valid values are in the range from 0 – 100. The default value is 0, which leaves the image unchanged.

**original**

![original](https://bellroy.imgix.net/dynamic-assets/W1siZnUiLCJodHRwczovL3MzLmFtYXpvbmF3cy5jb20vcHJvZHVjdC5pbWFnZXMuYmVsbHJveS5jb20vcHJvZHVjdF9pbWFnZXMvaW1hZ2VzLzAwMC8wMDMvODMzL29yaWdpbmFsLzc5ZmM2MGNkZmNkMjM5YWFjZGU3OWU4YTc2OTQ1NWZhOWJkN2MyODU3NGQ3Mzk0NDQxYTMyYmRmOGU4ZTdmOTUuanBnIl1d/5460fe0f4301a507/79fc60cdfcd239aacde79e8a769455fa9bd7c28574d7394441a32bdf8e8e7f95.jpg?fit=crop&w=150&h=150)

**sepia 80**

![sepia](https://bellroy.imgix.net/dynamic-assets/W1siZnUiLCJodHRwczovL3MzLmFtYXpvbmF3cy5jb20vcHJvZHVjdC5pbWFnZXMuYmVsbHJveS5jb20vcHJvZHVjdF9pbWFnZXMvaW1hZ2VzLzAwMC8wMDMvODMzL29yaWdpbmFsLzc5ZmM2MGNkZmNkMjM5YWFjZGU3OWU4YTc2OTQ1NWZhOWJkN2MyODU3NGQ3Mzk0NDQxYTMyYmRmOGU4ZTdmOTUuanBnIl1d/5460fe0f4301a507/79fc60cdfcd239aacde79e8a769455fa9bd7c28574d7394441a32bdf8e8e7f95.jpg?fit=crop&w=150&h=150&sepia=80)

-}
sepia : Int -> Stylize
sepia =
    Sepia << betweenZeroAndHundred



-- Applying


{-| -}
toQueryParameters : List Stylize -> List UrlBuilder.QueryParameter
toQueryParameters =
    List.foldl
        (\stylize list -> toQueryParameters_ stylize ++ list)
        []



-- Helpers


toQueryParameters_ : Stylize -> List UrlBuilder.QueryParameter
toQueryParameters_ stylize =
    case stylize of
        Duotone colorA colorB alpha ->
            [ String.join ","
                [ Color.toHex colorA
                , Color.toHex colorB
                ]
                |> UrlBuilder.string "duotone"
            , round (alpha * 100)
                |> String.fromInt
                |> UrlBuilder.string "duotone-alpha"
            ]

        GaussianBlur int ->
            [ UrlBuilder.int "blur" int ]

        Halftone int ->
            [ UrlBuilder.int "htn" int ]

        Monochrome color ->
            [ UrlBuilder.string "mono" <| Color.toHexAlpha color ]

        Pixelate int ->
            [ UrlBuilder.int "px" int ]

        Sepia int ->
            [ UrlBuilder.int "sepia" int ]


betweenZeroAndHundred : Int -> Int
betweenZeroAndHundred =
    between 0 100


betweenZeroAndTwoThousand : Int -> Int
betweenZeroAndTwoThousand =
    between 0 2000


between : Int -> Int -> Int -> Int
between a z value =
    if value < a then
        a

    else if value > z then
        z

    else
        value
