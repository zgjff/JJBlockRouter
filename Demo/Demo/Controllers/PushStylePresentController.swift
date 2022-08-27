//
//  PushStylePresentController.swift
//  Demo
//
//  Created by zgjff on 2022/7/29.
//

import UIKit

class PushStylePresentController: UIViewController, PushPopStylePresentDelegate, ShowMatchRouterable {
    private var result: JJBlockRouter.MatchResult?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .random()
        title = "PushPop Style Present"
        addScreenPanGestureDismiss()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(onClickClose))
        showMatchResult(result)
    }
    
    @IBAction private func onClickClose() {
        popStyleDismiss(completion: nil)
    }
}

extension PushStylePresentController: JJBlockRouterDestination {
    func showDetail(withMatchRouterResult result: JJBlockRouter.MatchResult, from sourceController: UIViewController) {
        self.result = result
        let navi = UINavigationController(rootViewController: self)
        navi.modalPresentationStyle = .fullScreen
        navi.transitioningDelegate = pushPopStylePresentDelegate
        sourceController.present(navi, animated: true)
    }
}
