//
//  SearchItemTableViewController.swift
//  MySearchApp
//
//  Created by systena on 2018/06/16.
//  Copyright © 2018年 systena. All rights reserved.
//

import UIKit

class SearchItemTableViewController: UITableViewController, UISearchBarDelegate {

    var itemDataArray = [ItemData]()
    var historyList = [SearchHistory]()
    var favoriteListOnSearch = [FavoriteItem]()
    var imageCache = NSCache<AnyObject, UIImage>()
    
    @IBOutlet var itemTableView: UITableView!
    
    // APIを利用するためのクライアントID
    let appid: String = "dj00aiZpPUI5aG9SOVBsNDYwZyZzPWNvbnN1bWVyc2VjcmV0Jng9YWQ-"
    let entryURL: String = "https://shopping.yahooapis.jp/ShoppingWebService/V1/json/itemSearch"
    // 数字を金額の形式に整形するためのフォーマッタ
    let priceFormat = NumberFormatter()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 通貨スタイルであることを示す
        priceFormat.numberStyle = .currency
        // 通貨の種類は日本である
        priceFormat.currencyCode = "JPY"
        let userDefaults = UserDefaults.standard
        if let storedhistoryList = userDefaults.object(forKey: "historyList") as? Data{
            if let unarchiveHistoryList = NSKeyedUnarchiver.unarchiveObject(with: storedhistoryList) as? [SearchHistory]{
                historyList.append(contentsOf: unarchiveHistoryList)
            }
        }
        reloadData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func reloadData(){
        favoriteListOnSearch.removeAll()
        let userDefaults = UserDefaults.standard
        if let storedFavoriteList = userDefaults.object(forKey: "favoriteList") as? Data{
            if let unarchiveFavoriteList = NSKeyedUnarchiver.unarchiveObject(with: storedFavoriteList) as? [FavoriteItem]{
                favoriteListOnSearch.append(contentsOf: unarchiveFavoriteList)
            }
        }
        self.itemTableView.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        // 入力された文字の取り出し
        guard let inputText = searchBar.text else{
            // 入力文字なし
            return
        }
        // 入力文字数が０文字より多いかどうかチェックする
        guard inputText.lengthOfBytes(using: String.Encoding.utf8) > 0 else{
            return
        }
        // 保持している商品を一旦削除
        itemDataArray.removeAll()
        // パラメータ指定
        let parameter = ["appid": appid, "query": inputText]
        // パラメータをエンコードしたURLを作成
        let requestURL = createRequestUrl(entryURL: entryURL, parameter: parameter)
        // APIをリクエストする
        request(requestUrl: requestURL)
        let history = SearchHistory()
        history.keyword = inputText
        history.search_date = Date()
        historyList.append(history)
        // 検索履歴をシリアライズ
        let archiveData = NSKeyedArchiver.archivedData(withRootObject: historyList)
        // userdefaultsに保存
        let userDefaults = UserDefaults.standard
        userDefaults.set(archiveData, forKey: "historyList")
        userDefaults.synchronize()
        // キーボードを閉じる
        searchBar.resignFirstResponder()
    }

    

