//
//  LotteryViewController.swift
//  LotteryAPI
//
//  Created by Lee Wonsun on 1/14/25.
//

import UIKit
import SnapKit
import Alamofire
import RxCocoa
import RxSwift

final class LotteryViewController: UIViewController {
    
    private let mainView = LotteryView()
    private let viewModel = LotteryViewModel()
    private let disposeBag = DisposeBag()
 
    var currentDraw: String = ""
    var drawNumber: [String] = ["11", "22", "33", "44", "5", "6", "+", "13"]
    var countArray: [Int] = []
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        bind()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        view.endEditing(true)
    }
    
    private func bind() {
        
        let input = LotteryViewModel.Input(callRequest: Observable.just(()))
        let output = viewModel.transform(input: input)
        
        
        output.lotteryList
            .bind(with: self) { owner, list in
                
                list.enumerated().forEach { index, element in
                    owner.mainView.drawingNumsLabels[index].text = element
                }
                
                owner.configDrawNumsLabels(list)
                owner.reloadBallColors(list)
            }
            .disposed(by: disposeBag)
            
        output.drwNoDate
            .map { "\($0) 추첨"}
            .bind(to: mainView.lottoDateLabel.rx.text)
            .disposed(by: disposeBag)
        
        
        // TODO: .withUnretained(self) 쓰면 오류나는 이유
        output.drwNo
            .map { String($0) }
            .map { self.resultTitle($0) }
            .bind(to: mainView.resultLabel.rx.attributedText)
            .disposed(by: disposeBag)
    }
}

// MARK: - pickerView 설정
extension LotteryViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let title = String(countArray.reversed()[row])
        
        return title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let title = String(countArray.reversed()[row])
        
        mainView.lottoDrawTextfield.text = title
        currentDraw = "\(title)회"
//        mainView.resultLabel.attributedText = resultTitle()
    }
    
}

// MARK: - 레이아웃 및 속성 설정
extension LotteryViewController {

    func resultTitle(_ currentDraw: String) -> NSAttributedString {
        let title = currentDraw + " 당첨결과"
        let attributedString = NSMutableAttributedString(string: title)
        let stringLength = attributedString.length
        attributedString.addAttributes([.foregroundColor: UIColor.lottoYellow, .font: UIFont.systemFont(ofSize: 30, weight: .semibold)],range: NSRange(location: 0, length: currentDraw.count))
        attributedString.addAttributes([.foregroundColor: UIColor.label, .font: UIFont.systemFont(ofSize: 30, weight: .medium)], range: NSRange(location: currentDraw.count, length: stringLength - currentDraw.count))
        
        return attributedString
    }
    
    func configDrawNumsLabels(_ drawNumber: [String]) {
        for index in 0...7 {
            mainView.drawingNumsLabels[index].text = drawNumber[index]
            mainView.drawingNumsLabels[index].textColor = .white
            mainView.drawingNumsLabels[index].textAlignment = .center
            mainView.drawingNumsLabels[index].font = .systemFont(ofSize: 20, weight: .semibold)
            
            mainView.drawingNumsViews[index].clipsToBounds = true
        }
        
        mainView.drawingNumsLabels[6].text = drawNumber[6]
        mainView.drawingNumsLabels[6].textColor = .black
        mainView.drawingNumsLabels[6].textAlignment = .center
        mainView.drawingNumsLabels[6].font = .systemFont(ofSize: 20, weight: .semibold)
    }
    
    func reloadBallColors(_ drawNumber: [String]) {
        
        for index in 0...7 {
 
            if let number = Int(drawNumber[index]) {
                
                switch number {
                case 1...10:
                    mainView.drawingNumsViews[index].backgroundColor = .lottoYellow
                case 11...20:
                    mainView.drawingNumsViews[index].backgroundColor = .lottoBlue
                case 21...30:
                    mainView.drawingNumsViews[index].backgroundColor = .lottoRed
                case 31...40:
                    mainView.drawingNumsViews[index].backgroundColor = .lottoGray
                case 41...45:
                    mainView.drawingNumsViews[index].backgroundColor = .lottoGreen
                default:
                    mainView.drawingNumsViews[index].backgroundColor = .clear
                }
            }
        }
    }
}
