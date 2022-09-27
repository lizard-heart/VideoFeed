//
//  NetworkManager.swift
//  VideoFeed
//
//  Created by Henry Gustafson on 9/26/22.
//

import Foundation

class NetworkManager: ObservableObject {

    @Published var channels = [Channel]()
    @Published var useThisURL = "\(URLName().partialURL)\(URLName().searchTerm)\(URLName().apiKey)"

    func fetchSearch(searchTerm: String) {
         useThisURL = "\(URLName().partialURL)\(URLName().searchTerm)\(URLName().apiKey)"
    }

    func fetchData() {
        if let url = URL(string: useThisURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? " ") {

            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error == nil {
                    let decoder = JSONDecoder()
                    if let data = data {
                        do {
                            let results2 = try decoder.decode(Items.self, from: data)
                            DispatchQueue.main.async {
                                self.channels = results2.items
                            }
                        } catch {
                            print(error)
                        }
                    }
                }
            }
            task.resume()
        }
    }
}
