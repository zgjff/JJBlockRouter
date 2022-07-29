//
//  LoginController.swift
//  Demo
//
//  Created by zgjff on 2022/7/29.
//

import UIKit

class LoginController: UIViewController {
    private var router: JJBlockRouter.MatchResult?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .random()
        title = "登录"
        let b = UIButton()
        b.setTitle("登录", for: [])
        b.backgroundColor = .random()
        b.frame = CGRect(x: 0, y: 0, width: view.bounds.width - 160, height: 44)
        b.center = view.center
        b.addTarget(self, action: #selector(onClick), for: .primaryActionTriggered)
        view.addSubview(b)
    }
    
    @IBAction private func onClick() {
        dismiss(animated: true) { [weak self] in
            self?.router?.perform(blockName: "loginSuccess", withObject: nil)
        }
    }
}

extension LoginController: JJBlockRouterDestination {
    func showDetail(withMatchRouterResult result: JJBlockRouter.MatchResult, from sourceController: UIViewController) {
        router = result
        sourceController.present(UINavigationController(rootViewController: self), animated: true)
    }
}
