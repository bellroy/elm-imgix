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
- [x] Pixel Density
- [x] Rotation
- [x] Size
- [x] Stylize
- [x] Text
- [ ] Trim
- [ ] Typesetting Endpoint
- [ ] Watermark

## Usage example Simple

```elm
  ImgIX.fromUrl imageUrlWomen
      |> ImgIX.sizes
          [ ImgIX.Size.height 200
          ]


```
![result example a](https://static-a.imgix.net/woman.jpg?h=200)


## Usage example Advanced


```elm
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
      |> ImgIX.pixelDensities
          [ ImgIX.PixelDensity.dpr 2
          ]
      |> ImgIX.automatics
          [ ImgIX.Automatic.fileFormat
          ]


```

![result example b](https://static-a.imgix.net/woman.jpg?w=200&h=200&fit=facearea&dpr=2&rot=12&flip=h&bri=20&auto=format&blur=20&sepia=99)


## Usage example Text
```elm
ImgIX.fromUrl imageUrlWomen
    |> ImgIX.sizes
        [ ImgIX.Size.height 380
        ]
    |> ImgIX.stylizations
        [ ImgIX.Stylize.blur 30
        ]
    |> ImgIX.adjustments
        [ ImgIX.Adjustment.brightness -50
        ]
    |> ImgIX.textOptions
        [ ImgIX.Text.text "Hello World 👍 !"
        , ImgIX.Text.alignCenter
        , ImgIX.Text.alignMiddle
        , ImgIX.Text.fontSize 100
        , ImgIX.Text.fitModeMax
        , ImgIX.Text.padding 40
        , ImgIX.Text.color (Color.rgba 255 255 255 0.8)
        ]
```
![result example c](https://static-a.imgix.net/woman.jpg?h=380&bri=-50&auto=&blur=30&txt=Hello%20World%20%F0%9F%91%8D%20!&txtalign=center%2Cmiddle&txtsize=100&txtfit=max&txtpad=40&txtclr=ccffffff)
