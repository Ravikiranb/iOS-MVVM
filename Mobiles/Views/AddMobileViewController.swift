//
//  AddMobileViewController.swift
//  Mobiles
//
//  Created by RaviKiran B on 30/05/18.
//  Copyright © 2018 RaviKiran B. All rights reserved.
//

import UIKit



class AddMobileViewController: UITableViewController {

    
    
    @IBOutlet weak var textViewName: UITextField!{
        didSet{
            self.textViewName.tag = AddMobileFieldTags.Name.rawValue
            self.textViewName.addTarget(self, action:#selector(textFieldDidChange(textField:)), for: .editingChanged)
        }
    }
    @IBOutlet weak var textViewColor: UITextField!{
        didSet{
            self.textViewColor.tag = AddMobileFieldTags.Color.rawValue
            self.textViewColor.addTarget(self, action:#selector(textFieldDidChange(textField:)), for: .editingChanged)
        }
    }
    
    @IBOutlet weak var textBattery: UITextField!{
        didSet{
            self.textBattery.tag = AddMobileFieldTags.Battery.rawValue
            self.textBattery.addTarget(self, action:#selector(textFieldDidChange(textField:)), for: .editingChanged)
        }
    }
    @IBOutlet weak var textCost: UITextField!{
        didSet{
            self.textCost.tag = AddMobileFieldTags.Cost.rawValue
            self.textCost.addTarget(self, action:#selector(textFieldDidChange(textField:)), for: .editingChanged)
        }
    }
    
    @IBOutlet weak var textSecondaryCamera: UITextField!{
        didSet{
            self.textSecondaryCamera.tag = AddMobileFieldTags.SecondaryCamera.rawValue
            self.textSecondaryCamera.addTarget(self, action:#selector(textFieldDidChange(textField:)), for: .editingChanged)
        }
    }
    @IBOutlet weak var textPrimaryCamera: UITextField!{
        didSet{
            self.textPrimaryCamera.tag = AddMobileFieldTags.PrimaryCamera.rawValue
            self.textPrimaryCamera.addTarget(self, action:#selector(textFieldDidChange(textField:)), for: .editingChanged)
        }
    }
    @IBOutlet weak var textMemory: UITextField!{
        didSet{
            self.textMemory.tag = AddMobileFieldTags.Memory.rawValue
            self.textMemory.addTarget(self, action:#selector(textFieldDidChange(textField:)), for: .editingChanged)
        }
    }
    
    @IBOutlet weak var buttonAddMobile: UIButton!
    
    lazy var viewModel: AddMobileViewModel = {
        return AddMobileViewModel()
    }()
    
    //MARK:View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initUI()
        self.initVM()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initUI() -> () {
        if let mainVC:ViewController = self.tabBarController!.parent as? ViewController{
            
            let toggleButton = UIBarButtonItem.init(image: UIImage.init(named: "menuIcon"), style: UIBarButtonItemStyle.done, target: mainVC, action:#selector(ViewController.callToggleMenu))
            
            self.navigationItem.leftBarButtonItem = toggleButton;
        }
        self.buttonAddMobile.layer.cornerRadius = 20.0
        self.buttonAddMobile.layer.borderColor = self.buttonAddMobile.tintColor.cgColor
        self.buttonAddMobile.layer.borderWidth = 1.0
    }
    
    func initVM() -> () {
        viewModel.showMessageClosure = { [weak self] () in
            DispatchQueue.main.async {
                if let message = self?.viewModel.message {
                    self?.showMessage( message )
                }
            }
        }
        
        viewModel.clearForm = { [weak self] () in
            DispatchQueue.main.async {
                self?.textViewName.text = ""
                self?.textCost.text = ""
                self?.textViewColor.text = ""
                self?.textMemory.text = ""
                self?.textBattery.text = ""
                self?.textPrimaryCamera.text = ""
                self?.textSecondaryCamera.text = ""
            }
        }
    }

    
    func showMessage( _ message: String ) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        self.viewModel.valueChangedForTag(tag: textField.tag, value: textField.text!)
    }
    
    //MARK:Actions
    @IBAction func addMobile(_ sender: Any) {
        self.viewModel.saveMobile()
    }
    
    
}
