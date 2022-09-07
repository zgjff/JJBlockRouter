//
//  MapBlockController.swift
//  Demo
//
//  Created by zgjff on 2022/7/29.
//

import UIKit

class MapBlockController: UIViewController, ShowMatchRouterable {
    private var result: JJBlockRouter.MatchResult?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "映射"
        view.backgroundColor = .jj_random()
        showMatchResult(result)
    }
}

extension MapBlockController: JJBlockRouterDestination {
    func showDetail(withMatchRouterResult result: JJBlockRouter.MatchResult, from sourceController: UIViewController) {
        self.result = result
        sourceController.present(self, animated: true)
    }
}
