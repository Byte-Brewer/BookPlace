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
        self.authorLabel.text = info.authors?.first ?? "Announ author"
        if let urlView = info.imageLinks?.smallThumbnail {
            print("My URL: ", urlView)
            self.imageBook.kf.setImage(with: URL(string: urlView))
        }
    }
}
