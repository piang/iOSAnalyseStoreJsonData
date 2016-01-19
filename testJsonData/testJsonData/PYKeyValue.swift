//
//  PYKeyValue.swift
//  testJsonData
//
//  Created by 洋 裴 on 15/11/17.
//  Copyright © 2015年 玖富集团. All rights reserved.
//

import UIKit

let Prefix = "T@"

let Prefix1 = ","

let temp = "."

var CoustomPrefix:String?

var Cla :AnyClass?

var arrayObj = NSArray()

var valueObj:String?

extension NSObject {
    
    /// 通过字典来创建一个模型  @param keyValues 字典 @return 新建的对象如果你的模型中有Number Int 8 32 64等 请写成String 预防类型安全
    
    class func objectWithKeyValues(Dict:NSDictionary)->Self{
        
        let objc = self.init()
        
        var count:UInt32 = 0
        
        let properties = class_copyPropertyList(self.classForCoder(),&count)
        
        for var i = 0; i < Int(count); ++i {
            
            let propert : objc_property_t  = properties[i]
            
            let keys : NSString = NSString(CString: property_getName(propert), encoding: NSUTF8StringEncoding)!
            
            let types : NSString = NSString(CString: property_getAttributes(propert), encoding: NSUTF8StringEncoding)!
            
            let value :AnyObject? = Dict[keys]
            
            CoustomPrefix = (types as NSString).substringFromIndex(Prefix.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
            
            if !CoustomPrefix!.hasPrefix(Prefix1){
                
                let CustomValueName:String? = CoustomPrefix!.componentsSeparatedByString(Prefix1).first!
                
                if  value != nil{
                    
                    //  自定义类型
                    
                    if   value!.isKindOfClass(NSDictionary.classForCoder()) { // Dic
                        
                        // 根据类型字符串创建类
                        
                        Cla = swiftClassFromString(CustomValueName!)
                        
                        if Cla != nil {
                            
                            //  将转换后的类作为Value
                            
                            let CustomValueObject: AnyObject = Cla!.objectWithKeyValues(value as! NSDictionary)
                            
                            objc.setValue(CustomValueObject, forKey: keys as String)
                            
                        }
                        
                    }
                    
                }
                
            }
            
            if value != nil{
                
                let strCls:AnyClass = NSString.classForCoder()
                
                let Number:AnyClass = NSNumber.classForCoder()
                
                // swift 类型安全很重要 类型转换
                
                if value!.isKindOfClass(NSArray.classForCoder()){ //
                    
                    objc.setValue(value!, forKeyPath:keys as String)
                    
                }
                
                if value!.isKindOfClass(strCls) {//string
                    
                    valueObj = String(format: "\(value!)")
                    
                    objc.setValue(valueObj, forKeyPath:keys as String)
                    
                }
                
                if  value!.isKindOfClass(Number){ // Number
                    
                    valueObj = String(format: "\(value!)")
                    
                    objc.setValue(valueObj, forKeyPath:keys as String)
                    
                }
                
                if value!.isKindOfClass(NSURL.classForCoder()){ // url
                    
                    valueObj = String(format: "\(value!)")
                    
                    objc.setValue(valueObj, forKeyPath:keys as String)
                    
                }
                
                if value!.isEqual(Bool() as AnyObject){
                    
                    valueObj = String(format: "\(value!)")
                    
                    objc.setValue(valueObj, forKeyPath:keys as String)
                    
                }
                
            }
            
        }
        
        return objc
        
    }
    
    /// 得到自定义类型的类名 如果你的模型中有Number Int 8 32 64等 请写成String 预防类型安全
    
    private  class func swiftClassFromString(className: String) -> AnyClass! {
        
        if  let appName: String = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleName") as! String? {
            
            let typeStr = "\""
            
            if className.hasPrefix(typeStr){
                
                var rang = (className as NSString).substringFromIndex(typeStr.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
                
                // 类型字符串截取
                
                let length = rang.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
                
                
                rang = (rang as NSString).substringToIndex(length.hashValue-1)
                
                return NSClassFromString("\(appName).\(rang)")
                
            }
            
        }
        
        return nil;
        
    }
    
    /// 通过字典数组来创建一个模型数组 @param keyValuesArray 字典数组 @return 模型数组 如果你的模型中有Number Int 8 32 64等 请写成String 预防类型安全
    
    class func objectArrayWithKeyValuesArray(keyValuesArray:[[String:AnyObject]])->NSArray{
        
        let modelArray = NSMutableArray()
        
        var array = NSArray()
        
        for dict in keyValuesArray{
            
            let model:AnyObject = objectWithKeyValues(dict)
            
            modelArray.addObject(model)
            
            array = modelArray
            
        }
        
        return array
        
    }
    
}
