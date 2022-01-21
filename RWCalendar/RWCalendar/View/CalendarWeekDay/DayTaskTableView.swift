//
//  DayTaskTableView.swift
//  RWCalendar
//
//  Created by Baichao Ye on 2022/1/14.
//

import SwiftUI

struct DayTaskTableView: View {
    private var threeColumnGrid = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    var body: some View {
        GeometryReader { geo in
            ScrollView(.vertical, showsIndicators: false) {
                ZStack {
                    VStack(spacing: geo.size.height/14) {
                        ForEach(0...12, id: \.self) { row in
                            HStack {
                                Text("\(row) : 00 AM")
                                    .font(.footnote)
                                Spacer()
                            }
                        }.frame(width: geo.size.width/4, alignment: .leading)

                        ForEach(13...24, id: \.self) { row in
                            HStack {
                                Text("\(row) : 00 PM")
                                    .font(.footnote)
                                Spacer()
                            }
                        }

                        .frame(width: geo.size.width/4, alignment: .leading)
                    }
                    .frame(width: geo.frame(in: .local).width, alignment: .leading)

                    Text("IOS Swift")
                        .frame(width: 200, height: 100)
                        .background(Color.green)
                        .position(x: geo.size.width/2, y: 100)
                }
            }
        }
    }
}

struct DayTaskTableView_Previews: PreviewProvider {
    static let store: AppStore<AppState, AppAction, AppEnvironment> = AppStore(
        initialState: AppState(),
        reducer: appReducer,
        environment: AppEnvironment()
    )
    
    static var previews: some View {
        DayTaskTableView()
            .environmentObject(store)
    }
}
