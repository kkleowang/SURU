//
//  DetailViewController.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/5/3.
//

import UIKit
import Kingfisher
import IQKeyboardManagerSwift
protocol DetailViewControllerDelegate: AnyObject {
    func didtapAuthor(_ vc: DetailViewController, targetUserID: String?)
}
class DetailViewController: UIViewController {
    weak var delegate: DetailViewControllerDelegate?
    var currentUser: Account?
    var author: Account?
    var accountData: [Account] = []
    var comment: Comment?
    var store: Store?
    
    var newCommet: Comment? {
        didSet {
            guard let data = newCommet?.userComment else { return }
            if data.count != tableView.numberOfRows(inSection: 1) {
                comment = newCommet
                guard let message = comment?.userComment, let currentUserID = UserRequestProvider.shared.currentUserID else { return }
                self.tableView.reloadSections([1], with: .automatic)
                if let author = message.sorted(by: {$0.createdTime > $1.createdTime}).last?.userID {
                    if author == currentUserID {
                    self.tableView.scrollToRow(at: IndexPath(row: message.count - 1, section: 1), at: .top, animated: true)
                    }
                }
            }
        }
    }
    func configMessage() {
        guard let blockList = currentUser?.blockUserList, let messages = comment?.userComment else { return }
        
        self.comment?.userComment = messages.filter { if blockList.contains($0.userID) {
            return false
        } else {
            return true
        }
        }
    }
    
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var badgeImageView: UIImageView!
    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var authorStackView: UIStackView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    @IBAction func tapFollowButton(_ sender: UIButton) {
        guard let userID = UserRequestProvider.shared.currentUserID, let account = author else { return }
        
        if sender.currentTitle == "追蹤" {
            followButton.setTitle("已追蹤", for: .normal)
            AccountRequestProvider.shared.followAccount(currentUserID: userID, tagertUserID: account.userID)
        } else {
            followButton.setTitle("追蹤", for: .normal)
            AccountRequestProvider.shared.unfollowAccount(currentUserID: userID, tagertUserID: account.userID)
        }
    }
    @IBAction func tapBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func showTextView() {
        inputTextField.becomeFirstResponder()
        textViewBarView.isHidden = false
    }
    @IBAction func tapCommentButton(_ sender: UIButton) {
        let messages = comment?.userComment ?? []
        if !messages.isEmpty {
            tableView.scrollToRow(at: IndexPath(row: 0, section: 1), at: .top, animated: true)
        } else {
            let sectionRect = tableView.rectForHeader(inSection: 1)
            tableView.scrollRectToVisible(sectionRect, animated: true)
        }
    }
    @IBAction func tapLikeButton(_ sender: UIButton) {
        guard let currentUserID = UserRequestProvider.shared.currentUserID, let tagertComment = comment else { return }
        guard let image = sender.imageView?.image else { return }
        if image == UIImage(systemName: "heart.fill") {
            sender.setImage(UIImage(systemName: "heart"), for: .normal)
            sender.setTitle("\((Int(sender.currentTitle ?? "1") ?? 1 ) - 1)", for: .normal)
            CommentRequestProvider.shared.likeComment(currentUserID: currentUserID, tagertComment: tagertComment)
        } else {
            sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            sender.setTitle("\((Int(sender.currentTitle ?? "0") ?? 0 ) + 1 )", for: .normal)
            CommentRequestProvider.shared.unLikeComment(currentUserID: currentUserID, tagertComment: tagertComment)
        }
    }
    
