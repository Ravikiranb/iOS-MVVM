//
//  MobileListViewModel.swift
//  Mobiles
//
//  Created by RaviKiran B on 30/05/18.
//  Copyright © 2018 RaviKiran B. All rights reserved.
//

import Foundation

class MobileListViewModel {
    
    let mobileStore: MobileStoreProtocol
    
    private var mobiles: [MobileModel] = [MobileModel]()
    
    private var cellViewModels: [MobileListCellViewModel] = [MobileListCellViewModel]() {
        didSet {
            self.reloadTableViewClosure?()
        }
    }
    
    private var expandedIndexes:[Int] = []
    var statusMessage: String? {
        didSet {
            self.showStatusClosure?()
        }
    }
    
    var isEditingEnabled = false {
        didSet {
            self.updateEditModeClosure?()
        }
    }
    
    
    //MARK:Closures
    var showStatusClosure: (()->())?
    var reloadTableViewClosure: (()->())?
    var updateEditModeClosure: (()->())?
    
    init( mobileStore: MobileStoreProtocol = MobileStore()) {
        self.mobileStore = mobileStore
        
    }
    
    
    
    
    func initFetch() {
        self.statusMessage = "Loading..."
        mobiles = mobileStore.getMobiles()
        self.processFetchedMobiles(mobiles: mobiles)
        
    }
    
    private func processFetchedMobiles( mobiles: [MobileModel] ) {
        if(mobiles.count>0){
            //Update TableView
            self.statusMessage = ""
            
        }
        else{
            //Show No records message
            self.statusMessage = "No mobiles found, please add mobile details by selecting add mobile tab."
        }
        var CVM = [MobileListCellViewModel]()
        for mobile in mobiles{
            CVM.append(self.createCellViewModel(mobile: mobile))
        }
        cellViewModels = CVM
    }
    
    func createCellViewModel( mobile: MobileModel ) -> MobileListCellViewModel {
        return MobileListCellViewModel(Name: mobile.modelName, Cost: "\(mobile.cost)", Color: mobile.color, Memory: mobile.memory, Battery: mobile.battery, PrimaryCamera: mobile.primaryCamera, SecondaryCamera: mobile.secondaryCamera, showDetails: false)
    }
    
    //MARK:TableView
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    func getCellViewModel( at indexPath: IndexPath ) -> MobileListCellViewModel {
        var cellViewModel = cellViewModels[indexPath.row]
        if expandedIndexes.contains(indexPath.row){
            cellViewModel.showDetails = true;
        }
        else{
            cellViewModel.showDetails = false;
        }
        
        return cellViewModel
    }
    
    func moreLessButtonPressed(tag:Int) -> () {
//        var CVM = cellViewModels[tag]
//        CVM.showDetails = !CVM.showDetails
//        cellViewModels.remove(at: tag)
//        cellViewModels.insert(CVM, at: tag)
        
        if expandedIndexes.contains(tag){
            expandedIndexes.remove(at: expandedIndexes.index(of: tag)!)
            
        }
        else{
            expandedIndexes.append(tag)
        }
        self.reloadTableViewClosure?()
    }
    
    func editButtonPressed() {
        self.isEditingEnabled = !self.isEditingEnabled
    }
    
    func deleteOptionSelected(index:Int) {
        let mobile = mobiles[index]
        mobileStore.deleteMobile(mobile: mobile)
        self.initFetch()
        
    }
    
    private func updateIndex(sourceIndex:Int, destinationIndex:Int){
        let mobile = mobiles[sourceIndex]
        mobileStore.updateIndexOfMobile(mobile: mobile, index: destinationIndex)
        if expandedIndexes.contains(sourceIndex){
            expandedIndexes.remove(at: expandedIndexes.index(of: sourceIndex)!)
        }
        
    }
    
    func movedMobile(sourceIndex:Int, destinationIndex:Int) -> Void {
        if sourceIndex != destinationIndex {
            var newExpandedIndexes:[Int] = []
            if expandedIndexes.contains(sourceIndex){
                newExpandedIndexes.append(destinationIndex)
            }
            self.updateIndex(sourceIndex: sourceIndex, destinationIndex: destinationIndex)
            
            if sourceIndex>destinationIndex {
                //Moved Up
                var index = sourceIndex-1
                while index >= destinationIndex{
                    if expandedIndexes.contains(index){
                        newExpandedIndexes.append(index+1)
                    }
                    self.updateIndex(sourceIndex: index, destinationIndex: index+1)
                    
                    index=index-1
                }
            }
            else{
                //Moved Down

                var index = sourceIndex+1
                while index <= destinationIndex{
                    
                    if expandedIndexes.contains(index){
                        newExpandedIndexes.append(index-1)
                    }
                    self.updateIndex(sourceIndex: index, destinationIndex: index-1)
                    
                    index=index+1
                }
            }
            expandedIndexes.append(contentsOf: newExpandedIndexes)
            self.initFetch()
        }
        
    }
}


struct MobileListCellViewModel {
    let Name:String
    let Cost:String
    let Color:String
    let Memory:String
    let Battery:String
    let PrimaryCamera:String
    let SecondaryCamera:String
    
    var showDetails:Bool = false
}
