//
//  FrontBlockAController.swift
//  Demo
//
//  Created by zgjff on 2022/7/29.
//

import UIKit

class FrontBlockAController: UIViewController {
    private var timer: Timer?
    private var data = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "A"
        view.backgroundColor = .random()
        let b = UIButton()
        b.backgroundColor = .random()
        b.frame = CGRect(x: 0, y: 0, width: view.bounds.width - 160, height: 44)
        b.center = view.center
        b.addTarget(self, action: #selector(onClick), for: .primaryActionTriggered)
        view.addSubview(b)
        let t = Timer(timeInterval: 2, repeats: true, block: { [weak self] _ in
            if let self = self {
                self.data += 12
                self.title = "A: \(self.data)"
            }
        })
        RunLoop.current.add(t, forMode: .common)
        timer = t
        timer?.fire()
    }
    
    @IBAction private func onClick() {
        // A跳转B, A通过路由block将实时数据回调给B
        // 主要用于,A的数据是实时变化的,B需要拿到A的最新数据
        let router = JJBlockRouter.default.open(BlockRouter.frontBlockB)(self)
        router?.register(blockName: "onNeedGetNewestData", callback: { [weak self] obj in
            guard let self = self,
                let block = obj as? (Int) -> () else {
                return
            }
            block(self.data)
        })
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
}

extension FrontBlockAController: JJBlockRouterDestination {
    func showDetail(withMatchRouterResult result: JJBlockRouter.MatchResult, from sourceController: UIViewController) {
        let navi = UINavigationController(rootViewController: self)
        sourceController.present(navi, animated: true)
    }
}
