//
//  UINavigationBar+Helper.swift
//  AccountApp
//
//  Created by Kuan-Chung Chen on 2017/12/17.
//  Copyright © 2017年 william. All rights reserved.
//

import UIKit

extension UINavigationBar {
    // MARK: - Gradient
    func applyGradient(colors: [UIColor]) {
        let frameAndStatusBar: CGRect = self.bounds
        setBackgroundImage(UINavigationBar.gradient(size: frameAndStatusBar.size, colors: colors), for: .default)
    }
    
    static func gradient(size: CGSize, colors: [UIColor]) -> UIImage? {
        let cgColors = colors.map({ $0.cgColor })
        UIGraphicsBeginImageContextWithOptions(size, true, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        defer {
            UIGraphicsEndImageContext()
        }
        var locations: [CGFloat] = [0.0, 1.0]
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: cgColors as NSArray as CFArray, locations: &locations) else { return nil }
        context.drawLinearGradient(gradient, start: CGPoint(x: 0.0, y: 0.0), end: CGPoint(x: size.width, y: 0.0), options: [])
        
        return UIGraphicsGetImageFromCurrentImageContext()
        
    }
}
