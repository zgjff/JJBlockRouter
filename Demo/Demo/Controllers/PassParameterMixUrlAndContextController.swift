//
//  PassParameterMixUrlAndContextController.swift
//  Demo
//
//  Created by zgjff on 2022/7/29.
//

import UIKit

class PassParameterMixUrlAndContextController: UIViewController {
    private var parameters: [String: String] = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .random()
        print("parameters: ", parameters)
    }
}

extension PassParameterMixUrlAndContextController: JJBlockRouterDestination {
    func showDetail(withMatchRouterResult result: JJBlockRouter.MatchResult, from sourceController: UIViewController) {
        guard let needShow = result.context as? Bool, needShow else {
            return
        }
        parameters = result.parameters
        sourceController.navigationController?.pushViewController(self, animated: true)
    }
}
