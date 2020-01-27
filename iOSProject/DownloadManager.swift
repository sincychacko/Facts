//
//  DownloadManager.swift
//  iOSProject
//
//  Created by SINCY on 27/01/20.
//  Copyright © 2020 SINCY. All rights reserved.
//

import Foundation
import UIKit

enum ServiceError: Error {
    case invalidURL
    case invalidResponse
    case errorWhileDecoding
}

class DownloadManager {
    typealias ImageDownloadHandler = (_ image: UIImage?, _ indexPath: IndexPath?, _ error: Error?) -> Void
    var fact: Fact
    private var sessionTask: URLSessionDataTask?
    private let imageCache = NSCache<NSString, UIImage>()
    
    init(withFact fact: Fact) {
        self.fact = fact
    }
    
    func downloadImage(at indexPath: IndexPath?, completion: @escaping ImageDownloadHandler) {
        guard fact.imageName != nil, let url = URL(string: fact.imageName!) else {
            completion(nil, indexPath, ServiceError.invalidURL)
            return
        }
        
        if let cachedImage = imageCache.object(forKey: fact.imageName! as NSString) {
            /* check for the cached image for url, if YES then return the cached image */
            print("Return cached Image for \(url)")
            completion(cachedImage, indexPath, nil)
        } else {
            sessionTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard error == nil else {
                    completion(nil, indexPath, error)
                    return
                }
                
                guard data != nil, let image = UIImage(data: data!) else {
                    completion(nil, indexPath, ServiceError.invalidResponse)
                    return
                }
                self.imageCache.setObject(image, forKey: self.fact.imageName! as NSString)
                completion(image, indexPath, nil)
            }
            sessionTask?.resume()
        }
        
    }
    
    func cancelDownload() {
        
    }
}
