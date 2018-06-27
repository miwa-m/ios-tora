//
//  ItemCollectionViewCell.swift
//  MySearchApp
//
//  Created by systena on 2018/06/24.
//  Copyright © 2018年 systena. All rights reserved.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var itemImageView: UIImageView!

    @IBOutlet weak var itemTitleLabel: UILabel!
    
    @IBOutlet weak var itemPriceLabel: UILabel!
    
    //var itemUrl: String?
    var itemData: ItemData?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    override func prepareForReuse() {
        // 元々入っている情報を再利用時にクリア
        
    }
}
