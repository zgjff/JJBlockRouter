//
//  RouteScanner.swift
//  Demo
//
//  Created by zgjff on 2022/7/29.
//

import Foundation

extension JJBlockRouter {
    internal struct Scanner {
        /// 包含字符串+数字+特定字符的字符集(主要为了正确解析类似于 name1.3app_test 为一个字段属性)
        private let letterNumberMixSpecificSymbolCharacterSet: CharacterSet
        private let below13ContinueScanCharacterSet: CharacterSet
        init() {
            let specificSymbolCharacterSet = CharacterSet(charactersIn: "_.")
            letterNumberMixSpecificSymbolCharacterSet = CharacterSet.alphanumerics.union(specificSymbolCharacterSet)
            below13ContinueScanCharacterSet = CharacterSet(charactersIn: "!@#$^&%*+,:;='\"`<>()[]{}/\\| ")
        }
    }
}

extension JJBlockRouter.Scanner {
    func tokenize(pattern: String) -> [JJBlockRouter.RoutingPatternToken] {
        guard !pattern.isEmpty else {
            return []
        }
        let scanner = Foundation.Scanner(string: pattern)
        var builder = JJBlockRouter.PatternTokenBuilder()
        while !scanner.isAtEnd {
            if #available(iOS 13.0, *) {
                scanner_above13(using: scanner, into: &builder)
            } else {
                scanner_below13(using: scanner, into: &builder)
            }
        }
        return builder.build()
    }
}

private extension JJBlockRouter.Scanner {
    /// 高于13版本使用新api进行扫描
    @available(iOS 13.0, *)
    func scanner_above13(using scanner: Foundation.Scanner, into builder: inout JJBlockRouter.PatternTokenBuilder) {
        if let str = scanner.scanCharacters(from: letterNumberMixSpecificSymbolCharacterSet) {
            builder.appendLetters(str)
            return
        }
        if let _ = scanner.scanString("/") {
            builder.appendSlash()
            return
        }
        if let _ = scanner.scanString(":") {
            builder.appendVariable()
            return
        }
        if let _ = scanner.scanString("?") {
            builder.appendQuery()
            return
        }
        if let _ = scanner.scanString("=") {
            builder.appendEqual()
            return
        }
        if let _ = scanner.scanString("&") {
            builder.appendAnd()
            return
        }
        if let _ = scanner.scanString("#") {
            builder.appendFragment()
            return
        }
        let _ = scanner.scanCharacter()
    }
    
    /// 低于13版本使用老api进行扫描
    func scanner_below13(using scanner: Foundation.Scanner, into builder: inout JJBlockRouter.PatternTokenBuilder) {
        if #unavailable(iOS 13) {
            var str: NSString?
            if scanner.scanCharacters(from: letterNumberMixSpecificSymbolCharacterSet, into: &str) {
                if let str = str {
                    builder.appendLetters(str as String)
                }
                return
            }
            if scanner.scanString("/", into: &str) {
                if str != nil {
                    builder.appendSlash()
                }
                return
            }
            if scanner.scanString(":", into: &str) {
                if str != nil {
                    builder.appendVariable()
                }
                return
            }
            if scanner.scanString("?", into: &str) {
                if str != nil {
                    builder.appendQuery()
                }
                return
            }
            if scanner.scanString("=", into: &str) {
                if str != nil {
                    builder.appendEqual()
                }
                return
            }
            if scanner.scanString("&", into: &str) {
                if str != nil {
                    builder.appendAnd()
                }
                return
            }
            if scanner.scanString("#", into: &str) {
                if str != nil {
                    builder.appendFragment()
                }
                return
            }
            var hint: UInt32 = 0
            if scanner.scanHexInt32(&hint) {
                return
            }
            var doubleValue: Double = -1
            if scanner.scanHexDouble(&doubleValue) {
                return
            }
            if scanner.scanCharacters(from: below13ContinueScanCharacterSet, into: &str) {
                return
            }
        }
    }
}
