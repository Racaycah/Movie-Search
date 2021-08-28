//
//  MovieCollectionViewCell.swift
//  Movie Search
//
//  Created by Ata DORUK on 28.08.2021.
//

import UIKit

enum MovieWatchState: String {
    case watched = "Watched"
    case notWatched = "Not Watched"
    
    var title: String { self.rawValue }
    var nextState: MovieWatchState { self == .watched ? .notWatched : .watched }
}

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var posterImageView: AsyncImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var ratingView: RatingView!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var watchStateButton: UIButton!
    
    static let itemSize: CGSize = CGSize(width: UIScreen.main.bounds.width, height: 175)
    
    private(set) var movie: Movie! {
        didSet {
            posterImageView.loadImage(from: movie.posterUrl)
            movieTitleLabel.text = movie.displayedTitle
            //ratingView.currentRating = CGFloat(movie.displayedRating)
            releaseDateLabel.text = movie.displayedReleaseDate
            overviewLabel.text = movie.overview
        }
    }
    
    private var watchState: MovieWatchState = .notWatched

    override func awakeFromNib() {
        super.awakeFromNib()
        posterImageView.layer.cornerRadius = 8
        posterImageView.clipsToBounds = true
        watchStateButton.backgroundColor = UIColor.systemIndigo
        watchStateButton.setTitleColor(UIColor.white, for: .normal)
        watchStateButton.layer.cornerRadius = watchStateButton.frame.height / 2
        watchStateButton.addTarget(self, action: #selector(watchStateButtonTapped), for: .touchUpInside)
    }

    func configure(with movie: Movie) {
        self.movie = movie
    }
    
    @objc
    private func watchStateButtonTapped() {
        watchState = watchState.nextState
        handleButtonStateChange()
    }
    
    private func handleButtonStateChange() {
        // TODO: Save movie id and load initial state
        UIView.transition(with: watchStateButton, duration: 0.5, options: .transitionCrossDissolve) {
            self.watchStateButton.setTitle(self.watchState.title, for: .normal)
        } completion: { success in
            print("State change result for movie (id - \(self.movie.id)): \(success)")
        }

    }
    
}
