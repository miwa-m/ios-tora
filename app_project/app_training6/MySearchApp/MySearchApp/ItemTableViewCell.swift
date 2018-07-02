//
//  ItemTableViewCell.swift
//  MySearchApp
//
//  Created by systena on 2018/06/16.
//  Copyright © 2018年 systena. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    @IBOutlet weak var itemImageView: UIImageView! // 商品画像
    @IBOutlet weak var itemTitleLabel: UILabel! // 商品タイトル
    @IBOutlet weak var itemPriceLabel: UILabel! // 商品価格
    
    @IBOutlet weak var fitemTitleLabel: UILabel!
    @IBOutlet weak var fitemImageView: UIImageView!
    @IBOutlet weak var fitemPriceLabel: UILabel!
    
    @IBOutlet weak var citemTitleLabel: UILabel!
    @IBOutlet weak var citemImageView: UIImageView!
    @IBOutlet weak var citemPriceLabel: UILabel!
    
    
    //var itemUrl: String? // 商品ページのURL。遷移先の画面で利用する
    var itemData: ItemData?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        // 元々入っている情報を再利用時にクリア
        if let itemImageView = itemImageView{
            itemImageView.image = nil
        }
        if let fitemImageView = fitemImageView{
            fitemImageView.image = nil
        }
        if let citemImageView = citemImageView{
            citemImageView.image = nil
        }
    }
}
