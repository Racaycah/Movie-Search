//
//  ViewController.swift
//  Movie Search
//
//  Created by Ata DORUK on 28.08.2021.
//

import UIKit
import Combine

class MovieSearchViewController: UIViewController {
    
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    
    private lazy var emptyView: UIView = {
        let containerView = UIView()
        containerView.addSubview(emojiLabel)
        containerView.addSubview(emptyTextLabel)
        
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            emptyTextLabel.centerXAnchor.constraint(equalTo: emojiLabel.centerXAnchor),
            emptyTextLabel.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 8)
        ])
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var emptyTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.secondaryLabel
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    let viewModel = MovieSearchViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTitle()
        configureSearchBar()
        configureCollectionView()
        configureEmptyView()
        bindViewModel()
    }
    
    func bindViewModel() {
        viewModel.moviesPublisher.sink { movies in self.moviesFetched(movies) }.store(in: &self.viewModel.subscriptions)
        viewModel.showEmptyViewPublisher.sink { show in self.showEmptyView(show) }.store(in: &self.viewModel.subscriptions)
        viewModel.emptyViewEmojiPublisher.sink { emoji in self.changeEmptyEmoji(emoji) }.store(in: &self.viewModel.subscriptions)
        viewModel.emptyViewTextPublisher.sink { text in self.changeEmptyText(text) }.store(in: &self.viewModel.subscriptions)
        
        viewModel.sendEmptyState(.emptyInput)
    }
    
    func moviesFetched(_ movies: [Movie]) {
        DispatchQueue.main.async {
            self.moviesCollectionView.reloadData()
        }
    }
    
    func showEmptyView(_ show: Bool) {
        DispatchQueue.main.async {
            self.emptyView.isHidden = !show
            self.moviesCollectionView.isHidden = show
        }
    }
    
    func changeEmptyEmoji(_ emoji: String) {
        DispatchQueue.main.async {
            self.emojiLabel.text = emoji
        }
    }
    
    func changeEmptyText(_ text: String) {
        DispatchQueue.main.async {
            self.emptyTextLabel.text = text
        }
    }

}

extension MovieSearchViewController {
    func configureTitle() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Movies"
    }
    
    func configureSearchBar() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a movie..."
        navigationItem.searchController = searchController
        
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: searchController.searchBar.searchTextField).map {
            ($0.object as! UISearchTextField).text
        }
        .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
        .removeDuplicates()
        .sink { searchText in
            self.viewModel.search(withQuery: searchText ?? "")
        }
        .store(in: &self.viewModel.subscriptions)
    }

    func configureCollectionView() {
        moviesCollectionView.register(cell: MovieCollectionViewCell.self)
        moviesCollectionView.delegate = self
        moviesCollectionView.dataSource = self
        
        //moviesCollectionView.isHidden = true
    }
    
    func configureEmptyView() {
        view.addSubview(emptyView)
        
        NSLayoutConstraint.activate([
            emptyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 8),
            emptyView.trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor, constant: 8),
            emptyView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        //emptyView.isHidden = false
    }
}

extension MovieSearchViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(cell: MovieCollectionViewCell.self, for: indexPath)
        let movie = viewModel.movies[indexPath.section]
        cell.configure(with: movie)
        return cell
    }
    
    
}

extension MovieSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        MovieCollectionViewCell.itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
}
