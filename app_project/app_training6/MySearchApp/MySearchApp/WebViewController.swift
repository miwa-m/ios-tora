//
//  WebViewController.swift
//  MySearchApp
//
//  Created by systena on 2018/06/19.
//  Copyright © 2018年 systena. All rights reserved.
//

import UIKit
import WebKit //WKWebViewを利用するために必要

class WebViewController: UIViewController {
    // 商品ページのURL
    //var itemUrl: String?
    // 商品詳細クラス
    var itemData: ItemData?
    var favoriteList = [FavoriteItem]()
    var parentView: Any?
    
    //let userDefaults = UserDefaults.standard
    
    // 商品ページを参照するためのWebView
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // User-AgentをiPhoneに設定する
        webView.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1"
        // WebViewのURLを読み込ませてWebページを表示させる
        guard let itemUrl = itemData?.url else{
            return
        }
        guard let url = URL(string: itemUrl) else {
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func didMove(toParentViewController parent: UIViewController?) {
        super.willMove(toParentViewController: parent)
        if parent == nil{
            if self.parentView is FavoriteItemTableViewController{
                (self.parentView as? FavoriteItemTableViewController)?.reloadData()
            }
            if self.parentView is SearchItemCollectionViewController{
                (self.parentView as? SearchItemCollectionViewController)?.reloadData()
            }
            if self.parentView is SearchItemTableViewController{
                (self.parentView as? SearchItemTableViewController)?.reloadData()
            }
            if self.parentView is SearchCategoryItemTableViewController{
                (self.parentView as? SearchCategoryItemTableViewController)?.reloadData()
            }
            
        }
    }
    
    @IBAction func addFavorite(_ sender: Any) {
        // アラートダイアログ
        let alertController = UIAlertController(title: "お気に入りに追加しますか", message: "", preferredStyle: UIAlertControllerStyle.alert)
        // OKボタンを追加
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default){(action: UIAlertAction) in
            // OKボタンがタップされたとき
            self.favoriteList.removeAll()
            let userDefaults = UserDefaults.standard
            if let storedFavoriteList = userDefaults.object(forKey: "favoriteList") as? Data{
                if let unarchiveFavoriteList = NSKeyedUnarchiver.unarchiveObject(with: storedFavoriteList) as? [FavoriteItem]{
                    self.favoriteList.append(contentsOf: unarchiveFavoriteList)
                }
            }
            // ファボリストに追加、userdefault化する
            let favoriteItem = FavoriteItem()
            favoriteItem.name = self.itemData?.name
            favoriteItem.price = self.itemData?.priceInfo.price
            favoriteItem.itemUrl = self.itemData?.url
            if let imageUrl = self.itemData?.imageInfo.medium{
                favoriteItem.imageUrl = imageUrl
            }
            self.favoriteList.append(favoriteItem)
            let archiveData = NSKeyedArchiver.archivedData(withRootObject: self.favoriteList)
            userDefaults.set(archiveData, forKey: "favoriteList")
            userDefaults.synchronize()
        }
        
        // Cancelボタンが押されたときの処理
        let cancelButton = UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.cancel, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelButton)
        present(alertController, animated: true, completion: nil)
    
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


