//
//  NetworkManager.swift
//  News
//
//  Created by Yunus Oktay on 20.02.2025.
//

import Foundation
import Alamofire

enum NetworkError: Error {
    case invalidRequest
    case requestFailed
    case decodingError
    case noData
    case customError(Error)

    var localizedDescription: String {
        switch self {
        case .invalidRequest:
            return "Invalid Request"
        case .requestFailed:
            return "Request Failed"
        case .decodingError:
            return "Decoding Error"
        case .customError(let error):
            return error.localizedDescription
        case .noData:
            return "No data received"
        }
    }
}

protocol NetworkManagerProtocol {
    func execute<T: Decodable>(urlRequest: URLRequestConvertible) async throws -> T
}

final class NetworkManager {
    static let shared = NetworkManager()
    private let session: Session

    // MARK: init

    init(session: Session = .default) {
        self.session = session
    }
}

// MARK: - NetworkManagerProtocol

extension NetworkManager: NetworkManagerProtocol {
    func execute<T: Decodable>(
        urlRequest: URLRequestConvertible) async throws -> T {
            return try await withCheckedThrowingContinuation { continuation in
                session.request(urlRequest)
                    .validate()
                    .responseDecodable(of: T.self) { response in
                        switch response.result {
                        case .success(let value):
                            continuation.resume(returning: value)
                        case .failure(let error):
                            print("Network error: \(error.localizedDescription)")
                            continuation.resume(throwing: NetworkError.customError(error))
                        }
                    }
            }
    }
}
