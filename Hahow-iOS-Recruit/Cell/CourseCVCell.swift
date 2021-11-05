//
//  CourseVerticalCVCell.swift
//  Hahow-iOS-Recruit
//
//  Created by ice on 2021/11/5.
//

import UIKit

class CourseCVCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var deatilLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}
