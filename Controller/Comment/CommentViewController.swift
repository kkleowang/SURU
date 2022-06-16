//
//  SendCommentConmViewController.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/17.
//

import UIKit

class CommentViewController: UIViewController {
    var startingView = CommentStartingView()
    var orderObserver: NSKeyValueObservation!
    
    var stores: [Store] = []
    var comments: [Comment] = []
    var commentDrafts: [CommentDraft] = [] {
        didSet {
            commentDrafts.sort { $0.createTime > $1.createTime }
        }
    }
    
    var currentUserID: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let userID = UserRequestProvider.shared.currentUserID else { return }
        currentUserID = userID
        settingKVO()
        fetchStoreData {
            self.fetchCoreData {
                self.setupStartingView()
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationItem.title = "新增評論"
    }

    func settingKVO() {
        orderObserver = StorageManager.shared.observe(\StorageManager.comments, options: .new) { [weak self] _, change in
            guard let newValue = change.newValue else { return }
            self?.commentDrafts = newValue
            self?.startingView.commentTableView.reloadSections([0], with: .none)
        }
    }

    func fetchStoreData(completion: @escaping () -> Void) {
        StoreRequestProvider.shared.fetchStores { result in
            switch result {
            case let .success(data):
                self.stores = data
            case let .failure(error):
                print(error)
            }
            completion()
        }
    }

    func fetchCoreData(completion: @escaping () -> Void) {
        StorageManager.shared.fetchComments { result in
            switch result {
            case let .success(data):
                self.commentDrafts = data
            case let .failure(error):
                print(error)
            }
            completion()
        }
    }

    func setupStartingView() {
        view.addSubview(startingView)
        startingView.translatesAutoresizingMaskIntoConstraints = false
        startingView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        startingView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        startingView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        startingView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        startingView.commentTableView.delegate = self
        startingView.commentTableView.dataSource = self
        
        startingView.commentTableView.allowsSelection = true
        startingView.commentTableView.isUserInteractionEnabled = true
        startingView.delegate = self
        startingView.layoutStartingView()
    }
    func initSelection(image: UIImage) {
        let controller = CommentSeletionController(userID: currentUserID, image: image, storeData: stores)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func initSelectionByDraft(draft: CommentDraft) {
        let controller = CommentSeletionController(userID: currentUserID, draft: draft, storeData: stores)
        navigationController?.pushViewController(controller, animated: true)
    }
}

// StartingView Delegate
extension CommentViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in _: UITableView) -> Int {
        1
    }

    func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
        "你的評論草稿"
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 120
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        commentDrafts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CommentTableViewCell.self), for: indexPath) as? CommentTableViewCell else { return CommentTableViewCell() }
        
        let name = stores.first(where: { $0.storeID == commentDrafts[indexPath.row].storeID })?.name ?? "未輸入店名"
        cell.layoutDraftCell(data: commentDrafts[indexPath.row], name: name)
        return cell
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        initSelectionByDraft(draft: commentDrafts[indexPath.row])
    }
}
extension CommentViewController: CommentStartingViewDelegate {
    func didFinishPickImage(_ view: CommentStartingView, imagePicker: UIImagePickerController, image: UIImage) {
        initSelection(image: image)
        imagePicker.dismiss(animated: true)
    }

    func didTapImageView(_: CommentStartingView, imagePicker: UIImagePickerController?) {
        if let imagePicker = imagePicker {
            present(imagePicker, animated: true)
        }
    }
}
