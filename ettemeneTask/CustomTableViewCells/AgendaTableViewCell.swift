//
//  AgendaTableViewCell.swift
//  ettemeneTask
//
//  Created by Mac on 27/11/23.
//

import UIKit
import SDWebImage

class AgendaTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var headerTitleLbl: UILabel!
    
    @IBOutlet weak var timeTitleLbl: UILabel!
    var numberOfCellsCount:Int = 7
    @IBOutlet weak var imageCollectionView: UICollectionView!
    var imageUrls = [Attendee]()
    var sectionImgUrls = [AgendaSpeaker]()
    override func awakeFromNib() {
        super.awakeFromNib()
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        imageCollectionView.collectionViewLayout = layout
        imageCollectionView.register(UINib(nibName: "MutualConnectionImagesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MutualConnectionImagesCollectionViewCell")
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MutualConnectionImagesCollectionViewCell", for: indexPath) as! MutualConnectionImagesCollectionViewCell
        if imageUrls.count > 0 {
            if indexPath.item < min(imageUrls.count, numberOfCellsCount) {
                    cell.imageView.isHidden = false
                    cell.countLabel.isHidden = true
                    if let imageUrl = imageUrls[indexPath.item].image, let url = URL(string: imageUrl) {
                        cell.imageView.sd_setImage(with: url, completed: nil)
                    } else {
                        cell.imageView.image = nil
                    }
                } else {
                    cell.imageView.isHidden = true
                    cell.countLabel.isHidden = false
                    
                    let additionalImageCount = imageUrls.count - numberOfCellsCount
                    cell.countLabel.text = "+\(additionalImageCount)"
                }
            }else {
                debugPrint("Images are not found")
            }
              return cell
          }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if imageUrls.count > numberOfCellsCount {
            return    min(imageUrls.count, numberOfCellsCount) + (imageUrls.count > numberOfCellsCount ? 1 : 0)
                }else{
                    return imageUrls.count
                }
        }
    
}
