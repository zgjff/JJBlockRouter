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
                    if let str = scanner.scanCharacters(from: .letters) {
                        builder.appendLetters(str)
                        continue
                    }
                    if let dvalue = scanner.scanDouble() {
                        let isInteger = floor(dvalue) == dvalue
                        builder.appendLetters(isInteger ? String(Int(dvalue)) : String(dvalue))
                        continue
                    }
                    if let _ = scanner.scanString("/") {
                        builder.appendSlash()
                        continue
                    }
                    if let _ = scanner.scanString(":") {
                        builder.appendVariable()
                        continue
                    }
                    if let _ = scanner.scanString("?") {
                        builder.appendQuery()
                        continue
                    }
                    if let _ = scanner.scanString("=") {
                        builder.appendEqual()
                        continue
                    }
                    if let _ = scanner.scanString("&") {
                        builder.appendAnd()
                        continue
                    }
                    if let _ = scanner.scanString("#") {
                        builder.appendFragment()
                        continue
                    }
                    let _ = scanner.scanCharacter()
                } else {
                    var str: NSString?
                    if scanner.scanCharacters(from: .letters, into: &str) {
                        if let str = str {
                            builder.appendLetters(str as String)
                        }
                        continue
                    }
                    var doubleValue: Double = -1
                    if scanner.scanDouble(&doubleValue) {
                        let isInteger = floor(doubleValue) == doubleValue
                        builder.appendLetters(isInteger ? String(Int(doubleValue)) : String(doubleValue))
                        continue
                    }
                    if scanner.scanString("/", into: &str) {
                        if str != nil {
                            builder.appendSlash()
                        }
                        continue
                    }
                    if scanner.scanString(":", into: &str) {
                        if str != nil {
                            builder.appendVariable()
                        }
                        continue
                    }
                    if scanner.scanString("?", into: &str) {
                        if str != nil {
                            builder.appendQuery()
                        }
                        continue
                    }
                    if scanner.scanString("=", into: &str) {
                        if str != nil {
                            builder.appendEqual()
                        }
                        continue
                    }
                    if scanner.scanString("&", into: &str) {
                        if str != nil {
                            builder.appendAnd()
                        }
                        continue
                    }
                    if scanner.scanString("#", into: &str) {
                        if str != nil {
                            builder.appendFragment()
                        }
                        continue
                    }
                    var hint: UInt32 = 0
                    if scanner.scanHexInt32(&hint) {
                        continue
                    }
                    if scanner.scanHexDouble(&doubleValue) {
                        continue
                    }
                    let cs = CharacterSet(charactersIn: "!@#$^&%*+,:;='\"`<>()[]{}/\\| ")
                    if scanner.scanCharacters(from: cs, into: &str) {
                        continue
                    }
                }
            }
            return builder.build()
        }
    }
}
