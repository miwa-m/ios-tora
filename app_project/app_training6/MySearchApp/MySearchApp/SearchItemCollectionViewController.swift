//
//  SearchItemCollectionViewController.swift
//  MySearchApp
//
//  Created by systena on 2018/06/24.
//  Copyright © 2018年 systena. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class SearchItemCollectionViewController: UICollectionViewController{

    var itemDataArray = [ItemData]()
    var favoriteListOnHistory = [FavoriteItem]()
    var imageCache = NSCache<AnyObject, UIImage>()
    
    // 数字を金額の形式に整形するためのフォーマッタ
    let priceFormat = NumberFormatter()
    
    @IBOutlet var colitemView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 通貨スタイルであることを示す
        priceFormat.numberStyle = .currency
        // 通貨の種類は日本である
        priceFormat.currencyCode = "JPY"

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        reloadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func reloadData(){
        
        favoriteListOnHistory.removeAll()
        let userDefaults = UserDefaults.standard
        if let storedFavoriteList = userDefaults.object(forKey: "favoriteList") as? Data{
            if let unarchiveFavoriteList = NSKeyedUnarchiver.unarchiveObject(with: storedFavoriteList) as? [FavoriteItem]{
                favoriteListOnHistory.append(contentsOf: unarchiveFavoriteList)
            }
        }
        self.colitemView.reloadData()
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
                self.colitemView.reloadData()
            }
        }
        // 通信開始
        task.resume()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return itemDataArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colitemCell", for: indexPath) as? ItemCollectionViewCell else{
            print("aaaa")
            return UICollectionViewCell()
        }
        let itemData = itemDataArray[indexPath.row]
        
        // 商品のタイトル設定
        cell.itemTitleLabel.text = itemData.name
        // 商品価格設定処理(日本通過の形式で設定する)
        let number = NSNumber(integerLiteral: Int(itemData.priceInfo.price!)!)
        cell.itemPriceLabel.text = priceFormat.string(from: number)
        // 商品のURL設定
        //cell.itemUrl = itemData.url
        cell.itemData = itemData
        
        var favFlag: Bool = false
        for favItem in favoriteListOnHistory{
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
        guard let itemImageUrl = itemData.imageInfo.medium else {
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
        guard let url = URL(string: itemImageUrl) else{
            // URLが生成できなかった
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
                cell.itemImageView.image = image
            }
        }
        // 画像の読み込み処理開始
        task.resume()
        // Configure the cell
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? ItemCollectionViewCell{
            if let webViewController = segue.destination as? WebViewController{
                // 商品ページの情報を設定する
                reloadData()
                webViewController.itemData = cell.itemData
                webViewController.parentView = self
            }
        }
    }
    
    

}
