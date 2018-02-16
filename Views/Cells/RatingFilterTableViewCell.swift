//
//  RatingFilterTableViewCell.swift
//  GiphyBrowser
//
//  Created by Admin on 15.02.18.
//  Copyright © 2018 Makser. All rights reserved.
//

import UIKit

class RatingFilterTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.accessoryType = selected ? .checkmark : .none
        layoutSubviews()
        // Configure the view for the selected state
    }

}
