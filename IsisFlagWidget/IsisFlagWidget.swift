// IsisFlagWidget.swift
import WidgetKit
import SwiftUI

struct FlagWidgetEntryView: View {
    let entry: FlagEntry

    var pretty_date: String {
        // Ensure the date string is in the expected format and has sufficient length
        let setDate = entry.status.set_date
        if setDate.count >= 16 {
            let time = setDate.prefix(16).suffix(5) // Extract "hh:mm" from "yyyy-MM-dd'T'hh:mm:ss"
            let date = setDate.prefix(10).suffix(5).replacingOccurrences(of: "-", with: "/")
            // replace "-" with "/" in date
            
            return "\(time), \(date)"
        }
        return ""
    }
    
    var body: some View {
        VStack {
            if !entry.status.notices.isEmpty {
                Text("Notices: \(entry.status.notices.joined(separator: ", "))")
                    .font(.caption)
            }

            Text("\(entry.status.set_by) at \(pretty_date)")
                .font(.caption)
        }
        .widgetBackground(colorForStatus(entry.status.status_text))
//        .cornerRadius(10)
    }
}



func colorForStatus(_ status: String) -> Color {
    switch status.lowercased() {
    case "red":
        return .red
    case "amber":
        return .orange
    case "dark blue":
        return Color.blue.opacity(0.8)
    case "light blue":
        return .blue
    case "green":
        return .green
    default:
        return .gray
    }
}

struct FlagEntry: TimelineEntry {
    let date: Date
    let status: FlagStatus
}

struct FlagProvider: TimelineProvider {
    func placeholder(in context: Context) -> FlagEntry {
        FlagEntry(date: Date(), status: FlagStatus(reach: "isis", status: "R", status_text: "Red", notices: ["No rowing"], set_date: "2024-11-24T16:14:53.675Z", set_by: "Firstname Lastname"))
    }

    func getSnapshot(in context: Context, completion: @escaping (FlagEntry) -> Void) {
        let entry = FlagEntry(date: Date(), status: FlagStatus(reach: "isis", status: "G", status_text: "Green", notices: [], set_date: "2024-11-24T16:14:53.675Z", set_by: "Firstname Lastname"))
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<FlagEntry>) -> Void) {
        fetchFlagStatus { status in
            let date = Date()
            let entry = FlagEntry(date: date, status: status ?? FlagStatus(reach: "isis", status: "R", status_text: "Red", notices: [], set_date: "", set_by: ""))
            let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(60 * 5))) // Update every 5 minutes
            completion(timeline)
        }
    }
}

@main
struct IsisFlagWidget: Widget {
    let kind: String = "IsisFlagWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: FlagProvider()) { entry in
            FlagWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Isis Flag Status")
        .description("Displays the current Isis (Thames) flag status.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}



extension View {
    func widgetBackground(_ backgroundView: some View) -> some View {
        if #available(iOSApplicationExtension 17.0, *) {
            return containerBackground(for: .widget) {
                backgroundView
            }
        } else {
            return background(backgroundView)
        }
    }
}
