//
//  SystemPushController.swift
//  Demo
//
//  Created by zgjff on 2022/7/29.
//

import UIKit

class SystemPushController: UIViewController, ShowMatchRouterable {

    private var result: JJBlockRouter.MatchResult?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "System Push"
        view.backgroundColor = .jj_random()
        showMatchResult(result)
    }
}

extension SystemPushController: JJBlockRouterDestination {
    func showDetail(withMatchRouterResult result: JJBlockRouter.MatchResult, from sourceController: UIViewController) {
        self.result = result
        sourceController.navigationController?.pushViewController(self, animated: true)
    }
}
