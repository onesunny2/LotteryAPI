//
//  NetworkManager.swift
//  LotteryAPI
//
//  Created by Lee Wonsun on 2/24/25.
//

import Foundation
import RxCocoa
import RxSwift

final class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    func callRequest<T: Decodable>(type: T.Type, url: API, completionHandler: @escaping (Result<T, APIError>) -> ()) {
        
        guard let urlString = URL(string: url.url) else {
            completionHandler(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: urlString) { data, response, error in
            
            if let error = error {
                completionHandler(.failure(.unknownResponse))
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                completionHandler(.failure(.unknownResponse))
                return
            }
            
            if let data = data {
                
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    completionHandler(.success(result))
                    
                } catch {
                    completionHandler(.failure(.unknownResponse))
                }
            } else {
                completionHandler(.failure(.unknownResponse))
            }
        }
        .resume()
        
    }
}

extension NetworkManager {
    enum API {
        case lotto(drwNo: Int)
        
        var url: String {
            switch self {
            case let .lotto(drwNo):
                return "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(drwNo)"
            }
        }
    }
}
