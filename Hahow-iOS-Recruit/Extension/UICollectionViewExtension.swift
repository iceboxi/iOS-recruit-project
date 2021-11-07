//
//  UICollectionViewExtension.swift
//  Hahow-iOS-Recruit
//
//  Created by ice on 2021/11/7.
//

import UIKit

extension UICollectionView {
    func registerSectionHeaderFromNib<T: UICollectionReusableView>(type: T.Type) {
        register(UINib(nibName: String(describing: type), bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: type))
    }
    
    func dequeueReusableSectionHeader<T: UICollectionReusableView>(with type: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: type), for: indexPath) as! T
    }
}
