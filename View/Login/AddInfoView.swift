//
//  AddInfoView.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/27.
//

import UIKit

protocol AddInfoViewDelegate: AnyObject {
    func didTapOnImageView(_ view: AddInfoView)
}
class AddInfoView: UIView {
    weak var delegate: AddInfoViewDelegate?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var imageNoteLabel: UILabel!
    
    @IBOutlet weak var mainImageImageView: UIImageView!
    @IBOutlet weak var nickNameNoteLabel: UILabel!
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    func layoutAddInfoView() {
        addGestureForImagePicker()
        nickNameTextField.delegate = self
    }
    
    private func addGestureForImagePicker() {
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(tapImageView))
        mainImageImageView.addGestureRecognizer(tap)
    }
    @objc private func tapImageView() {
        self.delegate?.didTapOnImageView(self)
    }
}
extension AddInfoView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if text.count > 10 {
            textField.textColor = .red
            sendButton.isEnabled = false
        } else {
            sendButton.isEnabled = true
        }
    }
}
