//
//  ColorHelper.swift
//  ColorClash
//
//  Created by user922914 on 12/2/20.
//

import Foundation
class ColorHelper {
    let dictColor: [String: Int] = [
        "Red": 0,
        "Blue": 1,
        "Yellow": 2,
        "Purple": 3,
        "Orange": 4,
        "Green": 5
    ]
    
    init() {}
    
    func getValueByColor(color: String) -> Int {
        return dictColor[color]!
    }
    
    func getColorByValue(value: Int) -> String {
        for (k, v) in dictColor {
            if dictColor[k] == value {
                return k
            }
        }
        return "Color not found"
    }
    
    func getCombinedColorString(color1: String, color2: String) -> String {
        return getColorByValue(value: getCombinedColorValue(color1: color1, color2: color2))
    }
    
    func getCombinedColorValue(color1: String, color2: String) -> Int {
        return getValueByColor(color: color1) + getValueByColor(color: color2) + 2
    }
}
