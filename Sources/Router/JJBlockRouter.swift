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
    public typealias UnmatchHandler = ((_ source: JJBlockRouter.MatchResult.Source, _ context: Any?) -> Void)
    public typealias MatchedHandler = (_ matchResult: MatchResult) -> (UIViewController?) -> Void
    
    /// 默认的路由管理
    public static let `default` = JJBlockRouter { source, context in
        debugPrint("⚠️⚠️⚠️JJBlockRouter 未匹配到 source: \(source), context: \(String(describing: context))")
    }
    
    /// app的`KeyWindow`,如果不使用框架提供的`version_keyWindow`,你可以提供自己实现的`appKeyWindow`
    ///
    /// 但是要注意在设置完`AppDelegate`的`window?.makeKeyAndVisible()`之后,否则此时获取不到window
    /// 用来获取app的最顶层的控制器
    public lazy var appKeyWindow: () -> UIWindow? = { 
        return UIApplication.shared.version_keyWindow
    }
    
    private let routes: Routes
    private let defaultUnmatchHandler: UnmatchHandler?
    private var routeHandlerMappings: [String: MatchedHandler] = [:]
    
    /// 初始化路由管理器
    /// - Parameter defaultUnmatchHandler: 匹配不到路由的回调
    public init(defaultUnmatchHandler: UnmatchHandler? = nil) {
        self.defaultUnmatchHandler = defaultUnmatchHandler
        routes = SyncRoutes()
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
            let tp = pattern.trimmingCharacters(in: .whitespacesAndNewlines)
            let route = try routes.register(pattern: tp)
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
    
    /// 使用默认的全局路由管理器注册路由
    /// - Parameters:
    ///   - pattern: 路由path
    ///   - mapRouter: 映射匹配到的路由来源----给匹配到路由时,最后决定跳转的策略(可在此处映射其他路由)
    public static func register(pattern: String, mapRouter: @escaping (_ matchResult: MatchResult) -> JJBlockRouterSource?) throws {
        try JJBlockRouter.default.register(pattern: pattern, mapRouter: mapRouter)
    }
}

// MARK: - open
extension JJBlockRouter {
    /// 匹配泛型`JJBlockRouterSource`并跳转路由
    /// - Parameters:
    ///   - source: 路由来源
    ///   - context: 传递给匹配到的路由界面数据
    ///   - unmatchHandler: 未匹配到路由时的回调
    /// - Returns: 路由打开成功
    @discardableResult
    public func open<T>(_ source: T, context: Any? = nil, unmatchHandler: UnmatchHandler? = nil) throws -> OpenSuccess where T: JJBlockRouterSource {
        guard let matchHandler = routeHandlerMappings[source.routerPattern] else {
            let expectUnmatchHandler = unmatchHandler ?? defaultUnmatchHandler
            expectUnmatchHandler?(.route(source), context)
            throw OpenFailure(source: .route(source))
        }
        let mresult = JJBlockRouter.MatchResult(source: .route(source), parameters: source.routerParameters, context: context)
        return OpenSuccess(matchedResult: mresult, matchedHandler: matchHandler)
    }
    
    /// 使用默认的全局路由管理器匹配泛型`JJBlockRouterSource`并跳转路由
    /// - Parameters:
    ///   - source: 路由来源
    ///   - context: 传递给匹配到的路由界面数据
    ///   - unmatchHandler: 未匹配到路由时的回调
    /// - Returns: 路由打开成功
    @discardableResult
    public static func open<T>(_ source: T, context: Any? = nil, unmatchHandler: UnmatchHandler? = nil) throws -> OpenSuccess where T: JJBlockRouterSource {
        return try JJBlockRouter.default.open(source, context: context, unmatchHandler: unmatchHandler)
    }
    
    /// 匹配`path`并跳转路由
    /// - Parameters:
    ///   - path: 路由path
    ///   - context: 传递给匹配到的路由界面数据
    ///   - unmatchHandler: 未匹配到路由时的回调
    /// - Returns: 路由打开成功
    @discardableResult
    public func open(_ path: String, context: Any? = nil, unmatchHandler: UnmatchHandler? = nil) throws -> OpenSuccess {
        let tp = path.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let url = URL(string: tp) else {
            let u = URL(string: "/app/path/errors")!
            let expectUnmatchHandler = unmatchHandler ?? defaultUnmatchHandler
            expectUnmatchHandler?(.url(u), context)
            throw OpenFailure(source: .url(u))
        }
        return try open(url, context: context, unmatchHandler: unmatchHandler)
    }
    
    /// 使用默认的全局路由管理器匹配`path`并跳转路由
    /// - Parameters:
    ///   - path: 路由path
    ///   - context: 传递给匹配到的路由界面数据
    ///   - unmatchHandler: 未匹配到路由时的回调
    /// - Returns: 路由打开成功
    @discardableResult
    public static func open(_ path: String, context: Any? = nil, unmatchHandler: UnmatchHandler? = nil) throws -> OpenSuccess {
        return try JJBlockRouter.default.open(path, context: context, unmatchHandler: unmatchHandler)
    }

    /// 匹配`URL`并跳转路由
    /// - Parameters:
    ///   - path: 路由path
    ///   - context: 传递给匹配到的路由界面数据
    ///   - unmatchHandler: 未匹配到路由时的回调
    /// - Returns: 路由打开成功
    @discardableResult
    public func open(_ url: URL, context: Any? = nil, unmatchHandler: UnmatchHandler? = nil) throws -> OpenSuccess {
        let result = routes.match(url)
        switch result {
        case .failure:
            let expectUnmatchHandler = unmatchHandler ?? defaultUnmatchHandler
            expectUnmatchHandler?(.url(url), context)
            throw OpenFailure(source: .url(url))
        case .success(let route):
            guard let matchHandler = routeHandlerMappings[route.pattern] else {
                let expectUnmatchHandler = unmatchHandler ?? defaultUnmatchHandler
                expectUnmatchHandler?(.url(url), context)
                throw OpenFailure(source: .url(url))
            }
            let mresult = JJBlockRouter.MatchResult(source: .url(route.url), parameters: route.parameters, context: context)
            return OpenSuccess(matchedResult: mresult, matchedHandler: matchHandler)
        }
    }
    
    /// 匹配`URL`并跳转路由
    /// - Parameters:
    ///   - path: 路由path
    ///   - context: 传递给匹配到的路由界面数据
    ///   - unmatchHandler: 未匹配到路由时的回调
    /// - Returns: 路由打开成功
    @discardableResult
    public static func open(_ url: URL, context: Any? = nil, unmatchHandler: UnmatchHandler? = nil) throws -> OpenSuccess {
        return try JJBlockRouter.default.open(url, context: context, unmatchHandler: unmatchHandler)
    }
}

// MARK: - CustomDebugStringConvertible, CustomStringConvertible
extension JJBlockRouter: CustomDebugStringConvertible, CustomStringConvertible {
    public var description: String {
        return routes.description
    }

    public var debugDescription: String {
        return description
    }
}
