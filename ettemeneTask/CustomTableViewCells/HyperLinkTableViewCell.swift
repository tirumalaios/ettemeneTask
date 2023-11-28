//
//  HyperLinkTableViewCell.swift
//  ettemeneTask
//
//  Created by Mac on 28/11/23.
//

import UIKit

class HyperLinkTableViewCell: UITableViewCell {
    

    @IBOutlet weak var registerLbl: UILabel!
    
    @IBOutlet weak var hyperlinkBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
