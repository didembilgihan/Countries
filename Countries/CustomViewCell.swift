//
//  CustomViewCell.swift
//  Countries
//
//  Created by Didem Bilgihan on 4.09.2022.
//

import UIKit

class CustomViewCell: UITableViewCell {
    
    
    @IBOutlet weak var homeCountryName: UILabel!
    @IBOutlet weak var homeCountryButton: UIButton!
    
    @IBOutlet weak var savedCountryButton: UIButton!
    @IBOutlet weak var savedCountryName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
