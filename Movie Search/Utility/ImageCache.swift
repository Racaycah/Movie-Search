//
//  ImageCache.swift
//  Movie Search
//
//  Created by Ata DORUK on 28.08.2021.
//

import UIKit

class ImageCache {
    private static let cache = NSCache<AnyObject, AnyObject>()
    
    static func image(for url: URL) -> UIImage? {
        cache.object(forKey: url.absoluteString as AnyObject) as? UIImage
    }
    
    static func save(image: UIImage, for url: URL) {
        cache.setObject(image, forKey: url.absoluteString as AnyObject)
    }
}
