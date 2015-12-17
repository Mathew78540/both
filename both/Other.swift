//
//  UIColorFromRGBA.swift
//  both
//
//  Created by Mathieu Le tyrant on 14/12/2015.
//  Copyright © 2015 Mathieu Le tyrant. All rights reserved.
//

import UIKit

// Return UIColor base on RGBA
func UIColorFromRGBA(colorCode: String, alpha: Float = 1.0) -> UIColor {
    let scanner = NSScanner(string:colorCode)
    var color:UInt32 = 0;
    scanner.scanHexInt(&color)
    
    let mask = 0x000000FF
    let r = CGFloat(Float(Int(color >> 16) & mask)/255.0)
    let g = CGFloat(Float(Int(color >> 8) & mask)/255.0)
    let b = CGFloat(Float(Int(color) & mask)/255.0)
    
    return UIColor(red: r, green: g, blue: b, alpha: CGFloat(alpha))
}

func borderBottom(inputTextField:UITextField){
    let border = CALayer()
    let width = CGFloat(1.0)
    border.borderColor = UIColorFromRGBA("EBEBEB").CGColor
    border.frame = CGRect(x: 0, y: inputTextField.frame.size.height - width, width:  inputTextField.frame.size.width, height: inputTextField.frame.size.height)
    
    border.borderWidth = width
    
    inputTextField.layer.addSublayer(border)
    inputTextField.layer.masksToBounds = true
}

func borderCercle(image:UIImageView, border:CGFloat){
    image.layer.borderWidth = border
    image.layer.masksToBounds = false
    image.layer.borderColor = UIColor.whiteColor().CGColor
    image.layer.cornerRadius = image.frame.size.width/2
    image.clipsToBounds = true
}
