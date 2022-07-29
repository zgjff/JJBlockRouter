//
//  SystemPresentController.swift
//  Demo
//
//  Created by zgjff on 2022/7/29.
//

import UIKit

class SystemPresentController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .random()
    }
}

extension SystemPresentController: JJBlockRouterDestination {
    func showDetail(withMatchRouterResult result: JJBlockRouter.MatchResult, from sourceController: UIViewController) {
        sourceController.present(self, animated: true)
    }
}