    @IBAction func postComment(_ sender: Any) {
        if let text = inputTextField.text {
            if !text.isEmpty {
                inputTextField.resignFirstResponder()
                publishMessage()
            }
            inputTextField.text = ""
        }
    }
    func publishMessage() {
        guard let currentUserId = UserRequestProvider.shared.currentUserID,
              let _ = author,
              let comment = comment,
              let content = inputTextField.text else { return }
        var message = Message(userID: currentUserId, message: content)
        //        LKProgressHUD.show()
        CommentRequestProvider.shared.addMessage(message: &message, tagertCommentID: comment.commentID) { result in
            switch result {
            case .success(let message):
                //                LKProgressHUD.dismiss()
                LKProgressHUD.showSuccess(text: message)
            case .failure:
                //                LKProgressHUD.dismiss()
                LKProgressHUD.showFailure(text: "新增評論失敗\n稍候再試")
            }
        }
    }
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var commentCountBtn: UIButton!
    @IBOutlet weak var likeVIew: UIView!
    @IBOutlet weak var textViewBarView: UIView!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var textViewBarBottomConstraint: NSLayoutConstraint!
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func tapAuthorView() {
        dismiss(animated: true) {
            guard let userID = self.comment?.userID else { return }
            self.delegate?.didtapAuthor(self, targetUserID: userID)
        }
    }
    func setupTopView() {
        guard let currentUserId = UserRequestProvider.shared.currentUserID,
              let account = author,
              let comment = comment else { return }
        CommentRequestProvider.shared.listenComment(for: comment.commentID) { result in
            switch result {
            case .success(let data):
                self.newCommet = data
            case .failure:
                LKProgressHUD.showFailure(text: "下載評論失敗")
            }
        }
        let tapAuthor = UITapGestureRecognizer(target: self, action: #selector(tapAuthorView))
        authorStackView.isUserInteractionEnabled = true
        authorStackView.addGestureRecognizer(tapAuthor)
        authorImageView.loadImage(account.mainImage, placeHolder: UIImage(named: "mainImage"))
        authorImageView.clipsToBounds = true
        authorImageView.layer.cornerRadius = authorImageView.bounds.width / 2
        
        followButton.titleLabel?.adjustsFontSizeToFitWidth = true
        authorNameLabel.text = account.name
        authorNameLabel.adjustsFontSizeToFitWidth = true
        authorNameLabel.setDefultFort()
        
        if let badge = account.badgeStatus {
            badgeImageView.image = UIImage(named: "long_\(badge)")
        } else {
            badgeImageView.isHidden = true
        }
        followButton.layer.cornerRadius = 10
        followButton.clipsToBounds = true
        followButton.layer.borderWidth = 1
        followButton.layer.borderColor = UIColor.B1?.cgColor
        if comment.likedUserList.contains(currentUserId) {
            followButton.setTitle("已追蹤", for: .normal)
        } else {
            followButton.setTitle("追蹤", for: .normal)
        }
    }
    
    func setupButtonView() {
        guard let currentUserId = UserRequestProvider.shared.currentUserID,
              let _ = author,
              let comment = comment else { return }
        
        if comment.likedUserList.contains(currentUserId) {
            likeBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            likeBtn.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        if !comment.likedUserList.isEmpty {
            likeBtn.setTitle("\(comment.likedUserList.count)", for: .normal)
        } else {
            likeBtn.setTitle("0", for: .normal)
        }
        if let userComment = comment.userComment {
            if !userComment.isEmpty {
                commentCountBtn.setTitle("\(userComment.count)", for: .normal)
            } else {
                commentCountBtn.setTitle("0", for: .normal)
            }
        }
    }
    
    func setuptableView() {
        tableView.register(UINib(nibName: String(describing: CommentCell.self), bundle: nil), forCellReuseIdentifier: String(describing: CommentCell.self))
        tableView.register(UINib(nibName: String(describing: CommentMessagesCell.self), bundle: nil), forCellReuseIdentifier: String(describing: CommentMessagesCell.self))
        tableView.dataSource = self
        tableView.delegate = self
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        listenToKeyStatus()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.enable = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.enable = false
        setupTopView()
        setupButtonView()
        setuptableView()
    }
    
    lazy var overlayView: UIView = {
        let overlayView = UIView(frame: view.frame)
        overlayView.backgroundColor = UIColor(white: 0, alpha: 0.1)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        overlayView.addGestureRecognizer(tap)
        return overlayView
    }()
    
    func listenToKeyStatus() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    //    func hideKeyboardWhenTappedAround(){
    //        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    //        tap.cancelsTouchesInView = false
    //        view.addGestureRecognizer(tap)
    //    }
    
}
extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "用戶留言"
        } else {
            return nil
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            guard let messages = comment?.userComment else { return 0 }
            
            return messages.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let storeData = store, let commentData = comment else { return UITableViewCell() }
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CommentCell.self), for: indexPath) as? CommentCell else { return CommentCell() }
            cell.layoutCell(data: commentData, store: storeData)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CommentMessagesCell.self), for: indexPath) as? CommentMessagesCell else { return CommentMessagesCell() }
            
            guard let messages = comment?.userComment else { return cell }
            cell.delegate = self
            let dataSource = messages.sorted { $0.createdTime > $1.createdTime }
            let message = dataSource[indexPath.row]
            let author = accountData.first { $0.userID == message.userID } ?? Account(userID: "123", provider: "")
            cell.layoutCell(commentMessage: messages[indexPath.row], author: author)
            
            return cell
        }
    }
}
extension DetailViewController: CommentMessagesCellDelegate {
    func didTapMoreButton(_ view: CommentMessagesCell, targetUserID: String?) {
        showAlert(targetUser: targetUserID)
    }
    func showAlert(targetUser: String?) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.popoverPresentationController?.sourceView = self.view
        
        let xOrigin = self.view.bounds.width / 2
        
        let popoverRect = CGRect(x: xOrigin, y: 0, width: 1, height: 1)
        
        alert.popoverPresentationController?.sourceRect = popoverRect
        
        alert.popoverPresentationController?.permittedArrowDirections = .up
        alert.addAction(UIAlertAction(title: "封鎖用戶", style: .destructive) { _ in
            guard let userID = UserRequestProvider.shared.currentUserID, let targetUser = targetUser else { return }
            AccountRequestProvider.shared.blockAccount(currentUserID: userID, tagertUserID: targetUser)
            LKProgressHUD.showFailure(text: "成功封鎖用戶")
            
            guard let messages = self.comment?.userComment else { return }
            
            self.comment?.userComment = messages.filter {
                if $0.userID == targetUser {
                    return false
                } else {
                    return true
                }
            }
            
            self.tableView.reloadSections([1], with: .automatic)
        })
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        
        self.present(alert, animated: true)
    }
}
extension DetailViewController {
    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        if let endFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            // when keyboard show >0, dismiss <0
            let keyboardH = UIScreen.height - endFrame.origin.y
            
            if keyboardH > 0 {
                view.insertSubview(overlayView, belowSubview: textViewBarView)
            } else {
                overlayView.removeFromSuperview()
                textViewBarView.isHidden = true
            }
            textViewBarBottomConstraint.constant = keyboardH
            view.layoutIfNeeded()
        }
    }
}
