# SwiftDropdown

Customizable Dropdown component written in Swift.


## Usage

``` swift
// 1. Works with any button
let myButton = UIButton(type: .system)
myButton.setTitle("•••", for: .normal)

// 2. Define your dropdown options and actions
let options = [
    DropdownView.Option(title: "Edit",   icon: UIImage(named: "edit")!,   action: { print("selected edit")     }),
    DropdownView.Option(title: "Share",  icon: UIImage(named: "share")!,  action: { print("selected share")    }),
    DropdownView.Option(title: "Delete", icon: UIImage(named: "delete")!, action: { print("selected delete")   })
]

// 3. Create the dropdown
let dropdown = DropdownView(
                 options: options,        // Array of DropdownView.Option from above
                 button: myButton,        // Button to trigger Dropdown
                 target: self,            // The current UIViewController
                 openDirection: .leftDown // The direction the Dropdown opens
               )
```

The Dropdown view is layouted automatically. You only need to layout your button where you need it.



![preview](https://github.com/fabiogiolito/SwiftDropdown/blob/master/assets/preview.gif?raw=true)


## Gestures

- **Tap** the buton: opens the dropdown
- **Long press** the button: opens the dropdown and allows you to slide your finger over the option you want. Option is selected when you lift your finger.
- **Drag** the button: When you get used to the long press gesture, you tend to start moving your finger before there was enough time to trigger the long press. So if you tap and start moving your finger it will open the dropdown as well.


## Options

``` swift
struct Option {
  let title: String?
  let icon: UIImage?
  let action: () -> ()
}
```


## Open Directions

Open direction will anchor the dropdown to the button appropriately and define the open animation direction.

``` swift
enum OpenDirection {
  case centerDown, rightDown, leftDown
  case centerUp, rightUp, leftUp
  case rightCenter, leftCenter
  case center
  case screenCenter, screenBottom
}
```


## Using a custom button

Any button works, the dropdown will pick up the background color and tint of your button.

``` swift
let customButton = MyCustomButtonClass()
customButton.setTitle("Actions", for: .normal)
customButton.backgroundColor = .blue
customButton.tintColor = .white

let dropdown = DropdownView(options: options, button: customButton, target: self, openDirection: .centerDown)
```

![Custom button](https://github.com/fabiogiolito/SwiftDropdown/blob/master/assets/custom.gif?raw=true)


## Appearance

You can override the dropdown's appearance after initalization.

``` swift
let dropdown = DropdownView(options: options, button: myButton, target: self, openDirection: .centerDown)

// Dropdown appearance
dropdown.layer.cornerRadius = 8
dropdown.backgroundColor = UIColor.darkGray
dropdown.tintColor = UIColor.white

// Highlighted option background color
dropdown.optionHighlightColor = UIColor(white: 1, alpha: 0.1)

// Misc overrides
dropdown.overlayBackgroundColor = UIColor(white: 0, alpha: 0.8) // Color of background overlay (use color with alpha)
dropdown.springDamping = 0.7 // Animation damping, change if you want it more or less "springy"
```
