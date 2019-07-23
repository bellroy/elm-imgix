module Example exposing (main)

import Browser exposing (element)
import Html
import ImgIX
import ImgIX.Adjustment
import ImgIX.Automatic
import ImgIX.Rotation
import ImgIX.Size
import ImgIX.Stylize
import Url


type Model
    = Model


type Msg
    = NoOp


main : Program () Model Msg
main =
    element
        { init = init
        , update = update
        , subscriptions = always Sub.none
        , view = view
        }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


view : Model -> Html.Html Msg
view _ =
    let
        exampleA =
            ImgIX.fromUrl imageUrlWomen
                |> ImgIX.sizes
                    [ ImgIX.Size.height 200
                    ]

        exampleB =
            ImgIX.fromUrl imageUrlWomen
                |> ImgIX.sizes
                    [ ImgIX.Size.width 200
                    , ImgIX.Size.height 200
                    , ImgIX.Size.fitFaceArea
                    ]
                |> ImgIX.adjustments
                    [ ImgIX.Adjustment.brightness 20
                    ]
                |> ImgIX.automatics
                    [ ImgIX.Automatic.fileFormat
                    ]
                |> ImgIX.rotations
                    [ ImgIX.Rotation.flipHorizontal
                    , ImgIX.Rotation.rotate 12
                    ]
                |> ImgIX.stylizations
                    [ ImgIX.Stylize.blur 20
                    , ImgIX.Stylize.sepia 99
                    ]
    in
    Html.div []
        [ Html.h1 [] [ Html.text "elm-imgix Example" ]
        , Html.h2 [] [ Html.text "Crop to height 200" ]
        , ImgIX.toHtml exampleA
        , Html.h2 [] [ Html.text "Crop 200 x 200, focus on face and set brightness to 20, flip and rotate, blur and apply sepia, serve as optimal file format" ]
        , ImgIX.toHtml exampleB
        ]


imageUrlWomen : Url.Url
imageUrlWomen =
    { protocol = Url.Https
    , host = "static-a.imgix.net"
    , port_ = Nothing
    , path = "/woman.jpg"
    , query = Nothing
    , fragment = Nothing
    }
