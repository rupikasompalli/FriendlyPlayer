//
//  ThumbnailService.swift
//  FriendlyPlayer
//
//  Created by Rupika Sompalli on 2022-02-01.
//

import Foundation
import UIKit
import AVFoundation

protocol ThumbnailServiceProtocol {
    var cache: [String: UIImage] { get }
    func loadImage(from url: String, completion: @escaping ((Result<UIImage, Error>)-> Void))
    func saveImage(key: String, value: UIImage)
}

enum ImageLoaderError: Error {
    case invalidData
}

class ThumbnailService: ThumbnailServiceProtocol {
    
    var cache: [String: UIImage] = [:]
    
    func loadImage(from url: String, completion: @escaping ((Result<UIImage, Error>) -> Void)) {
        if let cachedImage = cache[url] {
            completion(.success(cachedImage))
            return
        }
        guard let imgUrl = URL(string: url) else {
            return
        }
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            if let img = self.generateThumbnail(url: imgUrl) {
                self.saveImage(key: url, value: img)
                completion(.success(img))
            } else {
                completion(.failure(ImageLoaderError.invalidData))
            }
        }
    }
    
    func saveImage(key: String, value: UIImage) {
        cache[key] = value
    }
    
    private func generateThumbnail(url: URL) -> UIImage? {
        do {
            let asset = AVURLAsset(url: url)
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            imageGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imageGenerator.copyCGImage(at: .zero,
                                                         actualTime: nil)
            return UIImage(cgImage: cgImage)
        } catch {
            print(error.localizedDescription)

            return nil
        }
    }
}
