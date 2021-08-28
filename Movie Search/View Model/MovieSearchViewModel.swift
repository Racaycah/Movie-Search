//
//  MovieSearchViewModel.swift
//  Movie Search
//
//  Created by Ata DORUK on 28.08.2021.
//

import UIKit
import Combine

class MovieSearchViewModel: NSObject {
    
    struct EmptyState {
        let emoji: String
        let text: String
        
        static let emptyInput = EmptyState(emoji: "👆🏻", text: "Search for a movie up there")
        static let emptyResult = EmptyState(emoji: "🤷🏼‍♂️", text: "No results came up. Try a different name?")
        static let error  = EmptyState(emoji: "😔", text: "Something went wrong")
    }
    
    var movies: [Movie] = []
    var lastQuery: String = ""
    var page: Int = 1
    
    let moviesPublisher = PassthroughSubject<[Movie], Never>()
    let showEmptyViewPublisher = PassthroughSubject<Bool, Never>()
    let emptyViewEmojiPublisher = PassthroughSubject<String, Never>()
    let emptyViewTextPublisher = PassthroughSubject<String, Never>()
    
    var subscriptions = Set<AnyCancellable>()
    
    func search(withQuery query: String) {
        guard !query.isEmpty else {
            sendEmptyState(.emptyInput)
            return
        }
        
        handleLastQuery(query)
        
        NetworkManager.shared.search(query: query, page: page) { result in
            switch result {
            case .success(let movieResult):
                self.movies = movieResult.movies
                if movieResult.movies.isEmpty {
                    self.sendEmptyState(.emptyResult)
                    return
                }
                self.showEmptyViewPublisher.send(false)
                self.moviesPublisher.send(movieResult.movies)
            case .failure:
                self.sendEmptyState(.error)
            }
        }
    }
    
    private func handleLastQuery(_ query: String) {
        // TODO: Check if we are paginating and increment page
        lastQuery = query
    }
    
    func sendEmptyState(_ state: EmptyState) {
        showEmptyViewPublisher.send(true)
        emptyViewEmojiPublisher.send(state.emoji)
        emptyViewTextPublisher.send(state.text)
    }
}
