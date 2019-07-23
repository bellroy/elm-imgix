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
- [ ] Face Detection
- [ ] Fill
- [ ] Focal Point Crop
- [ ] Format
- [ ] Mask Image
- [ ] Noise Reduction
- [ ] PDF
- [ ] Pixel Density
- [ ] Rotation
- [x] Size
- [ ] Stylize
- [ ] Text
- [ ] Trim
- [ ] Typesetting Endpoint
- [ ] Watermark

## Simple usage example

Adjust the brightness of an imgix image and apply a list of automatic enhancement

```elm
import ImgIX
import ImgIX.Adjustment as Adjustment
import ImgIX.Automatic as Automatic

type alias Model =
    { imageSrc : Url.Url
    }

view : { imageSrc : Url.Url } -> Html.Html msg
view { imageSrc } =
    ImgIX.fromUrl imageSrc
        |> ImgIX.adjust (Adjustment.brightness 50)
        |> ImgIX.automatics [ Automatic.enhance, Automatic.compress, Automatic.fileFormat ]
        |> ImgIX.toHtml


```
