//
//  ViewController.swift
//  ImageUpdate
//
//  Created by Dimitar Dimitrov on 03/11/2023.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logoChangerView = LogoChangerView(imageStyle: .rectangular(20))
        
        let childView = UIHostingController(rootView: logoChangerView)
        
        addChild(childView)
        childView.view.frame = CGRect(x: 0, y: 0, width: 120, height: 120)
        childView.view.center = view.center
        view.addSubview(childView.view)
        childView.didMove(toParent: self)
    }
}
