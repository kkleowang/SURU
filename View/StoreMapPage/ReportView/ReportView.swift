//
//  ReportView.swift
//  SURU_Leo
//
//  Created by LEO W on 2022/5/4.
//

import UIKit

protocol ReportViewDelegate: AnyObject {
    func didTapSendButton(_ view: ReportView, queue: Int)
    func didTapCloseButton(_ view: ReportView)
}

class ReportView: UIView {
    weak var delegate: ReportViewDelegate?

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
    @IBOutlet var peopleCountSegement: UISegmentedControl!
    @IBOutlet var sendBuuton: UIButton!
    @IBAction func tapSendButton(_: Any) {
        let count = peopleCountSegement.selectedSegmentIndex + 1
        delegate?.didTapSendButton(self, queue: count)
    }

    @IBAction func tapCloseButton(_: Any) {
        delegate?.didTapCloseButton(self)
    }

    func layoutView(name: String) {
        sendBuuton.cornerRadii(radii: 10)
        titleLabel.text = name
    }
}