    // リクエストを行う
    func request(requestUrl: String){
        // URL生成
        guard let url = URL(string: requestUrl) else{
            // URL生成失敗
            return
        }
        // リクエスト生成
        let request = URLRequest(url: url)
        // 商品検索APIをコールして商品検索を行う
        let session = URLSession.shared
        let task = session.dataTask(with: request){
            (data: Data?, response: URLResponse?, error: Error?) in
            // 通信完了後の処理
            // エラーチェック
            //let v = String(data: data!, encoding: String.Encoding.utf8)
            //print(v!)
            guard error == nil else{
                // エラー表示
                let alert = UIAlertController(title: "エラー", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                // UIに関する処理はメインスレッド上で行う
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
                return
            }
            // JSONで返却されたデータをパースして格納する
            guard let data = data else{
                // データなし
                return
            }
            do{
                // パース実施
                let resultSet = try JSONDecoder().decode(ItemSearchResultSet.self, from: data)
                // 商品リストに追加
                self.itemDataArray.append(contentsOf: resultSet.resultSet.firstObject.Result.items)
            }catch let error{
                print("## error: \(error)")
            }
            // テーブルの描画処理を実施
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        // 通信開始
        task.resume()
    }
    
    // MARK: - Table view data source
    // テーブルのセクション数を取得
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    // セクション内の商品数を取得
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemDataArray.count
    }
    
    // テーブルセルの取得処理
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 再利用可能なセルを取得
        
        let itemData = itemDataArray[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as? ItemTableViewCell else {
            return UITableViewCell()
        }
        // 商品のタイトル設定
        cell.itemTitleLabel.text = itemData.name
        // 商品価格設定処理(日本通貨の形式で設定する)
        let number = NSNumber(integerLiteral: Int(itemData.priceInfo.price!)!)
        cell.itemPriceLabel.text = priceFormat.string(for: number)
        // 商品のURL設定
        //cell.itemUrl = itemData.url
        // 商品詳細も格納(お気に入り等連携のため)
        cell.itemData = itemData
        
        var favFlag: Bool = false
        for favItem in favoriteListOnSearch{
            if itemData.url == favItem.itemUrl!{
                favFlag = true
            }
        }
        // お気に入りにあったら背景色を変える
        if favFlag {
            cell.backgroundColor = UIColor(red: 1, green: 0.86, blue: 0, alpha: 1)
        }
        else{
            cell.backgroundColor = UIColor.clear
        }
        
        // 画像の設定処理
        // すでにセルに設定されている画像と同じかどうかチェックする
        // 画像がまだ設定されていない場合に処理を行う
        guard let itemImageUrl = itemData.imageInfo.medium else{
            // 画像なし商品
            return cell
        }
        // キャッシュの画像を取り出す
        if let cacheImage = imageCache.object(forKey: itemImageUrl as AnyObject){
            // キャッシュ画像の設定
            cell.itemImageView.image = cacheImage
            return cell
        }
        // キャッシュの画像がないためダウンロードする
        guard let url = URL(string: itemImageUrl) else {
            // URLが生成できなかった
            return cell
        }
        let request = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) {
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
                cell.itemImageView.image = image
            }
        }
        // 画像の読み込み処理開始
        task.resume()

        return cell
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

    // MARK: - Navigation
    // 商品をタップして次の画面に遷移する前の処理
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let cell = sender as? ItemTableViewCell{
            if let webViewController = segue.destination as? WebViewController{
                reloadData()
                // 商品ページの情報を設定する
                webViewController.itemData = cell.itemData
                webViewController.parentView = self
            }
        }
    }
}

// パラメータのURLエンコード処理
func encodeParameter(key: String, value: String) -> String?{
    // 値をエンコードする
    guard let escapedValue = value.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else{
        // エンコード失敗
        return nil
    }
    // エンコードしたあ値をkey=valueの形式で返却する
    return "\(key)=\(escapedValue)"
}

// URL作成処理
func createRequestUrl(entryURL: String, parameter: [String: String]) -> String{
    var parameterString = ""
    for key in parameter.keys{
        // 値の取り出し
        guard let value = parameter[key] else{
            continue
        }
        // すでにパラメータが設定されていた場合
        if parameterString.lengthOfBytes(using: String.Encoding.utf8) > 0{
            // パラメータ同士のセパレータであｒう&を追加する
            parameterString += "&"
        }
        // 値をエンコードする
        guard let encodeValue = encodeParameter(key: key, value: value) else{
            // エンコード失敗。次のfor
            continue
        }
        // エンコードした値をパラメータとして追加する
        parameterString += encodeValue
    }
    let requestURL = entryURL + "?" + parameterString
    return requestURL
}

// 履歴クラス
class SearchHistory: NSObject, NSCoding{
    // キーワード
    var keyword: String?
    // 検索日時
    var search_date: Date?
    // 検索URL
    //var
    
    // コンストラクタ
    override init(){
    }
    // NSCodingプロトコルに宣言されているシリアライズ処理、エンコード
    func encode(with aCoder: NSCoder) {
        aCoder.encode(keyword, forKey: "keyword")
        aCoder.encode(search_date, forKey: "search_date")
    }
    // NSCondingプロトコルに宣言されているデシリアライズ処理、デコード
    required init?(coder aDecoder: NSCoder) {
        keyword = aDecoder.decodeObject(forKey: "keyword") as? String
        search_date = aDecoder.decodeObject(forKey: "search_date") as? Date
    }
}
