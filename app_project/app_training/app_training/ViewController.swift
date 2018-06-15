//
//  ViewController.swift
//  app_training
//
//  Created by systena on 2018/05/13.
//  Copyright © 2018年 systena. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var priceField: UITextField!
    let userDefaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        userDefaults.register(defaults: ["Data": "1"])
        let p = userDefaults.integer(forKey: "Data")
        priceField.text = "\(p)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        //変異先の画面を取り出す方法
        let viewController = segue.destination as! PercentViewController
        // let price = Int(priceField.text!)
        // 変異先画面へ値段設定
        // viewController.price = price!
        if let price = Int(priceField.text!){
            viewController.price = price
        }
        
        
    }
    
    @IBAction func restart(_ segue: UIStoryboardSegue){
        priceField.text = "0"
    }
    
    @IBAction func tapClearButton(_ sender: Any) {
        priceField.text = "0"
    }
    @IBAction func tap0Button(_ sender: Any) {
        edit_text_field("0")
    }
    @IBAction func tap00Button(_ sender: Any) {
        edit_text_field("00")
    }
    @IBAction func tap1Button(_ sender: Any) {
        edit_text_field("1")
    }
    @IBAction func tap2Button(_ sender: Any) {
        edit_text_field("2")
    }
    @IBAction func tap3Button(_ sender: Any) {
        edit_text_field("3")
    }
    @IBAction func tap4Button(_ sender: Any) {
        edit_text_field("4")
    }
    @IBAction func tap5Button(_ sender: Any) {
        edit_text_field("5")
    }
    @IBAction func tap6Button(_ sender: Any) {
        edit_text_field("6")
    }
    @IBAction func tap7Button(_ sender: Any) {
        edit_text_field("7")
    }
    @IBAction func tap8Button(_ sender: Any) {
        edit_text_field("8")
    }
    @IBAction func tap9Button(_ sender: Any) {
        edit_text_field("9")
    }
    func edit_text_field(_ val: String){
        let value = priceField.text! + val
        if let price = Int(value){
            priceField.text = "\(price)"
        }
    }
    @IBAction func tapUsedButton(_ sender: Any) {
        // let price = userDefaults.object(forkey: "Data") as? Int
    }
}

