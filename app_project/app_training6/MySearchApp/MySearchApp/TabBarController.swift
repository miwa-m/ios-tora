//
//  TabBarController.swift
//  MySearchApp
//
//  Created by systena on 2018/06/23.
//  Copyright © 2018年 systena. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftSwipe = UISwipeGestureRecognizer()
        leftSwipe.direction = .left
        leftSwipe.numberOfTouchesRequired = 2
        leftSwipe.addTarget(self, action: #selector(self.didSwipe(sender:)))
        self.view.addGestureRecognizer(leftSwipe)
        let rightSwipe = UISwipeGestureRecognizer()
        rightSwipe.direction = .right
        rightSwipe.numberOfTouchesRequired = 2
        rightSwipe.addTarget(self, action: #selector(self.didSwipe(sender:)))
        self.view.addGestureRecognizer(rightSwipe)
        // Do any additional setup after loading the view.
    }
    
    @objc final func didSwipe(sender: UISwipeGestureRecognizer){
        if sender.direction == .left{
            if self.selectedIndex > 1{
                return
            }
            let destIndex = self.selectedIndex + 1
            transitioningReload(destIndex: destIndex)
            self.selectedIndex = destIndex
        }
        if sender.direction == .right{
            if sender.direction == .right{
                if self.selectedIndex < 1{
                    return
                }
                let destIndex = self.selectedIndex - 1
                transitioningReload(destIndex: destIndex)
                self.selectedIndex = destIndex
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        transitioningReload(destIndex: item.tag)
        /*
        switch item.tag {
        case 0:
            // 検索画面
            print("検索画面に遷移")
            let navigationController = self.viewControllers![0] as? UINavigationController
            let searchItemTableViewController = navigationController?.viewControllers[0] as? SearchItemTableViewController
            searchItemTableViewController?.reloadData()
        case 1:
            // 検索履歴
            // 検索画面のインスタンスも渡してしまうかメソッドを外にだす
            let navigationController = self.viewControllers![1] as? UINavigationController
            let historyTableViewController = navigationController?.viewControllers[0] as? SearchHistoryTableViewController
            historyTableViewController?.reloadhistoryData()
            print(navigationController?.viewControllers.count)
            let searchItemCollectionViewController = navigationController?.viewControllers[1] as? SearchItemCollectionViewController
            searchItemCollectionViewController?.reloadData()
        case 2:
            print("お気に入りに遷移")
            let navigatiomController = self.viewControllers![2] as? UINavigationController
            let favoriteTableViewController = navigatiomController?.viewControllers[0] as? FavoriteItemTableViewController
            favoriteTableViewController?.reloadData()
            
        default:
            print("何もなし")
        }
        */
    }

    func transitioningReload(destIndex: Int){
        let navigationController = self.viewControllers![destIndex] as? UINavigationController
        let topViewController = navigationController?.topViewController

        switch destIndex{
        case 0:
            // キーワード検索へ遷移
            (navigationController?.viewControllers[0] as? SearchItemTableViewController)?.reloadData()
        case 1:
            // 検索履歴へ遷移
            (navigationController?.viewControllers[0] as? SearchHistoryTableViewController)?.reloadhistoryData()
            if topViewController is SearchItemCollectionViewController{
                (topViewController as? SearchItemCollectionViewController)?.reloadData()
            }
        case 2:
            // お気に入り
            (navigationController?.viewControllers[0] as? FavoriteItemTableViewController)?.reloadData()
        default: break
        }
        /*
        if let topViewController = topViewController as? FavoriteItemTableViewController{
            topViewController.reloadData()
        }
        
        if topViewController is FavoriteItemTableViewController{
            (topViewController as? FavoriteItemTableViewController)?.reloadData()
        }
        if topViewController is SearchItemCollectionViewController{
            (topViewController as? SearchItemCollectionViewController)?.reloadData()
        }
        if topViewController is SearchItemTableViewController{
            print(type(of: topViewController))
            (topViewController as? SearchItemTableViewController)?.reloadData()
        }
        if topViewController is SearchHistoryTableViewController{
            (topViewController as? SearchHistoryTableViewController)?.reloadhistoryData()
        }*/
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
