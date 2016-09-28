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
    
    typealias MenuItem = (title: String, position: DSRadialMenu.MenuItemPosition)
    
    let menuItemSize = CGSize(width: 65, height: 65)

    @IBAction func tappedOpenOrClose(_ sender: UIButton) {
        switch radialMenu.state {
        case .closed:
            radialMenu.open()
            centerButton.setTitle("Close", for: UIControlState())
        case .open:
            radialMenu.close()
            centerButton.setTitle("Open", for: UIControlState())
        }
    }
    
    @IBAction func tappedAddMenuItem(_ sender: UIButton) {
        if let nextPostion = radialMenu.nextMenuItemPosition() {
            let title = String(nextPostion.rawValue)
            addMenuItem(MenuItem(title, nextPostion))
        } else {
            print("No more room!")
        }
    }
    
    @IBAction func tappedRemoveMenuItem(_ sender: UIButton) {
        if let lastPosition = radialMenu.menuItems.last?.position {
            radialMenu.removeMenuItem(lastPosition)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenu()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addMenuItems()
    }

    func addMenuItems() {
        let menuItems = [
            MenuItem("2", .twoOClock),
            MenuItem("4", .fourOClock),
            MenuItem("5", .fiveOClock),
            MenuItem("10", .tenOClock)
        ]
        for menuItem in menuItems {
            addMenuItem(menuItem)
        }
    }

    func addMenuItem(_ menuItem: MenuItem) {
        let button: RoundButton = radialMenu.addMenuItem(menuItem.title, position: menuItem.position, size: menuItemSize)
        setupButton(button)
    }

    func setupButton(_ button: RoundButton) {
        button.cornerRadius = menuItemSize.width / 2
        button.titleLabel?.font = centerButton.titleLabel!.font.withSize(15)
        button.backgroundColor = UIColor.red
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.setTitleColor(UIColor.white, for: UIControlState())
    }
 
    func setupMenu() {
        radialMenu.delegate = self
        radialMenu.distanceFromCenter = 150
    }
    
}

extension ViewController: DSRadialMenuDelegate {

    func menuItemTapped(_ menuItem: DSRadialMenu.MenuItem) {
        print("Tapped menu item at position \(menuItem.position.rawValue)")
    }
    
}
