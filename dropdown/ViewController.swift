//
//  ViewController.swift
//  dropdown
//
//  Created by Fabio Giolito on 12/12/2018.
//  Copyright © 2018 Fabio Giolito. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // Any button
        let button = UIButton(type: .system)
        button.setTitle("•••", for: .normal)
//        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
//        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
//        button.layer.cornerRadius = 8
        
        // Button style is automatically applied to dropdown view
//        button.backgroundColor = .darkGray
//        button.tintColor = .white
        
        // Add button to view first
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        // Define your dropdown options
        let options = [
            DropdownView.Option(title: "Edit",   icon: UIImage(named: "edit")!,   action: { print("selected edit")     }),
            DropdownView.Option(title: "Share",  icon: UIImage(named: "share")!,  action: { print("selected share")    }),
            DropdownView.Option(title: "Delete", icon: UIImage(named: "delete")!, action: { print("selected delete")   })
        ]
        
        // Set a dropdown on your button
        let dropdown = DropdownView(options: options, button: button, target: self, openDirection: .leftDown)
        
        // Customize the dropdown if necessary
//        dropdown.layer.cornerRadius = 8
//        dropdown.tintColor = .white
//        dropdown.backgroundColor = .red
//        dropdown.optionHighlightColor = UIColor(white: 1, alpha: 0.1)
//        dropdown.overlayBackgroundColor = UIColor(white: 0, alpha: 0.1)
//        dropdown.haptic = UIImpactFeedbackGenerator(style: .heavy)
//        dropdown.springDamping = 0.7
        
    }

}
