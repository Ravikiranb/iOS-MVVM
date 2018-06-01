//
//  AddMobileViewModel.swift
//  Mobiles
//
//  Created by RaviKiran B on 30/05/18.
//  Copyright © 2018 RaviKiran B. All rights reserved.
//

import Foundation


enum AddMobileFieldTags:Int {
    case Name
    case Color
    case Cost
    case Battery
    case Memory
    case PrimaryCamera
    case SecondaryCamera
}

class AddMobileViewModel {
    
    var mobileModel:MobileModel = MobileModel()
    let mobileStore: MobileStoreProtocol

    init( mobileStore: MobileStoreProtocol = MobileStore()) {
        self.mobileStore = mobileStore
        
    }
    
    var showMessageClosure: (()->())?
    
    var message: String? {
        didSet {
            self.showMessageClosure?()
        }
    }
    
    var clearForm: (()->())?
    
    func valueChangedForTag(tag: Int, value:String) {
        switch tag {
        case AddMobileFieldTags.Name.rawValue:
            self.mobileModel.modelName = value
            break
        case AddMobileFieldTags.Color.rawValue:
            self.mobileModel.color = value
            break
        case AddMobileFieldTags.Cost.rawValue:
            if let inValue : Int = Int (value){
                self.mobileModel.cost = inValue
            }
            
            break
        case AddMobileFieldTags.Battery.rawValue:
            self.mobileModel.battery = value
            break
        case AddMobileFieldTags.PrimaryCamera.rawValue:
            self.mobileModel.primaryCamera = value
            break
        case AddMobileFieldTags.SecondaryCamera.rawValue:
            self.mobileModel.secondaryCamera = value
            break
        case AddMobileFieldTags.Memory.rawValue:
            self.mobileModel.memory = value
            break
        default:
            print("Incorrect Tag")
        }
        
    }
    
    func saveMobile() -> () {
        self.mobileModel.indexOfMobile = self.mobileStore.getIndexForNew()
        mobileStore.addMobile(mobile: self.mobileModel)
        self.message = "Mobile details saved."
        self.clearForm?()
        mobileModel = MobileModel()
    
    }
    
    
    
    
    
}
