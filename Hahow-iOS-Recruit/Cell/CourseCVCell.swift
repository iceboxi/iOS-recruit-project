//
//  CourseVerticalCVCell.swift
//  Hahow-iOS-Recruit
//
//  Created by ice on 2021/11/5.
//

import UIKit
import SDWebImage

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
        imageView.sd_cancelCurrentImageLoad()
    }
    
    func config(with model: Course) {
        titleLabel.text = model.title
        deatilLabel.text = model.name
        imageView.sd_setImage(with: URL(string: model.coverImageUrl), completed: nil)
    }
}

extension CourseCVCell {
    enum Identifier: String {
        case vertical = "CourseVerticalCVCell"
        case horizontal = "CourseHorizontalCVCell"
    }
    
    static func getNib(_ style: Identifier) -> UINib {
        switch style {
        case .vertical:
            return UINib(nibName: "CourseVerticalCVCell", bundle: nil)
        case .horizontal:
            return UINib(nibName: "CourseHorizontalCVCell", bundle: nil)
        }
    }
}
