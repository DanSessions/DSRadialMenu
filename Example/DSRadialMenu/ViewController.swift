//
//  ViewController.swift
//  DSRadialMenu
//
//  Created by Dan Sessions on 03/06/2015.
//  Copyright (c) 2015 Daniel Sessions. All rights reserved.
//

import UIKit
import DSRadialMenu

class ViewController: UIViewController {

    @IBOutlet weak var radialMenu: DSRadialMenu!
    @IBOutlet weak var centerButton: UIButton!
    @IBOutlet weak var actionLabel: UILabel!
    
    typealias MenuItem = (title: String, position: DSRadialMenu.MenuItemPositon)
    
    let menuItemSize = CGSize(width: 65, height: 65)
    var menuItems: [MenuItem] {
        return [MenuItem("2", .TwoOClock), MenuItem("4", .FourOClock), MenuItem("5", .FiveOClock), MenuItem("10", .TenOClock)]
    }
    
    @IBAction func tappedOpenOrClose(sender: UIButton) {
        switch radialMenu.state {
        case .Closed:
            radialMenu.open()
            centerButton.setTitle("Close", forState: .Normal)
        case .Open:
            radialMenu.close()
            centerButton.setTitle("Open", forState: .Normal)
        }
    }
    
    @IBAction func tappedAddMenuItem(sender: UIButton) {
        if let nextPostion = radialMenu.nextMenuItemPosition() {
            let button = radialMenu.addMenuItem(String(nextPostion.rawValue), position: nextPostion, size: menuItemSize) as RoundButton
            configureButton(button)
        }
    }
    
    func tappedMenuItem(position: DSRadialMenu.MenuItemPositon) {
        actionLabel.text = "Tapped menu item at position \(position.rawValue)"
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        radialMenu.distanceFromCenter = 150
        radialMenu.tappedMenuItem = tappedMenuItem
        addMenuItems()
    }

    func addMenuItems() {
        for menuItem in menuItems {
            let button = radialMenu.addMenuItem(menuItem.title, position: menuItem.position, size: menuItemSize) as RoundButton
            configureButton(button)
        }
    }

    func configureButton(button: RoundButton) {
        button.cornerRadius = menuItemSize.width / 2
        button.titleLabel?.font = centerButton.titleLabel!.font.fontWithSize(15)
        button.backgroundColor = UIColor.redColor()
        button.titleLabel?.lineBreakMode = .ByWordWrapping
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    }
    
}

