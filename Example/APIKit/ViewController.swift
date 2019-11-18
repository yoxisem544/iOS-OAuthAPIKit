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

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        API.sharedd.request(SampleReqeust.Ya.GetYA())
            .done({ json in
                print(json)
            })
            .catch({ e in
                print(e)
            })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

