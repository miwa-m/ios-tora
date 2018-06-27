//
//  ViewController.swift
//  UserDefaultTest
//
//  Created by systena on 2018/06/24.
//  Copyright © 2018年 systena. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let userDefaults = UserDefaults.standard
        let data = MyData()
        data.valueString = "test"
        data.childData.childString = "childtest"
        print("a")
        // シリアライズ
        let archiveData = NSKeyedArchiver.archivedData(withRootObject: data)
        userDefaults.set(archiveData, forKey: "data")
        userDefaults.synchronize()
        print("b")
        // でシリアライズ
        if let storedData = userDefaults.object(forKey: "data") as? Data{
            print("c")
            if let unarchivedData = NSKeyedUnarchiver.unarchiveObject(with: storedData) as? MyData{
                print("d")
                if let valueString = unarchivedData.valueString{
                    print("e")
                    print(valueString)
                }
                if let childString = unarchivedData.childData.childString{
                    print(childString)
                }
            }
        }

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

