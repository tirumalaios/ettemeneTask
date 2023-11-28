//
//  SpeakersTableViewCell.swift
//  ettemeneTask
//
//  Created by Mac on 28/11/23.
//

import UIKit

class SpeakersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var speakerImg: UIImageView!
    
    @IBOutlet weak var companyLbl: UILabel!
    
    @IBOutlet weak var authorLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.clipsToBounds = true
        contentView.layer.masksToBounds = true
        speakerImg.layer.masksToBounds = true
        speakerImg?.layer.cornerRadius = (speakerImg?.frame.size.width ?? 0.0) / 2
        speakerImg?.layer.cornerRadius = (speakerImg?.frame.size.height ?? 0.0) / 2
      
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
