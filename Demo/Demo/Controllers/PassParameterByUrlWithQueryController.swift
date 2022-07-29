//
//  PassParameterByUrlWithQueryController.swift
//  Demo
//
//  Created by zgjff on 2022/7/29.
//

import UIKit

class PassParameterByUrlWithQueryController: UIViewController {
    private var parameters: [String: String] = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .random()
        print("parameters: ", parameters)
    }
}

extension PassParameterByUrlWithQueryController: JJBlockRouterDestination {
    func showDetail(withMatchRouterResult result: JJBlockRouter.MatchResult, from sourceController: UIViewController) {
        parameters = result.parameters
        sourceController.navigationController?.pushViewController(self, animated: true)
    }
}
