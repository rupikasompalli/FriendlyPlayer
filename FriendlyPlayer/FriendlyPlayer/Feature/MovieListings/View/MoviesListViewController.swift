//
//  MoviesListViewController.swift
//  UsedCarListings
//
//  Created by Rupika Sompalli on 2022-01-21.
//

import UIKit
import Combine
import GoogleCast
import AVKit

class MoviesListViewController: UIViewController {
    
    lazy var moviesListView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: MovieCell.Identifier, bundle: .main), forCellReuseIdentifier: MovieCell.Identifier)
        return tableView
    }()
    
    private let viewModel: MoviesViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: MoviesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createView()
        bindView()
        fetchData()
    }
    
    private func createView() {
        self.view = moviesListView
        navigationItem.title = "Top Movies"
        // TODO CAST
        let castButton = GCKUICastButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        castButton.tintColor = UIColor.gray
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: castButton)
    }
    
    private func fetchData() {
        viewModel.fetchCars()
    }
    
    private func bindView() {
        viewModel
            .$movies
            .sink { [weak self] _ in
                self?.refreshView()
            }
        .store(in: &cancellables)
    }
    
    private func refreshView() {
        DispatchQueue.main.async {
            self.moviesListView.reloadData()
        }
    }
    
    @objc func settingsClicked() {
        // TODO cast
    }
}

extension MoviesListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.movies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movieCell = tableView.dequeueReusableCell(withIdentifier: MovieCell.Identifier, for: indexPath) as? MovieCell
        guard let movieCell = movieCell,
              let movie = viewModel.movies?[indexPath.row] else {
            return UITableViewCell()
        }
        movieCell.showData(data: movie)
        viewModel.fetchImage(for: movie) { img in
            DispatchQueue.main.async {
                movieCell.thumbnail.image = img
            }
        }
        return movieCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let movie = viewModel.movies?[indexPath.row],
              let movieUrl =  movie.sources.first,
              let videoUrl = URL(string: movieUrl)  else {
            return
        }
        if viewModel.castService.sessionManager.hasConnectedCastSession() {
            viewModel.castService.loadMedia(videoUrl: movieUrl)
        } else {
            let player = AVPlayer(url: videoUrl)
            let vc = AVPlayerViewController()
            vc.player = player
            self.present(vc, animated: true) { vc.player?.play() }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
