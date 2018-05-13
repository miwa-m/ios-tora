//: Playground - noun: a place where people can play

// import UIKit

let values = ["a", "b", "c"]
for value in values{
    print(value)
}

func add_broadcast(_ tar_list: inout [Int], delta: Int = 1){
    // 数値リストの中身をdelta分増やす
    for (idx, ele) in tar_list.enumerated(){
        //tar_list[idx] += delta
        tar_list[idx] = ele + delta
    }
}
var num_list = [Int]()
// 0~9までの値でリストを初期化
for num in 0...9{
    num_list.append(num)
}
print(num_list)
// inout とすることで参照渡しになるので値を返す必要が無い
add_broadcast(&num_list, delta: 2)
print(num_list)

