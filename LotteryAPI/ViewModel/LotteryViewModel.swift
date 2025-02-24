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
        let pickerIndexpath: ControlEvent<(row: Int, component: Int)>
        let pickerTitle: ControlEvent<[Int]>
    }
    
    struct Output {
        let lotteryList: PublishRelay<[String]>
        let drwNoDate: PublishRelay<String>
        let drwNo: PublishRelay<Int>
        let totalLotto: BehaviorRelay<[Int]>
        let selectedDrawNo: PublishRelay<String>
    }
    
    var disposeBag: DisposeBag = DisposeBag()
    lazy var totalLotto: [Int] = Array(1...recentLottoCount())
    
    func transform(input: Input) -> Output {
        
        let lotteryList = PublishRelay<[String]>()
        let drwNoDate = PublishRelay<String>()
        let drwNo = PublishRelay<Int>()
        let totalLotto = BehaviorRelay(value: totalLotto)
        let selectedDrawNo = PublishRelay<String>()
        
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
        
        Observable.zip(
            input.pickerIndexpath,
            input.pickerTitle
        )
        .bind(with: self) { owner, value in
            let titleList = value.1
            let selectedTitle = titleList[value.0.component]
            
            selectedDrawNo.accept(String(selectedTitle))
        }
        .disposed(by: disposeBag)
        
        return Output(
            lotteryList: lotteryList,
            drwNoDate: drwNoDate,
            drwNo: drwNo,
            totalLotto: totalLotto,
            selectedDrawNo: selectedDrawNo
        )
    }
    
    
    // MARK: 가장 최근 회차 구하기
    func recentLottoCount() -> Int {
        
        let firstDate = DateComponents(year: 2002, month: 12, day: 07)
        let startDate = Calendar.current.date(from: firstDate)
        
        guard let startDate else { return 0 }
        
        let offsetComps = Calendar.current.dateComponents([.day], from: startDate, to: Date())
        
        guard let days = offsetComps.day else { return 0 }
        let recentDraw = ( days / 7 ) + 1
        
        return recentDraw
    }
}
