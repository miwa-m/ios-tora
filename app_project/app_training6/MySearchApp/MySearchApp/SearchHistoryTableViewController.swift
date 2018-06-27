//
//  SearchHistoryTableViewController.swift
//  MySearchApp
//
//  Created by systena on 2018/06/20.
//  Copyright © 2018年 systena. All rights reserved.
//

import UIKit

class SearchHistoryTableViewController: UITableViewController {

    // 履歴を格納した配列
    var historyList = [SearchHistory]()
    @IBOutlet var historyView: UITableView!
    
    // APIを利用するためのクライアントID
    let appid: String = "dj00aiZpPUI5aG9SOVBsNDYwZyZzPWNvbnN1bWVyc2VjcmV0Jng9YWQ-"
    let entryURL: String = "https://shopping.yahooapis.jp/ShoppingWebService/V1/json/itemSearch"
    // テーブルビュー
    
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        historyView.reloadData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    func reloadhistoryData(){
        // 保存しているhistoryの読み込み処理
        historyList.removeAll()
        let userDefaults = UserDefaults.standard
        if let storedhistoryList = userDefaults.object(forKey: "historyList") as? Data{
            if let unarchiveHistoryList = NSKeyedUnarchiver.unarchiveObject(with: storedhistoryList) as? [SearchHistory]{
                historyList.append(contentsOf: unarchiveHistoryList)
            }
        }
        if let historyView = historyView{
            historyView.reloadData()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let itemCollectionViewController = segue.destination as! SearchItemCollectionViewController
        let cell = sender as! HistoryTableViewCell
        // collectionView内のリクエストメソッドを実行
        // 保持している所持品を一旦削除
        itemCollectionViewController.itemDataArray.removeAll()
        // パラメータ指定
        let parameter = ["appid": appid, "query": cell.itemKeyword.text]
        // パラメータをエンコードしたURLを作成
        let requestURL = createRequestUrl(entryURL: entryURL, parameter: parameter as! [String : String])
        // APIをリクエストする
        itemCollectionViewController.request(requestUrl: requestURL)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return historyList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as? HistoryTableViewCell else{
            print("a") // debug
            return UITableViewCell()
        }
        let history = historyList[indexPath.row]
        cell.itemKeyword.text = history.keyword
        cell.itemSearchdate.text = dateFormatter.string(from: history.search_date!)

        // Configure the cell...

        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
 

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // 削除処理かどうか
        if editingStyle == UITableViewCellEditingStyle.delete{
            // リストから削除
            historyList.remove(at: indexPath.row)
            // セルを削除
            historyView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            // userdefaults更新
            let archiveData = NSKeyedArchiver.archivedData(withRootObject: historyList)
            let userDefaults = UserDefaults.standard
            userDefaults.set(archiveData, forKey: "historyList")
            userDefaults.synchronize()
        }
    }
 

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


