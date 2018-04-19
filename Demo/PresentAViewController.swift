//
//  PresentAViewController.swift
//  Demo
//
//  Created by Alvin Choo on 10/4/18.
//  Copyright © 2018 Alvin Choo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PresentAViewController: UIViewController {

    let disposeBag = DisposeBag()
    @IBOutlet weak var timeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Without weak self ❌
//        Observable<Int>.interval(1.0, scheduler: MainScheduler.instance)
//            .map { String($0) }
//            .subscribe(onNext: { value in
//                self.timeLabel.text = value
//                debugPrint(value)
//            })
//            .disposed(by: disposeBag)

        // With weak self ( better ) ✅
//        Observable<Int>.interval(1.0, scheduler: MainScheduler.instance)
//            .map { String($0) }
//            .subscribe(onNext: { [weak self] value in
//                self?.timeLabel.text = value
//                debugPrint(value)
//            })
//            .disposed(by: disposeBag)

        // Best ✅✅✅
        Observable<Int>.interval(1.0, scheduler: MainScheduler.instance)
            .map { String($0) }
            .debug()
            .subscribe(timeLabel.rx.text)
            .disposed(by: disposeBag)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
