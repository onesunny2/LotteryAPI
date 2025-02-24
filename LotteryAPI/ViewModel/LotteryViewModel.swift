//
//  LotteryViewModel.swift
//  LotteryAPI
//
//  Created by Lee Wonsun on 2/24/25.
//

import Foundation
import RxCocoa
import RxSwift

final class LotteryViewModel: BaseViewModel {
    
    struct Input {
        
    }
    
    struct Output {
        
        
    }
    
    var disposeBag: DisposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        return Output()
    }
    
    
    // MARK: 가장 최근 회차 구하기
    static func recentLottoCount() -> Int {
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        
        guard let first = dateFormat.date(from: "2002-12-07") else { return 0 }
        let firstDate = first.onlyDate
        let currentDate = Date.now.onlyDate
     
        let dateGap = Calendar.current.dateComponents([.day], from: firstDate, to: currentDate).day ?? 0
        
        let recentDraw = (dateGap / 7) + 1
        
        return recentDraw
    }
}
