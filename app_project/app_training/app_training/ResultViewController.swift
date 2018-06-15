//
//  ResultViewController.swift
//  app_training
//
//  Created by systena on 2018/05/16.
//  Copyright © 2018年 systena. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    
    @IBOutlet weak var resultField: UITextField!
    var price: Int = 0
    var percent: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let percentValue = Float(percent) / 100
        let waribikiPrice = Float(price) * percentValue
        let percentOffPrice = price - Int(waribikiPrice)
        resultField.text = "\(percentOffPrice)"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        let userDefaults = UserDefaults.standard
        let data: Int
        data = price
        userDefaults.set(data, forKey: "Data")
        userDefaults.synchronize()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
