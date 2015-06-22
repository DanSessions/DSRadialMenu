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
    
    var distanceBetweenMenuItems: Double = 30
    public var distanceFromCenter: Double = 100
    private(set) public var state: MenuState = .Closed
    private(set) var menuItems = [MenuItem]()
    
    public var tappedMenuItem: ((MenuItemPositon) -> Void)?
    
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
        return menuItem.button as! T
    }

    func tappedMenuItem(menuItem: UIButton) {
        if let position = MenuItemPositon(rawValue: menuItem.tag) {
            tappedMenuItem?(position)
        }
    }
    
    public func open() {
        for menuItem in menuItems {
            let point = calculateMenuItemPoint(menuItem.positon)
            UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.6, options: .CurveEaseInOut, animations: { () -> Void in
                menuItem.button.transform = CGAffineTransformMakeTranslation(point.x, point.y)
                }, completion: nil)
        }
        state = .Open
    }
    
    public func close() {
        for menuItem in menuItems {
            UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.4, options: .CurveEaseInOut, animations: { () -> Void in
                menuItem.button.transform = CGAffineTransformIdentity
                }, completion: nil)            
        }
        state = .Closed
    }
    
    public func nextMenuItemPosition() -> MenuItemPositon? {
        if let lastPosition = menuItems.last?.positon.rawValue, let nextPosition = MenuItemPositon(rawValue: lastPosition + 1) {
            if let index = find(menuItems.map( { $0.positon } ), nextPosition) {
                println("Taken")
            }
            
            return nextPosition
        } else {
            return .TwelveOClock
        }
    }
    
}