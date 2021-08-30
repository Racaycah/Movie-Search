//
//  Movie.swift
//  Movie Search
//
//  Created by Ata DORUK on 28.08.2021.
//

import Foundation

struct Movie: Decodable {
    let posterPath: String?
    let adult: Bool
    let overview: String
    private let releaseDate: String
    let genreIds: [Int]
    let id: Int
    private let originalTitle: String
    let originalLanguage: String
    private let title: String
    let backdropPath: String?
    let popularity: Double
    let voteCount: Int
    let video: Bool
    let voteAverage: Double
    
    enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
        case adult
        case overview
        case releaseDate = "release_date"
        case genreIds = "genre_ids"
        case id
        case originalTitle = "original_title"
        case originalLanguage = "original_language"
        case title
        case backdropPath = "backdrop_path"
        case popularity
        case voteCount = "vote_count"
        case video
        case voteAverage = "vote_average"
    }
    
    var posterUrl: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500" + path)
    }
    
    var displayedTitle: String { originalTitle == title ? title : "\(title)(\(originalTitle))" }
    
    var displayedReleaseDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: releaseDate) else { return "" }
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date)
    }
    
    var displayedRating: Int { voteCount == 0 ? 0 : Int(voteAverage) / voteCount }
    
    var webUrl: URL { URL(string: "https://www.themoviedb.org/movie/\(id)")! }
}
