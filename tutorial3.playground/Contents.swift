//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

func function1(handler: ()->Void){
    handler()
    print("this is function1!!")
}

// クロージャを引数として渡す
let closure = {
    print("this is closure!!!")
}

function1(handler: closure)
// this is closure
// this is function1

func function2(){
    print("this is function2!!")
}

function2()
// this is function2

// メソッドとクロージャの引数として渡せる
function1(handler: function2)
// this is function2
// this is function1

// クロージャを直接引数として渡す
function1(handler: {
    print("inside")
})

// クロージャを直接引数とする場合は括弧()の外でOK
// ただしクロージャの引数が１番最後の時のみ
function1(){
    print("outside")
}

// つまり
// この最後がクロージャの引数の場合はOKで
// 末尾クロージャ/Trailing Closures の書き方がこれ
func function3(arg1: String, handler: ()->Void){
    handler()
    print("this is \(arg1)!!!")
}
function3(arg1: "arg1 string"){print("arg1 handler")}
