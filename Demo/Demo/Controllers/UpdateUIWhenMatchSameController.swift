//
//  UpdateUIWhenMatchSameController.swift
//  Demo
//
//  Created by zgjff on 2022/7/30.
//

import UIKit

class UpdateUIWhenMatchSameController: UIViewController, ShowMatchRouterable {
    private var pid = 0
    private var result: JJBlockRouter.MatchResult?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "UpdateUIWhenMatchSame \(pid)"
        view.backgroundColor = .jj_random()
        let b = UIButton()
        b.backgroundColor = .jj_random()
        b.frame = CGRect(x: 0, y: 0, width: view.bounds.width - 160, height: 44)
        b.center = view.center
        b.addTarget(self, action: #selector(onClick), for: .primaryActionTriggered)
        view.addSubview(b)
        showMatchResult(result)
    }
    
    @IBAction private func onClick() {
        (try? JJBlockRouter.default.open("/app/updateUIMatchedSame/\(arc4random_uniform(100))"))?.jump(from: self)
    }
}

extension UpdateUIWhenMatchSameController: JJBlockRouterDestination {
    func showDetail(withMatchRouterResult result: JJBlockRouter.MatchResult, from sourceController: UIViewController) {
        self.result = result
        pid = parseId(from: result.parameters)
        let navi = UINavigationController(rootViewController: self)
        sourceController.present(navi, animated: true)
    }
    
    func actionWhenMatchedRouterDestinationSameToCurrent(withNewMatchRouterResult result: JJBlockRouter.MatchResult) -> JJBlockRouter.MatchedSameRouterDestinationAction {
        return .update
    }
    
    func updateWhenRouterIdentifierIsSame(withNewMatchRouterResult result: JJBlockRouter.MatchResult) {
        pid = parseId(from: result.parameters)
        title = "UpdateUIWhenMatchSame \(pid)"
        view.subviews.filter({ $0 is UILabel}).first?.removeFromSuperview()
        showMatchResult(result)
    }
    
    private func parseId(from parameters: [String: String]) -> Int {
        let idstr = parameters["id"] ?? ""
        let numberFormatter = NumberFormatter()
        let id = numberFormatter.number(from: idstr)?.intValue
        return id ?? 0
    }
}
