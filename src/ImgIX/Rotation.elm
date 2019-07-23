module ImgIX.Rotation exposing
    ( Rotation
    , rotate
    , flipVertical, flipHorizontal
    , orientNorth, orientEast, orientSouth, orientWest
    , toQueryParameters
    )

{-| The rotation parameters allow you to change the orientation of your image, by either flipping along its axes or rotating around the center.


# Rotation

@docs Rotation

@docs rotate


# Flip Axis

Combine both functions to flip along both axes.

@docs flipVertical, flipHorizontal


# Orientation

Changes the cardinal orientation of the image by overriding any Exif orientation metadata.

By default, ImgIX automatically uses Exchangeable image file format (Exif) metadata present in the master image to orient your photos correctly. If your image does not contain Exif orientation data, we assume a value of 0 (North) and do not rotate the image.

@docs orientNorth, orientEast, orientSouth, orientWest


# Applying

@docs toQueryParameters

-}

import List.Extra as ListExtra exposing (group)
import Url.Builder as UrlBuilder exposing (QueryParameter, string)


{-| The type of a Rotation
-}
type Rotation
    = Flip FlipDirection
    | Orientation CaridnalDirection
    | Rotation Int



-- Rotation


{-| Rotate your image by given degrees
-}
rotate : Int -> Rotation
rotate =
    Rotation << modBy 360



-- Flip Axis


{-| Flip image vertically
-}
flipVertical : Rotation
flipVertical =
    Flip FlipVertical


{-| Flip image horizontally
-}
flipHorizontal : Rotation
flipHorizontal =
    Flip FlipHorizontal



-- Orientation


{-| Change the Exif orientation metadata to face North
-}
orientNorth : Rotation
orientNorth =
    Orientation North


{-| Change the Exif orientation metadata to face East
-}
orientEast : Rotation
orientEast =
    Orientation East


{-| Change the Exif orientation metadata to face South
-}
orientSouth : Rotation
orientSouth =
    Orientation South


{-| Change the Exif orientation metadata to face West
-}
orientWest : Rotation
orientWest =
    Orientation West



-- Applying


{-| Takes a list of rotations and turns it in to a list of query parameters that ImgIX understands
-}
toQueryParameters : List Rotation -> List UrlBuilder.QueryParameter
toQueryParameters rotations =
    List.foldl (\a b -> toQueryParameter_ a :: b) [] rotations
        |> List.reverse
        |> ListExtra.groupWhile (\( a, _ ) ( b, _ ) -> a == b)
        |> List.map
            (\( ( a, b ), c ) ->
                case a of
                    "flip" ->
                        ( "flip", String.join "" <| (b :: List.map Tuple.second c) )

                    _ ->
                        ( a, b )
            )
        |> List.map (\( a, b ) -> UrlBuilder.string a b)


toQueryParameter_ : Rotation -> ( String, String )
toQueryParameter_ rotation =
    case rotation of
        Flip FlipVertical ->
            ( "flip", "v" )

        Flip FlipHorizontal ->
            ( "flip", "h" )

        Orientation North ->
            ( "or", "1" )

        Orientation East ->
            ( "or", "6" )

        Orientation South ->
            ( "or", "3" )

        Orientation West ->
            ( "or", "8" )

        Rotation int ->
            ( "rot", String.fromInt int )



-- Types


type FlipDirection
    = FlipVertical
    | FlipHorizontal


type CaridnalDirection
    = North
    | East
    | South
    | West
