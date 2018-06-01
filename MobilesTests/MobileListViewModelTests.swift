//
//  MobileListViewModelTests.swift
//  MobilesTests
//
//  Created by RaviKiran B on 31/05/18.
//  Copyright © 2018 RaviKiran B. All rights reserved.
//

import XCTest
@testable import Mobiles

class MobileListViewModelTests: XCTestCase {
    
    var VM : MobileListViewModel!
    var mockMobileStore: MockMobileStore!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockMobileStore = MockMobileStore()
        VM = MobileListViewModel(mobileStore:mockMobileStore)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        VM = nil
        mockMobileStore = nil
        super.tearDown()
    }
    
    func test_fetch_mobiles() {
        
        // When
        VM.initFetch()
        
        // Assert
        XCTAssertTrue(mockMobileStore!.getMobilesCalled)
    }
    
    func test_NoRecordsStatus() {
        mockMobileStore.completeMobiles = []
        VM.initFetch()
        
        XCTAssertEqual(VM.statusMessage, "No mobiles found, please add mobile details by selecting add mobile tab.")
    }
    
    func test_RecordsStatus() {
        mockMobileStore.completeMobiles = [MobileModel()]
        VM.initFetch()
        XCTAssertEqual(VM.statusMessage, "")
    }
    
    func test_EditEnabled() {
        //Initial
        XCTAssertFalse(VM.isEditingEnabled)
        
        VM.editButtonPressed()
        
        XCTAssertTrue(VM.isEditingEnabled)
    }
    

    
    func test_create_cell_view_model() {
        // Given
        let mobiles:[MobileModel] = [MobileModel(),MobileModel()]
        mockMobileStore.completeMobiles = mobiles
        
        VM.initFetch()
        
        XCTAssertEqual( VM.numberOfCells, mobiles.count )
        
    }
    func test_getCellViewModel(){
        let mobile = MobileModel()
        mobile.modelName = "Apple iPhone 9"
        mobile.battery = "2000"
        mobile.cost = 15000
        mobile.color = "Red"
        mobile.memory = "64GB"
        mobile.primaryCamera = "12MP"
        mobile.secondaryCamera = "7MP"
        
        let mobiles = [mobile]
        mockMobileStore.completeMobiles = mobiles
        
        VM.initFetch()
        
        let cellVM = VM.getCellViewModel(at: IndexPath(row: 0, section: 0))
        
        XCTAssertEqual(mobile.modelName, cellVM.Name)
        XCTAssertEqual(mobile.color, cellVM.Color)
        XCTAssertEqual("\(mobile.cost)", cellVM.Cost)
        XCTAssertEqual(mobile.memory, cellVM.Memory)
        XCTAssertEqual(mobile.battery, cellVM.Battery)
        XCTAssertEqual(mobile.primaryCamera, cellVM.PrimaryCamera)
        XCTAssertEqual(mobile.secondaryCamera, cellVM.SecondaryCamera)
    }
    
    func test_MoreLessButton(){
        let mobiles:[MobileModel] = [MobileModel(),MobileModel(),MobileModel()]
        mockMobileStore.completeMobiles = mobiles
        
        VM.initFetch()
        
        let indexPath = IndexPath(row: 1, section: 0)
        
        var cellVM = VM.getCellViewModel(at: indexPath)
        
        XCTAssertFalse(cellVM.showDetails)
        
        VM.moreLessButtonPressed(tag: 1)
        
        cellVM = VM.getCellViewModel(at: indexPath)
        
        XCTAssertTrue(cellVM.showDetails)
    }
    
    func test_DeleteMobile(){
        let mobiles:[MobileModel] = [MobileModel(),MobileModel(),MobileModel()]
        mockMobileStore.completeMobiles = mobiles
        VM.initFetch()
        
        VM.deleteOptionSelected(index: 1)
        
        XCTAssertTrue(mockMobileStore.deleteMobileCalled)
        
    }
    
    func test_UpdateIndex(){
        let mobiles:[MobileModel] = [MobileModel(),MobileModel(),MobileModel(),MobileModel()]
        mockMobileStore.completeMobiles = mobiles
        VM.initFetch()
        
        //Move UP 2 Steps
        VM.movedMobile(sourceIndex: 3, destinationIndex: 1)
        
        XCTAssertEqual(mockMobileStore.updateIndexes, [1,3,2])
        
        //Reset
        mockMobileStore.updateIndexes = []
        
        //Move Down 2 Steps
        VM.movedMobile(sourceIndex: 0, destinationIndex: 2)
        
        XCTAssertEqual(mockMobileStore.updateIndexes, [2,0,1])
        
        //Reset
        mockMobileStore.updateIndexes = []
        
        //Move Down 3 Steps
        VM.movedMobile(sourceIndex: 0, destinationIndex: 3)
        
        XCTAssertEqual(mockMobileStore.updateIndexes, [3,0,1,2])
        
        //Reset
        mockMobileStore.updateIndexes = []
        
        //Move Up 3 Steps
        VM.movedMobile(sourceIndex: 3, destinationIndex: 0)
        
        XCTAssertEqual(mockMobileStore.updateIndexes, [0,3,2,1])
    }
    
    func test_MoveMobile_MoreLessButton(){
        let mobiles:[MobileModel] = [MobileModel(),MobileModel(),MobileModel()]
        mockMobileStore.completeMobiles = mobiles
        
        VM.initFetch()
        
        let indexPath = IndexPath(row: 1, section: 0)
        VM.moreLessButtonPressed(tag: indexPath.row)
        var cellVM = VM.getCellViewModel(at: indexPath)
        
        XCTAssertTrue(cellVM.showDetails)
        
        VM.movedMobile(sourceIndex: 1, destinationIndex: 2)
        
        cellVM = VM.getCellViewModel(at: indexPath)
        
        XCTAssertFalse(cellVM.showDetails)
        
        cellVM = VM.getCellViewModel(at: IndexPath(row: 2, section: 0))
        
        XCTAssertTrue(cellVM.showDetails)
        
    }
}


class MockMobileStore: MobileStoreProtocol {
    
    
    var getMobilesCalled = false
    var deleteMobileCalled = false
    var saveMobileCalled = false
    
    var completeMobiles: [MobileModel] = [MobileModel]()
    
    var updateIndexes:[Int] = []
    
    func getMobiles() -> [MobileModel] {
        getMobilesCalled = true
        return Array(completeMobiles)
    }
    
    func getIndexForNew() -> Int {
        return completeMobiles.count
    }
    
    func addMobile(mobile: MobileModel) {
        saveMobileCalled = true;
    }

    func deleteMobile(mobile: MobileModel) {
        deleteMobileCalled = true
    }
    
    func updateIndexOfMobile(mobile: MobileModel, index: Int) {
        updateIndexes.append(index)
    }
}

