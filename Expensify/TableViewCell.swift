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
        imageCell.layer.cornerRadius = imageCell.frame.size.width/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCell(transaction: TransactionModel){
        if(transaction.income == true)
        {
            let image : UIImage = UIImage(named: "arrow_down")!
            
            imageCell.image = image
            labelCell.textColor = UIColor.systemGreen
            labelCell.text = "Income"
            labelPriceCell.text = transaction.amount
        }
        else
        {
            let image : UIImage = UIImage(named: "arrow_up")!
            imageCell.image = image
            labelCell.textColor = UIColor.red
            labelCell.text = transaction.category
            labelPriceCell.text = transaction.amount
        }
        
        
    }
    
}
