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
    
    private let endpoint = EndPoint(apiType: .trending)
    
    private init() { }
    
    func fetchData<T: Decodable>(endPoint: EndPoint, data: T) {
        guard let url = endpoint.url else { return }
        AF.request(url, method: .get)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: T.self) { response in
                dump(response.result)
            }
    }
}
