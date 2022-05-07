//
//  BadgeViewController.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/5/7.
//

import UIKit

class BadgeViewController: UIViewController {
    var badgeRef: [[Int]]?
    var totalBadge = 0
    var titleLabel = UILabel()
    var badgeTitle = ["登入次數", "發布評論", "回報次數", "收到的喜歡", "追蹤人數"]
    let BadgeName: [[String]] = [
        ["初來乍到", "尋找拉麵的訪客", "熟門熟路", "下一碗在哪", "拉麵迷"],
        ["新手", "鍵盤俠", "專業寫手", "三餐吃拉麵", "拉麵豪ㄘ"],
        ["好人", "熱心民眾", "大聲公", "排隊警察", "聖人"],
        ["沒人點我讚", "拜託點我讚", "可憐我一點讚", "就差你的讚", "不缺讚"],
        ["默默無名", "小有名氣", "街頭巷尾", "遠近馳名", "萬人迷"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getBadgeCount()
        layoutView()
    }
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewSectionColorFlowLayout()
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.size.width - 80) / 3, height: 150)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: String(describing: BadgeCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: BadgeCell.self))
        collectionView.register(UINib(nibName: String(describing: BadgeHeaderCell.self), bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: BadgeHeaderCell.self))
        collectionView.showsVerticalScrollIndicator = false
        layout.headerReferenceSize = CGSize(width: collectionView.bounds.width, height: 60)
        
        return collectionView
    }()
    
    func layoutView() {
        navigationItem.title = "我的勳章"
        
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.text = "已獲得\(totalBadge)枚勳章"
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        collectionView.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    func getBadgeCount() {
        guard let badgeRef = badgeRef else {
            return
        }
        totalBadge = 0
        for badgeType in badgeRef {
            let filterArr = badgeType.filter { $0 == 1}
            totalBadge += filterArr.count
        }
    }
}
extension BadgeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewSectionColorDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: BadgeHeaderCell.self), for: indexPath) as? BadgeHeaderCell else {
            return UICollectionReusableView()
        }
        cell.titleLabel.text = badgeTitle[indexPath.section]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        5
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: BadgeCell.self), for: indexPath) as? BadgeCell, let badgeRef = badgeRef else { return UICollectionViewCell() }
        cell.badgeNameLabel.text = BadgeName[indexPath.section][indexPath.row]
        if badgeRef[indexPath.section][indexPath.row] == 0 {
            cell.badgeNameLabel.textColor = .gray
            cell.badgeImageView.kf.setImage(with: URL(string: ""), placeholder: UIImage(named: badgeFile[indexPath.section][indexPath.item])?.withSaturationAdjustment(byVal: 0))
        } else {
            cell.badgeNameLabel.textColor = .systemBrown
            cell.badgeImageView.kf.setImage(with: URL(string: ""), placeholder: UIImage(named: badgeFile[indexPath.section][indexPath.item]))
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, backgroundColor section: Int) -> UIColor {
        .white
    }
    
    
}
