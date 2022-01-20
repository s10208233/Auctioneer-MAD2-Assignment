//
//  HomeFeedCustomCell.swift
//  Auctioneer
//
//  Created by Lester Cheong on 20/1/22.
//

import UIKit

class HomeFeedCustomCell: UITableViewCell {
    
    @IBOutlet weak var HomeFeedCellContentView: UIView!
    @IBOutlet weak var Cell_ImageView: CustomImageView!
    @IBOutlet weak var Cell_ItemNameLabel: UILabel!
    @IBOutlet weak var Cell_StartingPriceLabel: UILabel!
    @IBOutlet weak var Cell_NowAtPrice_Label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
