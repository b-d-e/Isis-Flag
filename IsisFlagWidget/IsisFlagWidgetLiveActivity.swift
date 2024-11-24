//
//  IsisFlagWidgetLiveActivity.swift
//  IsisFlagWidget
//
//  Created by B E on 24/11/2024.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct IsisFlagWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct IsisFlagWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: IsisFlagWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension IsisFlagWidgetAttributes {
    fileprivate static var preview: IsisFlagWidgetAttributes {
        IsisFlagWidgetAttributes(name: "World")
    }
}

extension IsisFlagWidgetAttributes.ContentState {
    fileprivate static var smiley: IsisFlagWidgetAttributes.ContentState {
        IsisFlagWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: IsisFlagWidgetAttributes.ContentState {
         IsisFlagWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: IsisFlagWidgetAttributes.preview) {
   IsisFlagWidgetLiveActivity()
} contentStates: {
    IsisFlagWidgetAttributes.ContentState.smiley
    IsisFlagWidgetAttributes.ContentState.starEyes
}
