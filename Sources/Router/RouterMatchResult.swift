//
//  JJBlockRouterMatchResult.swift
//  JJBlockRouter
//
//  Created by zgjff on 2022/6/10.
//

import Foundation

extension JJBlockRouter {
    /// 路由匹配结果
    public final class MatchResult {
        public let url: URL
        public let parameters: [String: String]
        public let context: Any?
        private var destinationBlocks: NSMapTable<NSString, JJBlockRouter.Closure<Any, Void>> = .strongToStrongObjects()
        
        public init(url: URL, parameters: [String: String], context: Any?) {
            self.url = url
            self.parameters = parameters
            self.context = context
        }
        
        deinit {
            destinationBlocks.removeAllObjects()
        }
    }
}

extension JJBlockRouter.MatchResult {
    /// 注册路由`block`回调
    /// - Parameters:
    ///   - key: 回调`block`名称
    ///   - callback: 回调`block`
    public func register(blockName key: String, callback: @escaping (Any) -> Void) {
        destinationBlocks.setObject(JJBlockRouter.Closure<Any, Void>(callback), forKey: key as NSString)
    }
    
    /// 向已经注册的对应回调`block`中进行数据回调
    /// - Parameters:
    ///   - key: 已经注册的回调名称
    ///   - object: 回调数据
    public func perform(blockName key: String, withObject object: Any?) {
        if let value = destinationBlocks.object(forKey: key as NSString) {
            if let obj = object {
                value.closure(obj)
            } else {
                value.closure(())
            }
        }
    }
}

extension JJBlockRouter.MatchResult: CustomDebugStringConvertible, CustomStringConvertible {
    public var description: String {
        if destinationBlocks.count == 0 {
            return """
            RouterMatchResult {
              url: \(url)
              parameters: \(parameters)
              context: \(String(describing: context))
            }
            """
        }
        return """
        RouterMatchResult {
          url: \(url)
          parameters: \(parameters)
          context: \(String(describing: context))
          blocks: \(destinationBlocks)
        }
        """
    }

    public var debugDescription: String {
        return description
    }
}

extension JJBlockRouter {
    final fileprivate class Closure<T, U> {
        let closure: (T) -> U
        init(_ closure: @escaping (T) -> U) {
            self.closure = closure
        }
    }
}
