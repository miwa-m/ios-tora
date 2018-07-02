//
//  CategoryTableViewCell.swift
//  MySearchApp
//
//  Created by systena on 2018/07/02.
//  Copyright © 2018年 systena. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    
    @IBOutlet weak var categoryWord: UILabel!
    
    var category = CategoryData()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
