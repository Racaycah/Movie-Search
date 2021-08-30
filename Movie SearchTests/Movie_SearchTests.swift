//
//  Movie_SearchTests.swift
//  Movie SearchTests
//
//  Created by Ata DORUK on 28.08.2021.
//

import XCTest
import Combine
@testable import Movie_Search

class Movie_SearchTests: XCTestCase {
    
    private var cancellables: Set<AnyCancellable>!

    let lionKingSearchQuery = "Lion king"
    let emptyResultQuery = "Ftestrotsgkt"
    
    override func setUp() {
        super.setUp()
        cancellables = []
    }
    
    func testSearchSucceeds() {
        let sut = MovieSearchViewModel()
        var movies = [Movie]()
        
        let expectation = self.expectation(description: "Should fetch movies")
        
        sut.moviesPublisher.sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            
            expectation.fulfill()
        } receiveValue: { fetchedMovies in
            movies = fetchedMovies
            expectation.fulfill()
        }
        .store(in: &cancellables)

        sut.search(withQuery: lionKingSearchQuery)
        
        waitForExpectations(timeout: 10)
        
        XCTAssertFalse(movies.isEmpty)
    }
    
    func testRandomTextReturnsEmptyResult() {
        let sut = MovieSearchViewModel()
        var showEmptyView: Bool = false
        
        let expectation = self.expectation(description: "Should fetch no movies and call showEmptyView")
        
        sut.showEmptyViewPublisher.sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            
            expectation.fulfill()
        } receiveValue: { empty in
            showEmptyView = empty
            
            if empty {
                expectation.fulfill()
            }
        }
        .store(in: &cancellables)

        sut.search(withQuery: emptyResultQuery)
        
        waitForExpectations(timeout: 10)
        
        XCTAssertTrue(showEmptyView)
    }

}
