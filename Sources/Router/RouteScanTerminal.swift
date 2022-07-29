//
//  RouteScanTerminal.swift
//  Demo
//
//  Created by zgjff on 2022/7/29.
//

import Foundation

extension JJBlockRouter.Scanner {
    internal enum Terminal {
        /// /
        case slash
        /// ?
        case query
        /// =
        case equal
        /// &
        case and
        /// :
        case variable
        /// #
        case fragment
        case letters(_ value: String)
    }
}
