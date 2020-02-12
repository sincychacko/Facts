//
//  DownloadManager.swift
//  iOSProject
//
//  Created by SINCY on 27/01/20.
//  Copyright © 2020 SINCY. All rights reserved.
//

import Foundation
import UIKit

final class DownloadManager {
    
    typealias ImageDownloadHandler = (_ image: UIImage?, _ indexPath: IndexPath?, _ error: Error?) -> Void
    
    //MARK: - Properties
    private var fact: Fact
    private var sessionTask: URLSessionDataTask?
    private let imageCache = NSCache<NSString, UIImage>()
    
    //MARK: - Initializers
    init(withFact fact: Fact) {
        self.fact = fact
    }
    
    //MARK: - Download handler methods
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
                    completion(nil, indexPath, ServiceError.customError(error!.localizedDescription))
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
        sessionTask?.cancel()
        sessionTask = nil
    }
}
