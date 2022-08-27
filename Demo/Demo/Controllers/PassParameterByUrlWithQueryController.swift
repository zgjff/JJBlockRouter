//
//  PassParameterByUrlWithQueryController.swift
//  Demo
//
//  Created by zgjff on 2022/7/29.
//

import UIKit

class PassParameterByUrlWithQueryController: UIViewController, ShowMatchRouterable {
    private var parameters: [String: String] = [:]
    private var result: JJBlockRouter.MatchResult?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .random()
        print("parameters: ", parameters)
        showMatchResult(result)
    }
}

extension PassParameterByUrlWithQueryController: JJBlockRouterDestination {
    func showDetail(withMatchRouterResult result: JJBlockRouter.MatchResult, from sourceController: UIViewController) {
        self.result = result
        parameters = result.parameters
        sourceController.navigationController?.pushViewController(self, animated: true)
    }
}
