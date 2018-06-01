//
//  MobileStore.swift
//  Mobiles
//
//  Created by RaviKiran B on 30/05/18.
//  Copyright © 2018 RaviKiran B. All rights reserved.
//

import Foundation
import RealmSwift

protocol MobileStoreProtocol {
    func getMobiles()->[MobileModel]
    func getIndexForNew() -> Int
    func addMobile(mobile:MobileModel) -> Void
    func deleteMobile(mobile:MobileModel) -> Void
    func updateIndexOfMobile(mobile:MobileModel, index:Int)
}

class MobileStore: MobileStoreProtocol{
    let realm = try! Realm()
    
    func getMobiles() -> [MobileModel] {
        let result = realm.objects(MobileModel.self).sorted(byKeyPath: "indexOfMobile")
        return Array(result)
    }
    
    func getIndexForNew() -> Int {
        return realm.objects(MobileModel.self).count
    }
    
    func addMobile(mobile:MobileModel) -> Void {
        try! realm.write {
            realm.add(mobile)
        }
    }
    
    func deleteMobile(mobile:MobileModel) -> Void {
        try! realm.write {
            realm.delete(mobile)
        }
    }
    
    func updateIndexOfMobile(mobile: MobileModel, index: Int) {
        try! realm.write {
            mobile.indexOfMobile = index
            realm.add(mobile)
        }
    }
    

    
}
