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
        // viewdidLoad -> 가장 최근회차
        let callRequest: Observable<()>
    }
    
    struct Output {
        let lotteryList: PublishRelay<[String]>
        let drwNoDate: PublishRelay<String>
        let drwNo: PublishRelay<Int>
    }
    
    var disposeBag: DisposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let lotteryList = PublishRelay<[String]>()
        let drwNoDate = PublishRelay<String>()
        let drwNo = PublishRelay<Int>()
        
        input.callRequest
            .debug()
            .withUnretained(self)
            .flatMap { _ in
                NetworkManager.shared.callObservableRequest(type: Lottery.self, url: .lotto(drwNo: self.recentLottoCount()))
            }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, value in
                
                lotteryList.accept(value.lotteryList)
                drwNoDate.accept(value.drwNoDate)
                drwNo.accept(value.drwNo)
            }
            .disposed(by: disposeBag)
        
        return Output(
            lotteryList: lotteryList,
            drwNoDate: drwNoDate,
            drwNo: drwNo
        )
    }
    
    
    // MARK: 가장 최근 회차 구하기
    private func recentLottoCount() -> Int {
        
        let firstDate = DateComponents(year: 2002, month: 12, day: 07)
        let startDate = Calendar.current.date(from: firstDate)
        
        guard let startDate else { return 0 }
        
        let offsetComps = Calendar.current.dateComponents([.day], from: startDate, to: Date())
        
        guard let days = offsetComps.day else { return 0 }
        let recentDraw = ( days / 7 ) + 1
        
        return recentDraw
    }
}
