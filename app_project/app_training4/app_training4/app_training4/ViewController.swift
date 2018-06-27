//
//  ViewController.swift
//  app_training4
//
//  Created by systena on 2018/05/19.
//  Copyright © 2018年 systena. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //ToDoを格納した配列
    var todoList = [MyTodo]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let userDefaults = UserDefaults.standard
        if let storedToDoList = userDefaults.object(forKey: "todoList") as? Data{
            if let unarchiveTodoList = NSKeyedUnarchiver.unarchiveObject(with: storedToDoList) as? [MyTodo]{
                todoList.append(contentsOf: unarchiveTodoList)
            }
        }

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tapSourceButton(_ sender: Any) {
        for idx in 0..<todoList.count-1{
            for comp_idx in idx+1..<todoList.count{
                if todoList[idx].todoLimit == nil || (todoList[comp_idx].todoLimit != nil && todoList[idx].todoLimit! > todoList[comp_idx].todoLimit!){
                    let  tmp_todo = todoList[idx]
                    todoList[idx] = todoList[comp_idx]
                    todoList[comp_idx] = tmp_todo
                }
            }
        }
        tableView.reloadData()
    }
    
    @IBAction func tapEditButton(_ sender: Any) {
        if tableView.isEditing{
            tableView.isEditing = false
        }
        else{
            tableView.isEditing = true
        }
    }
    
    @IBAction func tapAddButton(_ sender: Any) {
        // アラートダイアログを生成
        let alertController = UIAlertController(title: "TODO追加",
                                                message: "TODOを入力してください",
                                                preferredStyle: UIAlertControllerStyle.alert)
        // テキストエリアを追加
        alertController.addTextField(configurationHandler: nil)
        // OKボタンを追加
        let okAction = UIAlertAction(title: "OK",
                                     style: UIAlertActionStyle.default){(action: UIAlertAction) in
                                     // OKボタンがタップされた時の処理
                                     if let textField = alertController.textFields?.first{
                                        // TODOの配列の入力値を挿入。先頭に挿入する
                                        let myTodo = MyTodo()
                                        myTodo.todoTitle = textField.text!
                                        self.todoList.insert(myTodo, at: 0)
                                        // テーブルに行が追加されたことをテーブルに通知
                                        self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)],
                                                                  with: UITableViewRowAnimation.right)
                                        // ToDoの保存処理
                                        let userDefaults = UserDefaults.standard
                                        // Data型にシリアライズする
                                        let data = NSKeyedArchiver.archivedData(withRootObject: self.todoList)
                                        userDefaults.set(data, forKey: "todoList")
                                        userDefaults.synchronize()
                                        }
        }
        // OKボタンがタップされた時の処理
        alertController.addAction(okAction)
        // canncelボタンがタップされた時の処理
        let cancelButton = UIAlertAction(title: "CANCEL",
                                         style: UIAlertActionStyle.cancel, handler: nil)
        // canncelボタンを追加
        alertController.addAction(cancelButton)
        // アラートダイアログを表示
        present(alertController, animated: true, completion: nil)
    }
    
    // テーブルの行数を返却する
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // ToDoの配列の長さを返却する
        return todoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        // Storyboardで指定したtodoCell識別子を利用して再利用可能なセルを取得する
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)
        // 行番号にあったToDoの情報を取得
        let myTodo = todoList[indexPath.row]
        cell.textLabel?.text = myTodo.todoTitle
        // セルのチェックマーク状態をセット
        if myTodo.todoDone{
            // チェックあり
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
            // cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        }
        else{
            // チェックなし
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
        if let todoLimit = myTodo.todoLimit{
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "yyyy/MM/dd"
            var now = Date()
            let stringnow: String = dateformatter.string(from: now)
            now = dateformatter.date(from: stringnow)!
            if todoLimit < now{
                cell.textLabel?.textColor! = UIColor.red
            }
            else if todoLimit == now{
                cell.textLabel?.textColor! = UIColor.blue
            }
            else{
                cell.textLabel?.textColor! = UIColor.black
            }
        }
        else{
            cell.textLabel?.textColor! = UIColor.black
        }
        return cell
    }
    
    // セルをタップした時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let myTodo = todoList[indexPath.row]
        performSegue(withIdentifier: "CellEditDetail", sender: indexPath.row)
        // print(indexPath.row)
        // self.performSegue(withIdentifier: <#T##String#>, sender: <#T##Any?#>)
        // if myTodo.todoDone{
            // 完了済みの場合は未完了に変更
            //myTodo.todoDone = false
        // }
        // else{
            // 未完の場合は完了済みに変更
            // myTodo.todoDone = true
        // }
        
        // セルの状態を変更
        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        // データを保存。Data型にシリアライズする
        let data: Data = NSKeyedArchiver.archivedData(withRootObject: todoList)
        // UserDefaultsに保存
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey: "todoList")
        userDefaults.synchronize()
    }
    
    // セルが編集可能であるかどうかを返却する
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    // セルを移動可能
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    // セルを移動する時の処理
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let s_row = sourceIndexPath.row
        let d_row = destinationIndexPath.row
        //print(s_row)
        //print(todoList[s_row].todoTitle)
        let tmp_todo = todoList[s_row]
        //todoList[s_row] = todoList[d_row]
        //todoList[d_row] = tmp_todo
        todoList.remove(at: s_row)
        todoList.insert(tmp_todo, at: d_row)
    }
    // セルを削除した時の処理
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // 削除処理かどうか
        if editingStyle == UITableViewCellEditingStyle.delete{
            // ToDoリストから削除
            todoList.remove(at: indexPath.row)
            // セルを削除
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            // データを保存。Dataにシリアライズする
            let data: Data = NSKeyedArchiver.archivedData(withRootObject: todoList)
            // UserDefaultsに保存
            let userDefaults = UserDefaults.standard
            userDefaults.set(data, forKey: "todoList")
            userDefaults.synchronize()
        }
    }
    // 遷移時編集画面設定
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let celleditviewConttoller = segue.destination as! CelleditViewController
        // 遷移先オブジェクトのtodoListが書き換わっていない？
        let row = sender as! Int
        // 一件だけでいいようにする
        if let todo: [MyTodo] = todoList{
            celleditviewConttoller.todoList = todo
        }
        celleditviewConttoller.row = row
    }    
}

// 独自クラスをシリアライズする際には、NSObjectを継承し、
// NSCodingプロトコルに準拠する必要がある
class MyTodo: NSObject, NSCoding{
    // ToDoのタイトル
    var todoTitle: String?
    //ToDoを完了したかどうかを表すフラグ
    var todoDone: Bool = false
    // 締切日
    var todoLimit: Date? = nil
    // コンストラクタ
    override init(){
        
    }
    // NSCodingプロトコルに宣言されているでシリアライズ処理。デコード処理とも呼ばれる
    required init?(coder aDecoder: NSCoder){
        todoTitle = aDecoder.decodeObject(forKey: "todoTitle") as? String
        todoDone = aDecoder.decodeBool(forKey: "todoDone")
        todoLimit = aDecoder.decodeObject(forKey: "todoLimit") as? Date
    }
    
    // NSCodingプロトコルに宣言されているシリアライズ処理。エンコード処理とも呼ばれる
    func encode(with aCoder: NSCoder) {
        aCoder.encode(todoTitle, forKey: "todoTitle")
        aCoder.encode(todoDone, forKey: "todoDone")
        aCoder.encode(todoLimit, forKey: "todoLimit")
    }
    
}
