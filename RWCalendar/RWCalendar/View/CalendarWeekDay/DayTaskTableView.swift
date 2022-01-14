//
//  DayTaskTableView.swift
//  RWCalendar
//
//  Created by Baichao Ye on 2022/1/14.
//

import SwiftUI

struct DayTaskTableView: View {
    @EnvironmentObject var store: AppStore<AppState, AppAction, AppEnvironment>
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
                            }
                        }

                        ForEach(13...24, id: \.self) { row in
                            HStack {
                                Text("\(row) : 00 PM")
                                    .font(.footnote)
                                //                            Text("dsadadsadas")
                            }
                        }

                    }.frame(width: geo.frame(in: .local).width/4)

                    Circle()
                        .fill(Color.red)
                        .offset(CGSize(width: geo.frame(in: .global).width/4, height: 200))
                }
            }
//            }.frame(height:geo.size.height * 4)
//                .border(Color.red)
        }
    }
}

struct DayTaskTableView_Previews: PreviewProvider {
    static var previews: some View {
        DayTaskTableView()
    }
}
