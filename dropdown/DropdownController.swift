//
//  DropdownController.swift
//  dropdown
//
//  Created by Fabio Giolito on 17/12/2018.
//  Copyright © 2018 Fabio Giolito. All rights reserved.
//

import UIKit

class DropdownController: UIViewController {
    
    // =================================
    // MARK:- MODEL
    
    // Required
    var options: [DropdownButton.Option] = []
    var button: UIButton = UIButton()
    var gestureRecognizer: UIGestureRecognizer? {
        didSet {
            if gestureRecognizer == nil {
                didEndGesture()
            } else {
                didChangeGesture()
            }
        }
    }
    
    // State
    var highlightedOption: Int? {
        didSet { didChangeHighlightedOption(oldValue: oldValue) }
    }
    
    // Preferences
    var openDirection: DropdownButton.OpenDirection = .centerDown // value never used
    var highlightColor: UIColor = UIColor(white: 0, alpha: 0.1)
    var haptic: UIImpactFeedbackGenerator? = UIImpactFeedbackGenerator(style: .light)
    
    
    // =================================
    // MARK:- SUBVIEWS
    
    
    // View with same frame as button for anchoring
    private lazy var buttonProxy: UIView = {
        let view = UIView(frame: self.button.frame)
        view.alpha = 0
        return view
    }()
    
