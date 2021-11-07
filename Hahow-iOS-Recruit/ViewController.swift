//
//  ViewController.swift
//  Hahow-iOS-Recruit
//
//  Created by Tommy Lin on 2021/10/5.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {
    @IBOutlet weak private var collectionView: UICollectionView! {
        didSet {
            setupCollectionView()
        }
    }
    private let viewModel: ViewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.callMockAPI { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.collectionViewLayout = generateLayout()
        
        collectionView.registerSectionHeaderFromNib(type: CourseHeaderCRView.self)
        collectionView.register(CourseCVCell.getNib(.vertical), forCellWithReuseIdentifier: CourseCVCell.Identifier.vertical.rawValue)
        collectionView.register(CourseCVCell.getNib(.horizontal), forCellWithReuseIdentifier: CourseCVCell.Identifier.horizontal.rawValue)
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

// MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRow(section, style: showPadStyle)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: CourseCVCell!
        if indexPath.row == 0 && !showPadStyle {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: CourseCVCell.Identifier.vertical.rawValue, for: indexPath) as? CourseCVCell
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: CourseCVCell.Identifier.horizontal.rawValue, for: indexPath) as? CourseCVCell
        }
        
        let course = viewModel.getCourse(indexPath)
        cell.config(with: course)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSectionHeader(with: CourseHeaderCRView.self, for: indexPath)
        view.titleLabel.text = viewModel.getSectionTitle(indexPath.section)
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

