//
//  MapBlockController.swift
//  Demo
//
//  Created by zgjff on 2022/7/29.
//

import UIKit

class MapBlockController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "映射"
        view.backgroundColor = .random()
    }
}

extension MapBlockController: JJBlockRouterDestination {
    func showDetail(withMatchRouterResult result: JJBlockRouter.MatchResult, from sourceController: UIViewController) {
        sourceController.present(self, animated: true)
    }
}
