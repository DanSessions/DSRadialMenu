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
    func menuItemTapped(menuItem: DSRadialMenu.MenuItem)
}

public class DSRadialMenu: UIView {
    
    public typealias MenuItem = (button: UIButton, position: MenuItemPosition)

    @IBOutlet public weak var centerButton: UIButton!
    
    @IBInspectable public var menuItemSize = CGSize(width: 50, height: 50)
    @IBInspectable public var distanceFromCenter: Double = 100
    
    var distanceBetweenMenuItems: Double = 30
    private(set) public var menuItems = [MenuItem]()
    private(set) public var state: MenuState = .Closed
    public weak var delegate: DSRadialMenuDelegate?
    
    public enum MenuState {
        case Open
        case Closed
    }
    
    public enum MenuItemPosition: Int {
        case Center = -1
        case TwelveOClock = 0
        case OneOClock = 1
        case TwoOClock = 2
        case ThreeOClock = 3
        case FourOClock = 4
        case FiveOClock = 5
        case SixOClock = 6
        case SevenOClock = 7
        case EightOClock = 8
        case NineOClock = 9
        case TenOClock = 10
        case ElevenOClock = 11
    }
    
    // MARK: Public
    
    public func addMenuItem<T: UIButton>(title: String, position: MenuItemPosition) -> T {
        return addMenuItem(title, position: position, size: menuItemSize)        
    }
    
    public func addMenuItem<T: UIButton>(title: String, position: MenuItemPosition, size: CGSize) -> T {
        let button = T()
        button.setTitle(title, forState: .Normal)
        button.setTranslatesAutoresizingMaskIntoConstraints(false)
        button.hidden = true
        button.addTarget(self, action: "menuItemButtonTapped:", forControlEvents: .TouchUpInside)
        addSubview(button)
        sendSubviewToBack(button)
        addButtonConstraints(button, size: size)
        let menuItem = MenuItem(button, position)
        menuItems.append(menuItem)
        if state == .Open {
            animateMenuItemOut(menuItem)
        }
        return menuItem.button as! T
    }

    public func removeMenuItem(position: MenuItemPosition) {
        if let index = indexOfMenuItemAtPosition(position) {
            let menuItem = menuItems[index]
            animateMenuItemIn(menuItem)
            menuItems.removeAtIndex(index)
        }
    }
    
    public func open() {
        for menuItem in menuItems {
            animateMenuItemOut(menuItem)
        }
        state = .Open
    }
    
    public func close() {
        for menuItem in menuItems {
            animateMenuItemIn(menuItem)
        }
        state = .Closed
    }
    
    public func nextMenuItemPosition() -> MenuItemPosition? {
        let takenPositions = menuItems.map( { $0.position.rawValue } )
        let freePositions = [Int](MenuItemPosition.TwelveOClock.rawValue...MenuItemPosition.ElevenOClock.rawValue).filter() {
            return find(takenPositions, $0) == nil
        }
        if freePositions.isEmpty {
            return nil
        } else {
            return MenuItemPosition(rawValue: freePositions.first!)
        }
    }
    
    // MARK: Internal
    
    func animateMenuItemOut(menuItem: MenuItem) {
        menuItem.button.hidden = false
        let point = calculateMenuItemPoint(menuItem.position)
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.6, options: .CurveEaseInOut, animations: { () -> Void in
            menuItem.button.transform = CGAffineTransformMakeTranslation(point.x, point.y)
            }, completion: nil)
    }
    
    func animateMenuItemIn(menuItem: MenuItem) {
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.4, options: .CurveEaseInOut, animations: { () -> Void in
            menuItem.button.transform = CGAffineTransformIdentity
            }, completion: { (finished) -> Void in
                menuItem.button.hidden = true
        })
    }
    
    func calculateMenuItemPoint(position: MenuItemPosition) -> CGPoint {
        let π = M_PI
        let angle: Double = (distanceBetweenMenuItems * Double(position.rawValue))
        let cosine = cos(angle / Double(180.0) * π)
        let sine = sin(angle / Double(180.0) * π)
        let deltaY: Double = -distanceFromCenter * cosine
        let deltaX: Double = distanceFromCenter * sine
        let point = CGPoint(x: deltaX, y: deltaY)
        return point
    }
    
    func addButtonConstraints(button: UIButton, size: CGSize) {
        NSLayoutConstraint.activateConstraints([
            NSLayoutConstraint(item: button, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: size.width),
            NSLayoutConstraint(item: button, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: size.height),
            NSLayoutConstraint(item: button, attribute: .CenterX, relatedBy: .Equal, toItem: centerButton, attribute: .CenterX, multiplier: 1, constant: 1),
            NSLayoutConstraint(item: button, attribute: .CenterY, relatedBy: .Equal, toItem: centerButton, attribute: .CenterY, multiplier: 1, constant: 1)
            ])
    }
    
    func indexOfMenuItemAtPosition(position: MenuItemPosition) -> Int? {
        var indexOfMenuItem: Int?
        for (index, menuItem) in enumerate(menuItems) {
            if menuItem.position == position {
                indexOfMenuItem = index
                break
            }
        }
        return indexOfMenuItem
    }
    
    func menuItemButtonTapped(button: UIButton) {
        let menuItem = menuItems.filter {
            $0.button == button
            }.first
        if let menuItem = menuItem {
            delegate?.menuItemTapped(menuItem)
        }
    }
    
}