//
//  MovieDetailsViewModel.swift
//  Movie Search
//
//  Created by Ata DORUK on 30.08.2021.
//

import UIKit

class MovieDetailsViewModel {
    
    var details: MovieDetails!
    
    func openUrl() {
        if UIApplication.shared.canOpenURL(details.webUrl) {
            UIApplication.shared.open(details.webUrl, options: [:], completionHandler: nil)
        }
    }

}
