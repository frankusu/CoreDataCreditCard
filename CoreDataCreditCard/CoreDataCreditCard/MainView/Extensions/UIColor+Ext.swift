//
//  UIColor+Ext.swift
//  CoreDataCreditCard
//
//  Created by Frank Su on 2022-08-27.
//

import UIKit

extension UIColor {

     class func color(data:Data) -> UIColor? {
          return try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? UIColor
     }

     func encode() -> Data? {
          return try? NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
     }
}
