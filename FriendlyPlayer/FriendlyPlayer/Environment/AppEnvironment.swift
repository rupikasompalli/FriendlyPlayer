//
//  AppEnvironment.swift
//  UsedCarListings
//
//  Created by Rupika Sompalli on 2022-01-21.
//

import Foundation

protocol Environment {
    var movieService: MoviesServiceProtocol { get }
    var thumbnailService: ThumbnailServiceProtocol { get }
    var castService: CastServiceProtocol { get }
}

protocol AppFactory {
    func makeMoviesListView() -> MoviesListViewController
}

struct AppEnvironment: Environment {
    static let current = AppEnvironment()
    
    var movieService: MoviesServiceProtocol {
        MoviesServiceBackend()
    }
    
    var thumbnailService: ThumbnailServiceProtocol {
        ThumbnailService()
    }
    
    var castService: CastServiceProtocol {
        CastService()
    }
    
}

extension AppEnvironment: AppFactory {
    func makeMoviesListView() -> MoviesListViewController {
        let vm = MoviesViewModel(service: movieService, thumbnailService: thumbnailService, castService: castService)
        let view = MoviesListViewController(viewModel: vm)
        return view
    }
}
