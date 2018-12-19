//
//  DropdownView.swift
//  dropdown
//
//  Created by Fabio Giolito on 18/12/2018.
//  Copyright © 2018 Fabio Giolito. All rights reserved.
//

import UIKit

class DropdownView: UIView {
    
    // Option struct
    struct Option {
        let title: String?
        let icon: UIImage?
        let action: () -> ()
    }
    
    // Open direction
    enum OpenDirection {
        case centerDown, rightDown, leftDown
        case centerUp, rightUp, leftUp
        case rightCenter, leftCenter
        case center
        case screenCenter, screenBottom
        
        var initialTransform: CGAffineTransform {
            switch self {
            case .centerDown:   return CGAffineTransform(translationX: 0, y: -24).scaledBy(x: 0.5, y: 0.5)
            case .rightDown:    return CGAffineTransform(translationX: -24, y: -24).scaledBy(x: 0.5, y: 0.5)
            case .leftDown:     return CGAffineTransform(translationX: 24, y: -24).scaledBy(x: 0.5, y: 0.5)
            case .centerUp:     return CGAffineTransform(translationX: 0, y: 24).scaledBy(x: 0.5, y: 0.5)
            case .rightUp:      return CGAffineTransform(translationX: -24, y: 24).scaledBy(x: 0.5, y: 0.5)
            case .leftUp:       return CGAffineTransform(translationX: 24, y: 24).scaledBy(x: 0.5, y: 0.5)
            case .rightCenter:  return CGAffineTransform(translationX: -24, y: 0).scaledBy(x: 0.5, y: 0.5)
            case .leftCenter:   return CGAffineTransform(translationX: 24, y: 0).scaledBy(x: 0.5, y: 0.5)
            case .screenBottom: return CGAffineTransform(translationX: 0, y: 24)
            default:            return CGAffineTransform(scaleX: 0.5, y: 0.5)
            }
        }
    }
    
    
    // =================================
    // MARK:- MODEL
    
    private var options: [Option] = []
    private var button: UIButton?
    private var target: UIViewController?
    private var openDirection: OpenDirection?
    private var highlightedOption: Int? {
        didSet { didChangeHighlightedOption(oldValue) }
    }
    
    private var haptic = UISelectionFeedbackGenerator()
    
    // Preferences
    
    var springDamping: CGFloat = 2
    
    var overlayBackgroundColor: UIColor = UIColor(white: 0, alpha: 0.1) {
        didSet { backgroundOverlay.backgroundColor = overlayBackgroundColor }
    }
    
    var optionHighlightColor: UIColor = UIColor(white: 0, alpha: 0.1) {
        didSet { updateOptionsStyles() }
    }
    
    override var tintColor: UIColor! {
        didSet { updateOptionsStyles() }
    }


    // =================================
    // MARK:- SUBVIEWS
    
