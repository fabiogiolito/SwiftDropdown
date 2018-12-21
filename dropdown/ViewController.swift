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
    // SUBVIEWS
    
    // Button 1
    lazy var button1: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("•••", for: .normal)
        return button
    }()
    
    // Button 2
    lazy var button2: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Dropdown", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .darkGray
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.layer.cornerRadius = 8
        return button
    }()
    
    // Dropdown options
    let dropdownOptions = [
        DropdownView.Option(title: "Edit",   icon: UIImage(named: "edit")!,   action: { print("selected edit")   }),
        DropdownView.Option(title: "Share",  icon: UIImage(named: "share")!,  action: { print("selected share")  }),
        DropdownView.Option(title: "Delete", icon: UIImage(named: "delete")!, action: { print("selected delete") })
    ]
    
    // Dropdown 1
    lazy var dropdown1: DropdownView = {
        let dropdown = DropdownView(options: dropdownOptions, target: self)
        return dropdown
    }()

    // Dropdown 2
    lazy var dropdown2: DropdownView = {
        let dropdown = DropdownView(options: dropdownOptions, target: self)
        dropdown.tintColor = .white
        dropdown.backgroundColor = .darkGray
        dropdown.layer.cornerRadius = 4
        dropdown.springDamping = 0.7
        dropdown.optionHighlightColor = UIColor(white: 0, alpha: 0.2)
        dropdown.backgroundOverlayColor = UIColor(white: 0, alpha: 0.2)
        return dropdown
    }()

    
    // =================================
    // VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        // Add button 1 to view
        view.addSubview(button1)
        button1.translatesAutoresizingMaskIntoConstraints = false
        button1.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button1.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true
        
        // Add button 2 to view
        view.addSubview(button2)
        button2.translatesAutoresizingMaskIntoConstraints = false
        button2.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button2.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100).isActive = true
        
        // Connect dropdown 1 to button 1
        dropdown1.attachTo(button1, openDirection: .leftDown)

        // Connect dropdown 2 to button 2
        dropdown2.attachTo(button2, openDirection: .rightUp)

    }
}
