//
//  AddInfoView.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/4/27.
//

import UIKit

protocol AddInfoViewDelegate: AnyObject {
    func didTapOnImageView(_ view: AddInfoView)
    func didTapSendButton(_ view: AddInfoView, image: UIImage?, nikeName: String?)
}

class AddInfoView: UIView {
    weak var delegate: AddInfoViewDelegate?

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var imageNoteLabel: UILabel!

    @IBOutlet var mainImageImageView: UIImageView!
    @IBOutlet var nickNameNoteLabel: UILabel!
    @IBOutlet var nickNameTextField: UITextField!
    @IBOutlet var sendButton: UIButton!

    @IBAction func tapSendButton() {
        delegate?.didTapSendButton(self, image: mainImageImageView.image, nikeName: nickNameTextField.text)
    }

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
        delegate?.didTapOnImageView(self)
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
