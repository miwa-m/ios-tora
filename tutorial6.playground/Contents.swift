//: Playground - noun: a place where people can play

import UIKit

var a = [String: [String]]()
a.updateValue([], forKey: "a")
print(a["a"]!)
a["a"]?.append("b")
print(a["a"]!)

