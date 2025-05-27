//
//  String+.swift
//  EscapeSounds
//
//  Created by Manuel Pino Ros on 24/2/25.
//
import Foundation

//MARK: Localized extension to use when swift not find string. IE: when adding swiftData
extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }

    func localized(with args: CVarArg...) -> String {
        String(format: self.localized, arguments: args)
    }
}

struct Localized {
    static func string(_ key: String, _ args: CVarArg...) -> String {
        let format = NSLocalizedString(key, comment: "")
        return String(format: format, arguments: args)
    }
}
