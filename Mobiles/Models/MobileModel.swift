//
//  MobileModel.swift
//  Mobiles
//
//  Created by RaviKiran B on 30/05/18.
//  Copyright © 2018 RaviKiran B. All rights reserved.
//

import Foundation
import RealmSwift

class MobileModel: Object {
    @objc dynamic var modelName = ""
    @objc dynamic var color = ""
    @objc dynamic var cost = 0
    @objc dynamic var battery = ""
    @objc dynamic var primaryCamera = ""
    @objc dynamic var secondaryCamera = ""
    @objc dynamic var memory = ""
    @objc dynamic var indexOfMobile = 0
}


