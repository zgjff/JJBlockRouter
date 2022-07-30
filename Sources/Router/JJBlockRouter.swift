//
//  JJBlockRouter.swift
//  JJBlockRouter
//
//  Created by zgjff on 2022/6/10.
//

import Foundation
import UIKit

/// 路由管理
public final class JJBlockRouter {
    public typealias UnmatchHandler = ((_ url: URL, _ context: Any?) -> Void)
    public typealias MatchedHandler = (_ matchResult: MatchResult) -> (UIViewController?) -> Void
    
    /// 默认的路由管理
    public static let `default` = JJBlockRouter { url, context in
        debugPrint("⚠️⚠️⚠️JJBlockRouter 未匹配到 url: \(url), context: \(String(describing: context))")
    }
    
    /// app的`KeyWindow`,如果感觉框架提供的`version_keyWindow`有问题的话,你可以提供自己实现的`appKeyWindow`
    ///
    /// 用来获取app的最顶层的控制器
    public lazy var appKeyWindow: () -> UIWindow? = { 
        return UIApplication.shared.version_keyWindow
    }
    
    private let manager = RouterManager()
    private let defaultUnmatchHandler: UnmatchHandler?
    private var routeHandlerMappings: [String: MatchedHandler] = [:]
    public init(defaultUnmatchHandler: UnmatchHandler? = nil) {
        self.defaultUnmatchHandler = defaultUnmatchHandler
    }
}

// MARK: - register
extension JJBlockRouter {
    /// 注册路由
    /// - Parameters:
    ///   - pattern: 路由path
    ///   - mapRouter: 映射匹配到的路由来源----给匹配到路由时,最后决定跳转的策略(可在此处映射其他路由)
    public func register(pattern: String, mapRouter: @escaping (_ matchResult: MatchResult) -> JJBlockRouterSource?) throws {
        do {
            let route = try manager.register(pattern: pattern)
            routeHandlerMappings[route.pattern] = { matchResult in
                guard let mrd = mapRouter(matchResult) else {
                    return { _ in }
                }
                let dest = mrd.makeRouterDestination(parameters: matchResult.parameters, context: matchResult.context)
                return { sourceController in
                    dest.deal(withMatchedResult: matchResult, from: sourceController)
                }
            }
        } catch {
            throw error
        }
    }
}

// MARK: - open
extension JJBlockRouter {
    /// 匹配泛型`JJBlockRouterSource`并跳转路由
    /// - Parameters:
    ///   - source: 路由来源
    ///   - context: 传递给匹配到的路由界面数据
    /// - Returns: 匹配结果block
    @discardableResult
    public func open<T>(_ source: T, context: Any? = nil, unmatchHandler: UnmatchHandler? = nil) -> (UIViewController?) -> JJBlockRouter.MatchResult? where T: JJBlockRouterSource {
        return open(source.routerPattern, context: context, unmatchHandler: unmatchHandler)
    }
    
    /// 匹配`path`并跳转路由
    /// - Parameters:
    ///   - source: 路由来源
    ///   - context: 传递给匹配到的路由界面数据
    /// - Returns: 匹配结果block
    @discardableResult
    public func open(_ path: String, context: Any? = nil, unmatchHandler: UnmatchHandler? = nil) -> (UIViewController?) -> JJBlockRouter.MatchResult? {
        guard let url = URL(string: path) else {
            return { _ in nil }
        }
        return open(url, context: context, unmatchHandler: unmatchHandler)
    }

    /// 匹配`URL`并跳转路由
    /// - Parameters:
    ///   - url: 路由url
    ///   - context: 传递给匹配到的路由界面数据
    ///   - unmatchHandler: 未匹配到路由时
    /// - Returns: 匹配结果block
    @discardableResult
    public func open(_ url: URL, context: Any? = nil, unmatchHandler: UnmatchHandler? = nil) -> (UIViewController?) -> JJBlockRouter.MatchResult? {
        guard let route = manager.match(url),
              let matchHandler = routeHandlerMappings[route.pattern] else {
            let expectUnmatchHandler = unmatchHandler ?? defaultUnmatchHandler
                expectUnmatchHandler?(url, context)
            return { _ in nil }
        }
        let result = JJBlockRouter.MatchResult(url: route.url, parameters: route.parameters, context: context)
        return { fromController in
            matchHandler(result)(fromController)
            return result
        }
    }
}

// MARK: - CustomDebugStringConvertible, CustomStringConvertible
extension JJBlockRouter: CustomDebugStringConvertible, CustomStringConvertible {
    public var description: String {
        return manager.description
    }

    public var debugDescription: String {
        return description
    }
}
