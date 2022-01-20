//
//  ImageCachingService.swift
//  GoraStudioTestAssignment
//
//  Created by Vladimir Banushkin on 20.01.2022.
//

import UIKit

/// Simple cache on disk. 
class ImageCache {
    /// Saves provided image data at file system
    /// - Parameters:
    ///   - url: url is key for further retrieving cached data.
    ///   - data: data to store at file system.
    static func saveImageData(withUrl url: URL, data: Data) {
        let path = NSTemporaryDirectory().appending(UUID().uuidString)
        let saveURL = URL(fileURLWithPath: path)
        try? data.write(to: saveURL)
        var dictionary = UserDefaults.standard.object(forKey: "cache") as? [String: String]

        if dictionary == nil {
            dictionary = [String: String]()
        }

        dictionary![url.absoluteString] = path
        UserDefaults.standard.set(dictionary, forKey: "cache")
    }

    /// Loading image data from file system
    /// - Parameter url: key to get image data
    /// - Returns: Data type which can be used to prepare UiImage
    static func retrieveImageData(ofImageWithUrl url: URL) -> Data? {
        if let dict = UserDefaults.standard.object(forKey: "cache") as? [String: String] {
            guard let path = dict[url.absoluteString],
                  let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else { return nil}
            return data
        }
        else {
            return nil
        }
    }
}
