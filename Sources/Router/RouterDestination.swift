//
//  JJBlockRouterDestination.swift
//  JJBlockRouter
//
//  Created by zgjff on 2022/6/10.
//

import UIKit

/// 匹配成功后的路由目标界面
public protocol JJBlockRouterDestination {
    /// 当匹配到的路由跟当前展示的界面相同时的操作方法,默认返回`new`
    ///
    /// 返回`none`时,不做任何操作
    ///
    /// 返回`update`时,会调用`updateWhenRouterIdentifierIsSame`方法来更新当前界面
    ///
    /// 返回`new`时,会调用`showDetail`来重新展示新的界面
    /// - Parameter result: 匹配结果
    func actionWhenMatchedRouterDestinationSameToCurrent(withNewMatchRouterResult result: JJBlockRouter.MatchResult) -> JJBlockRouter.MatchedSameRouterDestinationAction
    
    /// 当当前界面为路由匹配到的界面时,并且当前控制器跟匹配到的控制器一致时的操作
    func updateWhenRouterIdentifierIsSame(withNewMatchRouterResult result: JJBlockRouter.MatchResult)
    
    /// 显示匹配到的界面逻辑
    func showDetail(withMatchRouterResult result: JJBlockRouter.MatchResult, from sourceController: UIViewController)
}

extension JJBlockRouterDestination {
    public func actionWhenMatchedRouterDestinationSameToCurrent(withNewMatchRouterResult result: JJBlockRouter.MatchResult) -> JJBlockRouter.MatchedSameRouterDestinationAction {
        return .new
    }
    
    public func updateWhenRouterIdentifierIsSame(withNewMatchRouterResult result: JJBlockRouter.MatchResult) {}
    
    /// 处理路由匹配到的界面
    /// - Parameter result: 匹配结果
    func deal(withMatchedResult result: JJBlockRouter.MatchResult, from sourceController: UIViewController?) {
        let fromController = sourceController ?? UIApplication.shared.topViewController(JJBlockRouter.default.appKeyWindow()?.rootViewController)
        guard let tvc = fromController else {
            return
        }
        if type(of: tvc) != type(of: self) {
            return showDetail(withMatchRouterResult: result, from: tvc)
        }
        switch actionWhenMatchedRouterDestinationSameToCurrent(withNewMatchRouterResult: result) {
        case .none:
            return
        case .update:
            if let rvc = tvc as? JJBlockRouterDestination {
                rvc.updateWhenRouterIdentifierIsSame(withNewMatchRouterResult: result)
            }
        case .new:
            showDetail(withMatchRouterResult: result, from: tvc)
        }
    }
}
