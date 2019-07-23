module ImgIX.Internals.Color exposing (Alpha, Color, toHex, toHexAlpha)


type alias Color =
    { red : Float, green : Float, blue : Float, alpha : Alpha }


type alias Alpha =
    Float


{-| Converts a color to a hexadecimal string.
-}
toHex : Color -> String
toHex color =
    let
        { red, green, blue } =
            color
    in
    List.map intToHex [ round red, round green, round blue ]
        |> String.join ""


{-| Converts a color to a hexadecimal string maintaining the alpha channel.
-}
toHexAlpha : Color -> String
toHexAlpha color =
    let
        { red, green, blue, alpha } =
            color
    in
    List.map intToHex [ round (alpha * 255), round red, round green, round blue ]
        |> String.join ""



-- Helpers


intToHex : Int -> String
intToHex =
    intToRadix >> String.padLeft 2 '0'


intToRadix : Int -> String
intToRadix n =
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
        intToRadix (n // 16) ++ getChr (modBy 16 n)
