//
//  MovieListResult.swift
//  Movie Search
//
//  Created by Ata DORUK on 28.08.2021.
//

import Foundation

struct MovieListResult: Decodable {
    let page: Int
    let movies: [Movie]
    let totalResults: Int
    let totalPages: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case movies = "results"
        case totalResults = "total_results"
        case totalPages = "total_pages"
    }
}
