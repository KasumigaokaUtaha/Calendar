//
//  CompactCalendarMonthView.swift
//  RWCalendar
//
//  Created by Kasumigaoka Utaha on 04.01.22.
//

import SwiftUI

/// A custom view that displays all days in a calendar month in a compact way.
struct CompactCalendarMonthView: UIViewRepresentable {
    let font: UIFont
    let lastMonthDays: [String]
    let currMonthDays: [String]
    let nextMonthDays: [String]
    let showLastMonthDays = false
    let showNextMonthDays = false

    func makeUIView(context _: Context) -> RWCompactCalendarMonthView {
        let view = RWCompactCalendarMonthView()
        view.font = font
        view.lastMonthDays = lastMonthDays
        view.currMonthDays = currMonthDays
        view.nextMonthDays = nextMonthDays
        view.showLastMonthDays = showLastMonthDays
        view.showNextMonthDays = showNextMonthDays

        return view
    }

    func updateUIView(_ uiView: RWCompactCalendarMonthView, context _: Context) {
        uiView.setNeedsDisplay()
    }

    typealias UIViewType = RWCompactCalendarMonthView

    class RWCompactCalendarMonthView: UIView {
        enum Tense {
            case past, current, future
        }

        private var maxItemSize: CGSize

        var font: UIFont
        var lastMonthDays: [String] {
            didSet {
                let maxItemSize = computeAndUpdateItemSizes(for: lastMonthDays)
                let maxWidth = max(self.maxItemSize.width, maxItemSize.width)
                let maxHeight = max(self.maxItemSize.height, maxItemSize.height)
                self.maxItemSize = CGSize(width: maxWidth, height: maxHeight)
            }
        }

        var currMonthDays: [String] {
            didSet {
                let maxItemSize = computeAndUpdateItemSizes(for: currMonthDays)
                let maxWidth = max(self.maxItemSize.width, maxItemSize.width)
                let maxHeight = max(self.maxItemSize.height, maxItemSize.height)
                self.maxItemSize = CGSize(width: maxWidth, height: maxHeight)
            }
        }

        var nextMonthDays: [String] {
            didSet {
                let maxItemSize = computeAndUpdateItemSizes(for: nextMonthDays)
                let maxWidth = max(self.maxItemSize.width, maxItemSize.width)
                let maxHeight = max(self.maxItemSize.height, maxItemSize.height)
                self.maxItemSize = CGSize(width: maxWidth, height: maxHeight)
            }
        }

        var showLastMonthDays = false
        var showNextMonthDays = false

        var itemSizes: [String: CGSize]
        var hSpacing: CGFloat = 4.0
        var vSpacing: CGFloat = 4.0
        var edgeInsets: UIEdgeInsets = .init(top: 4.0, left: 0.0, bottom: 4.0, right: 0.0)

        override var intrinsicContentSize: CGSize {
            let allDaysCount = lastMonthDays.count + currMonthDays.count + nextMonthDays.count
            let rows = (Double(allDaysCount) / 7.0).rounded(.up)
            let height = rows * maxItemSize.height + (rows - 1.0) * vSpacing
            let width = maxItemSize.width * 7 + 6.0 * hSpacing
            let horizontalInsets = edgeInsets.left + edgeInsets.right
            let verticalInsets = edgeInsets.top + edgeInsets.bottom
            return CGSize(width: width + horizontalInsets, height: height + verticalInsets)
        }

        override init(frame: CGRect) {
            maxItemSize = CGSize()
            font = .systemFont(ofSize: 10)
            lastMonthDays = []
            currMonthDays = []
            nextMonthDays = []
            itemSizes = [:]
            super.init(frame: frame)
            isOpaque = false
        }

        @available(*, unavailable)
        required init?(coder _: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func draw(_ rect: CGRect) {
            drawCompactCalendarMonth(rect)
        }

        private func computeAndUpdateItemSizes(for items: [String]) -> CGSize {
            var maxItemWidth = 0.0, maxItemHeight = 0.0
            for item in items {
                let size = NSString(string: item).size(withAttributes: [.font: font as Any])
                itemSizes.updateValue(size, forKey: item)

                maxItemWidth = max(maxItemWidth, size.width)
                maxItemHeight = max(maxItemHeight, size.height)
            }
            return CGSize(width: maxItemWidth, height: maxItemHeight)
        }

        private func drawCompactCalendarMonth(_ rect: CGRect) {
            let intrinsiContentOrigin = CGPoint(
                x: (rect.width - intrinsicContentSize.width) / 2.0,
                y: (rect.height - intrinsicContentSize.height) / 2.0
            )
            // Draw the content in the center
            let contentRect = CGRect(
                x: intrinsiContentOrigin.x + edgeInsets.left,
                y: intrinsiContentOrigin.y + edgeInsets.top,
                width: rect.width - edgeInsets.left - edgeInsets.right,
                height: rect.height - edgeInsets.top - edgeInsets.bottom
            )
            var maxItemOrigin = contentRect.origin, index = 1, count = 1
            var allDays: [(String, Tense)] = []

            for lastMonthDay in lastMonthDays {
                allDays.append((lastMonthDay, .past))
            }
            for currMonthDay in currMonthDays {
                allDays.append((currMonthDay, .current))
            }
            for nextMonthDay in nextMonthDays {
                allDays.append((nextMonthDay, .future))
            }

            for (day, tense) in allDays {
                let size = itemSizes[day]!
                let xOffset = (maxItemSize.width - size.width) / 2.0
                let yOffset = (maxItemSize.height - size.height) / 2.0
                let itemOrigin = CGPoint(x: maxItemOrigin.x + xOffset, y: maxItemOrigin.y + yOffset)
                let attributes: [NSAttributedString.Key: Any] = [
                    .font: font,
                    .foregroundColor: tense == .current ? UIColor.label : UIColor.secondaryLabel
                ]

                switch tense {
                case .past:
                    if showLastMonthDays {
                        NSString(string: day).draw(at: itemOrigin, withAttributes: attributes)
                    }
                case .current:
                    NSString(string: day).draw(at: itemOrigin, withAttributes: attributes)
                case .future:
                    if showNextMonthDays {
                        NSString(string: day).draw(at: itemOrigin, withAttributes: attributes)
                    }
                }

                if index != 7 {
                    maxItemOrigin.x += maxItemSize.width + hSpacing
                } else {
                    maxItemOrigin.x = contentRect.origin.x
                    maxItemOrigin.y = contentRect.origin.y + Double(count / 7) * (maxItemSize.height + vSpacing)
                }

                index = index == 7 ? 1 : index + 1
                count += 1
            }
        }
    }
}

struct CompactCalendarMonthView_Previews: PreviewProvider {
    static var previews: some View {
        CompactCalendarMonthView(
            font: .systemFont(ofSize: 10),
            lastMonthDays: (25 ... 30).map { "\($0)" },
            currMonthDays: (1 ... 31).map { "\($0)" },
            nextMonthDays: (1 ... 7).map { "\($0)" }
        )
    }
}