    // Options stack view
    private var optionsStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        return view
    }()
    
    // Dropdown view
    private var dropdownMenu: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.alpha = 0
        return view
    }()
    
    // Background overlay
    private lazy var backgroundOverlay: UIButton = {
        let background = UIButton()
        background.backgroundColor = UIColor(white: 0, alpha: 0.1)
        background.alpha = 0
        background.addTarget(self, action: #selector(didTapBackgroundOverlay(_:)), for: .touchUpInside)
        return background
    }()
    
    
    // =================================
    // MARK:- VIEW LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        
        setupStyles()
        setupDropdownMenu()
        setupSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showView()
    }
    
    
    // =================================
    // MARK:- SETUP FUNCTIONS
    
    func setupStyles() {
        dropdownMenu.backgroundColor = button.backgroundColor
        dropdownMenu.tintColor = button.tintColor
        dropdownMenu.layer.cornerRadius = 16
        dropdownMenu.transform = openDirection.initialTransform
    }
    
    func setupDropdownMenu() {
        for (index, option) in options.enumerated() {
            let optionButton = UIButton(type: .system)
            optionButton.setTitle(option.title, for: .normal)
            optionButton.setBackgroundColor(color: highlightColor, forState: .highlighted)
            
            optionButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16) // TODO: This could be a preference
            optionButton.contentHorizontalAlignment = .left // TODO: This could be a preference
            optionButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 24, bottom: 8, right: 32) // TODO: This could be a preference
            
            if option.icon != nil {
                optionButton.setImage(option.icon, for: .normal)
                optionButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -12, bottom: 0, right: 12) // TODO: This could be a preference
            }
            
            optionButton.tag = index
            optionButton.addTarget(self, action: #selector(didTapOptionButton(_:)), for: .touchUpInside)
            
            optionsStackView.addArrangedSubview(optionButton)
        }
    }
    
    func setupSubviews() {
        // Background overlay over view
        view.addSubview(backgroundOverlay)
        backgroundOverlay.translatesAutoresizingMaskIntoConstraints = false
        backgroundOverlay.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundOverlay.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundOverlay.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        backgroundOverlay.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        // Button position proxy
        view.addSubview(buttonProxy)
        
        // Stack view in dropdown menu
        dropdownMenu.addSubview(optionsStackView)
        optionsStackView.translatesAutoresizingMaskIntoConstraints = false
        optionsStackView.topAnchor.constraint(equalTo: dropdownMenu.topAnchor, constant: 8).isActive = true
        optionsStackView.bottomAnchor.constraint(equalTo: dropdownMenu.bottomAnchor, constant: -8).isActive = true
        optionsStackView.leftAnchor.constraint(equalTo: dropdownMenu.leftAnchor).isActive = true
        optionsStackView.rightAnchor.constraint(equalTo: dropdownMenu.rightAnchor).isActive = true
        
        // Dropdown Menu
        view.addSubview(dropdownMenu)
        dropdownMenu.translatesAutoresizingMaskIntoConstraints = false
        switch openDirection {
        case .centerDown:
            dropdownMenu.topAnchor.constraint(equalTo: buttonProxy.topAnchor, constant: -8).isActive = true
            dropdownMenu.centerXAnchor.constraint(equalTo: buttonProxy.centerXAnchor, constant: 0).isActive = true
            
        case .leftDown:
            dropdownMenu.topAnchor.constraint(equalTo: buttonProxy.topAnchor, constant: -8).isActive = true
            dropdownMenu.rightAnchor.constraint(equalTo: buttonProxy.rightAnchor, constant: 8).isActive = true
            
        case .rightDown:
            dropdownMenu.topAnchor.constraint(equalTo: buttonProxy.topAnchor, constant: -8).isActive = true
            dropdownMenu.leftAnchor.constraint(equalTo: buttonProxy.leftAnchor, constant: -8).isActive = true
            
        case .centerUp:
            dropdownMenu.bottomAnchor.constraint(equalTo: buttonProxy.bottomAnchor, constant: 8).isActive = true
            dropdownMenu.centerXAnchor.constraint(equalTo: buttonProxy.centerXAnchor, constant: 0).isActive = true
            
        case .leftUp:
            dropdownMenu.bottomAnchor.constraint(equalTo: buttonProxy.bottomAnchor, constant: 8).isActive = true
            dropdownMenu.rightAnchor.constraint(equalTo: buttonProxy.rightAnchor, constant: 8).isActive = true
            
        case .rightUp:
            dropdownMenu.bottomAnchor.constraint(equalTo: buttonProxy.bottomAnchor, constant: 8).isActive = true
            dropdownMenu.leftAnchor.constraint(equalTo: buttonProxy.leftAnchor, constant: -8).isActive = true
            
        case .rightCenter:
            dropdownMenu.centerYAnchor.constraint(equalTo: buttonProxy.centerYAnchor, constant: 0).isActive = true
            dropdownMenu.leftAnchor.constraint(equalTo: buttonProxy.leftAnchor, constant: -8).isActive = true
            
        case .leftCenter:
            dropdownMenu.centerYAnchor.constraint(equalTo: buttonProxy.centerYAnchor, constant: 0).isActive = true
            dropdownMenu.rightAnchor.constraint(equalTo: buttonProxy.rightAnchor, constant: 8).isActive = true
            
        case .center:
            dropdownMenu.centerYAnchor.constraint(equalTo: buttonProxy.centerYAnchor, constant: 0).isActive = true
            dropdownMenu.centerXAnchor.constraint(equalTo: buttonProxy.centerXAnchor, constant: 0).isActive = true
            
        case .screenCenter:
            dropdownMenu.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
            dropdownMenu.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 32).isActive = true
            dropdownMenu.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -32).isActive = true
            
        case .screenBottom:
            dropdownMenu.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
            dropdownMenu.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 32).isActive = true
            dropdownMenu.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -32).isActive = true
        }
    }
    
    
    // =================================
    // MARK:- ANIMATION FUNCTIONS
    
    func showView() {
        UIView.animate(withDuration: 0.1) {
            self.backgroundOverlay.alpha = 1
            self.dropdownMenu.alpha = 1
            self.dropdownMenu.transform = .identity
        }
    }
    
    func hideView() {
        highlightedOption = nil
        UIView.animate(withDuration: 0.1, animations: {
            self.backgroundOverlay.alpha = 0
            self.dropdownMenu.alpha = 0
            self.dropdownMenu.transform = self.openDirection.initialTransform
        }) { (_) in
            self.dismiss(animated: false)
        }
    }
    
    
    // =================================
    // MARK:- EVENTS FUNCTIONS
    
    func didChangeHighlightedOption(oldValue: Int?) {
        if highlightedOption != oldValue {
            if let highlightedOption = highlightedOption {
                haptic?.impactOccurred()
                optionsStackView.arrangedSubviews[highlightedOption].backgroundColor = highlightColor
            }
            if let oldValue = oldValue {
                optionsStackView.arrangedSubviews[oldValue].backgroundColor = .clear
            }
        }
    }
    
    func didSelectOption(_ option: DropdownButton.Option) {
        option.action()
        hideView()
    }
    
    
    // =================================
    // MARK:- GESTURE FUNCTIONS
    
    @objc func didTapBackgroundOverlay(_ sender: AnyObject) {
        hideView()
    }
    
    @objc func didTapOptionButton(_ sender: AnyObject) {
        didSelectOption(options[sender.tag])
    }
    
    func didEndGesture() {
        if let highlightedOption = highlightedOption {
            didSelectOption(options[highlightedOption])
        }
        hideView()
    }
    
    func didChangeGesture() {
        if gestureRecognizer == nil { return }
        let touchPosition = gestureRecognizer!.location(in: self.optionsStackView).y
        let optionHeight = (optionsStackView.frame.height) / CGFloat(options.count)
        let activeButton = Int(touchPosition / optionHeight)

        if Array(0...options.count - 1).contains(activeButton) {
            highlightedOption = activeButton
        } else {
            highlightedOption = nil
        }
    }
}
