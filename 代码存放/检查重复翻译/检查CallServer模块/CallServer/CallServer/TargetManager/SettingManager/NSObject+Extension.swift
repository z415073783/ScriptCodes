//
//  NSObject+Extension.swift
//  UME
//
//  Created by zlm on 16/8/5.
//  Copyright © 2016年 yealink. All rights reserved.
//

import Foundation
public extension NSObject {

    /**
     获取对象的属性值，无对于的属性则返回NIL
     
     - parameter property: 要获取值的属性
     
     - returns: 属性的值
     */
    public func getValueOfProperty(_ property: String) -> AnyObject? {
        let allPropertys = getAllPropertys()

        if(allPropertys.contains(property)) {
            return value(forKey: property) as AnyObject?

        } else {
            return nil
        }
    }

    /**
     设置对象属性的值
     
     - parameter property: 属性
     - parameter value:    值
     
     - returns: 是否设置成功
     */
    public func setValueOfProperty(_ property: String, value: AnyObject) -> Bool {
        let allPropertys = getAllPropertys()
        if(allPropertys.contains(property)) {
            setValue(value, forKey: property)
            return true

        } else {
            return false
        }
    }

    /**
     获取对象的所有属性名称
     
     - returns: 属性名称数组
     */
    public func getAllPropertys() -> [String] {

        var result = [String]()
        let count = UnsafeMutablePointer<UInt32>.allocate(capacity: 0)
        let buff = class_copyPropertyList(object_getClass(self), count)
        let countInt = Int(count[0])

        for i in 0 ..< countInt {
            let temp = buff?[i]
            let tempPro = property_getName(temp!)
            let proper = String.init(validatingUTF8: tempPro)
            result.append(proper!)

        }

        return result
    }
    //字典转对象
    public func translateObject(_ sender: NSMutableDictionary) {
        for (key, value) in sender {
            setValue(value, forKey: key as! String)
        }
    }

    public func getString() -> String {
        var str: String = ""
        if (self as? NSArray) != nil {
            let arr = self as! NSArray
            if arr.count != 0 {
                str = "["
                for i in 0 ..< arr.count {
                    let value = arr[i]
                    if ((value as? String) != nil) {
                        str += value as! String
                    } else if ((value as? Double) != nil) {
                        str += String((value as! Double))
                    } else if ((value as? Bool) != nil) {
                        str += String(value as! Bool)
                    } else if ((value as? NSObject) != nil) {
                        str += (value as! NSObject).getString()
                    }
                    if i < arr.count-1 {
                        str += ","
                    }
                }
                str += "]"
                return str
            }

        }

        str = "{"
        for i in 0 ..< getAllPropertys().count {
            let item = getAllPropertys()[i]
            let value = getValueOfProperty(item)

            if ((value as? String) != nil) {
                str += item + ":" + (value as! String)
            } else if ((value as? Double) != nil) {
                str += item + ":" + String((value as! Double))
            } else if ((value as? Bool) != nil) {
                str += item + ":" + String(value as! Bool)
            } else if ((value as? NSObject) != nil) {
                str += (item + ":" + (value as! NSObject).getString())
            }
            if i < getAllPropertys().count-1 {
                str += ","
            }
        }

        str += "}"
        return str
    }

}
