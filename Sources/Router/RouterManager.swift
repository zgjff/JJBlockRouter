//
//  RouterManager.swift
//  Demo
//
//  Created by zgjff on 2022/7/29.
//

import Foundation

internal final class RouterManager {
    private var routes: Set<JJBlockRouter.Route> = []
    private let scanner = JJBlockRouter.Scanner()
}

extension RouterManager {
    @discardableResult
    func register(pattern: String) throws -> JJBlockRouter.Route {
        let tokens = scanner.tokenize(pattern: pattern)
        if tokens.isEmpty {
            throw RegisterRouteError.emptyPattern
        }
        let route = JJBlockRouter.Route(pattern: pattern, tokens: tokens)
        let (success, member) = routes.insert(route)
        if !success {
            throw RegisterRouteError.alreadyExists(oldRoute: member)
        }
        return route
    }
    
    func match(_ url: URL) -> RouteMatchResult?  {
        if routes.isEmpty {
            return nil
        }
        var pattern = url.path
        if let query = url.query {
            pattern.append("?\(query)")
        }
        if let fragment = url.fragment {
            pattern.append("#\(fragment)")
        }
        let utokens = scanner.tokenize(pattern: pattern)
        if utokens.isEmpty {
            return nil
        }
        var route = routes.makeIterator()
        var matchResult: RouteMatchResult?
        while let b = route.next() {
            if let mathed = b.match(target: utokens) {
                matchResult = RouteMatchResult(pattern: mathed.pattern, url: url, parameters: mathed.parameter)
                break
            }
        }
        return matchResult
    }
}

extension RouterManager {
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
}

extension RouterManager: CustomStringConvertible {
    var description: String {
        let desc: String = routes.reduce("") { result, token in
            if result.isEmpty {
                return token.description
            }
            return "\(result),\n\(token.description)"
        }
        return "[\n\(desc)\n]"
    }
}
