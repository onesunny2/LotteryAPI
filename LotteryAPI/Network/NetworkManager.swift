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
    
    func callObservableRequest<T: Decodable>(type: T.Type, url: API) -> Observable<T> {
        
        return Observable<T>.create { value in
            
            guard let urlString = URL(string: url.url) else {
                value.onError(APIError.invalidURL)
                return Disposables.create {
                    print("disposed")
                }
            }
            
            URLSession.shared.dataTask(with: urlString) { data, response, error in
                
                if let error = error {
                    value.onError(APIError.unknownResponse)
                    return
                }
                
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    value.onError(APIError.unknownResponse)
                    return
                }
                
                if let data = data {
                    
                    do {
                        let result = try JSONDecoder().decode(T.self, from: data)
                        
                        value.onNext(result)
                        value.onCompleted()
                        
                    } catch {
                        value.onError(APIError.unknownResponse)
                    }
                } else {
                    value.onError(APIError.unknownResponse)
                }
            }
            .resume()
            
            return Disposables.create {
                print("disposed")
            }
        }
    }

    func callSingleRequest<T: Decodable>(type: T.Type, url: API) -> Single<T> {
        
        return Single<T>.create { value in
            
            guard let urlString = URL(string: url.url) else {
                value(.failure(APIError.invalidURL))
                return Disposables.create {
                    print("disposed")
                }
            }
            
            URLSession.shared.dataTask(with: urlString) { data, response, error in
                
                if let error = error {
                    value(.failure(APIError.unknownResponse))
                    return
                }
                
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    value(.failure(APIError.unknownResponse))
                    return
                }
                
                if let data = data {
                    
                    do {
                        let result = try JSONDecoder().decode(T.self, from: data)
                        
                        value(.success(result))
                        
                    } catch {
                        value(.failure(APIError.unknownResponse))
                    }
                } else {
                    value(.failure(APIError.unknownResponse))
                }
            }
            .resume()
            
            return Disposables.create {
                print("disposed")
            }
        }
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
