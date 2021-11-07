//
//  ViewController.swift
//  Hahow-iOS-Recruit
//
//  Created by Tommy Lin on 2021/10/5.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {
    @IBOutlet weak private var collectionView: UICollectionView!
    private var items: [Classmute] = []
    
    private let itemsPerRow: CGFloat = 2
    private let spacing: CGFloat = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = generateLayout()
        
        collectionView.register(UINib(nibName: "CourseHeaderCRView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CourseHeaderCRView")
        collectionView.register(UINib(nibName: "CourseVerticalCVCell", bundle: nil), forCellWithReuseIdentifier: "CourseVerticalCVCell")
        collectionView.register(UINib(nibName: "CourseHorizontalCVCell", bundle: nil), forCellWithReuseIdentifier: "CourseHorizontalCVCell")
        
        let mock = HahowSessionMock()
        let manager = NetworkManager(session: mock)
        manager.loadData(from: URL(string: "mock")!) { [weak self] result in
            guard let result = result else {
                return
            }
            
            self?.items = result.data
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .portrait
        } else {
            return super.supportedInterfaceOrientations
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard previousTraitCollection != nil else {
            return
        }
        
        collectionView.reloadData()
    }
    
    private var showPadStyle: Bool {
        return traitCollection.horizontalSizeClass == .regular && traitCollection.verticalSizeClass == .regular
    }
}

// MARK: - UICollectionViewDelegate
extension ViewController: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var max = 3
        if showPadStyle {
            max = 4
        }
        return items[section].courses.count > max ? max : items[section].courses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: CourseCVCell!
        if indexPath.row == 0 && !showPadStyle {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CourseVerticalCVCell", for: indexPath) as? CourseCVCell
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CourseHorizontalCVCell", for: indexPath) as? CourseCVCell
        }
        
        let model = items[indexPath.section].courses[indexPath.row]
        cell.titleLabel.text = model.title
        cell.deatilLabel.text = model.name
        cell.imageView.sd_setImage(with: URL(string: model.coverImageUrl), completed: nil)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CourseHeaderCRView", for: indexPath) as! CourseHeaderCRView
        let model = items[indexPath.section]
        view.titleLabel.text = model.category
        return view
    }
}

// MARK: - UICollectionViewCompositionalLayout
extension ViewController {
    func generateLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { [unowned self] section, environment in
            if showPadStyle {
                return self.padLayoutSection
            } else {
                return self.phoneLayoutSection
            }
        }
    }
    
    var phoneLayoutSection: NSCollectionLayoutSection {
        let inset: CGFloat = 5
        let space: CGFloat = 15
        
        // Items
        let largeItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.6))
        let largeItem = NSCollectionLayoutItem(layoutSize: largeItemSize)
        largeItem.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        let smallItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.5))
        let smallItem = NSCollectionLayoutItem(layoutSize: smallItemSize)
        smallItem.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        // Nested Group
        let nestedGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.4))
        let nestedGroup = NSCollectionLayoutGroup.vertical(layoutSize: nestedGroupSize, subitems: [smallItem, smallItem])
        
        // Outer Group
        let outerGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.6))
        let outerGroup = NSCollectionLayoutGroup.vertical(layoutSize: outerGroupSize, subitems: [largeItem, nestedGroup])
        
        // Section
        let section = NSCollectionLayoutSection(group: outerGroup)
        section.contentInsets = NSDirectionalEdgeInsets(top: space, leading: space, bottom: space, trailing: space)
        section.interGroupSpacing = inset
        
        // Supplementary Item
        let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44))
        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [headerItem]
        return section
    }
    
    var padLayoutSection: NSCollectionLayoutSection {
        let inset: CGFloat = 5
        let space: CGFloat = 20
        
        // Items
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        // Nested Group
        let nestedGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.5))
        let nestedGroup = NSCollectionLayoutGroup.horizontal(layoutSize: nestedGroupSize, subitems: [item, item])
        
        // Outer Group
        let outerGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.2))
        let outerGroup = NSCollectionLayoutGroup.vertical(layoutSize: outerGroupSize, subitems: [nestedGroup, nestedGroup])
        
        // Section
        let section = NSCollectionLayoutSection(group: outerGroup)
        section.contentInsets = NSDirectionalEdgeInsets(top: space, leading: space, bottom: space, trailing: space)
        section.interGroupSpacing = inset
        
        // Supplementary Item
        let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44))
        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [headerItem]
        return section
    }
}

