//
//  ViewController.swift
//  APIKit
//
//  Created by yoxisem544 on 11/15/2019.
//  Copyright (c) 2019 yoxisem544. All rights reserved.
//

import UIKit
import APIKit
import PromiseKit
import RxSwift

class ViewController: UIViewController {

    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

//        API.sharedd.blockRequestQueue()

//        API.sharedd.request(SampleReqeust.Auth.RefreshAccessToken())
        
//        API.sharedd.request(SampleReqeust.Ya.GetYA())
//            .done({ json in
//                print(json)
//            })
//            .catch({ e in
//                print(e)
//            })

        API.stubbing().setSuccess(mockData: """
            {
                "username": "John",
                "id": 123,
            }
            """.data(using: .utf8)!)
            .request(SampleReqeust.Auth.RefreshAccessToken())
            .done({ user in

            })
            .catch({ e in

            })

//        API.shared.rx.request(SampleReqeust.Auth.RefreshAccessToken())
//            .subscribe(onSuccess: { json in }, onError: { e in })
//            .disposed(by: bag)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

