//
//  UsedCarsViewModel.swift
//  UsedCarListings
//
//  Created by Rupika Sompalli on 2022-01-21.
//

import Foundation
import Combine
import UIKit

class MoviesViewModel {
    
    let moviesService: MoviesServiceProtocol
    let thumbnailService: ThumbnailServiceProtocol
    let castService: CastServiceProtocol
    
    @Published var movies: [Movie]?
    @Published var error: Error? = nil
    
    init(service: MoviesServiceProtocol, thumbnailService: ThumbnailServiceProtocol, castService: CastServiceProtocol) {
        moviesService = service
        self.thumbnailService = thumbnailService
        self.castService = castService
    }
    
    func fetchCars() {
        moviesService.fetchMoviesData { result in
            switch result {
            case .success(let data):
                self.movies = data
            case .failure(let error):
                self.error = error
            }
        }
    }
    
    func fetchImage(for movie: Movie, completion: @escaping ((UIImage?) -> Void)) {
        thumbnailService.loadImage(from: movie.sources.first ?? "") { result in
            switch result {
            case .success(let image):
                debugPrint("image downloaded", image)
                completion(image)
            case .failure(let error):
                debugPrint("Error in downloadin image", error)
                completion(nil)
            }
        }
    }
}
