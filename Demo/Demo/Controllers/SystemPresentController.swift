//
//  SystemPresentController.swift
//  Demo
//
//  Created by zgjff on 2022/7/29.
//

import UIKit

class SystemPresentController: UIViewController, ShowMatchRouterable {

    private var result: JJBlockRouter.MatchResult?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "SystemPresent"
        view.backgroundColor = .random()
        showMatchResult(result)
    }
}

extension SystemPresentController: JJBlockRouterDestination {
    func showDetail(withMatchRouterResult result: JJBlockRouter.MatchResult, from sourceController: UIViewController) {
        self.result = result
        sourceController.present(self, animated: true)
    }
}
