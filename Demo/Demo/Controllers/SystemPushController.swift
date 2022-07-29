//
//  SystemPushController.swift
//  Demo
//
//  Created by zgjff on 2022/7/29.
//

import UIKit

class SystemPushController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "System Push"
        view.backgroundColor = .random()
    }
}

extension SystemPushController: JJBlockRouterDestination {
    func showDetail(withMatchRouterResult result: JJBlockRouter.MatchResult, from sourceController: UIViewController) {
        sourceController.navigationController?.pushViewController(self, animated: true)
    }
}
