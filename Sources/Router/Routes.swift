//
//  Routes.swift
//  Demo
//
//  Created by zgjff on 2022/7/30.
//

import Foundation

protocol Routes: CustomStringConvertible {
    func register(pattern: String) throws -> JJBlockRouter.Route
    func match(_ url: URL) -> Result<RouteMatchResult, MatchRouteError>
}

enum RegisterRouteError: Error, CustomStringConvertible {
    case emptyPattern
    case alreadyExists(oldRoute: JJBlockRouter.Route)
    
    var description: String {
        switch self {
        case .emptyPattern:
            return "路由格式为空"
        case .alreadyExists(let oldRoute):
            return "已经存在相同模式的路由: \(oldRoute)"
        }
    }
}

enum MatchRouteError: Error, CustomStringConvertible {
    case emptyRoutes
    case emptyPattern
    case notMatch
    
    var description: String {
        switch self {
        case .emptyRoutes:
            return "未注册路由"
        case .emptyPattern:
            return "路由格式为空"
        case .notMatch:
            return "没有匹配到路由"
        }
    }
}
