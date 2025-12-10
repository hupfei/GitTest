//
//  DemoWidget.swift
//  DemoWidget
//
//  Created by hupfei on 2025/9/26.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), emoji: "😀")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), emoji: "😀")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, emoji: "😀")
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let emoji: String
}

struct DemoWidgetEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) private var family
    
    var body: some View {
        switch family {
        case .accessoryInline:
            HStack {
                Image(systemName: "brain.head.profile")
                    .padding(.trailing, 5)
                Text("iOS 新知 锁屏小组件")
            }
            
        case .accessoryRectangular:
            VStack {
                Image(systemName: "brain.head.profile")
                    .padding(.bottom, 5)
                Text("iOS 新知")
                Text("锁屏小组件")
            }
            
        default:
            Text("iOS 新知")
        }
    }
}

struct DemoWidget: Widget {
    let kind: String = "DemoWidget"

    var body: some WidgetConfiguration {
            StaticConfiguration(kind: kind, provider: Provider()) { entry in
                DemoWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            }
            .configurationDisplayName("锁屏小组件")
            .description("这是一个锁屏小组件 demo")
            .supportedFamilies([.systemSmall, .accessoryRectangular, .accessoryInline])
        }
}