    private var optionsStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 0
        view.axis = .vertical
        return view
    }()
    
    private var backgroundOverlay: UIButton = {
        let background = UIButton()
        background.backgroundColor = UIColor(white: 0, alpha: 0.1)
        background.alpha = 0
        return background
    }()
    
    
    // =================================
    // MARK:- INITIALIZERS
    
    convenience init(options: [Option], button: UIButton, target: UIViewController, openDirection: OpenDirection = .leftDown) {
        self.init()

        self.options = options
        self.button = button
        self.target = target
        self.openDirection = openDirection
        
        setupOptions()
        setupGestures()
        layoutSubviews()
        setupStyles()
    }
    
    
    // =================================
    // MARK:- LAYOUT SUBVIEWS
    
    private func setupStyles() {
        self.alpha = 0
        self.clipsToBounds = true
        self.transform = openDirection?.initialTransform ?? .identity
        self.backgroundColor = button?.backgroundColor ?? .white
        self.tintColor = button?.tintColor
        self.layer.cornerRadius = 16
    }
    
    private func updateOptionsStyles() {
        for optionButton in optionsStackView.arrangedSubviews {
            if let optionButton = optionButton as? UIButton {
                optionButton.setBackgroundColor(color: optionHighlightColor, forState: .highlighted)
                optionButton.setTitleColor(self.tintColor, for: .normal)
            }
        }
    }
    
    override func layoutSubviews() {
        
        // Unwrap optionals
        guard let targetView = target?.view,
              let button = button
        else { return }
        
        
        // Background overlay
        targetView.addSubview(backgroundOverlay)
        backgroundOverlay.translatesAutoresizingMaskIntoConstraints = false
        backgroundOverlay.topAnchor.constraint(equalTo: targetView.topAnchor).isActive = true
        backgroundOverlay.bottomAnchor.constraint(equalTo: targetView.bottomAnchor).isActive = true
        backgroundOverlay.leftAnchor.constraint(equalTo: targetView.leftAnchor).isActive = true
        backgroundOverlay.rightAnchor.constraint(equalTo: targetView.rightAnchor).isActive = true
        
        
        // Options stack view
        self.addSubview(optionsStackView)
        optionsStackView.translatesAutoresizingMaskIntoConstraints = false
        optionsStackView.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        optionsStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        optionsStackView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        optionsStackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
            
        // Dropdown menu (self)
        targetView.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        switch openDirection! {
        case .centerDown:
            self.topAnchor.constraint(equalTo: button.topAnchor, constant: -8).isActive = true
            self.centerXAnchor.constraint(equalTo: button.centerXAnchor, constant: 0).isActive = true

        case .leftDown:
            self.topAnchor.constraint(equalTo: button.topAnchor, constant: -8).isActive = true
            self.rightAnchor.constraint(equalTo: button.rightAnchor, constant: 8).isActive = true

        case .rightDown:
            self.topAnchor.constraint(equalTo: button.topAnchor, constant: -8).isActive = true
            self.leftAnchor.constraint(equalTo: button.leftAnchor, constant: -8).isActive = true

        case .centerUp:
            self.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: 8).isActive = true
            self.centerXAnchor.constraint(equalTo: button.centerXAnchor, constant: 0).isActive = true

        case .leftUp:
            self.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: 8).isActive = true
            self.rightAnchor.constraint(equalTo: button.rightAnchor, constant: 8).isActive = true

        case .rightUp:
            self.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: 8).isActive = true
            self.leftAnchor.constraint(equalTo: button.leftAnchor, constant: -8).isActive = true

        case .rightCenter:
            self.centerYAnchor.constraint(equalTo: button.centerYAnchor, constant: 0).isActive = true
            self.leftAnchor.constraint(equalTo: button.leftAnchor, constant: -8).isActive = true

        case .leftCenter:
            self.centerYAnchor.constraint(equalTo: button.centerYAnchor, constant: 0).isActive = true
            self.rightAnchor.constraint(equalTo: button.rightAnchor, constant: 8).isActive = true

        case .center:
            self.centerYAnchor.constraint(equalTo: button.centerYAnchor, constant: 0).isActive = true
            self.centerXAnchor.constraint(equalTo: button.centerXAnchor, constant: 0).isActive = true

        case .screenCenter:
            self.centerYAnchor.constraint(equalTo: targetView.centerYAnchor, constant: 0).isActive = true
            self.leftAnchor.constraint(equalTo: targetView.safeAreaLayoutGuide.leftAnchor, constant: 32).isActive = true
            self.rightAnchor.constraint(equalTo: targetView.safeAreaLayoutGuide.rightAnchor, constant: -32).isActive = true

        case .screenBottom:
            self.bottomAnchor.constraint(equalTo: targetView.safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
            self.leftAnchor.constraint(equalTo: targetView.safeAreaLayoutGuide.leftAnchor, constant: 32).isActive = true
            self.rightAnchor.constraint(equalTo: targetView.safeAreaLayoutGuide.rightAnchor, constant: -32).isActive = true
        }
    }
    
    
    // =================================
    // MARK:- SETUP FUNCTIONS
    
    private func setupOptions() {
        for (index, option) in options.enumerated() {
            let optionButton = UIButton(type: .custom)
            optionButton.setTitle(option.title, for: .normal)
            
            // Color
            optionButton.setBackgroundColor(color: optionHighlightColor, forState: .highlighted)
            optionButton.setTitleColor(self.tintColor, for: .normal)
            
            // Font, Alignment, Padding
            optionButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            optionButton.contentHorizontalAlignment = .left
            optionButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 24, bottom: 8, right: 32)
            
            // Image
            if option.icon != nil {
                let icon = option.icon!.withRenderingMode(.alwaysTemplate)
                optionButton.setImage(icon, for: .normal)
                optionButton.setImage(icon, for: .highlighted)
                optionButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -12, bottom: 0, right: 12)
            }
            
            optionButton.tag = index
            optionButton.addTarget(self, action: #selector(didTapOptionButton(_:)), for: .touchUpInside)
            
            optionsStackView.addArrangedSubview(optionButton)
        }
    }
    
    private func setupGestures() {
        
        // Tap Background
        backgroundOverlay.addTarget(self, action: #selector(didTapBackgroundOverlay(_:)), for: .touchUpInside)
        
        // Tap button
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapButton(_:)))
        button?.addGestureRecognizer(tapRecognizer)
        
        // Long press button
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(didLongPressButton(_:)))
        longPressRecognizer.minimumPressDuration = 0.2
        button?.addGestureRecognizer(longPressRecognizer)
        
        // Drag Button
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didLongPressButton(_:)))
        button?.addGestureRecognizer(panRecognizer)
    }
    
    
    
    // =================================
    // MARK:- STATE FUNCTIONS
    
    func showDropdown() {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: springDamping, initialSpringVelocity: 2, options: [], animations: {
            self.backgroundOverlay.alpha = 1
            self.alpha = 1
            self.transform = .identity
        })
    }
    
    func hideDropdown() {
        highlightedOption = nil
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: springDamping, initialSpringVelocity: 2, options: [], animations: {
            self.backgroundOverlay.alpha = 0
            self.alpha = 0
            self.transform = self.openDirection?.initialTransform ?? .identity
        })
    }
    
    private func didChangeHighlightedOption(_ oldValue: Int?) {
        if highlightedOption != oldValue {
            if let highlightedOption = highlightedOption {
                haptic.selectionChanged()
                optionsStackView.arrangedSubviews[highlightedOption].backgroundColor = optionHighlightColor
            }
            if let oldValue = oldValue {
                optionsStackView.arrangedSubviews[oldValue].backgroundColor = .clear
            }
        }
    }
    
    private func didSelectOption(_ option: DropdownView.Option) {
        option.action()
        hideDropdown()
    }
    
    
    
    // =================================
    // MARK:- GESTURES FUNCTIONS
    
    @objc private func didTapOptionButton(_ sender: AnyObject) {
        didSelectOption(options[sender.tag])
    }
    
    @objc private func didTapBackgroundOverlay(_ sender: AnyObject) {
        hideDropdown()
    }
    
    @objc private func didTapButton(_ recognizer: UIGestureRecognizer) {
        haptic.selectionChanged()
        showDropdown()
    }
    
    @objc private func didLongPressButton(_ recognizer: UIGestureRecognizer) {
        switch recognizer.state {
        case .began:
            showDropdown()
            
        case .changed:
            let touchPosition = recognizer.location(in: self).y
            let buttonHeight = (self.frame.height - 8 - 8) / CGFloat(options.count)
            let activeButton = Int(touchPosition / buttonHeight)
            
            if Array(0...options.count - 1).contains(activeButton) {
                highlightedOption = activeButton
            } else {
                highlightedOption = nil
            }
            
        case .ended:
            if highlightedOption != nil {
                didSelectOption(options[highlightedOption!])
            } else {
                hideDropdown()
            }
            
        default:
            break
        }
    }
}
