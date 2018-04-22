//: Playground - noun: a place where people can play


func add_result_info(_ info_list: [(name: String, point: Int)]) -> [[String:String]]{
    // タプルのリストをName,Point,Resultのキーを持つ辞書のリストにして返す
    // ResultはPointが80以上ならば合格、小さいなら不合格
    var result_list: [[String:String]] = []
    for tup in info_list{
        let isPass = 80 <= tup.1 ? "合格" : "不合格"
        result_list.append(["Name": tup.0, "Point": String(tup.1), "Result": isPass])
    }
    return result_list
}
// 氏名と点数の情報を受け取る
var received_list = [("Alex", 81), ("Ben", 78), ("Clark", 80), ("Donald", 93), ("Edwin", 79)]

let result_list = add_result_info(received_list)
//print("Name   Point  Result")
//print("------ -----  -------")
// 出力
for row in result_list{
    print(row["Name"]! + "   " + row["Point"]! + " " + row["Result"]!)
    //print(String(format: "%5@", row["Name"]))
    // ↑列ごとに位置を揃えるためにフォーマットしたいがエラー(argument labels '(_:)' do not match any vailable)
    // intの変換 String(format: "%05", 1) も同様のエラー
}

