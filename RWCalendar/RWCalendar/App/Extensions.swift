//
//  Extensions.swift
//  RWCalendar
//
//  Created by Kasumigaoka Utaha on 20.01.22.
//

import Foundation

extension Sequence where Element == String {
    func toData() -> Data? {
        return try? JSONSerialization.data(withJSONObject: self, options: [])
    }
}

extension Data {
    func toStringArray() -> [String]? {
        return (try? JSONSerialization.jsonObject(with: self, options: []) as? [String])
    }
}
