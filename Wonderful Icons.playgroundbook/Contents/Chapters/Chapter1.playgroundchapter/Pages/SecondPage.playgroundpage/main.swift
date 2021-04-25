/*:
 # Creating Icon
 In order to make an icon use this simple creator. Please follow steps below.
 
 ![Sample Icons](SampleIcons.png)
 
 - - -
 
 ## Glyph
 Select your image.
 * Callout(Tip):
 To keep your glyphs original colors please set "Display as original".
*/
let image = /*#-editable-code*/#imageLiteral(resourceName: "star.png")/*#-end-editable-code*/
/*:
 ## Declaring palette of colors
 Custom your color set below.
 * Callout(Tip):
 Remember to use opaque colors😀!
*/
let paletteOfColors = [
    /*#-editable-code*/#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)/*#-end-editable-code*/,
    /*#-editable-code*/#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)/*#-end-editable-code*/,
    /*#-editable-code*/#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)/*#-end-editable-code*/,
    /*#-editable-code*/#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)/*#-end-editable-code*/,
    /*#-editable-code*/#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)/*#-end-editable-code*/,
    /*#-editable-code*/#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)/*#-end-editable-code*/
]
/*:
 ## Quick manual
 Icon editor is divided into 4 categories:
 - Colors - Pick colors for your background and image.
 - Image - Manipulate your image. Change its rotation and offset, add padding.
 - Gradient - Switch between linear and radial. Set gradients properties, add blur.
 - Miscellaneous - Show or hide grid, invert its color. Display an image in original colors. Save icon to the gallery.
 
 - - -
  
 ## Start!
 Ready to go? Hit "Run my code" have fun🥳!\
 Thank you for spending time on my playground. I hope you enjoyed it, and learnt something new😁.
 
 ### Sources
 If you would like to learn more about creating app icons, check out sources below:
 - [This amazing talk](https://developer.apple.com/wwdc17/822) from WWDC17
 - [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
 - Sample images - [freeicons.io](https://freeicons.io)
 - Camera shutter sound effect - [soundjay.com](https://www.soundjay.com/camera-sound-effect.html)
*/
//#-hidden-code
import SwiftUI
import PlaygroundSupport
import AuxiliaryModule

PlaygroundPage.current.setLiveView(EditorView(image: image, paletteOfColors: paletteOfColors))
//#-end-hidden-code
