//
//  Article.swift
//  Newier
//
//  Created by KhaleD HuSsien on 31/01/2023.
//

import Foundation
/// this RelativeDateTimeFormatter make like example for i hour for 2 weeks like that from date to current date nowand it calculate the time bettwen them...
private let relativeDateFormatter = RelativeDateTimeFormatter()
struct Article {
    let source: Source
    let title: String
    let url: String
    let publishedAt: Date
    let auther: String?
    let description: String?
    let urlToImage: String?
    
    //.....
    var autherText: String{
        auther ?? ""
    }
    var descriptionText: String{
        description ?? ""
    }
    var captionText: String {
        "\(source.name) · \(relativeDateFormatter.localizedString(for: publishedAt, relativeTo: Date()))"
    }
    var articleURL: URL{
        URL(string: url) ?? URL(string: "https://github.com/khaled2024")!
    }
    var imageURL: URL?{
        guard let urlToImage = urlToImage else{return nil}
        return URL(string: urlToImage)
    }
}
extension Article: Codable {}
extension Article: Equatable {}
extension Article: Identifiable {
    var id: String { url }
}
extension Article{
    static var previewData: [Article]{
        let previewDataURL = Bundle.main.url(forResource: "news", withExtension: "json")!
        let data = try! Data(contentsOf: previewDataURL)
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        let apiResponse = try! jsonDecoder.decode(NewsAPIResponse.self, from: data)
        return apiResponse.articles ?? []
    }
}


struct Source{
    let name: String
}
extension Source: Codable{}
extension Source: Equatable{}


