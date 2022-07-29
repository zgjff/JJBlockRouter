//
//  AlertCenterController.swift
//  Demo
//
//  Created by zgjff on 2022/7/29.
//

import UIKit

class AlertCenterController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .random()
        preferredContentSize = CGSize(width: view.bounds.width - 100, height: 300)
    }
}

extension AlertCenterController: JJBlockRouterDestination {
    func showDetail(withMatchRouterResult result: JJBlockRouter.MatchResult, from sourceController: UIViewController) {
        let pd = AlertPresentationController(show: self, from: sourceController) { ctx in
            ctx.usingBlurBelowCoverAnimators(style: .regular)
        }
        transitioningDelegate = pd
        sourceController.present(self, animated: true) {
            let _ = pd
        }
    }
}
