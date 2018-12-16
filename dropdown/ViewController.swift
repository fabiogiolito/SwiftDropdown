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
        Dropdown.Option(title: "Edit",     icon: UIImage(named: "edit")!,     action: { print("selected edit")     }),
        Dropdown.Option(title: "Share",    icon: UIImage(named: "share")!,    action: { print("selected share")    }),
        Dropdown.Option(title: "Delete",   icon: UIImage(named: "delete")!,   action: { print("selected delete")   })
    ]
    
    
    // =================================
    // MARK:- SUBVIEWS

    var customButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Custom button", for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        button.layer.cornerRadius = 8
        button.setBackgroundColor(color: .gray, forState: .highlighted)
        button.backgroundColor = .blue
        button.tintColor = .white
        return button
    }()
    
    lazy var dropdown1: Dropdown = {
        let dropdown = Dropdown(options: options, openDirection: .leftDown)
        return dropdown
    }()
    
    lazy var dropdown2: Dropdown = {
        let dropdown = Dropdown(options: options, openDirection: .center)
        return dropdown
    }()
    
    lazy var dropdown3: Dropdown = {
        let dropdown = Dropdown(options: options, openDirection: .screenBottom)
        return dropdown
    }()
    
    
    
    // =================================
    // MARK:- VIEW LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(dropdown1)
        dropdown1.translatesAutoresizingMaskIntoConstraints = false
        dropdown1.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dropdown1.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -200).isActive = true
        
        view.addSubview(dropdown2)
        dropdown2.translatesAutoresizingMaskIntoConstraints = false
        dropdown2.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dropdown2.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        
        view.addSubview(dropdown3)
        dropdown3.translatesAutoresizingMaskIntoConstraints = false
        dropdown3.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dropdown3.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 200).isActive = true
    }
}
