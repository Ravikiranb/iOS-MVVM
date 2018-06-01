//
//  MobileListViewController.swift
//  Mobiles
//
//  Created by RaviKiran B on 30/05/18.
//  Copyright © 2018 RaviKiran B. All rights reserved.
//

import UIKit

class MobileListViewController: UIViewController {

    //
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    lazy var viewModel: MobileListViewModel = {
        return MobileListViewModel()
    }()
    
    //MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Init UI
        self.initUI()
        
        //Init ViewModel
        self.initVM()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.initFetch()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK:Initialization
    func initUI() -> () {
        if let mainVC:ViewController = self.tabBarController!.parent as? ViewController{
            
            let toggleButton = UIBarButtonItem.init(image: UIImage.init(named: "menuIcon"), style: UIBarButtonItemStyle.done, target: mainVC, action:#selector(ViewController.callToggleMenu))
            
            self.navigationItem.leftBarButtonItem = toggleButton;
        }
        let editButton = UIBarButtonItem.init(title: "Edit", style: .done, target: self, action: #selector(didPressEditButton(sender:)))
        
        self.navigationItem.rightBarButtonItem = editButton
        
        self.tableView.estimatedRowHeight = 100;
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.isEditing = true
    }
        

    func initVM() -> () {
        //Status
        viewModel.showStatusClosure = { [weak self] () in
            DispatchQueue.main.async {
                if let message = self?.viewModel.statusMessage {
                    self?.statusLabel.text = message
                }
            }
        }
        
        viewModel.reloadTableViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        
        
        viewModel.updateEditModeClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.tableView.isEditing = true;
                self?.tableView.allowsSelectionDuringEditing = (self?.viewModel.isEditingEnabled)!
                self?.tableView.reloadData()
                
                if (self?.viewModel.isEditingEnabled)! {
                    let editButton = UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(self?.didPressEditButton(sender:)))
                    
                    self?.navigationItem.rightBarButtonItem = editButton
                }
                else{
                    let editButton = UIBarButtonItem.init(title: "Edit", style: .done, target: self, action: #selector(self?.didPressEditButton(sender:)))
                    
                    self?.navigationItem.rightBarButtonItem = editButton
                }
            }
        }
    }
    
    @IBAction func didPressMoreLessButton(sender : UIButton) {
        viewModel.moreLessButtonPressed(tag: sender.tag)
    }

    @IBAction func didPressEditButton (sender : Any){
        viewModel.editButtonPressed()
        
    }
    
}

extension MobileListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MobileListTableViewCell", for: indexPath) as? MobileListTableViewCell else {
            fatalError("Cell not exists in storyboard")
        }

        let cellVM = viewModel.getCellViewModel( at: indexPath )
        
        cell.buttonMoreLess.tag = indexPath.row
        cell.buttonMoreLess.addTarget(self, action: #selector(didPressMoreLessButton(sender:)), for:.touchUpInside)
        
        if cellVM.showDetails {
            cell.buttonMoreLess .setTitle("Less", for:.normal)
            cell.heightForDetails.constant = 90;
            cell.viewDetails.isHidden = false
            
        }
        else{
            cell.buttonMoreLess .setTitle("More", for:.normal)
            cell.heightForDetails.constant = 0;
            cell.viewDetails.isHidden = true
        }
        
        cell.labelName.text = cellVM.Name;
        cell.labelColor.text = cellVM.Color
        cell.labelCost.text = cellVM.Cost
        cell.labelMemory.text = cellVM.Memory
        cell.labelBattery.text = cellVM.Battery
        cell.labelPrimaryCamera.text = cellVM.PrimaryCamera
        cell.labelSecondaryCamera.text = cellVM.SecondaryCamera
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.numberOfCells>0 {
            self.tableView.alpha = 1.0
        }
        else{
            self.tableView.alpha = 0.0
        }
        return viewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteOptionSelected(index: indexPath.row)
        }
        
        
    }
    
     func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if viewModel.isEditingEnabled {
            return .delete
        }
        return .none
    }
    
     func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print("Moved: ", "\(sourceIndexPath.row) => \(destinationIndexPath.row) ")
        viewModel.movedMobile(sourceIndex: sourceIndexPath.row, destinationIndex: destinationIndexPath.row)
        
    }
    
    
    
}

class MobileListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var viewDetails: UIView!
    
    @IBOutlet weak var buttonMoreLess: UIButton!
    @IBOutlet weak var heightForDetails: NSLayoutConstraint!
    @IBOutlet weak var labelName: UILabel!
    
    @IBOutlet weak var labelMemory: UILabel!
    @IBOutlet weak var labelCost: UILabel!
    @IBOutlet weak var labelColor: UILabel!
    @IBOutlet weak var labelSecondaryCamera: UILabel!
    @IBOutlet weak var labelBattery: UILabel!
    @IBOutlet weak var labelPrimaryCamera: UILabel!
}
