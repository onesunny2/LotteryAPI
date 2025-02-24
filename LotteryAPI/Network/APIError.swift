//
//  APIError.swift
//  LotteryAPI
//
//  Created by Lee Wonsun on 2/24/25.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case statusError
    case unknownResponse
}
