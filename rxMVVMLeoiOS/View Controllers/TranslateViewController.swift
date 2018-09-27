//
//  TranslateViewController.swift
//  rxMVVMLeoiOS
//
//  Created by Ivan  on 24/09/2018.
//  Copyright © 2018 Ivan . All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
//import RxDataSources

class TranslateViewController: UIViewController, BindableType {
    
    var viewModel: TranslateViewModel!
    //var dataSource: RxTableViewSectionedReloadDataSource<TranslateSection>!
    
    private let bag = DisposeBag()

    @IBOutlet weak var translateTableView: UITableView!
    @IBOutlet weak var apiSegmentedControl: UISegmentedControl!
    @IBOutlet weak var wordsLabel: UILabel!
    @IBOutlet weak var addWordButton: UIButton!
    @IBOutlet weak var wordTextField: UITextField!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //configureDataSource()
        translateTableView.rowHeight = UITableViewAutomaticDimension
        translateTableView.estimatedRowHeight = UITableViewAutomaticDimension
    }

    
//    func configureDataSource() {
//        dataSource = RxTableViewSectionedReloadDataSource<TranslateSection>(configureCell: {
//             dataSource, tableView, IndexPath, item in
//
//            let cell = tableView.dequeueReusableCell(withIdentifier: "translateCell", for: IndexPath) as! TranslateTableViewCell
//            cell.configure(with: item)
//            cell.sizeToFit()
//
//            return cell
//        })
//    }
//
    
    func bindViewModel() {
        
        logoutButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                
                self.viewModel.logout()
            })
            .disposed(by: bag)
        
//        let translateResults = wordTextField.rx.text.orEmpty
//            .throttle(0.3, scheduler: MainScheduler.instance)
//            .distinctUntilChanged()
//            .flatMapLatest { words -> Observable<[String]> in
//                if words.isEmpty {
//                    return .just([])
//                } else {
//                    return self.viewModel.translate(word: words, translateAPI: 0)
//                        .catchErrorJustReturn([])
//                }
//            }
//            .observeOn(MainScheduler.instance)
        
        let translateResults = Observable.combineLatest(wordTextField.rx.text.orEmpty, apiSegmentedControl.rx.selectedSegmentIndex)
            .throttle(0.3, scheduler: MainScheduler.instance)
            .flatMapLatest { [unowned self] words, segment -> Observable<[String]> in
                if words.isEmpty {
                    return .just([])
                } else {
                    return self.viewModel.translate(word: words, translateAPI: segment)
                        .catchErrorJustReturn([])
                }
            }
            .observeOn(MainScheduler.instance)
        
        
//        translateResults
//            .map {
//                return [TranslateSection.init(model: "Translate", items: $0)]
//            }
//            .bind(to: self.translateTableView.rx.items(dataSource: dataSource))
//            .disposed(by: bag)
        
        translateResults
            .bind(to: self.translateTableView.rx.items(cellIdentifier: "translateCell", cellType: TranslateTableViewCell.self)) {  _, translate, cell in
                cell.configure(with: translate)
            }
            .disposed(by: bag)
        
        viewModel.meatballs()
            .bind(to: wordsLabel.rx.text)
            .disposed(by: bag)
        
        translateTableView.rx.itemSelected
            .subscribe({ _ in
                self.addWordButton.isEnabled = true
            })
            .disposed(by: bag)
       
        
        
//        let table = Observable.zip(translateTableView.rx.itemSelected, translateTableView.rx.modelSelected(String.self))
//            .bind { indexPath, model in
//                self.translateTableView.deselectRow(at: indexPath, animated: true)
//                self.viewModel.add(word: self.wordTextField.text!, translate: model)
//            }
//
        let testin = Observable.zip(addWordButton.rx.tap, translateTableView.rx.modelSelected(String.self))
            
            .flatMapLatest { _, model -> Observable<Bool> in
                return self.viewModel.add(word: self.wordTextField.text!, translate: model)
            }
            .observeOn(MainScheduler.instance)
        
        
        testin
            .bind(to: addWordButton.rx.isEnabled)
            .disposed(by: bag)
        
        
    
        
//        _ = Observable.combineLatest(addWordButton.rx.tap, translateTableView.rx.itemSelected)
//            .distinctUntilChanged { _,item in return item }
//            .do(onNext: { [unowned self] _, IndexPath in
//                self.translateTableView.deselectRow(at: IndexPath, animated: false)
//            })
//            .map { [unowned self] tap, indexPath  in
//                try self.dataSource.model(at: indexPath) as! String
//            }
//            .observeOn(MainScheduler.instance)
//            .subscribe(onNext: { [unowned self] text  in
//                 self.viewModel.add(word: self.wordTextField.text!, translate: text)
//                    .bind(to: self.addWordButton.rx.isEnabled)
//                    .disposed(by: self.bag)
//            })
//
        
        
        
        
    }
}

//extension TranslateViewController: UITableViewDelegate {
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//
//        let textView = tableView.cellForRow(at: indexPath)
//        let sizeThatShouldFitTheContent = textView.sizeThatFits(textView.frame.size)
//        let height = sizeThatShouldFitTheContent.height
//        
//        return height
//    }
//}

