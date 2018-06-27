//
//  ItemViewController.swift
//  MySearchApp
//
//  Created by systena on 2018/06/25.
//  Copyright © 2018年 systena. All rights reserved.
//

import UIKit

class ItemViewController: UIPageViewController, UIPageViewControllerDataSource {
    let idList = ["Search", "History", "Favorite"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 最初のビューコントローラーを取得する
        let controller = storyboard!.instantiateViewController(withIdentifier: idList.first!)
        // ビューコントローラーを表示する
        self.setViewControllers([controller], direction: .forward, animated: true, completion: nil)
        // データ提供元に自分を設定する
        self.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = idList.index(of: viewController.restorationIdentifier!)
        if (index! > 0){
            // 前ページのビューコントローラーを返す
            return storyboard!.instantiateViewController(withIdentifier: idList[index!-1])
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = idList.index(of: viewController.restorationIdentifier!)
        if (index! < idList.count-1){
            // 前ページのビューコントローラーを返す
            return storyboard!.instantiateViewController(withIdentifier: idList[index!+1])
        }
        return nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
