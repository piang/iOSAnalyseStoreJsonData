//
//  chinaModel.swift
//  testJsonData
//
//  Created by 洋 裴 on 15/11/16.
//  Copyright © 2015年 玖富集团. All rights reserved.
//

import Foundation

class chinaModel: NSObject {
    
    var name:NSString!
    
    var province:NSArray!
    
    init(dic:NSDictionary) {
        
        super.init()
        
        name = dic["name"] as! NSString
        
        let array = dic["province"] as! [[String:AnyObject]]
        
        province = provinceModel.objectArrayWithKeyValuesArray(array) 

    }
    
    func initWithCoder(coder:NSCoder) -> AnyObject {
        
        self.name = coder.decodeObjectForKey("name") as! NSString
        self.province = coder.decodeObjectForKey("province") as! NSArray
        return self
        
    }
    
    func encodeWithCoder(coder:NSCoder) {
        coder.encodeObject(name, forKey: "name")
        coder.encodeObject(province, forKey: "province")
    }
    
}