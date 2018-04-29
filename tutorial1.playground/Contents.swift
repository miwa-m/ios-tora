//: Playground - noun: a place where people can play

// import UIKit
// 例外処理
var str = "Hello, playground"

enum MyError: Error{
    case InvalidValue
}

func doubleUp(value: Int) throws -> Int{
    if value < 0{
        throw MyError.InvalidValue
    }
    return value * 2
}
do{
    // 終わりに必ず実行する
    defer {
        print("処理終了")
    }
    let a = try doubleUp(value: -9)
    print(a)
    
}catch MyError.InvalidValue{
    print("エラー発生")
}

// 構造体
struct MyStruct{
    var value: Int
    // イニシャライザ
    init(){
        value = 0
    }
    // 構造体内でのメソッドの宣言
    mutating func plus_one() -> Int{
        value += 1
        return value
    }
}
// 比較用クラス
class MyClass{
    var value: Int
    init() {
        value = 0
    }
}

// 比較用メソッド
func compare_s_c(test_struct: MyStruct, test_class: MyClass){
    var test_struct = test_struct
    var test_class = test_class
    test_struct.value = 5
    test_class.value = 5
}
var struct_var: MyStruct = MyStruct()
var class_var: MyClass = MyClass()
print("Before Struct: " + String(struct_var.value))
print("Before Class: " + String(class_var.value))
compare_s_c(test_struct: struct_var, test_class: class_var)
// 構造体は値渡し:関数に渡した先で元の値は変わらない　クラスは変更が反映される
print("After Struct: " + String(struct_var.value))
print("After Struct: " + String(class_var.value))
// struct_var.value = 5
// print(struct_var.plus_one())
