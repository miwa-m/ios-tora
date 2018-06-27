//
//  HistoryTableViewCell.swift
//  MySearchApp
//
//  Created by systena on 2018/06/23.
//  Copyright © 2018年 systena. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    @IBOutlet weak var itemKeyword: UILabel!
    @IBOutlet weak var itemSearchdate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
