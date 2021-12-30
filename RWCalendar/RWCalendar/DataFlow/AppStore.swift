//
//  AppStore.swift
//  RWCalendar
//
//  Created by Kasumigaoka Utaha on 27.12.21.
//

import Combine
import SwiftUI

class AppStore<State, Action, Environment>: ObservableObject {
    @Published private(set) var state: State

    private let environment: Environment
    private let reducer: Reducer<State, Action, Environment>
    private var cancellables: Set<AnyCancellable> = []

    init(initialState: State, reducer: @escaping Reducer<State, Action, Environment>, environment: Environment) {
        state = initialState
        self.reducer = reducer
        self.environment = environment
    }

    func send(_ action: Action) {
        guard let effect = reducer(&state, action, environment) else {
            return
        }

        effect
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: send)
            .store(in: &cancellables)
    }
}
