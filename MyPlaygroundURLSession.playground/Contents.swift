//: Playground - noun: a place where people can play

import UIKit
// 非同期処理の実行を実現(playground)
import PlaygroundSupport

// 非同期処理の実行を許可
PlaygroundPage.current.needsIndefiniteExecution = true

// セッションの取り出し
let session = URLSession.shared

// URLオブジェクトを生成
if let url = URL(string: "http://www.yahoo.co.jp"){
    // リクエストオブジェクトを生成
    let request = URLRequest(url: url)
    // 処理タスクを生成
    let task = session.dataTask(with: request, completionHandler: {
        (data: Data?, response: URLResponse?, error:Error?) in
            // データ取得後に呼ばれる処理はここに記載する
            guard let data = data else{
                print("データなし")
                return
            }
        // Data型の変数をString型に変換してprintで出力
        let value = String(data: data, encoding: String.Encoding.utf8)
        print(value)
    })
    // 通信開始
    task.resume()
}
