//
//  TableViewCell.swift
//  EmotionalPlayer
//
//  Created by Isaac Annan on 28/05/2019.
//  Copyright © 2019 Isaac Annan. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var sngNameLabel: UILabel!
    @IBOutlet weak var albNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
