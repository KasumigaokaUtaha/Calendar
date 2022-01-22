//
//  PickerModel.swift
//  RWCalendar
//
//  Created by Kasumigaoka Utaha on 22.01.22.
//

import Foundation

struct PickerModel<V: Hashable>: Identifiable {
    let id: UUID = .init()
    let values: [String: V]
    let headerTitle: String?
    var labels: [String] {
        Array(values.keys).sorted {
            $0.localizedStandardCompare($1) == .orderedAscending
        }
    }

    func tag(for label: String) -> V {
        values[label]!
    }
}
