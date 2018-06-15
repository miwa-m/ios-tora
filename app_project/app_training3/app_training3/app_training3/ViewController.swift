//
//  ViewController.swift
//  app_training3
//
//  Created by systena on 2018/05/19.
//  Copyright © 2018年 systena. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let userDefaults = UserDefaults.standard
        if let value = userDefaults.string(forKey: "text"){
            textField.text = value
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapActionButton(_ sender: Any) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(textField.text, forKey: "text")
        userDefaults.synchronize()
    }
    
}

