

import UIKit

class PlayerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblPlayerName: UILabel!
    @IBOutlet weak var ivPlayerImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        ivPlayerImage.layer.cornerRadius = 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class collectionViewCell: UICollectionViewCell {
    @IBOutlet weak var lblPlayerName: UILabel!
    @IBOutlet weak var ivPlayerImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ivPlayerImage.layer.cornerRadius = 2
    }
    
    func setupWithPhoto(flickrPhoto: FlickrPhoto) {
        lblPlayerName.text = flickrPhoto.title
        ivPlayerImage.DownloadImageForCollectionView(from: flickrPhoto.photoUrl) { (err) in
            
            if err != nil {
                
            }
        }
    }
}
