//
//  WriteCommentView.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/5/3.
//

import UIKit

protocol WrireCommentViewControllerDelegate: AnyObject {
    func didTapSendComment(_ view: WriteCommentView, text: String, viewController: UIViewController)
    func didTapSaveDraft(_ view: WriteCommentView, text: String, viewController: UIViewController)
}

class WriteCommentView: UIView {
    weak var delegate: WrireCommentViewControllerDelegate?
    
    var storename: String!
    var mealName: String!
    var time: String!
    @IBOutlet var contentTextView: UITextView!

    @IBOutlet var saveButton: UIButton!
    @IBOutlet var importTempButton: UIButton!
    @IBOutlet var sendButton: UIButton!
    @IBAction func tapImportTemp(_: Any) {
        contentTextView.text = "| 店家： \(storename)\n| 時間 ：\(time)\n| 品項 ：\(mealName)\n| 配置 ：\n| 評論：\n"
    }

    @IBAction func tapSendComment(_: Any) {
        if let vc =  topMostController() {
            delegate?.didTapSendComment(self, text: contentTextView.text!.replacingOccurrences(of: "\n", with: "\\n"), viewController: vc)
        }
    }

    @IBAction func tapSaveToDraft(_: Any) {
        if let vc =  topMostController() {
        delegate?.didTapSaveDraft(self, text: contentTextView.text!.replacingOccurrences(of: "\n", with: "\\n"), viewController: vc)
        }
    }

    func layoutView(comment: Comment, storeName: String) {
        mealName = comment.meal
        storename = storeName
        time = configTime()
        
        setTextView(textBox: contentTextView)
        saveButton.cornerRadii(radii: 10)
        sendButton.cornerRadii(radii: 10)
        saveButton.cornerRadii(radii: 10)
    }
    func configTime() -> String {
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        return formatter.string(from: today)
    }

    private func setTextView(textBox: UITextView) {
        textBox.autocorrectionType = .no
        textBox.backgroundColor = .secondarySystemBackground
        textBox.textColor = .secondaryLabel
        textBox.font = UIFont.preferredFont(forTextStyle: .body)
        textBox.layer.cornerRadius = 20
        textBox.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textBox.layer.shadowColor = UIColor.gray.cgColor
        textBox.layer.shadowOffset = CGSize(width: 0.75, height: 0.75)
        textBox.layer.shadowOpacity = 0.4
        textBox.layer.shadowRadius = 20
        textBox.layer.masksToBounds = false
    }
}
