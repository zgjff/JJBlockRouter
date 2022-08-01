//
//  PassParameterByEnumController.swift
//  Demo
//
//  Created by 郑桂杰 on 2022/8/1.
//

import UIKit

class PassParameterByEnumController: UIViewController {
    private let p: String
    private let q: Int
    init(p: String, q: Int) {
        self.p = p
        self.q = q
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .random()
        title = "p: \(p), q: \(q)"
        print("p: \(p), q: \(q)")
    }
}

extension PassParameterByEnumController: JJBlockRouterDestination {
    func showDetail(withMatchRouterResult result: JJBlockRouter.MatchResult, from sourceController: UIViewController) {
        sourceController.navigationController?.pushViewController(self, animated: true)
    }
}
