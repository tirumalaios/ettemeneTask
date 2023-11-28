//
//  DescriptionTableViewCell.swift
//  ettemeneTask
//
//  Created by Mac on 28/11/23.
//

import UIKit

class DescriptionTableViewCell: UITableViewCell {
    

    @IBOutlet weak var descriptionLbl: UILabel!
    
    
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var htmlTextView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    
}

extension String {
    var attributedHtmlString: NSAttributedString? {
        try? NSAttributedString(
            data: Data(utf8),
            options: [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ],
            documentAttributes: nil
        )
    }
}
