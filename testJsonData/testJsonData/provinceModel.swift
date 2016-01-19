//
//  provinceModel.swift
//  testJsonData
//
//  Created by 洋 裴 on 15/12/15.
//  Copyright © 2015年 玖富集团. All rights reserved.
//

import UIKit

class provinceModel: NSObject {
    
    var name:NSString!
    var city:NSString!
    
    func initWithCoder(coder:NSCoder) -> AnyObject {
        
        self.name = coder.decodeObjectForKey("name") as! NSString
        self.city = coder.decodeObjectForKey("city") as! NSString
        return self
        
    }
    
    func encodeWithCoder(coder:NSCoder) {
        coder.encodeObject(name, forKey: "name")
        coder.encodeObject(city, forKey: "city")
    }

}
