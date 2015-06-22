//
//  RoundButton.swift
//  DSRadialMenu
//
//  Created by Dan Sessions on 03/06/2015.
//  Copyright (c) 2015 Daniel Sessions. All rights reserved.
//

import UIKit

@IBDesignable
class RoundButton: UIButton {
   
    @IBInspectable var cornerRadius: CGFloat = 6 {
        didSet {
            updateLayer()
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            updateLayer()
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            updateLayer()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateLayer()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateLayer()
    }

    required override init(frame: CGRect) {
        super.init(frame: frame)
        updateLayer()
    }
    
    func updateLayer() {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = cornerRadius > 0
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor?.CGColor
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        updateLayer()
    }
    
}
