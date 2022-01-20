//
//  ImageFetchingService.swift
//  GoraStudioTestAssignment
//
//  Created by Vladimir Banushkin on 19.01.2022.
//

import Foundation

typealias GenericResult<T> = (Result<T, ErrorDomain>) -> Void
typealias UsersResult = (Result<[User], ErrorDomain>) -> Void
typealias AlbumsResult = (Result<[Album], ErrorDomain>) -> Void
typealias PhotosResult = (Result<[Photo], ErrorDomain>) -> Void
typealias PhotoDataResult = (Result<Data, ErrorDomain>) -> Void

protocol DataProvider {
    /// Method to load from remote source list of users
    func getListOfUsers(completion: @escaping UsersResult)

    /// Method to load from remote source list of albums
    func getListOfAlbums(byUserId id: Int, completion: @escaping AlbumsResult)

    /// Method to load from remote source list of photo codable models
    func getListOfPhotos(byAlbumId id: Int, completion: @escaping PhotosResult)

    /// Method to asynchronously load image data by provided url.
    func loadPhoto(url: URL, completion: @escaping PhotoDataResult
    )
}

final class ImageFetchingService: DataProvider {

    /// Used to produce request for requested needs.
    public enum RequestGenerator {
        case users
        case albums(userID: Int)
        case photos(albumID: Int)

        private var url: URL? {
            switch self {
            case .users:
                return URL(string: "https://jsonplaceholder.typicode.com/users")
            case .albums(userID: let userID):
                return URL(string: "https://jsonplaceholder.typicode.com/users/\(userID)/albums")
            case .photos(albumID: let albumID):
                return URL(string: "https://jsonplaceholder.typicode.com/albums/\(albumID)/photos")
            }
        }

        var request: URLRequest {
            var request = URLRequest(url: url!)
            request.httpMethod = "GET"
            return request
        }
    }

    static let shared = ImageFetchingService()

    private let mainQueue = OperationQueue.main
    private var session: URLSession!

    private init() {}

    // MARK: - Private methods
    private func performSimpleRequest<T: Decodable>(for request: RequestGenerator, completion: @escaping GenericResult<T>) {
        let request = request.request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error: error)))
                return
            }
            guard let data = data else { return }
            let decoder = JSONDecoder()
            guard let result = try? decoder.decode(T.self, from: data) else {
                completion(.failure(.parsingError))
                return
            }
            completion(.success(result))
        }.resume()
    }

    // MARK: - Public methods
    func getListOfUsers(completion: @escaping (Result<[User], ErrorDomain>) -> Void) {
        performSimpleRequest(for: .users, completion: completion)
    }

    func getListOfAlbums(byUserId id: Int, completion: @escaping (Result<[Album], ErrorDomain>) -> Void) {
        performSimpleRequest(for: .albums(userID: id), completion: completion)
    }

    func getListOfPhotos(byAlbumId id: Int, completion: @escaping (Result<[Photo], ErrorDomain>) -> Void) {
        performSimpleRequest(for: .photos(albumID: id), completion: completion)
    }

    func loadPhoto( url: URL, completion: @escaping PhotoDataResult) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        guard let imageData = ImageCache.retrieveImageData(ofImageWithUrl: url) else
            {
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(.networkError(error: error)))
                }
                else if let data = data {
                    ImageCache.saveImageData(withUrl: url, data: data)
                    completion(.success(data))
                }
            }.resume()
            return
            }
        completion(.success(imageData))
    }
}
