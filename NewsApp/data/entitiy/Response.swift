//
//  Haberler.swift
//  NewsApp
//
//  Created by Ezgi Kaltalıoğlu on 9.09.2023.
//

import Foundation

struct Response: Codable {
    let status: String?
    let totalResults: Int?
    let articles: [Haber]?
}

struct Haber: Codable {
    let source: Kaynak?
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let category: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
}

struct Kaynak: Codable {
    let id: String?
    let name: String?
}
