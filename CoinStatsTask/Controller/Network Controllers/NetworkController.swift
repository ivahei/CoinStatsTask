//
//  NetworkController.swift
//  CoinStatsTask
//
//  Created by Vahe Abazyan on 07.04.22.
//

import UIKit

import Kingfisher

final class NetworkController {

    static let shared = NetworkController()
    private init() {}

    enum ItemError: Error, LocalizedError {
        case urlNotFound
        case itemsNotFound
    }

    let baseURL = URL(string: "https://coinstats.getsandbox.com/feed")

    // MARK: - Fetch Items

    func fetchItems() async throws -> [Article] {

        guard let baseURL = baseURL else { throw ItemError.urlNotFound }

        let (data, response) = try await URLSession.shared.data(from: baseURL)

        guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode)
        else { throw ItemError.itemsNotFound }

        let decoder = JSONDecoder()
        let searchResponse = try decoder.decode(ArticleResponse.self, from: data)

        return searchResponse.data
    }
}
