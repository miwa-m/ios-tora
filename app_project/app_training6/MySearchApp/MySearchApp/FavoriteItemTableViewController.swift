//
//  FavoriteItemTableViewController.swift
//  MySearchApp
//
//  Created by systena on 2018/06/24.
//  Copyright © 2018年 systena. All rights reserved.
//

import UIKit

class FavoriteItemTableViewController: SearchItemTableViewController {

    @IBOutlet var favoriteView: UITableView!
    // お気に入り
    var favoriteList = [FavoriteItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 通貨スタイルであることを示す
        priceFormat.numberStyle = .currency
        // 通貨の種類は日本である
        priceFormat.currencyCode = "JPY"
        reloadData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func reloadData(){
        favoriteList.removeAll()
        let userDefaults = UserDefaults.standard
        if let storedFavoriteList = userDefaults.object(forKey: "favoriteList") as? Data{
            if let unarchiveFavoriteList = NSKeyedUnarchiver.unarchiveObject(with: storedFavoriteList) as? [FavoriteItem]{
                favoriteList.append(contentsOf: unarchiveFavoriteList)
            }
        }
        if let favoriteView = favoriteView{
            favoriteView.reloadData()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return favoriteList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "favitemCell", for: indexPath) as? ItemTableViewCell else{
            return UITableViewCell()
        }
        let favoriteData = favoriteList[indexPath.row]
        // 商品のタイトル設定
        cell.fitemTitleLabel.text = favoriteData.name!
        let number = NSNumber(integerLiteral: Int(favoriteData.price!)!)
        cell.fitemPriceLabel.text = priceFormat.string(from: number)
        // ここでWebView受け渡し用のItemDataを作る
        let itemData = ItemData()
        itemData.name = favoriteData.name!
        itemData.priceInfo.price = favoriteData.price!
        itemData.url = favoriteData.itemUrl!
        itemData.imageInfo.medium = favoriteData.imageUrl!
        cell.itemData = itemData
        guard let itemImageUrl = favoriteData.imageUrl else{
            return cell
        }
        if let cacheImage = imageCache.object(forKey: itemImageUrl as AnyObject){
            cell.fitemImageView.image = cacheImage
            return cell
        }
        guard let url = URL(string: itemImageUrl) else {
            return cell
        }
        let request = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: request){
            (data: Data?, response: URLResponse?, error: Error?) in
            guard error == nil else{
                // エラーあり
                return
            }
            guard let data = data else{
                // データが存在しない
                return
            }
            guard let image = UIImage(data: data) else{
                // imageが生成できなかった
                return
            }
            // ダウンロードした画像をキャッシュに登録
            self.imageCache.setObject(image, forKey: itemImageUrl as AnyObject)
            // 画像はメインスレッド上で設定する
            DispatchQueue.main.async {
                cell.fitemImageView.image = image
            }
        }
        task.resume()
        // Configure the cell...

        return cell
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // セルを編集可能
        return true
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // 削除処理かどうか
        if editingStyle == UITableViewCellEditingStyle.delete{
            // リストから削除
            favoriteList.remove(at: indexPath.row)
            // セルを削除
            favoriteView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            // userdefaults更新
            let archiveData = NSKeyedArchiver.archivedData(withRootObject: self.favoriteList)
            let userDefaults = UserDefaults.standard
            userDefaults.set(archiveData, forKey: "favoriteList")
            userDefaults.synchronize()
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? ItemTableViewCell{
            if let webViewController = segue.destination as? WebViewController{
                reloadData()
                webViewController.itemData = cell.itemData
                webViewController.parentView = self
            }
        }
    }

}
class FavoriteItem: NSObject, NSCoding{
    
    var name: String?
    var price: String?
    var itemUrl: String?
    var imageUrl: String?
    // コンストラクタ
    override init(){
    }
    // NSCodingプロトコルに宣言されているシリアライズ処理、エンコード
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "fname")
        aCoder.encode(price, forKey: "fprice")
        aCoder.encode(itemUrl, forKey: "fitemUrl")
        aCoder.encode(imageUrl, forKey: "fimageUrl")
    }
    // NSCondingプロトコルに宣言されているデシリアライズ処理、デコード
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "fname") as? String
        price = aDecoder.decodeObject(forKey: "fprice") as? String
        itemUrl = aDecoder.decodeObject(forKey: "fitemUrl") as? String
        imageUrl = aDecoder.decodeObject(forKey: "fimageUrl") as? String
    }
}
