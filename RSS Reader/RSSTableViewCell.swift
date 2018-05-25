//
//  RSSTableViewCell.swift
//  RSS Reader
//
//  Created by Tim Song on 2018/5/24.
//  Copyright © 2018 Tim Song. All rights reserved.
//

import UIKit

class RSSTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var publishDateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
