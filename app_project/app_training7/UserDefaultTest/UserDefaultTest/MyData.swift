//
//  MyData.swift
//  UserDefaultTest
//
//  Created by systena on 2018/06/24.
//  Copyright © 2018年 systena. All rights reserved.
//

import Foundation

class MyData: NSObject, NSCoding{
    
    var valueString: String?
    
    @objc(_TtCC15UserDefaultTest6MyData9ChildData)class ChildData: NSObject, NSCoding{
        var childString: String?
        override init(){
            
        }
        func encode(with aCoder: NSCoder){
            aCoder.encode(childString, forKey: "childString")
        }
        
        required init?(coder aDecoder: NSCoder){
            childString = aDecoder.decodeObject(forKey: "childString") as? String
        }
    }
    
    var childData: ChildData = ChildData()
    
    override init(){
        
    }
    func encode(with aCoder: NSCoder){
        aCoder.encode(valueString, forKey: "valueString")
        aCoder.encode(childData, forKey: "childData")
    }
    
    required init?(coder aDecoder: NSCoder){
        valueString = aDecoder.decodeObject(forKey: "valueString") as? String
        childData = (aDecoder.decodeObject(forKey: "childData") as? ChildData)!
    }
    
}
