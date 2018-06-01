//
//  AddMobileViewModelTests.swift
//  MobilesTests
//
//  Created by RaviKiran B on 31/05/18.
//  Copyright © 2018 RaviKiran B. All rights reserved.
//

import XCTest

@testable import Mobiles

class AddMobileViewModelTests: XCTestCase {
    
    var VM : AddMobileViewModel!
    var mockMobileStore: MockMobileStore!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockMobileStore = MockMobileStore()
        VM = AddMobileViewModel(mobileStore:mockMobileStore)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        VM = nil
        mockMobileStore = nil
        super.tearDown()
    }
    
    func test_NameTextFieldChange(){
        VM.valueChangedForTag(tag: AddMobileFieldTags.Name.rawValue, value:"Apple")
        XCTAssertEqual(VM.mobileModel.modelName, "Apple")
    }
    
    func test_ColorFieldChange(){
        VM.valueChangedForTag(tag: AddMobileFieldTags.Color.rawValue, value:"Green")
        XCTAssertEqual(VM.mobileModel.color, "Green")
    }
    
    func test_CostFieldChange(){
        VM.valueChangedForTag(tag: AddMobileFieldTags.Cost.rawValue, value:"12000")
        XCTAssertEqual("\(VM.mobileModel.cost)", "12000")
    }
    
    func test_BatteryFieldChange(){
        VM.valueChangedForTag(tag: AddMobileFieldTags.Battery.rawValue, value:"2300")
        XCTAssertEqual(VM.mobileModel.battery, "2300")
    }
    
    func test_MemoryFieldChange(){
        VM.valueChangedForTag(tag: AddMobileFieldTags.Memory.rawValue, value:"64")
        XCTAssertEqual(VM.mobileModel.memory, "64")
    }
    
    func test_PrimaryCameraTextFieldChange(){
        VM.valueChangedForTag(tag: AddMobileFieldTags.PrimaryCamera.rawValue, value:"12")
        XCTAssertEqual(VM.mobileModel.primaryCamera, "12")
    }
    
    func test_SecondaryCameraFieldChange(){
        VM.valueChangedForTag(tag: AddMobileFieldTags.SecondaryCamera.rawValue, value:"8")
        XCTAssertEqual(VM.mobileModel.secondaryCamera, "8")
    }
    
    func test_Save(){
        VM.saveMobile()
        XCTAssertTrue(mockMobileStore.saveMobileCalled)
        
        XCTAssertEqual(VM.message, "Mobile details saved.")
    }
    
}


