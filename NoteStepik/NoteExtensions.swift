//
//  NoteExtensions.swift
//  NoteStepik
//
//  Created by Gorbovtsova Ksenya on 18/06/2019.
//  Copyright © 2019 Gorbovtsova Ksenya. All rights reserved.
//

import Foundation
import UIKit

extension Note {
    
    var json: [String:Any] {
        return makeJson()
    }
    
    func makeJson() -> [String:Any] {
        
        var json = [String:Any]()
        
        json["uid"] = self.uid
        json["title"] = self.title
        json["content"] = self.content
        
        switch (self.priority) {
        case Priority.regular:
            break
        case Priority.important:
            json["priroty"] = "important"
        case Priority.irrelevant:
            json["priroty"] = "irrelevant"
        }

        switch (self.color){
        case UIColor.white:
            break
        default:
            json["color"] = self.color.transformToHex()
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        
        if let date = self.dateOfSelfDestruction {
            json["dateOfSelfDestruction"] = formatter.string(from: date)
        }
        
        return json
        
    }
   
    static func parse(json: [String: Any]) -> Note? {
        
        guard let uid = json["uid"] as? String,
            let title = json["title"] as? String,
            let content = json["content"] as? String
            else {
                return nil
        }
        
        let colorString: String
        switch (json["color"] as? String) {
            case .none:
                colorString = "#FFFFFF"
            case .some:
                colorString = (json["color"] as? String)!
        }
        
        var date: Date? = nil
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        switch json["dateOfSelfDestruction"] as? String {
        case .none:
            break
        case .some:
            date = formatter.date(from: (json["dateOfSelfDestruction"] as? String)!)!
        }

        if date == nil {
            return self.init(uid: uid, title: title, content: content, color: UIColor(hexString: colorString), priority: Priority.regular)
        }else {
            return self.init(uid: uid, title: title, content: content, color: UIColor(hexString: colorString), priority: Priority.regular, dateOfSelfDestruction: date!)
        }
        
    }
    
    enum SerelizationError: Error {
        case missing(String)
    }
    
}
public extension UIColor {
    
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    var toHex: String? {
        return transformToHex()
    }
    
    func transformToHex() -> String? {
        guard let components = cgColor.components, components.count >= 3 else {
            return nil
        }
        
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)
        
        if components.count >= 4 {
            a = Float(components[3])
            return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }

}
