//
//  RouterOpenSuccess.swift
//  Demo
//
//  Created by 郑桂杰 on 2022/8/27.
//

import Foundation
import UIKit

extension JJBlockRouter {
    /// 路由跳转成功
    public struct OpenSuccess {
        private let matchedResult: MatchResult
        private let matchedHandler: MatchedHandler
        internal init(matchedResult: MatchResult, matchedHandler: @escaping MatchedHandler) {
            self.matchedResult = matchedResult
            self.matchedHandler = matchedHandler
        }
    }
}

extension JJBlockRouter.OpenSuccess {
    /// 开始跳转
    /// - Parameter from: 跳转源控制器
    @discardableResult
    public func jump(from sourceController: UIViewController?) -> JJBlockRouter.MatchResult {
        matchedHandler(matchedResult)(sourceController)
        return matchedResult
    }
}
