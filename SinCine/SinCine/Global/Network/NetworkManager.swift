//
//  NetworkManager.swift
//  SinCine
//
//  Created by 박성훈 on 8/4/25.
//

import Foundation
import Alamofire

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() { }
    
    func fetchData<T: Decodable>(endPoint: EndPoint, type: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void) {
        
        guard let url = endPoint.url else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        let key = Bundle.main.apiKey
        
        let headers: HTTPHeaders = [
            HTTPHeader(name: "Authorization", value: "Bearer \(key)")
        ]
        
        
        AF.request(url, method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let result):
                    completion(.success(result))
                case .failure(let error):
                    completion(.failure(.invalidURL))
                }
            }
    }
}

enum NetworkError: Error {
    case invalidURL
}
