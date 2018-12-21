# SwiftDropdown

Simple customizable Dropdown component written in Swift.


## Usage

``` swift
// 1. Create dropdown
let dropdown = DropdownView(options: [
  DropdownView.Option(title: "Edit",   icon: UIImage(named: "edit")!,   action: { print("selected edit")   }),
  DropdownView.Option(title: "Share",  icon: UIImage(named: "share")!,  action: { print("selected share")  }),
  DropdownView.Option(title: "Delete", icon: UIImage(named: "delete")!, action: { print("selected delete") })
], target: self)

// 2. Attach dropdown to your button
dropdown.attachTo(myButton, openDirection: .leftDown)
```

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

Open direction will anchor the dropdown to the button appropriately and define the open animation direction. You define the Open Direction on the `attachTo` function. If no direction is passed, defaults to `.leftDown`.

``` swift
enum OpenDirection {
  case centerDown, rightDown, leftDown
  case centerUp, rightUp, leftUp
  case rightCenter, leftCenter
  case center
  case screenCenter, screenBottom
}
```


## Appearance

You can customize the dropdown's appearance.

``` swift
let options = [...]
let dropdown = DropdownView(options: options, target: self)

// Dropdown appearance
dropdown.tintColor = .white
dropdown.backgroundColor = .blue
dropdown.layer.cornerRadius = 8

// Background color on a highlighted/tapped option
dropdown.optionHighlightColor = UIColor(white: 0, alpha: 0.2)

// Color of background overlay
dropdown.backgroundOverlayColor = UIColor(white: 0, alpha: 0.1)

// Spring animation damping
dropdown.springDamping = 0.7
```

![Custom button](https://github.com/fabiogiolito/SwiftDropdown/blob/master/assets/custom.gif?raw=true)
