//
//  ShowMatchRouterable.swift
//  Demo
//
//  Created by 郑桂杰 on 2022/8/27.
//

import UIKit

protocol ShowMatchRouterable: UIViewController {
    func showMatchResult(_ result: JJBlockRouter.MatchResult?)
}

extension ShowMatchRouterable {
    func showMatchResult(_ result: JJBlockRouter.MatchResult?) {
        guard let result = result else {
            return
        }
        let l = UILabel()
        l.numberOfLines = 0
        l.text = result.description
        let size = l.sizeThatFits(CGSize(width: self.view.bounds.width - 50, height: self.view.bounds.height))
        l.frame = CGRect(x: 0, y: 0 , width: size.width, height: size.height)
        l.center = view.center
        view.addSubview(l)
    }
}
