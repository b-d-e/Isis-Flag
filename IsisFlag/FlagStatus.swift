// FlagStatus.swift
import Foundation

struct FlagStatus: Decodable {
    let reach: String
    let status: String
    let status_text: String
    let notices: [String]
    var set_date: String
    let set_by: String
}

//
//struct FlagEntry: Identifiable {
//    let id = UUID()
//    let date: Date
//    let status: FlagStatus
//}


func fetchFlagStatus(completion: @escaping (FlagStatus?) -> Void) {
    guard let url = URL(string: "https://ourcs.co.uk/api/flags/status/isis/") else {
        completion(nil)
        return
    }

    URLSession.shared.dataTask(with: url) { data, _, error in
        guard let data = data, error == nil else {
            completion(nil)
            return
        }

        do {
            let status = try JSONDecoder().decode(FlagStatus.self, from: data)
            
            print(status)
            completion(status)
            
        } catch {
            print("Failed to decode JSON:", error)
            completion(nil)
        }
    }.resume()
}
