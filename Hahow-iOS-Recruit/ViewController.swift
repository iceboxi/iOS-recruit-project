//
//  ViewController.swift
//  Hahow-iOS-Recruit
//
//  Created by Tommy Lin on 2021/10/5.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .portrait
        } else {
            return super.supportedInterfaceOrientations
        }
    }
    }


}

