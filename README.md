# elm-imgix

A wrapper around ImgIX image API for Elm

![imgix logo](https://assets.imgix.net/presskit/imgix-presskit.pdf?page=3&fm=png&w=200)

From [imgix.com](https://www.imgix.com)

_Powerful image processing, simple API
imgix transforms, optimizes, and intelligently caches your entire image library for fast websites and apps using simple and robust URL parameters._

## Goal

The goal of this package is to supply a full comprehending API supporting all the available image configuration options made available by [imgix](https://www.imgix.com).

## ToDo

- [x] Adjustment
- [x] Automatic
- [ ] Blending
- [ ] Border & Padding
- [ ] Color Palette
- [x] Face Detection
- [x] Fill
- [x] Focal Point Crop
- [ ] Format
- [ ] Mask Image
- [ ] Noise Reduction
- [ ] PDF
- [ ] Pixel Density
- [x] Rotation
- [x] Size
- [ ] Stylize
- [ ] Text
- [ ] Trim
- [ ] Typesetting Endpoint
- [ ] Watermark

## Usage example A

```elm
import ImgIX
import ImgIX.Size


exampleB :   Html.Html msg
exampleB  =
  ImgIX.fromUrl imageUrlWomen
      |> ImgIX.sizes
          [ ImgIX.Size.height 200
          ]


```
![result example a](https://static-a.imgix.net/woman.jpg?h=200)


## Usage example B


```elm
import ImgIX
import ImgIX.Adjustment
import ImgIX.Automatic
import ImgIX.Rotation
import ImgIX.Size
import ImgIX.Stylize


exampleB :   Html.Html msg
exampleB  =
  ImgIX.fromUrl imageUrlWomen
      |> ImgIX.sizes
          [ ImgIX.Size.width 200
          , ImgIX.Size.height 200
          , ImgIX.Size.fitFaceArea
          ]
      |> ImgIX.adjustments
          [ ImgIX.Adjustment.brightness 20
          ]
      |> ImgIX.rotations
          [ ImgIX.Rotation.flipHorizontal
          , ImgIX.Rotation.rotate 12
          ]
      |> ImgIX.stylizations
          [ ImgIX.Stylize.blur 20
          , ImgIX.Stylize.sepia 99
          ]
      |> ImgIX.automatics
          [ ImgIX.Automatic.fileFormat
          ]


```

![result example b](https://static-a.imgix.net/woman.jpg?w=200&h=200&fit=facearea&rot=12&flip=h&bri=20&auto=format&blur=20&sepia=99)
