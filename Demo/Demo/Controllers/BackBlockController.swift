//
//  BackBlockController.swift
//  Demo
//
//  Created by zgjff on 2022/7/29.
//

import UIKit

class BackBlockController: UIViewController {
    private var router: JJBlockRouter.MatchResult?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .random()
        let b = UIButton()
        b.backgroundColor = .random()
        b.frame = CGRect(x: 0, y: 0, width: view.bounds.width - 160, height: 44)
        b.center = view.center
        b.addTarget(self, action: #selector(onClick), for: .primaryActionTriggered)
        view.addSubview(b)
    }
    
    @IBAction private func onClick() {
        dismiss(animated: true) { [weak self] in
            self?.router?.perform(blockName: "onSend", withObject: 5)
        }
    }
}

extension BackBlockController: JJBlockRouterDestination {
    func showDetail(withMatchRouterResult result: JJBlockRouter.MatchResult, from sourceController: UIViewController) {
        router = result
        sourceController.present(self, animated: true)
    }
}
