//
//  CustomYLCell.swift
//  Auctioneer
//
//  Created by Lester Cheong on 27/1/22.
//

import UIKit

class CustomYLCell:UITableViewCell {
    
    @IBOutlet weak var Cell_ImageView: CustomImageView!
    @IBOutlet weak var Cell_ProductNameLabel: UILabel!
    @IBOutlet weak var Cell_Status: UILabel!
    @IBOutlet weak var Cell_HighestBid_Label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
