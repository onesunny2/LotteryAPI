//
//  Lottery+Protocol.swift
//  LotteryAPI
//
//  Created by Lee Wonsun on 1/14/25.
//

import Foundation

// 단일 뷰에 큰 의미는 없겠지만, 잊지말자는 의미로 사용!
protocol LotteryResult: AnyObject {
    
    func configHierarchy()
    func configLayout()
    func configView()
}
