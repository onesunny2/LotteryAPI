//
//  LotteryViewController.swift
//  LotteryAPI
//
//  Created by Lee Wonsun on 1/14/25.
//

import UIKit
import SnapKit
import Alamofire

final class LotteryViewController: UIViewController {
    
    private let mainView = LotteryView()
 
    var currentDraw: String = ""
    var drawNumber: [String] = ["11", "22", "33", "44", "5", "6", "+", "13"]
    var countArray: [Int] = []
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        currentDraw = "1154회"
        getAPIInfo("1154")
        
        configPicker()

        countArray = Array(1...caculateDate())
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        view.endEditing(true)
    }

    func getAPIInfo(_ drwNo: String) {
        let url = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(drwNo)"
        
        AF.request(url, method: .get).responseDecodable(of: Lottery.self) { response in
            
            switch response.result {
            case .success(let value):
                
                self.drawNumber = value.lotteryList
                
                for index in 0...7 {
                    self.mainView.drawingNumsLabels[index].text = self.drawNumber[index]
                }
                
                self.reloadBallColors()
                
                self.mainView.lottoDateLabel.text = "\(value.drwNoDate) 추첨"
                
            case .failure(let value):
                print(value
                )
            }
        }
    }
    
    func caculateDate() -> Int {
        let firstDate = DateComponents(year: 2002, month: 12, day: 07)
        let startDate = Calendar.current.date(from: firstDate)!
        
        let offsetComps = Calendar.current.dateComponents([.day], from: startDate, to: Date())
        
        guard let days = offsetComps.day else { return 0 }
        let drw = ( days / 7 ) + 1
        
        return drw
    }
 
}

// MARK: - pickerView 설정
extension LotteryViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func configPicker() {
        mainView.lottoDrawPicker.delegate = self
        mainView.lottoDrawPicker.dataSource = self
    }
    
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
        mainView.resultLabel.attributedText = resultTitle()
        
        getAPIInfo(title)
    }
    
}

// MARK: - 레이아웃 및 속성 설정
extension LotteryViewController {

    func resultTitle() -> NSAttributedString {
        let title = currentDraw + " 당첨결과"
        let attributedString = NSMutableAttributedString(string: title)
        let stringLength = attributedString.length
        attributedString.addAttributes([.foregroundColor: UIColor.lottoYellow, .font: UIFont.systemFont(ofSize: 30, weight: .semibold)],range: NSRange(location: 0, length: currentDraw.count))
        attributedString.addAttributes([.foregroundColor: UIColor.label, .font: UIFont.systemFont(ofSize: 30, weight: .medium)], range: NSRange(location: currentDraw.count, length: stringLength - currentDraw.count))
        
        return attributedString
    }
    
    func configDrawNumsLabels() {
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
    
    func reloadBallColors() {
        
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
