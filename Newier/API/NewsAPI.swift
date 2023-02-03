//
//  NewsAPI.swift
//  Newier
//
//  Created by KhaleD HuSsien on 01/02/2023.
//

import Foundation
struct NewsAPI {
    //MARK: - Proparties...
    static let shared = NewsAPI()
    private init(){}
    private let apiKey = "19e12b58505d4d398273914025c8afa2"
    private let session = URLSession.shared
    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    //MARK: - Functions...
    func fetch(from category: Category)async throws ->[Article]{
        try await fetchArticle(from: generateNewsURL(from: category))
    }
    func search(for query: String)async throws -> [Article]{
        try await fetchArticle(from: generateSearchURL(from: query))
    }
    private func fetchArticle(from url: URL)async throws -> [Article]{
        let (data,response) = try await session.data(from: url)
        guard let response = response as? HTTPURLResponse else{
            throw generateError(description: "Bad Response")
        }
        switch response.statusCode{
        case (200...299),(400...499):
            let apiResponse = try jsonDecoder.decode(NewsAPIResponse.self, from: data)
            if apiResponse.status == "ok"{
                return apiResponse.articles ?? []
            }else{
                throw generateError(description: apiResponse.message ?? "Error happen with 400..499 status error message")
            }
        default:
            throw generateError(description: "Server Error happen")
        }
    }
    private func generateError(code: Int = 1,description: String)-> Error{
        NSError(domain: "NewsAPI", code: code, userInfo: [NSLocalizedDescriptionKey:description])
    }
    private func generateSearchURL(from query: String)-> URL{
        let percentEncodedString = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        var url = "https://newsapi.org/v2/everything?"
        url += "apiKey=\(apiKey)"
        url += "&language=en"
        url += "&q=\(percentEncodedString)"
        return URL(string: url)!
    }
    private func generateNewsURL(from category: Category)-> URL{
        var url = "https://newsapi.org/v2/top-headlines?"
        url += "apiKey=\(apiKey)"
        url += "&language=en"
        url += "&category=\(category.rawValue)"
        return URL(string: url)!
    }
}
