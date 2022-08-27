//
//  RouterOpenFailure.swift
//  Demo
//
//  Created by 郑桂杰 on 2022/8/27.
//

import Foundation

extension JJBlockRouter {
    /// 路由跳转失败
    public struct OpenFailure: Error {
        private let source: JJBlockRouter.MatchResult.Source
        internal init(source: JJBlockRouter.MatchResult.Source) {
            self.source = source
        }
    }
}

extension JJBlockRouter.OpenFailure: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        return "OpenFailure source: \(source)"
    }
    
    public var debugDescription: String {
        return description
    }
}
