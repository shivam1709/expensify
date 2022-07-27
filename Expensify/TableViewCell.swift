//
//  TableViewCell.swift
//  Summary
//
//  Created by user207259 on 7/27/22.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet var labelCell : UILabel!
    @IBOutlet var labelPriceCell : UILabel!
    @IBOutlet var imageCell : UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
