//
//  SearchCell.swift
//  BookPlace
//
//  Created by Nazar on 10.02.18.
//  Copyright © 2018 Nazar. All rights reserved.
//

import UIKit
import Kingfisher

class SearchCell: UITableViewCell {
    
    @IBOutlet weak var imageBook: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(volumInfo info: VolumInfo) {
        self.titleLabel.text = info.title
        self.authorLabel.text = info.authors?.first ?? "Without author"
        if let urlView = info.imageLinks?.smallThumbnail {
            self.imageBook.kf.setImage(with: URL(string: urlView))
        } else {
            imageBook.image = UIImage.init(named: "bookPlaceHolder")
        }
    }
    
    func setup(cart info: Cart) {
        self.titleLabel.text = info.title
        self.authorLabel.text = info.author ?? "Without author"
        if let image = UIImage.init(data: info.image!)  {
            self.imageBook.image = image
        } else {
            self.imageBook.image = UIImage.init(named: "bookPlaceHolder")
        }
    }
}
