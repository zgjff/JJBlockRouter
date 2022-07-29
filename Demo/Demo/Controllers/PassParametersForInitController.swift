//
//  PassParametersForInitController.swift
//  Demo
//
//  Created by zgjff on 2022/7/30.
//

import UIKit

class PassParametersForInitController: UIViewController {
    private let pid: Int
    
    init(id: Int) {
        pid = id
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .random()
        title = "\(pid)"
        print("pid: ", pid)
    }
}

extension PassParametersForInitController: JJBlockRouterDestination {
    func showDetail(withMatchRouterResult result: JJBlockRouter.MatchResult, from sourceController: UIViewController) {
        sourceController.navigationController?.pushViewController(self, animated: true)
    }
}
