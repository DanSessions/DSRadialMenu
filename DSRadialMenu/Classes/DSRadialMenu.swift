//
//  DSRadialMenu.swift
//  DSRadialMenu
//
//  Created by Dan Sessions on 05/06/2015.
//  Copyright (c) 2015 Daniel Sessions. All rights reserved.
//

import Darwin
import UIKit

public protocol DSRadialMenuDelegate: class {
    func menuItemTapped(_ menuItem: DSRadialMenu.MenuItem)
}

open class DSRadialMenu: UIView {
    
    public typealias MenuItem = (button: UIButton, position: MenuItemPosition)
    
    @IBOutlet open weak var centerButton: UIButton!
    
    @IBInspectable open var menuItemSize = CGSize(width: 50, height: 50)
    @IBInspectable open var distanceFromCenter: Double = 100
    
    var distanceBetweenMenuItems: Double = 30
    
    open fileprivate(set) var menuItems = [MenuItem]()
    open fileprivate(set) var state: MenuState = .closed
    open weak var delegate: DSRadialMenuDelegate?
    
    public enum MenuState {
        case open
        case closed
    }
    
    public enum MenuItemPosition: Int {
        case center = -1
        case twelveOClock = 0
        case oneOClock = 1
        case twoOClock = 2
        case threeOClock = 3
        case fourOClock = 4
        case fiveOClock = 5
        case sixOClock = 6
        case sevenOClock = 7
        case eightOClock = 8
        case nineOClock = 9
        case tenOClock = 10
        case elevenOClock = 11
    }
    
    // MARK: Public
    
    open func addMenuItem<T: UIButton>(_ title: String, position: MenuItemPosition) -> T {
        return addMenuItem(title, position: position, size: menuItemSize)
    }
    
    open func addMenuItem<T: UIButton>(_ title: String, position: MenuItemPosition, size: CGSize) -> T {
        let button = T()
        button.setTitle(title, for: UIControl.State())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        button.addTarget(self, action: #selector(DSRadialMenu.menuItemButtonTapped(_:)), for: .touchUpInside)
        addSubview(button)
        sendSubviewToBack(button)
        addButtonConstraints(button, size: size)
        let menuItem = MenuItem(button, position)
        menuItems.append(menuItem)
        if state == .open {
            animateMenuItemOut(menuItem)
        }
        return menuItem.button as! T
    }
    
    open func removeMenuItem(_ position: MenuItemPosition) {
        if let index = indexOfMenuItemAtPosition(position) {
            let menuItem = menuItems[index]
            animateMenuItemIn(menuItem, completion: {
                menuItem.button.removeFromSuperview()
            })
            self.menuItems.remove(at: index)
        }
    }
    
    open func open() {
        for menuItem in menuItems {
            animateMenuItemOut(menuItem)
        }
        state = .open
    }
    
    open func close() {
        for menuItem in menuItems {
            animateMenuItemIn(menuItem)
        }
        state = .closed
    }
    
    open func nextMenuItemPosition() -> MenuItemPosition? {
        let takenPositions = menuItems.map { $0.position.rawValue }
        let range = (MenuItemPosition.twelveOClock.rawValue...MenuItemPosition.elevenOClock.rawValue)
        let freePositions = range.filter() { return takenPositions.index(of: $0) == nil }
        if let freePosition = freePositions.first {
            return MenuItemPosition(rawValue: freePosition)
        } else {
            return nil
        }
    }
    
    // MARK: Internal
    
    func animateMenuItemOut(_ menuItem: MenuItem) {
        menuItem.button.isHidden = false
        let point = calculateMenuItemPoint(menuItem.position)
        animateMenuItem(menuItem,
                        direction: .out,
                        animations: { menuItem.button.transform = CGAffineTransform(translationX: point.x, y: point.y) },
                        completion: nil
        )
    }
    
    func animateMenuItemIn(_ menuItem: MenuItem, completion: (() -> Void)? = nil) {
        animateMenuItem(menuItem,
                        direction: .in,
                        animations: { menuItem.button.transform = CGAffineTransform.identity },
                        completion: { finished in
                            menuItem.button.isHidden = true
                            completion?()
        })
    }
    
    func animateMenuItem(_ menuItem: MenuItem, direction: MenuItemAnimationDirection, animations: @escaping (() -> Void), completion: ((Bool) -> Void)?) {
        UIView.animate(withDuration: 0.4,
                                   delay: 0,
                                   usingSpringWithDamping: direction.damping,
                                   initialSpringVelocity: direction.velocity,
                                   options: UIView.AnimationOptions(),
                                   animations: { animations() },
                                   completion: { finished in completion?(finished)
        })
    }
    
    func calculateMenuItemPoint(_ position: MenuItemPosition) -> CGPoint {
        let π = Double.pi
        let angle: Double = (distanceBetweenMenuItems * Double(position.rawValue))
        let cosine = cos(angle / Double(180.0) * π)
        let sine = sin(angle / Double(180.0) * π)
        let deltaY: Double = -distanceFromCenter * cosine
        let deltaX: Double = distanceFromCenter * sine
        let point = CGPoint(x: deltaX, y: deltaY)
        return point
    }
    
    func addButtonConstraints(_ button: UIButton, size: CGSize) {
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: size.width),
            NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: size.height),
            NSLayoutConstraint(item: button, attribute: .centerX, relatedBy: .equal, toItem: centerButton, attribute: .centerX, multiplier: 1, constant: 1),
            NSLayoutConstraint(item: button, attribute: .centerY, relatedBy: .equal, toItem: centerButton, attribute: .centerY, multiplier: 1, constant: 1)
            ])
    }
    
    func indexOfMenuItemAtPosition(_ position: MenuItemPosition) -> Int? {
        var indexOfMenuItem: Int?
        for (index, menuItem) in menuItems.enumerated() {
            if menuItem.position == position {
                indexOfMenuItem = index
                break
            }
        }
        return indexOfMenuItem
    }
    
    @objc func menuItemButtonTapped(_ button: UIButton) {
        let menuItem = menuItems.filter { $0.button == button }.first
        if let menuItem = menuItem {
            delegate?.menuItemTapped(menuItem)
        }
    }
    
}

enum MenuItemAnimationDirection {
    case `in`
    case out
    
    var damping: CGFloat {
        switch self {
        case .in:
            return 1
        case .out:
            return 0.8
        }
    }
    
    var velocity: CGFloat {
        switch self {
        case .in:
            return 0.4
        case .out:
            return 0.6
        }
    }
    
}

