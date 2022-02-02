//
//  UsedCarService.swift
//  UsedCarListings
//
//  Created by Rupika Sompalli on 2022-01-21.
//

import Foundation

protocol MoviesServiceProtocol {
    typealias MoviesServiceResult = ((Result<[Movie], Error>) -> Void)
    func fetchMoviesData(completion: @escaping MoviesServiceResult)
}

class MoviesServiceBackend: MoviesServiceProtocol {
    func fetchMoviesData(completion: @escaping MoviesServiceResult) {
        let url = Bundle.main.url(forResource: "Movies", withExtension: "json")
        guard let url = url else {
            print("no json url")
            return
        }
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let movies = try decoder.decode(Movies.self, from: data)
            completion(.success(movies.videos))
        } catch  {
            debugPrint("error", error)
            completion(.failure(error))
        }
    }
}
