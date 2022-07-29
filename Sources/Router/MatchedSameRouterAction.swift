//
//  MatchedSameRouterAction.swift
//  JJBlockRouter
//
//  Created by zgjff on 2022/6/10.
//

import Foundation

extension JJBlockRouter {
    /// 匹配到的路由跟当前展示的界面相同时的操作
    public enum MatchedSameRouterDestinationAction {
        /// 不做任何操作
        case none
        /// 更新数据
        case update
        /// 展示新界面
        case new
    }
}
