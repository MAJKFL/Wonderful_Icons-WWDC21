/*:
 # Designing Icon
 Icons are very important for your apps. They represent them on home screen and the App Store.
 Their aim is to invite a user to have an incredible experience inside them.
 This is why your icons should be clean, beautiful and easily recognizable.
 
 - - -
 
 ## Glyphs
 **Metaphor for your apps.**\
 Glyph should be simple and without too much detail. Its color should stand out against from the background.
 You should think about your app's purpose, name and features. When designing your icon avoid using text as it won't look good when in small size.
 
 ![Wallet and Home icons](MusicAndWalletIcons.png)
 - Example: *Music and Wallet icons*\
 Note symbol represents music. Wallet is self-explanatory.
 
 Now, imagine you've been asked to create an icon for the mail app.
 Choose an image that, in your opinion, is most suitable and then hit "Run My Code".
*/
let image = /*#-editable-code*/#imageLiteral(resourceName: "star.png")/*#-end-editable-code*/
/*:
 ## Alignment
 **When aligning glyphs you should follow some rules.**\
 You probably remember the default iOS icon grid(after all, you work at Apple😀).
 Use it to align your glyphs.
 They will stay in focus and icons will look great next to each other on users home screen. Their design will stay consistent.
 
 ![Safari and Photos app icons](SafariAndAppStoreIcons.png)
 - Example: *Safari and App Store icons*\
 Using grid helps feature same margins and proportions.
 
 Let's return to our mail icon. Set `showImageSizeManipulator` to `true` and tap "Run My Code". Use these tools to align glyph inside the biggest circle.
*/
let showImageSizeManipulator = /*#-editable-code*/false/*#-end-editable-code*/
/*:
 ## Background
 **Background is even more important than glyph.**\
 It makes your icon more easily recognizable in small size.
 When creating the background choosing the right color helps attract draw attention to important information.
 
 ![Weather and Calendar icons](WeatherAndCalendarIcons.png)
 - Example: *Weather and Calendar icons*\
 Blue gradient represents the sky. Date on white background represents a classic calendar.
 
 Let's get back to your mail icon. Now It's time to add some background. Imagine you are at post office. What colors come to your mind? Set `showColorPicker` to `true` hit "Run My Code" and compose your background gradient!
 - Important:
 Remember do not use transparent colors. According to [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/) your icon should be opaque.
*/
let showColorPicker = /*#-editable-code*/false/*#-end-editable-code*/
/*:
 ## Congratulations!
 Now practise what you have learned. Please proceed to the [next page](@next) create your own ideas🤩!
*/
//#-hidden-code
import SwiftUI
import PlaygroundSupport
import AuxiliaryModule

PlaygroundPage.current.setLiveView(DesigningView(image: image, showImageSizeManipulator: showImageSizeManipulator, showColorPicker: showColorPicker))
//#-end-hidden-code
