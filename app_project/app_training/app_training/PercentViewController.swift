//
//  PercentViewController.swift
//  app_training
//
//  Created by systena on 2018/05/16.
//  Copyright © 2018年 systena. All rights reserved.
//

import UIKit

class PercentViewController: UIViewController {
    var price: Int = 0
    @IBOutlet weak var percentField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 次の画面を取り出す
        let viewController = segue.destination as! ResultViewController
        // 次の画面に現在保持している金額を設定する
        viewController.price = price
        if let percent = Int(percentField.text!){
            // 次の画面に現在保持しているパーセンテージを設定する
            viewController.percent = percent
        }
    }
    
    @IBAction func tapClearButton(_ sender: Any) {
        percentField.text = "0"
    }
    @IBAction func tap0Button(_ sender: Any) {
        edit_text_field("0")
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
        let value = percentField.text! + val
        if let percent = Int(value){
            percentField.text = "\(percent)"
        }
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
