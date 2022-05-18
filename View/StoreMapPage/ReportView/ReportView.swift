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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var peopleCountSegement: UISegmentedControl!
    @IBOutlet weak var sendBuuton: UIButton!
    @IBAction func tapSendButton(_ sender: Any) {
        sendBuuton.layer.cornerRadius = 15
        sendBuuton.clipsToBounds = true
        
        let count = peopleCountSegement.selectedSegmentIndex + 1
        self.delegate?.didTapSendButton(self, queue: count)
    }
    @IBAction func tapCloseButton(_ sender: Any) {
        self.delegate?.didTapCloseButton(self)
    }
    
    func layoutView(name: String) {
        titleLabel.text = name
    }

}
