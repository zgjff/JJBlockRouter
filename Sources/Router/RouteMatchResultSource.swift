//
//  RouteMatchResultSource.swift
//  Demo
//
//  Created by 郑桂杰 on 2022/8/27.
//

import Foundation

extension JJBlockRouter.MatchResult {
    /// 匹配来源
    public enum Source {
        /// 通过path或者url匹配
        case url(URL)
        /// 通过具体的协议对象匹配
        case route(JJBlockRouterSource)
    }
}

extension JJBlockRouter.MatchResult.Source: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        switch self {
        case .url(let url):
            return "url: \(url)"
        case .route(let route):
            return "route: \(route)"
        }
    }
    
    public var debugDescription: String {
        return description
    }
}
