//
//  ViewController.swift
//  AppleLogin
//
//  Created by Manvendra on 12/12/19.
//  Copyright © 2019 Manvendra. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var view1: MSAppleLoginView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view1.delegate = self
    }
}
extension ViewController: MSAppleLoginDelegate {
    func fialedToAuthorize(error: Error) {
        print(error)
    }
    func authorize(with data: MSAuthorizeData) {
        print(data.appleId)
        print(data.userEmail ?? "")
        print(data.userName ?? "")
    }
}
