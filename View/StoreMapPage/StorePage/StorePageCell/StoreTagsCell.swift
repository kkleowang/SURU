//
//  StoreTagsCell.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/5/8.
//

import UIKit

class StoreTagsCell: UITableViewCell {
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var iconImageView: UIImageView!
    var storeData: Store?

    func layoutCell(isMeal: Bool, store: Store?) {
        storeData = store
        selectionStyle = .none
        collectionView.register(UINib(nibName: TagsCell.identifier, bundle: nil), forCellWithReuseIdentifier: TagsCell.identifier)
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = CGSize(width: 200, height: 40)
        collectionView.collectionViewLayout = layout

        if isMeal {
            collectionView.tag = 90
            iconImageView.image = UIImage(named: "noodle")
        } else {
            collectionView.tag = 80
        }
    }
}

extension StoreTagsCell: UICollectionViewDataSource {
    func numberOfSections(in _: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        guard let storeData = storeData else { return 0 }
        if collectionView.tag == 80 {
            return storeData.tags.count
        } else {
            return storeData.meals.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: TagsCell.self), for: indexPath) as? TagsCell else { return TagsCell() }
        guard let storeData = storeData else { return TagsCell() }

        if collectionView.tag == 80 {
            cell.tagLabel.text = storeData.tags[indexPath.row]
            cell.backgroundColor = .C4
            return cell
        } else {
            cell.layoutForMeal()
            cell.tagLabel.text = storeData.meals[indexPath.row]
            cell.backgroundColor = .C2
            return cell
        }
    }
}
