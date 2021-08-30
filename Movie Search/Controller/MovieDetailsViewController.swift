//
//  MovieDetailsViewController.swift
//  Movie Search
//
//  Created by Ata DORUK on 30.08.2021.
//

import UIKit

final class MovieDetailsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var posterImageView: AsyncImageView!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var watchStatusButton: UIButton!
    @IBOutlet weak var overviewBodyLabel: UILabel!
    
    private lazy var titleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = posterImageView.image
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var titleViewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = viewModel.details.title
        label.sizeToFit()
        
        return label
    }()
    
    private lazy var titleContainerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleImageView)
        view.addSubview(titleViewLabel)
        
        NSLayoutConstraint.activate([
            titleImageView.heightAnchor.constraint(equalToConstant: 30),
            titleImageView.widthAnchor.constraint(equalToConstant: 30),
            titleImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            titleViewLabel.leadingAnchor.constraint(equalTo: titleImageView.trailingAnchor, constant: 8),
            titleViewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleViewLabel.centerYAnchor.constraint(equalTo: titleImageView.centerYAnchor)
        ])
        
        return view
    }()
    
    // MARK: - Properties
    
    let viewModel: MovieDetailsViewModel = MovieDetailsViewModel()
    private var titleLabelFrame: CGRect { titleLabel.frame }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = false
        configureScrollView()
        configureMovieDetails()
        configureWebsiteButton()
    }
    
    // MARK: - Methods
    
    func configureScrollView() {
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
    }
    
    func configureMovieDetails() {
        configureImageView()
        configureTitle()
        configureInfo()
        configureWatchState()
        configureOverview()
    }
    
    func configureImageView() {
        posterImageView.loadImage(from: viewModel.details.posterUrl)
    }
    
    func configureTitle() {
        titleLabel.text = viewModel.details.displayedTitle
    }
    
    func configureInfo() {
        infoLabel.text = viewModel.details.info
    }
    
    func configureWatchState() {
        // TODO: Watch state
    }
    
    func configureOverview() {
        overviewBodyLabel.text = viewModel.details.overview
    }
    
    func configureWebsiteButton() {
        let websiteButton = UIBarButtonItem(image: UIImage(systemName: "network"), style: .done, target: self, action: #selector(openUrl))
        navigationItem.setRightBarButton(websiteButton, animated: false)
    }
    
    @objc
    private func openUrl() {
        viewModel.openUrl()
    }

}

extension MovieDetailsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.bounds.contains(titleLabelFrame) {
            navigationItem.titleView = nil
        } else {
            navigationItem.titleView = titleContainerView
        }
        
        if scrollView.contentOffset.y < 0 {
            imageViewHeightConstraint.constant = max(abs(scrollView.contentOffset.y), 50)
        } else {
            imageViewHeightConstraint.constant = 50
        }
    }
    
}
