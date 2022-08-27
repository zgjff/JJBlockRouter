//
//  RouteScanner.swift
//  Demo
//
//  Created by zgjff on 2022/7/29.
//

import Foundation

extension JJBlockRouter {
    internal struct Scanner {
        func tokenize(pattern: String) -> [RoutingPatternToken] {
            guard !pattern.isEmpty else {
                return []
            }
            let scanner = Foundation.Scanner(string: pattern)
            var builder = PatternTokenBuilder()
            while !scanner.isAtEnd {
                if #available(iOS 13.0, *) {
                    scanner_above13(using: scanner, into: &builder)
                } else {
                    scanner_below3(using: scanner, into: &builder)
                }
            }
            return builder.build()
        }
    }
}

private extension JJBlockRouter.Scanner {
    @available(iOS 13.0, *)
    func scanner_above13(using scanner: Foundation.Scanner, into builder: inout JJBlockRouter.PatternTokenBuilder) {
        if let str = scanner.scanCharacters(from: .letters) {
            builder.appendLetters(str)
            return
        }
        if let dvalue = scanner.scanDouble() {
            let isInteger = floor(dvalue) == dvalue
            builder.appendLetters(isInteger ? String(Int(dvalue)) : String(dvalue))
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
    
    func scanner_below3(using scanner: Foundation.Scanner, into builder: inout JJBlockRouter.PatternTokenBuilder) {
        if #unavailable(iOS 13) {
            var str: NSString?
            if scanner.scanCharacters(from: .letters, into: &str) {
                if let str = str {
                    builder.appendLetters(str as String)
                }
                return
            }
            var doubleValue: Double = -1
            if scanner.scanDouble(&doubleValue) {
                let isInteger = floor(doubleValue) == doubleValue
                builder.appendLetters(isInteger ? String(Int(doubleValue)) : String(doubleValue))
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
            if scanner.scanHexDouble(&doubleValue) {
                return
            }
            let cs = CharacterSet(charactersIn: "!@#$^&%*+,:;='\"`<>()[]{}/\\| ")
            if scanner.scanCharacters(from: cs, into: &str) {
                return
            }
        }
    }
}
