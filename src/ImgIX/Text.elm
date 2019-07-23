module ImgIX.Text exposing
    ( Text
    , text
    , serif, sansSerif, monospace, cursive, fantasy, font
    , bold, italic
    , fontSize
    , color, colour
    , padding
    , width
    , alignLeft, alignCenter, alignRight, alignTop, alignMiddle, alignBottom
    , clippingModeStart, clippingModeMiddle, clippingModeEnd, clippingModeEllipsis
    , fitModeMax
    , requiredLigatures, commonLigatures, allLigatures
    , outline
    , shadow
    , toQueryParameters
    )

{-| Adds a text overlay to your image, with positioning and a full range of formatting properties.

![example hello world!](https://assets.imgix.net/examples/clouds.jpg?blur=150&w=640&h=200&fit=crop&txt=HELLO%20WORLD!&txtsize=62&txtclr=ff2e4357&txtalign=middle,center&txtfont=Futura%20Condensed%20Medium&mono=ff6598cc)

@docs Text


# Text

@docs text


# Text Font

@docs serif, sansSerif, monospace, cursive, fantasy, font


# Text Style

@docs bold, italic


# Text Font Size

@docs fontSize


# Text Color

@docs color, colour


# Text Padding

@docs padding


# Text Width

@docs width


# Text Position

@docs alignLeft, alignCenter, alignRight, alignTop, alignMiddle, alignBottom


# Text Clipping Mode

Sets the region of the string that will be clipped if the string extends beyond the defined width of the text.

The ellipsis input adds an ellipsis on the region where the text is clipped, and can be combined with one of the other clipping methods.

If no value is set, the default value is end.

The `padding` and `width` functions are used to control the bounding region.

@docs clippingModeStart, clippingModeMiddle, clippingModeEnd, clippingModeEllipsis


# Text Fit Mode

@docs fitModeMax


# Text Ligatures

Enables support for ligatures in the text, if the selected font supports them.

@docs requiredLigatures, commonLigatures, allLigatures


# Text Outline

@docs outline


# Text Shadow

@docs shadow


# Applying

@docs toQueryParameters

-}

import Base64 as Base64 exposing (encode)
import ImgIX.Internals.Color as Color exposing (Color, toHexAlpha)
import List.Extra as ListExtra exposing (groupWhile)
import Url.Builder as UrlBuilder exposing (QueryParameter, int, string)


{-| The Text Type
-}
type Text
    = Text String
    | AlignVertically AlignVertically
    | AlignHorizontally AlignHorizontally
    | ClippingMode ClippingMode
    | Color Color.Color
    | FitMode FitMode
    | Font Font
    | Style Style
    | FontSize Int
    | Ligatures Ligatures
    | Outline { width : Int, color : Color.Color }
    | Padding Int
    | Shadow Float
    | Width Int



-- Text


{-| The text string to overlay on the image. This value must be supplied for text to be rendered—all other text parameters are ignored if it isn't set.

imgix has full support for UTF-8 characters, and will appropriately render non-Latin character sets and emoji. This means that you can easily pipe in localized text to a base image instead of creating a different master image for each language you want to support.

Text has the following defaults if none of the other text parameters are set:

  - Position: Lower right corner
  - Font: Helvetica
  - Size: 12px
  - Color: #000 (Opaque Black)
  - Padding: 10px

-}
text : String -> Text
text string =
    Text string



-- Text Font


{-| Set the font to a "CSS-Style" category
(e.g font-family: serif;)
-}
serif : Text
serif =
    Font Serif


{-| Set the font to a "CSS-Style" category
(e.g font-family: sans-serif;)
-}
sansSerif : Text
sansSerif =
    Font SansSerif


{-| Set the font to a "CSS-Style" category
(e.g font-family: monospace;)
-}
monospace : Text
monospace =
    Font Monospace


{-| Set the font to a "CSS-Style" category
(e.g font-family: cursive;)
-}
cursive : Text
cursive =
    Font Cursive


{-| Set the font to a "CSS-Style" category
(e.g font-family: fantasy;)
-}
fantasy : Text
fantasy =
    Font Fantasy


{-| Set the font to use an explicit typeface.

See the [ImgIX documentation Text Font](https://docs.imgix.com/apis/url/text/txtfont) for a list of available typefaces.

-}
font : String -> Text
font =
    Font << Typeface



-- Text Style


{-| Make the font style bold
-}
bold : Text
bold =
    Style Bold


{-| Make the font style italic
-}
italic : Text
italic =
    Style Italic



-- Text Font Size


{-| Sets the font size of the text, in pixels.

The value must be a number greater than 0. The default value is 12.

-}
fontSize : Int -> Text
fontSize =
    FontSize



-- Text Color


{-| Sets the color of the text.

The default is opaque black, 000.

-}
color : Color.Color -> Text
color =
    Color


{-| Alias of color
-}
colour : Color.Color -> Text
colour =
    color



-- Text Padding


{-| The amount of spacing (in pixels) to add around the text.

**The default is 10.**

-}
padding : Int -> Text
padding =
    Padding



-- Text Width


{-| The width (in pixels) to restrict the width of the text to.

The default value is calculated by the width of the output image, minus any padding on the left and right.

If the text exceeds the value of txtwidth, it will be clipped on a per-character basis;
the maximum number of characters that will fit in the specified width will be displayed.

The location of the clipping is determined by the value of the [Text Clipping Mode](#text-clipping-mode).

-}
width : Int -> Text
width =
    Width



-- Text Position


{-| align text to the left
-}
alignLeft : Text
alignLeft =
    AlignVertically Left


{-| align text to the center
-}
alignCenter : Text
alignCenter =
    AlignVertically Center


{-| align text to the right
-}
alignRight : Text
alignRight =
    AlignVertically Right


{-| align text to the top
-}
alignTop : Text
alignTop =
    AlignHorizontally Top


{-| align text to the middle
-}
alignMiddle : Text
alignMiddle =
    AlignHorizontally Middle


{-| align text to the bottom
-}
alignBottom : Text
alignBottom =
    AlignHorizontally Bottom



-- Text Clipping Mode


{-| Clip text to the start
-}
clippingModeStart : Text
clippingModeStart =
    ClippingMode ClippingModeStart


{-| Clip text to the middle
-}
clippingModeMiddle : Text
clippingModeMiddle =
    ClippingMode ClippingModeMiddle


{-| Clip text to the end
-}
clippingModeEnd : Text
clippingModeEnd =
    ClippingMode ClippingModeEnd


{-| Clip text using ellipsis
-}
clippingModeEllipsis : Text
clippingModeEllipsis =
    ClippingMode ClippingModeEllipsis



-- Fit Mode


{-| Presently, only the max fit mode is supported by ImgIX.
With no fit mode, the text will be clipped if it exceeds the contraints of the text bounds.
With `fitModeMax`, the text will be scaled down to fit within the bounds rather than clipping the text contents.

The default is to not set a fit mode.

The `padding` and `width` parameters are used to control the bounding region.

-}
fitModeMax : Text
fitModeMax =
    FitMode FitModeMax



-- Text Ligatures


{-| Enables typographically-required ligatures present in non-English languages.
-}
requiredLigatures : Text
requiredLigatures =
    Ligatures RequiredLigatures


{-| Enables common ligatures in the selected typeface.

This is the **default**

-}
commonLigatures : Text
commonLigatures =
    Ligatures CommonLigatures


{-| Enables all of the ligatures that are available in the selected typeface.
-}
allLigatures : Text
allLigatures =
    Ligatures AllLigatures



-- Text Outline


{-| Sets the width and color of the outline to draw around the text.
-}
outline : { width : Int, color : Color.Color } -> Text
outline =
    Outline



-- Text Shadow


{-| A number indicating the strength of a shadow to place on the text.

The default is no shadow, and the range is from 0 – 10.

-}
shadow : Float -> Text
shadow =
    Shadow << betweenZeroAndTen



-- Applying


{-| Takes a list of text options and turns it in to a list of query parameters that ImgIX understands
-}
toQueryParameters : List Text -> List UrlBuilder.QueryParameter
toQueryParameters textOptions =
    List.foldl (\a b -> toQueryParameters_ a ++ b) [] textOptions
        |> ListExtra.groupWhile (\( a, _ ) ( b, _ ) -> a == b)
        |> List.map
            (\( ( a, b ), c ) ->
                ( a, String.join "," <| (b :: List.map Tuple.second c) )
            )
        |> List.map (\( a, b ) -> UrlBuilder.string a b)


toQueryParameters_ : Text -> List ( String, String )
toQueryParameters_ a =
    case a of
        Text string ->
            [ ( "txt", string )
            ]

        AlignVertically Left ->
            [ ( "txtalign", "left" ) ]

        AlignVertically Center ->
            [ ( "txtalign", "center" ) ]

        AlignVertically Right ->
            [ ( "txtalign", "right" ) ]

        AlignHorizontally Top ->
            [ ( "txtalign", "top" ) ]

        AlignHorizontally Middle ->
            [ ( "txtalign", "middle" ) ]

        AlignHorizontally Bottom ->
            [ ( "txtalign", "bottom" ) ]

        ClippingMode ClippingModeStart ->
            [ ( "txtclip", "start" ) ]

        ClippingMode ClippingModeMiddle ->
            [ ( "txtclip", "middle" ) ]

        ClippingMode ClippingModeEnd ->
            [ ( "txtclip", "end" ) ]

        ClippingMode ClippingModeEllipsis ->
            [ ( "txtclip", "ellipsis" ) ]

        Color cl ->
            [ ( "txtclr", Color.toHexAlpha cl ) ]

        FitMode FitModeMax ->
            [ ( "txtfit", "max" ) ]

        Font Serif ->
            [ ( "txtfont", "serif" ) ]

        Font SansSerif ->
            [ ( "txtfont", "sans-serif" ) ]

        Font Monospace ->
            [ ( "txtfont", "monospace" ) ]

        Font Cursive ->
            [ ( "txtfont", "cursive" ) ]

        Font Fantasy ->
            [ ( "txtfont", "fantasy" ) ]

        Font (Typeface string) ->
            [ ( "txtfont64", Base64.encode string ) ]

        Style Bold ->
            [ ( "txtfont", "bold" ) ]

        Style Italic ->
            [ ( "txtfont", "italic" ) ]

        FontSize int ->
            [ ( "txtsize", String.fromInt int ) ]

        Ligatures RequiredLigatures ->
            [ ( "txtlig", "0" ) ]

        Ligatures CommonLigatures ->
            [ ( "txtlig", "1" ) ]

        Ligatures AllLigatures ->
            [ ( "txtlig", "2" ) ]

        Outline outlineOptions ->
            [ ( "txtline", String.fromInt outlineOptions.width )
            , ( "txtlineclr", Color.toHexAlpha outlineOptions.color )
            ]

        Padding int ->
            [ ( "txtpad", String.fromInt int ) ]

        Shadow float ->
            [ ( "txtshad", String.fromFloat float ) ]

        Width int ->
            [ ( "txtwidth", String.fromInt int ) ]


type AlignVertically
    = Left
    | Center
    | Right


type AlignHorizontally
    = Top
    | Middle
    | Bottom


type ClippingMode
    = ClippingModeStart
    | ClippingModeMiddle
    | ClippingModeEnd
    | ClippingModeEllipsis


type FitMode
    = FitModeMax


type Font
    = Serif
    | SansSerif
    | Monospace
    | Cursive
    | Fantasy
    | Typeface String


type Style
    = Bold
    | Italic


type Ligatures
    = RequiredLigatures
    | CommonLigatures
    | AllLigatures



-- Helpers


betweenZeroAndTen : number -> number
betweenZeroAndTen =
    between 0 10


between : number -> number -> number -> number
between a z value =
    if value < a then
        a

    else if value > z then
        z

    else
        value
