//
//  ProfileCommentCell.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/5/15.
//

import UIKit
import CHTCollectionViewWaterfallLayout

class ProfileCommentCell: UITableViewCell {

    var dataSource: [Comment]?
    @IBOutlet weak var collectionView: UICollectionView!
    
    func layoutCell(commentData: [Comment]) {
        collectionView.dataSource = self
        collectionView.delegate = self
        let layout = CHTCollectionViewWaterfallLayout()
        layout.columnCount = 3
        layout.minimumColumnSpacing = 3
        layout.minimumInteritemSpacing = 3
        let inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.sectionInset = inset
        collectionView.collectionViewLayout = layout
        collectionView.register(UINib(nibName: String(describing: ProfileCommentCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: ProfileCommentCollectionViewCell.self))
    }
}
extension ProfileCommentCell: UICollectionViewDataSource, UICollectionViewDelegate, CHTCollectionViewDelegateWaterfallLayout {
   
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            guard let comment = dataSource else { return 0 }
            if comment.isEmpty {
                collectionView.setEmptyMessage("你還沒有發表過評論喔！")
            } else {
                collectionView.restore()
            }
            return comment.count
        }
    
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ProfileCommentCollectionViewCell.self), for: indexPath) as? ProfileCommentCollectionViewCell else { return ProfileCommentCollectionViewCell() }
            guard let comment = dataSource else { return cell }
            cell.layoutCell(comment: comment[indexPath.item])
            return cell
        }
    
    
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = UIScreen.width - 3 * 2
    
            return CGSize(width: width, height: width)
        }
    
}
