//
//  LocationTableViewCell.swift
//  ettemeneTask
//
//  Created by Mac on 28/11/23.
//

import UIKit

class LocationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var loactionImg: UIImageView!
    
    @IBOutlet weak var timeslotLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    @IBOutlet weak var surveyBtn: UIButton!
    @IBOutlet weak var eventImg: UIImageView!
    
    @IBOutlet weak var codeBtn: UIButton!
    
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var venueLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
