//
//  DropdownButton.swift
//  dropdown
//
//  Created by Fabio Giolito on 18/12/2018.
//  Copyright © 2018 Fabio Giolito. All rights reserved.
//

import UIKit

class DropdownButton: UIButton {
    
    // =================================
    // MARK:- DATA
    
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
    }
    
    
    // =================================
    // MARK:- MODEL
    
    var viewController: UIViewController? = nil // TODO: Rename Delegate, use protocol
    var dropdownController: DropdownController? = nil
    var options: [DropdownButton.Option] = [] // TODO: Move to setup function
    var openDirection: DropdownButton.OpenDirection = .screenBottom // TODO: Move to setup function

    
    
    // =================================
    // MARK:- INITIALIZE DROPDOWN
    
    func dropdown(target: UIViewController) {
        self.viewController = target

        setupGestures()
    }
    
    
    // =================================
    // MARK:- SETUP FUNCTIONS
    
    // Setup Gestures
    func setupGestures() {
        // Tap button
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapButton(_:)))
        self.addGestureRecognizer(tapRecognizer)
        
        // Long press button
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(didLongPressButton(_:)))
        longPressRecognizer.minimumPressDuration = 0.2
        self.addGestureRecognizer(longPressRecognizer)
        
        // Drag Button
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didLongPressButton(_:)))
        self.addGestureRecognizer(panRecognizer)
    }
    
    
    // =================================
    // MARK:- ACTION FUNCTIONS
    
    func showDropdown() {
        guard let viewController = self.viewController else { return }
        self.dropdownController = DropdownController()
        if dropdownController != nil {
            dropdownController!.modalPresentationStyle = .overCurrentContext
            dropdownController!.options = self.options
            dropdownController!.openDirection = self.openDirection
            dropdownController!.button = self
            viewController.present(dropdownController!, animated: false)
        }
    }

    
    // =================================
    // MARK:- GESTURES FUNCTIONS
    
    // Did tap button
    @objc func didTapButton(_ recognizer: UIGestureRecognizer) {
        showDropdown()
    }
    
    // Did long press or drag button
    @objc func didLongPressButton(_ recognizer: UIGestureRecognizer) {
        switch recognizer.state {
        case .began:
            showDropdown()
            
        case .changed:
            dropdownController?.gestureRecognizer = recognizer
            
        case .ended:
            dropdownController?.gestureRecognizer = nil

        default:
            break
        }
    }
    
}
