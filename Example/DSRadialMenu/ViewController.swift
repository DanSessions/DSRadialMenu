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
    
    typealias MenuItem = (title: String, position: DSRadialMenu.MenuItemPosition)
    
    let menuItemSize = CGSize(width: 65, height: 65)

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
            let title = String(nextPostion.rawValue)
            addMenuItem(MenuItem(title, nextPostion))
        } else {
            actionLabel.text = "No more room!"
        }
    }
    
    @IBAction func tappedRemoveMenuItem(sender: UIButton) {
        if let lastPosition = radialMenu.menuItems.last?.position {
            radialMenu.removeMenuItem(lastPosition)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenu()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        addMenuItems()
    }

    func addMenuItems() {
        let menuItems = [
            MenuItem("2", .TwoOClock),
            MenuItem("4", .FourOClock),
            MenuItem("5", .FiveOClock),
            MenuItem("10", .TenOClock)
        ]
        for menuItem in menuItems {
            addMenuItem(menuItem)
        }
    }

    func addMenuItem(menuItem: MenuItem) {
        let button: RoundButton = radialMenu.addMenuItem(menuItem.title, position: menuItem.position, size: menuItemSize)
        setupButton(button)
    }

    func setupButton(button: RoundButton) {
        button.cornerRadius = menuItemSize.width / 2
        button.titleLabel?.font = centerButton.titleLabel!.font.fontWithSize(15)
        button.backgroundColor = UIColor.redColor()
        button.titleLabel?.lineBreakMode = .ByWordWrapping
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    }
 
    func setupMenu() {
        radialMenu.delegate = self
        radialMenu.distanceFromCenter = 150
    }
    
}

extension ViewController: DSRadialMenuDelegate {

    func menuItemTapped(menuItem: DSRadialMenu.MenuItem) {
        actionLabel.text = "Tapped menu item at position \(menuItem.position.rawValue)"
    }
    
}
