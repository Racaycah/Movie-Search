//
//  MovieDetails.swift
//  Movie Search
//
//  Created by Ata DORUK on 30.08.2021.
//

import Foundation

struct MovieDetails: Decodable {
    struct Genre: Decodable {
        let id: Int
        let name: String
    }
    
    let adult: Bool
    let backdropPath: String?
    let budget: Int
    let genres: [Genre]
    let homepage: String?
    let id: Int
    let imdbId: String?
    let originalLanguage: String
    let originalTitle: String
    let overview: String?
    let popularity: Double
    let posterPath: String?
    let releaseDate: String
    let revenue: Int
    let runtime: Int?
    let status: String
    let title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
    
    var posterUrl: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/original" + path)
    }
    
    var displayedTitle: String { originalTitle == title ? title : "\(title)(\(originalTitle))" }
    
    var info: String { displayedReleaseDate + (runtime == nil ? "" : " • \(runtime!) minutes") + " • " + status }
    
    var displayedReleaseDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: releaseDate) else { return "" }
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date)
    }
    
    var displayedRating: Int { voteCount == 0 ? 0 : Int(voteAverage) / voteCount }
    
    var webUrl: URL { URL(string: "https://www.themoviedb.org/movie/\(id)")! }
    
    enum CodingKeys: String, CodingKey {
        case adult, budget, genres, homepage, id, overview, popularity, revenue, runtime, status, title, video
        case backdropPath = "backdrop_path"
        case imdbId = "imdb_id"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
