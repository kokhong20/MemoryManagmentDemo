//
//  PushedBViewController.swift
//  Demo
//
//  Created by Alvin Choo on 10/4/18.
//  Copyright © 2018 Alvin Choo. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

enum ImagePickerType {
    case camera
    case gallery

    static let `default`: [ImagePickerType] = [.camera, .gallery]

    var name: String {
        switch self {
        case .camera:
            return "Take Photo"
        case .gallery:
            return "Choosee Photo"
        }
    }

    var sourceType: UIImagePickerControllerSourceType {
        switch self {
        case .camera:
            return .camera
        case .gallery:
            return .photoLibrary
        }
    }
}

class PushedBViewController: UIViewController {

    @IBOutlet weak var selectPhotoButton: UIButton!

    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

        // EXAMPLE 1
        // Nested closure.. Wrong! ❌
//            selectPhotoButton.rx.tap.asDriver()
//            .flatMap { _ in
//                return Observable<ImagePickerType>.create { [weak self] observer in
//                    guard let `self` = self else {
//                        observer.onCompleted()
//                        return Disposables.create()
//                    }
//                    let actionSheet = self.prepareActionSheet(with: observer, sources: ImagePickerType.default)
//                    self.present(actionSheet, animated: true, completion: nil)
//                    return Disposables.create {
//                        actionSheet.dismiss(animated: true, completion: nil)
//                        }
//                    }
//                    .asDriver(onErrorJustReturn: .gallery)
//            }.drive()
//            .disposed(by: disposeBag)

        // Nested closure.. Correct!! ✅
//        selectPhotoButton.rx.tap.asDriver()
//            .flatMap { [weak self] _ in
//                return Observable<ImagePickerType>.create { observer in
//                    guard let `self` = self else {
//                        observer.onCompleted()
//                        return Disposables.create()
//                    }
//                    let actionSheet = self.prepareActionSheet(with: observer, sources: ImagePickerType.default)
//                    self.present(actionSheet, animated: true, completion: nil)
//                    return Disposables.create {
//                        actionSheet.dismiss(animated: true, completion: nil)
//                    }
//                    }
//                    .asDriver(onErrorJustReturn: .gallery)
//            }.drive()
//            .disposed(by: disposeBag)


        // EXAMPLE 2
        // Using DispatchQueue.. Wrong! ❌
//        let queue = DispatchQueue(label: "com.tigerspike.Demo")
//
//        for i in 0 ..< 10 {
//            queue.async { () in
//                print("closure \(i) start")
//                self.performSomeTask(i)
//                print("closure \(i) finish")
//            }
//        }

        // Using DispatchQueue... Correct!! ✅
        let queue = DispatchQueue(label: "com.tigerspike.Demo")

        for i in 0 ..< 10 {
            queue.async { [weak self] in
                print("closure \(i) start")
                self?.performSomeTask(i)
                print("closure \(i) finish")
            }
        }


        // Try with unowned?
//        let queue = DispatchQueue(label: "com.tigerspike.Demo")
//
//        for i in 0 ..< 10 {
//            queue.async { [unowned self] in
//                print("closure \(i) start")
//                self.performSomeTask(i)
//                print("closure \(i) finish")
//            }
//        }
    }







    private func performSomeTask(_ value: Int) {
        print("performSomeTask starting \(value)")
        Thread.sleep(forTimeInterval: 5)
        print("performSomeTask finishing \(value)")
    }

    private func prepareActionSheet(with actionTapObserver: AnyObserver<ImagePickerType>,
                                    sources: [ImagePickerType]) -> UIAlertController {
        func prepareActionSheetActions(with tapObserver: AnyObserver<ImagePickerType>,
                                       sources: [ImagePickerType]) -> [UIAlertAction] {
            var actions = createSourcesActions(with: tapObserver, sources: sources)
            let cancel = createCancelAction(with: tapObserver)
            actions.append(cancel)
            return actions
        }

        func createSourcesActions(with tapObserver: AnyObserver<ImagePickerType>,
                                  sources: [ImagePickerType]) -> [UIAlertAction] {
            return sources.map { source in
                return UIAlertAction(title: source.name, style: .default) { _ in
                    tapObserver.onNext(source)
                    tapObserver.onCompleted()
                }
            }
        }

        func createCancelAction(with tapObserver: AnyObserver<ImagePickerType>) -> UIAlertAction {
            return UIAlertAction(title: "Cancel", style: .cancel) { _ in
                tapObserver.onCompleted()
            }
        }

        let actionSheet = UIAlertController(title: "Title",
                                            message: nil,
                                            preferredStyle: .actionSheet)
        prepareActionSheetActions(with: actionTapObserver, sources: sources)
            .forEach { actionSheet.addAction($0) }
        return actionSheet
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
