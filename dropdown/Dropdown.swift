//
//  Dropdown.swift
//  dropdown
//
//  Created by Fabio Giolito on 13/12/2018.
//  Copyright © 2018 Fabio Giolito. All rights reserved.
//

import UIKit

class Dropdown: UIView {

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
    }

    
    // =================================
    // MARK:- MODEL

    // Dropdown Options data
    private var options: [Option] = []

    // Dropdown visibility
    private var isOpen = false {
        didSet { openStateHasChanged() }
    }

    // Highlighted option
    private var highlightedOption: Int? {
        didSet { highlightedOptionHasChanged(oldValue: oldValue) }
    }

    
    // =================================
    // MARK:- CONFIG
    
    private var openDirection: OpenDirection = .leftCenter
    private var highlightColor: UIColor = UIColor(white: 0, alpha: 0.1)
    private var haptic: UIImpactFeedbackGenerator? = UIImpactFeedbackGenerator(style: .light)
    
    private var animationTransform: CGAffineTransform {
        switch openDirection {
        case .centerDown:   return CGAffineTransform(translationX: 0, y: -40).scaledBy(x: 0.5, y: 0.5)
        case .rightDown:    return CGAffineTransform(translationX: -40, y: -40).scaledBy(x: 0.5, y: 0.5)
        case .leftDown:     return CGAffineTransform(translationX: 40, y: -40).scaledBy(x: 0.5, y: 0.5)
        case .centerUp:     return CGAffineTransform(translationX: 0, y: 40).scaledBy(x: 0.5, y: 0.5)
        case .rightUp:      return CGAffineTransform(translationX: -40, y: 40).scaledBy(x: 0.5, y: 0.5)
        case .leftUp:       return CGAffineTransform(translationX: 40, y: 40).scaledBy(x: 0.5, y: 0.5)
        case .rightCenter:  return CGAffineTransform(translationX: -40, y: 0).scaledBy(x: 0.5, y: 0.5)
        case .leftCenter:   return CGAffineTransform(translationX: 40, y: 0).scaledBy(x: 0.5, y: 0.5)
        case .screenBottom: return CGAffineTransform(translationX: 0, y: 40)
        default:            return CGAffineTransform(scaleX: 0.5, y: 0.5)
        }
    }
    
    
    // =================================
    // MARK:- SUBVIEWS
    
    
    // Dropdown button
    private var button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("•••", for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        return button
    }()

    // Options stack view
    private var optionsStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        return view
    }()
    
    // Dropdown view
    private var dropdownView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.alpha = 0
        return view
    }()
    
    // Background overlay
    private var backgroundOverlay: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(white: 0, alpha: 0.1)
        button.alpha = 0
        return button
    }()
    
    
    // =================================
    // MARK:- INITIALIZERS
    
    convenience init(options: [Option], openDirection: OpenDirection? = nil, button: UIButton? = nil) {
        self.init()
        
        if openDirection != nil { self.openDirection = openDirection! }
        if button != nil { self.button = button! }
        
        self.options = options
        
        setupStyles()
        setupOptionsList()
        setupGestures()
        layoutSubviews()
    }
    
    
    // Override hitTest so elements are tappable outside view bounds
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if clipsToBounds || isHidden || alpha == 0 {
            return nil
        }
        for subview in subviews.reversed() {
            let subPoint = subview.convert(point, from: self)
            if let result = subview.hitTest(subPoint, with: event) {
                return result
            }
        }
        return nil
    }

    
    // =================================
    // MARK:- LAYOUT SUBVIEWS
    
    private func setupStyles() {
        dropdownView.backgroundColor = button.backgroundColor
        dropdownView.layer.cornerRadius = button.layer.cornerRadius
        dropdownView.tintColor = button.tintColor
    }
    
    override func layoutSubviews() {
        
        print("layouting subviews")
        
        // Hide dropdown
        dropdownView.transform = animationTransform

        // Anchor button
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.topAnchor.constraint(equalTo: topAnchor).isActive = true
        button.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        button.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        // Anchor list to dropdown view
        dropdownView.addSubview(optionsStackView)
        optionsStackView.translatesAutoresizingMaskIntoConstraints = false
        optionsStackView.topAnchor.constraint(equalTo: dropdownView.topAnchor, constant: 8).isActive = true
        optionsStackView.leftAnchor.constraint(equalTo: dropdownView.leftAnchor).isActive = true
        optionsStackView.rightAnchor.constraint(equalTo: dropdownView.rightAnchor).isActive = true
        optionsStackView.bottomAnchor.constraint(equalTo: dropdownView.bottomAnchor, constant: -8).isActive = true

        // Anchor dropdown view
        addSubview(dropdownView)
        dropdownView.translatesAutoresizingMaskIntoConstraints = false
        switch openDirection {
        case .centerDown:
            dropdownView.topAnchor.constraint(equalTo: button.topAnchor, constant: -8).isActive = true
            dropdownView.centerXAnchor.constraint(equalTo: button.centerXAnchor, constant: 0).isActive = true

        case .leftDown:
            dropdownView.topAnchor.constraint(equalTo: button.topAnchor, constant: -8).isActive = true
            dropdownView.rightAnchor.constraint(equalTo: button.rightAnchor, constant: 8).isActive = true

        case .rightDown:
            dropdownView.topAnchor.constraint(equalTo: button.topAnchor, constant: -8).isActive = true
            dropdownView.leftAnchor.constraint(equalTo: button.leftAnchor, constant: -8).isActive = true

        case .centerUp:
            dropdownView.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: 8).isActive = true
            dropdownView.centerXAnchor.constraint(equalTo: button.centerXAnchor, constant: 0).isActive = true

        case .leftUp:
            dropdownView.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: 8).isActive = true
            dropdownView.rightAnchor.constraint(equalTo: button.rightAnchor, constant: 8).isActive = true

        case .rightUp:
            dropdownView.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: 8).isActive = true
            dropdownView.leftAnchor.constraint(equalTo: button.leftAnchor, constant: -8).isActive = true

        case .rightCenter:
            dropdownView.centerYAnchor.constraint(equalTo: button.centerYAnchor, constant: 0).isActive = true
            dropdownView.leftAnchor.constraint(equalTo: button.leftAnchor, constant: -8).isActive = true

        case .leftCenter:
            dropdownView.centerYAnchor.constraint(equalTo: button.centerYAnchor, constant: 0).isActive = true
            dropdownView.rightAnchor.constraint(equalTo: button.rightAnchor, constant: 8).isActive = true

        case .center:
            dropdownView.centerYAnchor.constraint(equalTo: button.centerYAnchor, constant: 0).isActive = true
            dropdownView.centerXAnchor.constraint(equalTo: button.centerXAnchor, constant: 0).isActive = true

        case .screenCenter:
            if let superview = self.superview {
                dropdownView.centerYAnchor.constraint(equalTo: superview.centerYAnchor, constant: 0).isActive = true
                dropdownView.leftAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leftAnchor, constant: 32).isActive = true
                dropdownView.rightAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.rightAnchor, constant: -32).isActive = true
            }

        case .screenBottom:
            if let superview = self.superview {
                dropdownView.bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
                dropdownView.leftAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leftAnchor, constant: 32).isActive = true
                dropdownView.rightAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.rightAnchor, constant: -32).isActive = true
            }
        }

        // Anchor background overlay
        if let superview = self.superview {
            superview.insertSubview(backgroundOverlay, belowSubview: self)
            backgroundOverlay.translatesAutoresizingMaskIntoConstraints = false
            backgroundOverlay.topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
            backgroundOverlay.leftAnchor.constraint(equalTo: superview.leftAnchor).isActive = true
            backgroundOverlay.rightAnchor.constraint(equalTo: superview.rightAnchor).isActive = true
            backgroundOverlay.bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
        }

    }
    
    // Setup options list
    private func setupOptionsList() {
        for (index, option) in options.enumerated() {
            let optionButton = UIButton(type: .system)
            optionButton.setTitle(option.title, for: .normal)
            optionButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            optionButton.contentHorizontalAlignment = .left
            optionButton.setBackgroundColor(color: highlightColor, forState: .highlighted)

            if option.icon != nil {
                optionButton.setImage(option.icon, for: .normal)
                optionButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 24, bottom: 8, right: 32)
                optionButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -12, bottom: 0, right: 12)
            } else {
                optionButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 24, bottom: 8, right: 32)
            }

            optionButton.tag = index
            optionButton.addTarget(self, action: #selector(didTapOptionButton(_:)), for: .touchUpInside)

            optionsStackView.addArrangedSubview(optionButton)
        }
    }
    
    private func setupGestures() {
        // Tap Button
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapTriggerButton(_:)))
        button.addGestureRecognizer(tapRecognizer)

        // Long Press Button
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(didLongPressTriggerButton(_:)))
        longPressRecognizer.minimumPressDuration = 0.2
        button.addGestureRecognizer(longPressRecognizer)

        // Drag Button
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didLongPressTriggerButton(_:)))
        button.addGestureRecognizer(panRecognizer)

        // Tap Background Overlay
        backgroundOverlay.addTarget(self, action: #selector(didTapDropdownOverlay(_:)), for: .touchUpInside)
    }

    
    // =================================
    // MARK:- ACTION FUNCTIONS
    
    // Tapped dropdown: Open dropdown
    @objc func didTapTriggerButton(_ recognizer: UITapGestureRecognizer) {
        isOpen = !isOpen
    }

    // Tapped background: Close dropdown
    @objc func didTapDropdownOverlay(_ sender: AnyObject) {
        isOpen = false
    }

    // Tapped option: Do whatever, close dropdown
    @objc func didTapOptionButton(_ sender: AnyObject) {
        triggerOption(options[sender.tag])
    }

    // Long pressed or dragged dropdown button: Open dropdown, highlight options, trigger action
    @objc func didLongPressTriggerButton(_ recognizer: UIGestureRecognizer) {
        switch recognizer.state {
        case .began:
            isOpen = true

        case .changed:
            let touchPosition = recognizer.location(in: dropdownView).y
            let buttonHeight = (dropdownView.frame.height - 8 - 8) / CGFloat(options.count)
            let activeButton = Int(touchPosition / buttonHeight)

            if Array(0...options.count - 1).contains(activeButton) {
                highlightedOption = activeButton
            } else {
                highlightedOption = nil
            }

        case .ended:
            if highlightedOption != nil {
                triggerOption(options[highlightedOption!])
            }

        default:
            break
        }
    }

    private func triggerOption(_ option: Option) {
        isOpen = false
        highlightedOption = nil
        option.action()
    }

    private func openStateHasChanged() {
        haptic?.impactOccurred()
        UIView.animate(withDuration: 0.1) {
            if self.isOpen {
                self.dropdownView.transform = .identity
                self.dropdownView.alpha = 1
                self.backgroundOverlay.alpha = 1
            } else {
                self.dropdownView.transform = self.animationTransform
                self.dropdownView.alpha = 0
                self.backgroundOverlay.alpha = 0
            }
        }
    }

    private func highlightedOptionHasChanged(oldValue: Int?) {
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

}
