//
//  ViewController.swift
//  dropdown
//
//  Created by Fabio Giolito on 12/12/2018.
//  Copyright © 2018 Fabio Giolito. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // =================================
    // MARK:- MODEL
    
    let options = [
        DropdownButton.Option(title: "Edit",     icon: UIImage(named: "edit")!,     action: { print("selected edit")     }),
        DropdownButton.Option(title: "Share",    icon: UIImage(named: "share")!,    action: { print("selected share")    }),
        DropdownButton.Option(title: "Delete",   icon: UIImage(named: "delete")!,   action: { print("selected delete")   })
    ]
    
    
    // =================================
    // MARK:- SUBVIEWS

    lazy var dropdownButton: DropdownButton = {
        let button = DropdownButton(type: .system)
        button.setTitle("Custom button", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        button.layer.cornerRadius = 8
        
        // important to dropdown
        button.backgroundColor = .blue // used as dropdown menu backgorund color
        button.tintColor = .white // used as dropdown menu tint color
        button.options = options // dropdown menu data
        button.dropdown(target: self) // Initialize and configure Dropdown menu
        
        return button
    }()
    
    
    // =================================
    // MARK:- VIEW LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Anchor button on screen
        view.addSubview(dropdownButton)
        dropdownButton.translatesAutoresizingMaskIntoConstraints = false
        dropdownButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dropdownButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

    }
}
