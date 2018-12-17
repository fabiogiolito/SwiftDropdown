# SwiftDropdown

Trying to make a self contained dropdown component. This is what I got so far.


## Usage

``` swift
let options = [
  Dropdown.Option(title: "Edit",     icon: UIImage(named: "edit")!,     action: { print("selected edit")     }),
  Dropdown.Option(title: "Share",    icon: UIImage(named: "share")!,    action: { print("selected share")    }),
  Dropdown.Option(title: "Delete",   icon: UIImage(named: "delete")!,   action: { print("selected delete")   })
]

let dropdown1 = Dropdown(options: options, openDirection: .leftDown)
let dropdown2 = Dropdown(options: options, openDirection: .center)
let dropdown3 = Dropdown(options: options, openDirection: .centerUp)
```

![Preview](https://github.com/fabiogiolito/SwiftDropdown/blob/master/assets/preview.gif?raw=true)


## Gestures

- **Tap** the buton: opens the dropdown
- **Long press** the button: opens the dropdown and allows you to slide your finger over the option you want. Option is selected when you lift your finger.
- **Drag** the button: When you get used to the long press gesture, you tend to start moving your finger before there was enough time to trigger the long press. So if you tap and start moving your finger it will open the menu as well.


## Options

``` swift
struct Option {
  let title: String?
  let icon: UIImage?
  let action: () -> ()
}
```


## Open Directions

Open direction will anchor the dropdownView to the button appropriately and define the open animation direction. 

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

``` swift
let customButton = UIButton(type: .system)
customButton.setTitle("Custom button", for: .normal)
customButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
customButton.layer.cornerRadius = 8
customButton.backgroundColor = .blue
customButton.tintColor = .white

let dropdown4 = Dropdown(options: options, openDirection: .screenBottom, button: customButton)
```

![Custom button](https://github.com/fabiogiolito/SwiftDropdown/blob/master/assets/custom.gif?raw=true)


## Appearance

The dropdown view will use the same background color and tint color as the button. Alternatively you can override it's appearance after initalization:

``` swift
let dropdown = Dropdown(options: options, openDirection: .center)
dropdown.dropdownView.backgroundColor = .red
dropdown.dropdownView.tintColor = .green
```


## Known problems

So I've hit some problems. Since all the elements are self contained in the Dropdown UIView, I don't know how to anchor the background overlay to the view controller's view, and always display the overlay and dropdown menu views above all other elements.
