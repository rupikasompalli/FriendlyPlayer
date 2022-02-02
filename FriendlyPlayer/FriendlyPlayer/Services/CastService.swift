//
//  CastService.swift
//  FriendlyPlayer
//
//  Created by Rupika Sompalli on 2022-02-01.
//

import Foundation
import GoogleCast

protocol CastServiceProtocol {
    var sessionManager: GCKSessionManager { get }
    func loadMetadata(url: String) -> GCKMediaMetadata
    func loadMedia(videoUrl: String)
}

class CastService: NSObject, CastServiceProtocol {
    var sessionManager: GCKSessionManager {
        GCKCastContext.sharedInstance().sessionManager
    }
    
    func loadMetadata(url: String) -> GCKMediaMetadata {
        let metadata = GCKMediaMetadata()
        metadata.setString("Rupika Sompalli", forKey: kGCKMetadataKeyTitle)
        metadata.setString("Testing subtitle",
                           forKey: kGCKMetadataKeySubtitle)
        metadata.addImage(GCKImage(url: URL(string: url)!,
                                   width: 480,
                                   height: 360))
        return metadata
    }
    
    func loadMedia(videoUrl: String) {
        let url = URL.init(string: videoUrl)
        guard let mediaURL = url else {
          print("invalid mediaURL")
          return
        }

        let mediaInfoBuilder = GCKMediaInformationBuilder.init(contentURL: mediaURL)
        mediaInfoBuilder.streamType = GCKMediaStreamType.none
        mediaInfoBuilder.contentType = "video/mp4"
        mediaInfoBuilder.metadata = loadMetadata(url: videoUrl)
        let mediaInformation = mediaInfoBuilder.build()

        if let request = sessionManager.currentSession?.remoteMediaClient?.loadMedia(mediaInformation) {
          request.delegate = self
        }
    }
}

extension CastService: GCKRequestDelegate {
    func requestDidComplete(_ request: GCKRequest) {
        debugPrint("request completed")
    }
    
    func request(_ request: GCKRequest, didFailWithError error: GCKError) {
        debugPrint("request failed", error)
    }
    
    func request(_ request: GCKRequest, didAbortWith abortReason: GCKRequestAbortReason) {
        debugPrint("request aborted", abortReason)
    }
}
