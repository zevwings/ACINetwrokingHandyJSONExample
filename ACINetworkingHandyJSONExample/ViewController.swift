//
//  ViewController.swift
//  ACINetworkingHandyJSONExample
//
//  Created by 张伟 on 2021/12/10.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ExampleService.shared.request(api: .userInfo) { result in
            do {
                let object = try result.get().mapObject(ExampleModel.self)
                print(object)
            } catch {
                print(error)
            }
        }

        
        ExampleService.shared.rx.request(.userInfo)
            .filterSuccessfulStatusCodes()
            .mapObject(ExampleModel.self) // HandyJSON map
            .asObservable()
            .subscribe(onNext: { object in
                print(object)
            }, onError: { error in
                print(error)
            })
            .disposed(by: disposeBag)

    }


}

