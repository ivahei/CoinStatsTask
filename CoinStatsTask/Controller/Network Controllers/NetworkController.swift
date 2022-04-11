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
        case responseError
        case dataError
    }

    // MARK: - Fetch Items

    func fetchItems(_ completion: @escaping (Result<[Article], Error>) -> Void) {
        guard let url = URL(string: Endpoints.feed) else { return completion(.failure(ItemError.urlNotFound)) }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard
                let httpResponse = response as? HTTPURLResponse,
                (200..<300).contains(httpResponse.statusCode)
            else {
                completion(.failure(ItemError.responseError))
                return
            }

            guard let data = data else {
                completion(.failure(ItemError.dataError))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                let responseData = try decoder.decode(ArticleResponse.self, from: data)
                completion(.success(responseData.data))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
