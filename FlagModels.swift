// FlagModels.swift

import Foundation

struct FlagStatus {
    var reach: String
    var status: String
    var status_text: String
    var notices: [String]
    var set_date: String
    var set_by: String
}

struct FlagEntry: Identifiable {
    let id = UUID()
    let date: Date
    let status: FlagStatus
}
