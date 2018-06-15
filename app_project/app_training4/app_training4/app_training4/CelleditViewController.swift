//
//  CelleditViewController.swift
//  app_training4
//
//  Created by systena on 2018/06/05.
//  Copyright © 2018年 systena. All rights reserved.
//

import UIKit

class CelleditViewController: UIViewController, UITextFieldDelegate {
    // var content: String = ""
    var toolBar:UIToolbar!
    var todoList = [MyTodo]()
    var row: Int?
    var pickerDate: Date?
    let dateformatter = DateFormatter()

    @IBOutlet weak var contentbox: UITextField!
    @IBOutlet weak var limitbox: UITextField!
    @IBOutlet weak var todostatus: UISegmentedControl!
    // @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 選択したセルの内容代入
        dateformatter.dateFormat = "yyyy/MM/dd"
        //contentbox.text = content

        contentbox.text = todoList[row!].todoTitle
        if let limitdate: Date = todoList[row!].todoLimit{
            limitbox.text = dateformatter.string(from: limitdate)
        }
        else{
            limitbox.text = "None"
        }
        if todoList[row!].todoDone{
            todostatus.selectedSegmentIndex = 1
        }
        else{
            todostatus.selectedSegmentIndex = 0
        }
        // datepicker上のtoolbardのdoneボタン
        toolBar = UIToolbar()
        toolBar.sizeToFit()
        let toolBarBtn = UIBarButtonItem(title: "DONE", style: .plain, target: self, action: #selector(doneBtn))
        toolBar.items = [toolBarBtn]
        limitbox.inputAccessoryView = toolBar
        // limitbox.inputView = datePicker
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // limitbox(テキストフィールド)が選択されたらdatepickerを表示
    @IBAction func textFieldEditing(_ sender: Any) {
        let datePickerView: UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        datePickerView.locale = Locale(identifier: "ja_JP")
        if let limitfield: UITextField = sender as? UITextField{
            limitfield.inputView = datePickerView
        }
        pickerDate = datePickerView.date
        datePickerView.addTarget(self, action: #selector(datepickerEditEnd), for: UIControlEvents.valueChanged)
    }
    @objc func datepickerEditEnd(sender: UIDatePicker){
        pickerDate = sender.date
        //let dateformatter = DateFormatter()
        //dateformatter.dateFormat = "yyyy/MM/dd"
        //limitbox.text = dateformatter.string(from: sender.date)
    }
    // DONEが押された時
    @objc func doneBtn(){
        if let pcDate = pickerDate{
            limitbox.text = dateformatter.string(from: pcDate)
        }
        // キーボードを隠す
        limitbox.resignFirstResponder()
    }
    @IBAction func doneEdit(_ sender: Any) {
        todoList[row!].todoTitle = contentbox.text
        todoList[row!].todoDone = (todostatus.selectedSegmentIndex != 0)
        if limitbox.text != "None"{
            todoList[row!].todoLimit = dateformatter.date(from: limitbox.text!)
        }
        // todolistをData型にシリアライズ
        let data: Data = NSKeyedArchiver.archivedData(withRootObject: todoList)
        // UserDefaultに保存
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey: "todoList")
        userDefaults.synchronize()
        let count = (self.navigationController?.viewControllers.count)! - 2
        if let prevView = self.navigationController?.viewControllers[count] as? ViewController{
            prevView.todoList = todoList
            prevView.tableView.reloadData()
        }
        //print(String(describing: type(of: self.presentingViewController)))
        
        cancelEdit(true)
    }
    @IBAction func cancelEdit(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // キーボード入力をさせない
        return false
    }
    // 遷移時処理

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
