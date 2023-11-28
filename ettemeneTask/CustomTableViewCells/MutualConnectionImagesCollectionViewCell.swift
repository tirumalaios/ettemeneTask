//
//  MutualConnectionImagesCollectionViewCell.swift
//  RideLoud
//
//  Created by Manoj Reddy on 24/11/23.
//

import UIKit

class MutualConnectionImagesCollectionViewCell: UICollectionViewCell {
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var countLabel:UILabel!

	override func awakeFromNib() {
		super.awakeFromNib()
		setUP()
	}
	func setUP(){
		//imageView.layer.borderWidth = 4
		imageView.layer.masksToBounds = false
		//imageView.layer.borderColor = UIColor.white.cgColor
		imageView.layer.cornerRadius = imageView.frame.height/2
		//imageView.layer.cornerRadius = imageView.frame.width/2
		imageView.contentMode = .scaleToFill
		imageView.clipsToBounds = true
	}

}
