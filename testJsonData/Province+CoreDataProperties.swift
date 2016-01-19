//
//  Province+CoreDataProperties.swift
//  testJsonData
//
//  Created by 洋 裴 on 16/1/18.
//  Copyright © 2016年 玖富集团. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Province {

    @NSManaged var city: String?
    @NSManaged var name: String?

}
