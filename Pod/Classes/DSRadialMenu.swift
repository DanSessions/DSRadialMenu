//
//  DSRadialMenu.swift
//  DSRadialMenu
//
//  Created by Dan Sessions on 05/06/2015.
//  Copyright (c) 2015 Daniel Sessions. All rights reserved.
//

import Darwin
import UIKit

public class DSRadialMenu: UIView {
    
    typealias MenuItem = (button: UIButton, positon: MenuItemPositon)

    @IBInspectable public var menuItemSize: CGSize = CGSizeZero
    @IBInspectable var distanceFromCenter: Double = 100
    
    var distanceBetweenMenuItems: Double = 30

    private(set) public var state: MenuState = .Closed
    private(set) var menuItems = [MenuItem]()
    
    public var tappedMenuItem: ((String, MenuItemPositon) -> Void)?
    
    public enum MenuState {
        case Open
        case Closed
    }
    
    public enum MenuItemPositon: Int {
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
    
    func calculateMenuItemPoint(position: MenuItemPositon) -> CGPoint {
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
        addConstraint(NSLayoutConstraint(item: button, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: size.width))
        addConstraint(NSLayoutConstraint(item: button, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: size.height))
        addConstraint(NSLayoutConstraint(item: button, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 1))
        addConstraint(NSLayoutConstraint(item: button, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 1))
    }

    public func addMenuItem<T: UIButton>(title: String, position: MenuItemPositon) -> T {
        return addMenuItem(title, position: position, size: menuItemSize)        
    }
    
    public func addMenuItem<T: UIButton>(title: String, position: MenuItemPositon, size: CGSize) -> T {
        let button = T()
        button.setTranslatesAutoresizingMaskIntoConstraints(false)
        button.setTitle(title, forState: .Normal)
        button.tag = position.rawValue
        button.addTarget(self, action: "tappedMenuItem:", forControlEvents: .TouchUpInside)
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

    public func removeMenuItem(position: MenuItemPositon) {
        let index = menuItems.indexOf { (element) in
            return element.positon == position
        }
        if let index = index {
            let menuItem = menuItems[index]
            animateMenuItemIn(menuItem)
            menuItems.removeAtIndex(index)
        }
    }
    
    func tappedMenuItem(menuItem: UIButton) {
        if let position = MenuItemPositon(rawValue: menuItem.tag) {
            tappedMenuItem?(menuItem.titleForState(.Normal)!, position)
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
    
    func animateMenuItemOut(menuItem: MenuItem) {
        let point = calculateMenuItemPoint(menuItem.positon)
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.6, options: .CurveEaseInOut, animations: { () -> Void in
            menuItem.button.transform = CGAffineTransformMakeTranslation(point.x, point.y)
            }, completion: nil)
    }
    
    func animateMenuItemIn(menuItem: MenuItem) {
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.4, options: .CurveEaseInOut, animations: { () -> Void in
            menuItem.button.transform = CGAffineTransformIdentity
            }, completion: nil)
    }
    
    public func nextMenuItemPosition() -> MenuItemPositon? {
        let takenPositions = menuItems.map( { $0.positon.rawValue } )
        let freePositions = [Int](MenuItemPositon.TwelveOClock.rawValue...MenuItemPositon.ElevenOClock.rawValue).filter() {
            return find(takenPositions, $0) == nil
        }
        if freePositions.isEmpty {
            return nil
        } else {
            return MenuItemPositon(rawValue: freePositions.first!)
        }
    }
    
}