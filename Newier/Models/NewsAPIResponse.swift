//
//  NewsAPIResponse.swift
//  Newier
//
//  Created by KhaleD HuSsien on 31/01/2023.
//

import Foundation
struct NewsAPIResponse: Decodable {
    let status: String
    let totalResults: Int?
    let articles: [Article]?
    
    let code: String?
    let message: String?
}
