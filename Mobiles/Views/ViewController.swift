//
//  ViewController.swift
//  Mobiles
//
//  Created by RaviKiran B on 30/05/18.
//  Copyright © 2018 RaviKiran B. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var leadingSpaceForMenu: NSLayoutConstraint!
    
    
    
    @IBAction func callToggleMenu(_ sender: Any) {
        leadingSpaceForMenu.constant = leadingSpaceForMenu.constant<0 ?0:-270
        UIView.animate(withDuration: 0.3, animations: {()-> Void in
            self.view.layoutIfNeeded()
        })
    }
    
}


