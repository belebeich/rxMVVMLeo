//
//  TranslateTableViewCell.swift
//  rxMVVMLeoiOS
//
//  Created by Ivan  on 26/09/2018.
//  Copyright © 2018 Ivan . All rights reserved.
//

import UIKit
import RxSwift

class TranslateTableViewCell: UITableViewCell {

    @IBOutlet weak var translateTextView: UITextView!
    var bag = DisposeBag()
    override func awakeFromNib() {
        super.awakeFromNib()
        bag = DisposeBag()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with translate: String) {
//        let obs = Observable.of(translate)
//        obs
//            .subscribe(onNext: { [weak self] translate in
//                self?.translateTextView.text =
//            })
//            .disposed(by: bag)
//        self.sizeToFit()
        
        self.translateTextView.text = translate
        self.translateTextView.sizeToFit()
        self.translateTextView.setNeedsLayout()
        self.translateTextView.setNeedsDisplay()
    }

}
