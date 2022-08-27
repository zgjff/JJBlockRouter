//
//  AlertCenterController.swift
//  Demo
//
//  Created by zgjff on 2022/7/29.
//

import UIKit

class AlertCenterController: UIViewController, ShowMatchRouterable {
    private var result: JJBlockRouter.MatchResult?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .random()
        preferredContentSize = CGSize(width: view.bounds.width - 100, height: 300)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        showMatchResult(result)
    }
}

extension AlertCenterController: JJBlockRouterDestination {
    func showDetail(withMatchRouterResult result: JJBlockRouter.MatchResult, from sourceController: UIViewController) {
        self.result = result
        let pd = AlertPresentationController(show: self, from: sourceController) { ctx in
            ctx.usingBlurBelowCoverAnimators(style: .dark)
        }
        transitioningDelegate = pd
        sourceController.present(self, animated: true) {
            let _ = pd
        }
    }
}
