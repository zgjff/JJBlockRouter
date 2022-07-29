//
//  JJBlockRouterSource.swift
//  JJBlockRouter
//
//  Created by zgjff on 2022/6/10.
//

import Foundation

/// 要匹配的路由来源
public protocol JJBlockRouterSource {
    /// 注册的路由path
    var routerPattern: String { get }
    
    /// 注册路由
    func register() throws

    /// 生成与路由匹配的跳转路由目标
    func makeRouterDestination(parameters: [String: String], context: Any?) -> JJBlockRouterDestination
}

extension JJBlockRouterSource {
    public func register() throws {
        return try JJBlockRouter.default.register(pattern: routerPattern) { _ in
            return self
        }
    }
}
