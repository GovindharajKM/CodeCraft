//
//  Extensions.swift
//  CodeCraft
//
//  Created by Govindharaj Murugan on 21/01/21.
//

import Foundation
import UIKit

var gradientLayer: CAGradientLayer!

extension UIView {
    
    func setGradientColor() {
        let colorTop = UIColor().hexStringToUIColor(hex:"#011285").cgColor
        let colorMiddle = UIColor().hexStringToUIColor(hex:"#0F2185").cgColor
        let colorDownMiddle = UIColor().hexStringToUIColor(hex:"#121F81").cgColor
        let colorBottom = UIColor().hexStringToUIColor(hex:"#1D319C").cgColor
        self.setGradientBackground([colorTop, colorMiddle, colorDownMiddle, colorBottom])
    }
    
    func setOptimumGradientColor() {
        let colorTop = UIColor().hexStringToUIColor(hex:"#0D0048").cgColor
        let colorMiddle = UIColor().hexStringToUIColor(hex:"#170A52").cgColor
        let colorDownMiddle = UIColor().hexStringToUIColor(hex:"#23106C").cgColor
        let colorBottom = UIColor().hexStringToUIColor(hex:"#4D147B").cgColor
        self.setGradientBackground([colorTop, colorMiddle, colorDownMiddle, colorBottom])
    }
    
    func setGradientBackground(_ arrColor: [CGColor]) {
        
        if gradientLayer != nil {
            if ((self.layer.sublayers?.contains(gradientLayer)) != nil) {
                for gLayer in self.layer.sublayers! {
                    if gLayer == gradientLayer {
                        gLayer.removeFromSuperlayer()
                    }
                }
            }
        }
        
        gradientLayer = CAGradientLayer()
        gradientLayer.colors = arrColor
        gradientLayer.locations =  [0.2, 0.5, 0.7, 1.0]
        gradientLayer.frame = self.bounds
        
        self.layer.layoutSublayers()
        self.layer.insertSublayer(gradientLayer, at:0)
    }
    
    func removeSublayer(layerIndex index: Int) {
        guard let sublayers = self.layer.sublayers else {
            print("The view does not have any sublayers.")
            return
        }
        if sublayers.count > index {
            self.layer.sublayers!.remove(at: index)
        } else {
            print("There are not enough sublayers to remove that index.")
        }
    }
    
    func setRoundedCorner() {
        self.layer.cornerRadius = self.frame.width/2
        self.layer.masksToBounds = true
    }
    
    func setborderWith(_ color: UIColor)  {
        self.layer.borderWidth = 2
        self.layer.borderColor = color.cgColor
        self.addShadow(offset: CGSize.init(width: 3, height: 3), color: color, radius: 20.0, opacity: 0.5)
    }
    
    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
        self.layer.masksToBounds = true
        self.layer.shadowOffset = offset
        self.layer.shadowColor = color.cgColor
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity
        
        let backgroundCGColor = backgroundColor?.cgColor
        self.backgroundColor = nil
        self.layer.backgroundColor =  backgroundCGColor
    }
}

extension UIColor {
    
    func hexStringToUIColor(hex: String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}


extension UISegmentedControl{
    
    func removeBorder() {
        
        let backgroundImage = UIImage.getColoredRectImageWith(color: UIColor.white.cgColor, andSize: self.bounds.size)
        self.setBackgroundImage(backgroundImage, for: .normal, barMetrics: .default)
        self.setBackgroundImage(backgroundImage, for: .selected, barMetrics: .default)
        self.setBackgroundImage(backgroundImage, for: .highlighted, barMetrics: .default)

        let deviderImage = UIImage.getColoredRectImageWith(color: UIColor.white.cgColor, andSize: CGSize(width: 1.0, height: self.bounds.size.height))
        self.setDividerImage(deviderImage, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], for: .normal)
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(red: 67/255, green: 129/255, blue: 244/255, alpha: 1.0)], for: .selected)
    }

    func addUnderlineForSelectedSegment(){
        
        self.removeBorder()
        let underlineWidth: CGFloat = self.bounds.size.width / CGFloat(self.numberOfSegments)
        let underlineHeight: CGFloat = 3.0
        let underlineXPosition = CGFloat(selectedSegmentIndex * Int(underlineWidth))
        let underLineYPosition = self.bounds.size.height - 3.0
        let underlineFrame = CGRect(x: underlineXPosition, y: underLineYPosition, width: underlineWidth, height: underlineHeight)
        let underline = UIView(frame: underlineFrame)
        underline.backgroundColor = UIColor().hexStringToUIColor(hex: "#1D319C")
        underline.tag = 1
        self.addSubview(underline)
    }

    func changeUnderlinePosition(){
        guard let underline = self.viewWithTag(1) else {return}
        let underlineFinalXPosition = (self.bounds.width / CGFloat(self.numberOfSegments)) * CGFloat(selectedSegmentIndex)
        UIView.animate(withDuration: 0.1, animations: {
            underline.frame.origin.x = underlineFinalXPosition
        })
    }
    
    func selectedSegmentTintColor() {
        self.setTitleTextAttributes([.foregroundColor: UIColor.red], for: .selected)
    }
    
    func unselectedSegmentTintColor() {
        self.setTitleTextAttributes([.foregroundColor: UIColor().hexStringToUIColor(hex: "#23106C")], for: .normal)
    }
    
}

extension UIImage {

    class func getColoredRectImageWith(color: CGColor, andSize size: CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let graphicsContext = UIGraphicsGetCurrentContext()
        graphicsContext?.setFillColor(color)
        let rectangle = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        graphicsContext?.fill(rectangle)
        let rectangleImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return rectangleImage!
    }
}
