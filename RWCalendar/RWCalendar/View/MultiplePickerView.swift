//
//  MultiplePickerView.swift
//  RWCalendar
//
//  Created by Kasumigaoka Utaha on 22.01.22.
//

import SwiftUI

struct MultiplePickerView<SelectionValue: Hashable>: View {
    
    private var selection: Binding<SelectionValue>
    private let models: [PickerModel<SelectionValue>]
    
    init(selection: Binding<SelectionValue>, pickerModels models: [PickerModel<SelectionValue>]) {
        self.selection = selection
        self.models = models
    }

    var body: some View {
        Form {
            ForEach(models) { model in
                if let title = model.headerTitle {
                    Section {
                        makePicker(for: model)
                    } header: {
                        Text(title)
                    }
                } else {
                    Section {
                        makePicker(for: model)
                    }
                }
            }
        }
    }
    
    func makePicker(for model: PickerModel<SelectionValue>) -> some View {
        Picker("", selection: selection) {
            ForEach(model.labels, id: \.self) { label in
                Text(label)
                    .tag(model.tag(for: label))
            }
        }
        .pickerStyle(.inline)
        .labelsHidden()
    }
}
