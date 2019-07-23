module ImgIX.Adjustment exposing
    ( Adjustment
    , brightness, contrast, exposure, gamma, highlight, hueshift, invert, saturation, shadow, sharpen, unsharpmask, vibrance
    , toQueryParameters
    )

{-| Adjustment parameters do basic retouching operations similar to those in image-editing applications like Adobe® Photoshop®. You can use them to fix common issues such as under- or over-exposure, blurriness, and color range, or alter your images artistically.

For additional artistic effects, see the Stylize parameters.

[ImgIx documentation for Adjustments](https://docs.imgix.com/apis/url/adjustment)

@docs Adjustment


# Available adjustments

@docs brightness, contrast, exposure, gamma, highlight, hueshift, invert, saturation, shadow, sharpen, unsharpmask, vibrance


# Applying

@docs toQueryParameters

-}

import Url.Builder as UrlBuilder exposing (QueryParameter, int, string)


{-| The Adjustment type
-}
type Adjustment
    = Brightness Int
    | Contrast Int
    | Exposure Int
    | Gamma Int
    | HighLight Int
    | HueShift Int
    | Invert
    | Saturation Int
    | Shadow Int
    | Sharpen Int
    | UnsharpMask Int Float
    | Vibrance Int


{-| Adjusts the overall brightness of the image.

Valid values are in the range -100 – 100. The default value is 0, which leaves the image unchanged.

**original**

![original](https://bellroy.imgix.net/dynamic-assets/W1siZnUiLCJodHRwczovL3MzLmFtYXpvbmF3cy5jb20vcHJvZHVjdC5pbWFnZXMuYmVsbHJveS5jb20vcHJvZHVjdF9pbWFnZXMvaW1hZ2VzLzAwMC8wMDMvODMzL29yaWdpbmFsLzc5ZmM2MGNkZmNkMjM5YWFjZGU3OWU4YTc2OTQ1NWZhOWJkN2MyODU3NGQ3Mzk0NDQxYTMyYmRmOGU4ZTdmOTUuanBnIl1d/5460fe0f4301a507/79fc60cdfcd239aacde79e8a769455fa9bd7c28574d7394441a32bdf8e8e7f95.jpg?fit=crop&w=150&h=150")

**brightness 50**

![brightness 50](https://bellroy.imgix.net/dynamic-assets/W1siZnUiLCJodHRwczovL3MzLmFtYXpvbmF3cy5jb20vcHJvZHVjdC5pbWFnZXMuYmVsbHJveS5jb20vcHJvZHVjdF9pbWFnZXMvaW1hZ2VzLzAwMC8wMDMvODMzL29yaWdpbmFsLzc5ZmM2MGNkZmNkMjM5YWFjZGU3OWU4YTc2OTQ1NWZhOWJkN2MyODU3NGQ3Mzk0NDQxYTMyYmRmOGU4ZTdmOTUuanBnIl1d/5460fe0f4301a507/79fc60cdfcd239aacde79e8a769455fa9bd7c28574d7394441a32bdf8e8e7f95.jpg?bri=50&fit=crop&w=150&h=150")

-}
brightness : Int -> Adjustment
brightness =
    Brightness << betweenNegativeHundredAndHundred


{-| Adjusts the contrast of the image.

Valid values are in the range -100 – 100. The default value is 0, which leaves the image unchanged.

**original**

![original](https://bellroy.imgix.net/dynamic-assets/W1siZnUiLCJodHRwczovL3MzLmFtYXpvbmF3cy5jb20vcHJvZHVjdC5pbWFnZXMuYmVsbHJveS5jb20vcHJvZHVjdF9pbWFnZXMvaW1hZ2VzLzAwMC8wMDMvODMzL29yaWdpbmFsLzc5ZmM2MGNkZmNkMjM5YWFjZGU3OWU4YTc2OTQ1NWZhOWJkN2MyODU3NGQ3Mzk0NDQxYTMyYmRmOGU4ZTdmOTUuanBnIl1d/5460fe0f4301a507/79fc60cdfcd239aacde79e8a769455fa9bd7c28574d7394441a32bdf8e8e7f95.jpg?fit=crop&w=150&h=150")

**contrast -50**

![contrast -50](https://bellroy.imgix.net/dynamic-assets/W1siZnUiLCJodHRwczovL3MzLmFtYXpvbmF3cy5jb20vcHJvZHVjdC5pbWFnZXMuYmVsbHJveS5jb20vcHJvZHVjdF9pbWFnZXMvaW1hZ2VzLzAwMC8wMDMvODMzL29yaWdpbmFsLzc5ZmM2MGNkZmNkMjM5YWFjZGU3OWU4YTc2OTQ1NWZhOWJkN2MyODU3NGQ3Mzk0NDQxYTMyYmRmOGU4ZTdmOTUuanBnIl1d/5460fe0f4301a507/79fc60cdfcd239aacde79e8a769455fa9bd7c28574d7394441a32bdf8e8e7f95.jpg?con=-50&fit=crop&w=150&h=150")

[ImgIx documentation for Contrast](https://docs.imgix.com/apis/url/adjustment/con)

-}
contrast : Int -> Adjustment
contrast =
    Contrast << betweenNegativeHundredAndHundred


{-| Adjusts the exposure setting for an image, similar to changing the F-stop on a camera.

Valid values are in the range -100 – 100. The default value is 0, which leaves the image unchanged.

**original**

![original](https://bellroy.imgix.net/dynamic-assets/W1siZnUiLCJodHRwczovL3MzLmFtYXpvbmF3cy5jb20vcHJvZHVjdC5pbWFnZXMuYmVsbHJveS5jb20vcHJvZHVjdF9pbWFnZXMvaW1hZ2VzLzAwMC8wMDMvODMzL29yaWdpbmFsLzc5ZmM2MGNkZmNkMjM5YWFjZGU3OWU4YTc2OTQ1NWZhOWJkN2MyODU3NGQ3Mzk0NDQxYTMyYmRmOGU4ZTdmOTUuanBnIl1d/5460fe0f4301a507/79fc60cdfcd239aacde79e8a769455fa9bd7c28574d7394441a32bdf8e8e7f95.jpg?fit=crop&w=150&h=150")

**exposure 10**

![exposure 10](https://bellroy.imgix.net/dynamic-assets/W1siZnUiLCJodHRwczovL3MzLmFtYXpvbmF3cy5jb20vcHJvZHVjdC5pbWFnZXMuYmVsbHJveS5jb20vcHJvZHVjdF9pbWFnZXMvaW1hZ2VzLzAwMC8wMDMvODMzL29yaWdpbmFsLzc5ZmM2MGNkZmNkMjM5YWFjZGU3OWU4YTc2OTQ1NWZhOWJkN2MyODU3NGQ3Mzk0NDQxYTMyYmRmOGU4ZTdmOTUuanBnIl1d/5460fe0f4301a507/79fc60cdfcd239aacde79e8a769455fa9bd7c28574d7394441a32bdf8e8e7f95.jpg?exp=10&fit=crop&w=150&h=150")

-}
exposure : Int -> Adjustment
exposure =
    Exposure << betweenNegativeHundredAndHundred


{-| Adjusts gamma and midtone brightness.

Valid values are in the range -100 – 100. The default value is 0, which leaves the image unchanged.

**original**

![original](https://bellroy.imgix.net/dynamic-assets/W1siZnUiLCJodHRwczovL3MzLmFtYXpvbmF3cy5jb20vcHJvZHVjdC5pbWFnZXMuYmVsbHJveS5jb20vcHJvZHVjdF9pbWFnZXMvaW1hZ2VzLzAwMC8wMDMvODMzL29yaWdpbmFsLzc5ZmM2MGNkZmNkMjM5YWFjZGU3OWU4YTc2OTQ1NWZhOWJkN2MyODU3NGQ3Mzk0NDQxYTMyYmRmOGU4ZTdmOTUuanBnIl1d/5460fe0f4301a507/79fc60cdfcd239aacde79e8a769455fa9bd7c28574d7394441a32bdf8e8e7f95.jpg?fit=crop&w=150&h=150")

**gamma 50**

![gamma 50](https://bellroy.imgix.net/dynamic-assets/W1siZnUiLCJodHRwczovL3MzLmFtYXpvbmF3cy5jb20vcHJvZHVjdC5pbWFnZXMuYmVsbHJveS5jb20vcHJvZHVjdF9pbWFnZXMvaW1hZ2VzLzAwMC8wMDMvODMzL29yaWdpbmFsLzc5ZmM2MGNkZmNkMjM5YWFjZGU3OWU4YTc2OTQ1NWZhOWJkN2MyODU3NGQ3Mzk0NDQxYTMyYmRmOGU4ZTdmOTUuanBnIl1d/5460fe0f4301a507/79fc60cdfcd239aacde79e8a769455fa9bd7c28574d7394441a32bdf8e8e7f95.jpg?gam=50&fit=crop&w=150&h=150")

-}
gamma : Int -> Adjustment
gamma =
    Gamma << betweenNegativeHundredAndHundred


{-| Adjusts the highlight tonal mapping of an image while preserving detail in highlighted areas.

Valid values are in the range -100 – 0. The default value is 0, which leaves the image unchanged.

**original**

![original](https://bellroy.imgix.net/dynamic-assets/W1siZnUiLCJodHRwczovL3MzLmFtYXpvbmF3cy5jb20vcHJvZHVjdC5pbWFnZXMuYmVsbHJveS5jb20vcHJvZHVjdF9pbWFnZXMvaW1hZ2VzLzAwMC8wMDMvODMzL29yaWdpbmFsLzc5ZmM2MGNkZmNkMjM5YWFjZGU3OWU4YTc2OTQ1NWZhOWJkN2MyODU3NGQ3Mzk0NDQxYTMyYmRmOGU4ZTdmOTUuanBnIl1d/5460fe0f4301a507/79fc60cdfcd239aacde79e8a769455fa9bd7c28574d7394441a32bdf8e8e7f95.jpg?fit=crop&w=150&h=150")

**highlight 50**

![highlight 50](https://bellroy.imgix.net/dynamic-assets/W1siZnUiLCJodHRwczovL3MzLmFtYXpvbmF3cy5jb20vcHJvZHVjdC5pbWFnZXMuYmVsbHJveS5jb20vcHJvZHVjdF9pbWFnZXMvaW1hZ2VzLzAwMC8wMDMvODMzL29yaWdpbmFsLzc5ZmM2MGNkZmNkMjM5YWFjZGU3OWU4YTc2OTQ1NWZhOWJkN2MyODU3NGQ3Mzk0NDQxYTMyYmRmOGU4ZTdmOTUuanBnIl1d/5460fe0f4301a507/79fc60cdfcd239aacde79e8a769455fa9bd7c28574d7394441a32bdf8e8e7f95.jpg?high=50&fit=crop&w=150&h=150")

-}
highlight : Int -> Adjustment
highlight =
    HighLight << betweenNegativeHundredAndHundred


{-| Adjusts the highlight tonal mapping of an image while preserving detail in highlighted areas.

Valid values are in the range -100 – 0. The default value is 0, which leaves the image unchanged.

**original**

![original](https://bellroy.imgix.net/dynamic-assets/W1siZnUiLCJodHRwczovL3MzLmFtYXpvbmF3cy5jb20vcHJvZHVjdC5pbWFnZXMuYmVsbHJveS5jb20vcHJvZHVjdF9pbWFnZXMvaW1hZ2VzLzAwMC8wMDMvODMzL29yaWdpbmFsLzc5ZmM2MGNkZmNkMjM5YWFjZGU3OWU4YTc2OTQ1NWZhOWJkN2MyODU3NGQ3Mzk0NDQxYTMyYmRmOGU4ZTdmOTUuanBnIl1d/5460fe0f4301a507/79fc60cdfcd239aacde79e8a769455fa9bd7c28574d7394441a32bdf8e8e7f95.jpg?fit=crop&w=150&h=150")

**hueshift 50**

![hueshift 50](https://bellroy.imgix.net/dynamic-assets/W1siZnUiLCJodHRwczovL3MzLmFtYXpvbmF3cy5jb20vcHJvZHVjdC5pbWFnZXMuYmVsbHJveS5jb20vcHJvZHVjdF9pbWFnZXMvaW1hZ2VzLzAwMC8wMDMvODMzL29yaWdpbmFsLzc5ZmM2MGNkZmNkMjM5YWFjZGU3OWU4YTc2OTQ1NWZhOWJkN2MyODU3NGQ3Mzk0NDQxYTMyYmRmOGU4ZTdmOTUuanBnIl1d/5460fe0f4301a507/79fc60cdfcd239aacde79e8a769455fa9bd7c28574d7394441a32bdf8e8e7f95.jpg?hue=50&fit=crop&w=150&h=150")

-}
hueshift : Int -> Adjustment
hueshift =
    HueShift << betweenZeroAndThreeHundredAndFiftyNine


{-| Inverts all pixel colors and brightness values within the image, producing a negative of the image.

**original**

![original](https://bellroy.imgix.net/dynamic-assets/W1siZnUiLCJodHRwczovL3MzLmFtYXpvbmF3cy5jb20vcHJvZHVjdC5pbWFnZXMuYmVsbHJveS5jb20vcHJvZHVjdF9pbWFnZXMvaW1hZ2VzLzAwMC8wMDMvODMzL29yaWdpbmFsLzc5ZmM2MGNkZmNkMjM5YWFjZGU3OWU4YTc2OTQ1NWZhOWJkN2MyODU3NGQ3Mzk0NDQxYTMyYmRmOGU4ZTdmOTUuanBnIl1d/5460fe0f4301a507/79fc60cdfcd239aacde79e8a769455fa9bd7c28574d7394441a32bdf8e8e7f95.jpg?fit=crop&w=150&h=150")

**invert**

![invert](https://bellroy.imgix.net/dynamic-assets/W1siZnUiLCJodHRwczovL3MzLmFtYXpvbmF3cy5jb20vcHJvZHVjdC5pbWFnZXMuYmVsbHJveS5jb20vcHJvZHVjdF9pbWFnZXMvaW1hZ2VzLzAwMC8wMDMvODMzL29yaWdpbmFsLzc5ZmM2MGNkZmNkMjM5YWFjZGU3OWU4YTc2OTQ1NWZhOWJkN2MyODU3NGQ3Mzk0NDQxYTMyYmRmOGU4ZTdmOTUuanBnIl1d/5460fe0f4301a507/79fc60cdfcd239aacde79e8a769455fa9bd7c28574d7394441a32bdf8e8e7f95.jpg?invert=true&fit=crop&w=150&h=150")

-}
invert : Adjustment
invert =
    Invert


{-| Adjusts the saturation of the image.

Valid values are in the range -100 – 100. The default value is 0, which leaves the image unchanged. A value of -100 will convert the image to grayscale.

**original**

![original](https://bellroy.imgix.net/dynamic-assets/W1siZnUiLCJodHRwczovL3MzLmFtYXpvbmF3cy5jb20vcHJvZHVjdC5pbWFnZXMuYmVsbHJveS5jb20vcHJvZHVjdF9pbWFnZXMvaW1hZ2VzLzAwMC8wMDMvODMzL29yaWdpbmFsLzc5ZmM2MGNkZmNkMjM5YWFjZGU3OWU4YTc2OTQ1NWZhOWJkN2MyODU3NGQ3Mzk0NDQxYTMyYmRmOGU4ZTdmOTUuanBnIl1d/5460fe0f4301a507/79fc60cdfcd239aacde79e8a769455fa9bd7c28574d7394441a32bdf8e8e7f95.jpg?fit=crop&w=150&h=150")

**saturation 100**

![saturation 100](https://bellroy.imgix.net/dynamic-assets/W1siZnUiLCJodHRwczovL3MzLmFtYXpvbmF3cy5jb20vcHJvZHVjdC5pbWFnZXMuYmVsbHJveS5jb20vcHJvZHVjdF9pbWFnZXMvaW1hZ2VzLzAwMC8wMDMvODMzL29yaWdpbmFsLzc5ZmM2MGNkZmNkMjM5YWFjZGU3OWU4YTc2OTQ1NWZhOWJkN2MyODU3NGQ3Mzk0NDQxYTMyYmRmOGU4ZTdmOTUuanBnIl1d/5460fe0f4301a507/79fc60cdfcd239aacde79e8a769455fa9bd7c28574d7394441a32bdf8e8e7f95.jpg?sat=100&fit=crop&w=150&h=150")

-}
saturation : Int -> Adjustment
saturation =
    Saturation << betweenNegativeHundredAndHundred


{-| Adjusts the shadow tonal mapping of an image while preserving detail in shadowed areas.

Valid values are in the range 0 – 100. The default value is 0, which leaves the image unchanged.

**original**

![original](https://bellroy.imgix.net/dynamic-assets/W1siZnUiLCJodHRwczovL3MzLmFtYXpvbmF3cy5jb20vcHJvZHVjdC5pbWFnZXMuYmVsbHJveS5jb20vcHJvZHVjdF9pbWFnZXMvaW1hZ2VzLzAwMC8wMDMvODMzL29yaWdpbmFsLzc5ZmM2MGNkZmNkMjM5YWFjZGU3OWU4YTc2OTQ1NWZhOWJkN2MyODU3NGQ3Mzk0NDQxYTMyYmRmOGU4ZTdmOTUuanBnIl1d/5460fe0f4301a507/79fc60cdfcd239aacde79e8a769455fa9bd7c28574d7394441a32bdf8e8e7f95.jpg?fit=crop&w=150&h=150")

**shadow 50**

![shadow 50](https://bellroy.imgix.net/dynamic-assets/W1siZnUiLCJodHRwczovL3MzLmFtYXpvbmF3cy5jb20vcHJvZHVjdC5pbWFnZXMuYmVsbHJveS5jb20vcHJvZHVjdF9pbWFnZXMvaW1hZ2VzLzAwMC8wMDMvODMzL29yaWdpbmFsLzc5ZmM2MGNkZmNkMjM5YWFjZGU3OWU4YTc2OTQ1NWZhOWJkN2MyODU3NGQ3Mzk0NDQxYTMyYmRmOGU4ZTdmOTUuanBnIl1d/5460fe0f4301a507/79fc60cdfcd239aacde79e8a769455fa9bd7c28574d7394441a32bdf8e8e7f95.jpg?shad=50&fit=crop&w=150&h=150")

-}
shadow : Int -> Adjustment
shadow =
    Shadow << betweenNegativeHundredAndHundred


{-| Sharpens the image using luminance (which only affects the black and white values), providing crisp detail with minimal color artifacts.

Valid values are in the range 0 – 100. The default value is 0, which leaves the image unchanged.

**original**

![original](https://bellroy.imgix.net/dynamic-assets/W1siZnUiLCJodHRwczovL3MzLmFtYXpvbmF3cy5jb20vcHJvZHVjdC5pbWFnZXMuYmVsbHJveS5jb20vcHJvZHVjdF9pbWFnZXMvaW1hZ2VzLzAwMC8wMDMvODMzL29yaWdpbmFsLzc5ZmM2MGNkZmNkMjM5YWFjZGU3OWU4YTc2OTQ1NWZhOWJkN2MyODU3NGQ3Mzk0NDQxYTMyYmRmOGU4ZTdmOTUuanBnIl1d/5460fe0f4301a507/79fc60cdfcd239aacde79e8a769455fa9bd7c28574d7394441a32bdf8e8e7f95.jpg?fit=crop&w=150&h=150")

**sharpen 50**

![sharpen 50](https://bellroy.imgix.net/dynamic-assets/W1siZnUiLCJodHRwczovL3MzLmFtYXpvbmF3cy5jb20vcHJvZHVjdC5pbWFnZXMuYmVsbHJveS5jb20vcHJvZHVjdF9pbWFnZXMvaW1hZ2VzLzAwMC8wMDMvODMzL29yaWdpbmFsLzc5ZmM2MGNkZmNkMjM5YWFjZGU3OWU4YTc2OTQ1NWZhOWJkN2MyODU3NGQ3Mzk0NDQxYTMyYmRmOGU4ZTdmOTUuanBnIl1d/5460fe0f4301a507/79fc60cdfcd239aacde79e8a769455fa9bd7c28574d7394441a32bdf8e8e7f95.jpg?sharp=50&fit=crop&w=150&h=150")

-}
sharpen : Int -> Adjustment
sharpen =
    Sharpen << betweenZeroAndHundred


{-| Sharpens the image details using an unsharp mask (a blurred, inverted copy of the image).

Valid values are any integers. The default value is 0, which leaves the image unchanged.

Valid radius values are any floating point number. The default value is 0, which leaves the image unchanged.

For images with general noise, we suggest using the sharp parameter instead. Unsharp mask and radius are better for thumbnails and fine-tuned sharpening.

**original**

![original](https://bellroy.imgix.net/dynamic-assets/W1siZnUiLCJodHRwczovL3MzLmFtYXpvbmF3cy5jb20vcHJvZHVjdC5pbWFnZXMuYmVsbHJveS5jb20vcHJvZHVjdF9pbWFnZXMvaW1hZ2VzLzAwMC8wMDMvODMzL29yaWdpbmFsLzc5ZmM2MGNkZmNkMjM5YWFjZGU3OWU4YTc2OTQ1NWZhOWJkN2MyODU3NGQ3Mzk0NDQxYTMyYmRmOGU4ZTdmOTUuanBnIl1d/5460fe0f4301a507/79fc60cdfcd239aacde79e8a769455fa9bd7c28574d7394441a32bdf8e8e7f95.jpg?fit=crop&w=150&h=150")

**unsharpmask 20 10.5**

![unsharpmask 20 10.5](https://bellroy.imgix.net/dynamic-assets/W1siZnUiLCJodHRwczovL3MzLmFtYXpvbmF3cy5jb20vcHJvZHVjdC5pbWFnZXMuYmVsbHJveS5jb20vcHJvZHVjdF9pbWFnZXMvaW1hZ2VzLzAwMC8wMDMvODMzL29yaWdpbmFsLzc5ZmM2MGNkZmNkMjM5YWFjZGU3OWU4YTc2OTQ1NWZhOWJkN2MyODU3NGQ3Mzk0NDQxYTMyYmRmOGU4ZTdmOTUuanBnIl1d/5460fe0f4301a507/79fc60cdfcd239aacde79e8a769455fa9bd7c28574d7394441a32bdf8e8e7f95.jpg?usmrad=10.5&usm=20&fit=crop&w=150&h=150")

-}
unsharpmask : Int -> Float -> Adjustment
unsharpmask value radius =
    UnsharpMask value radius


{-| Adjusts the color saturation of an image while keeping pleasing skin tones.

Valid values are in the range -100 – 100. The default value is 0, which leaves the image unchanged.

**original**

![original](https://bellroy.imgix.net/dynamic-assets/W1siZnUiLCJodHRwczovL3MzLmFtYXpvbmF3cy5jb20vcHJvZHVjdC5pbWFnZXMuYmVsbHJveS5jb20vcHJvZHVjdF9pbWFnZXMvaW1hZ2VzLzAwMC8wMDMvODMzL29yaWdpbmFsLzc5ZmM2MGNkZmNkMjM5YWFjZGU3OWU4YTc2OTQ1NWZhOWJkN2MyODU3NGQ3Mzk0NDQxYTMyYmRmOGU4ZTdmOTUuanBnIl1d/5460fe0f4301a507/79fc60cdfcd239aacde79e8a769455fa9bd7c28574d7394441a32bdf8e8e7f95.jpg?fit=crop&w=150&h=150")

**vibrance 50**

![vibrance 50](https://bellroy.imgix.net/dynamic-assets/W1siZnUiLCJodHRwczovL3MzLmFtYXpvbmF3cy5jb20vcHJvZHVjdC5pbWFnZXMuYmVsbHJveS5jb20vcHJvZHVjdF9pbWFnZXMvaW1hZ2VzLzAwMC8wMDMvODMzL29yaWdpbmFsLzc5ZmM2MGNkZmNkMjM5YWFjZGU3OWU4YTc2OTQ1NWZhOWJkN2MyODU3NGQ3Mzk0NDQxYTMyYmRmOGU4ZTdmOTUuanBnIl1d/5460fe0f4301a507/79fc60cdfcd239aacde79e8a769455fa9bd7c28574d7394441a32bdf8e8e7f95.jpg?vib=50&fit=crop&w=150&h=150")

-}
vibrance : Int -> Adjustment
vibrance =
    Vibrance << betweenNegativeHundredAndHundred



-- Applying


{-| Takes a list of adjustments and turns it in to a list of query parameters that ImgIX understands
-}
toQueryParameters : List Adjustment -> List UrlBuilder.QueryParameter
toQueryParameters adjustments =
    List.foldl
        (\adjustment list -> toQueryParameters_ adjustment ++ list)
        []
        adjustments



-- Helpers


{-| Takes an adjustment and turns it in to a list of query parameters that ImgIX understands
-}
toQueryParameters_ : Adjustment -> List UrlBuilder.QueryParameter
toQueryParameters_ adjustment =
    case adjustment of
        Brightness int ->
            [ UrlBuilder.int "bri" int ]

        Contrast int ->
            [ UrlBuilder.int "con" int ]

        Exposure int ->
            [ UrlBuilder.int "exp" int ]

        Gamma int ->
            [ UrlBuilder.int "gam" int ]

        HighLight int ->
            [ UrlBuilder.int "high" int ]

        HueShift int ->
            [ UrlBuilder.int "hue" int ]

        Invert ->
            [ UrlBuilder.string "invert" "true" ]

        Saturation int ->
            [ UrlBuilder.int "sat" int ]

        Shadow int ->
            [ UrlBuilder.int "shad" int ]

        Sharpen int ->
            [ UrlBuilder.int "sharp" int ]

        UnsharpMask int float ->
            [ UrlBuilder.int "usm" int
            , UrlBuilder.string "usmrad" <| String.fromFloat float
            ]

        Vibrance int ->
            [ UrlBuilder.int "vib" int ]


betweenNegativeHundredAndHundred : Int -> Int
betweenNegativeHundredAndHundred =
    between -100 100


betweenZeroAndHundred : Int -> Int
betweenZeroAndHundred =
    between 0 100


betweenZeroAndThreeHundredAndFiftyNine : Int -> Int
betweenZeroAndThreeHundredAndFiftyNine =
    between 0 359


between : Int -> Int -> Int -> Int
between a z value =
    if value < a then
        a

    else if value > z then
        z

    else
        value
