//
//  LotteryViewController.swift
//  LotteryAPI
//
//  Created by Lee Wonsun on 1/14/25.
//

import UIKit
import SnapKit
import Alamofire

class LotteryViewController: UIViewController {
    
    let lottoDrawTextfield = UITextField()
    let subtitleLabel = UILabel()
    let lottoDateLabel = UILabel()
    let resultLabel = UILabel()
    let bonusLabel = UILabel()
    var drawingNumsLabels: [UILabel] = []
    var drawingNumsViews: [UIView] = []
    let lottoDrawPicker = UIPickerView()
    let underlineUIView = UIView()
    
    lazy var drawStackView = {
        let stackview = UIStackView()
        stackview.axis = .horizontal
        stackview.distribution = .equalSpacing
        stackview.alignment = .center
        
        return stackview
    }()
    
    var currentDraw: String = ""
    var drawNumber: [String] = ["11", "22", "33", "44", "5", "6", "+", "13"]
    var countArray = Array(1...1154)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        currentDraw = "1154회"
        getAPIInfo("1154")
        
        configPicker()
        
        for _ in 0...7 {
            drawingNumsLabels.append(UILabel())
            drawingNumsViews.append(UIView())
        }
       
        configHierarchy()
        configLayout()
        configView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        drawStackView.arrangedSubviews.forEach {
            $0.layer.cornerRadius = $0.frame.width / 2
        }
    }

    func getAPIInfo(_ drwNo: String) {
        let url = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(drwNo)"
        
        AF.request(url, method: .get).responseDecodable(of: Lottery.self) { response in
            
            switch response.result {
            case .success(let value):
                self.drawNumber[0] = String(value.drwtNo1)
                self.drawNumber[1] = String(value.drwtNo2)
                self.drawNumber[2] = String(value.drwtNo3)
                self.drawNumber[3] = String(value.drwtNo4)
                self.drawNumber[4] = String(value.drwtNo5)
                self.drawNumber[5] = String(value.drwtNo6)
                self.drawNumber[7] = String(value.bnusNo)
                
                self.reloadDrawNumbers()
                
                self.lottoDateLabel.text = "\(value.drwNoDate) 추첨"
                
            case .failure(let value):
                print(value
                )
            }
        }
    }
}

// MARK: - pickerView 설정
extension LotteryViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func configPicker() {
        lottoDrawTextfield.inputView = lottoDrawPicker
        
        lottoDrawPicker.delegate = self
        lottoDrawPicker.dataSource = self
        lottoDrawPicker.selectedRow(inComponent: 0)
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
        
        lottoDrawTextfield.text = title
        currentDraw = "\(title)회"
        resultLabel.attributedText = resultTitle()
        
        getAPIInfo(title)
    }
    
}

// MARK: - 레이아웃 및 속성 설정
extension LotteryViewController: LotteryResult {
    
    func configHierarchy() {
        view.addSubview(lottoDrawTextfield)
        view.addSubview(subtitleLabel)
        view.addSubview(lottoDateLabel)
        view.addSubview(resultLabel)
        view.addSubview(bonusLabel)
        view.addSubview(underlineUIView)
        
        view.addSubview(drawStackView)
        for index in 0...7 {
            drawingNumsViews[index].addSubview(drawingNumsLabels[index])
            drawStackView.addArrangedSubview(drawingNumsViews[index])
            
        }
    }
    
    func configLayout() {
        lottoDrawTextfield.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(50)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.top.equalTo(lottoDrawTextfield.snp.bottom).offset(30)
        }
        
        lottoDateLabel.snp.makeConstraints { make in
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.centerY.equalTo(subtitleLabel)
        }
        
        underlineUIView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(2)
        }
        
        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(underlineUIView.snp.bottom).offset(40)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        drawStackView.snp.makeConstraints { make in
            make.top.equalTo(resultLabel.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
        }
        
        for index in 0...7 {
            drawingNumsViews[index].snp.makeConstraints { make in
                make.size.equalTo(40)
            }
            drawingNumsLabels[index].snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }
        
        // 🥺🥺🥺 보너스 label 바로 위 stackView로 여백을 잡으면 스택뷰가 원형이 깨져요... 해결하지 못해서 정말 이유가 궁금합니다 ㅠㅠ 구글링도 실패했어요...
        // 아주 신기하게도 stackView 기준이 아니라 다른 객체를 기준으로 여백을 잡아도 cornerRadius가 폴립니다..
        /* bonusLabel.snp.makeConstraints { make in
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.top.equalTo(drawStackView.snp.bottom).offset(4)
        } */
        
    }
    
    func configView() {
        lottoDrawTextfield.borderStyle = .roundedRect
        lottoDrawTextfield.layer.cornerRadius = 5
        lottoDrawTextfield.clipsToBounds = true
        lottoDrawTextfield.layer.borderColor = UIColor.systemGray6.cgColor
        lottoDrawTextfield.layer.borderWidth = 2
        lottoDrawTextfield.layer.backgroundColor = UIColor.clear.cgColor
        lottoDrawTextfield.placeholder = "조회를 원하는 회차를 골라주세요 :)"
        lottoDrawTextfield.textAlignment = .center
        
        subtitleLabel.text = "당첨번호 안내"
        subtitleLabel.font = .systemFont(ofSize: 17, weight: .medium)
        subtitleLabel.textColor = .label
        subtitleLabel.textAlignment = .left
        
        lottoDateLabel.text = "2020-06-30" + " 추첨"
        lottoDateLabel.font = .systemFont(ofSize: 13, weight: .medium)
        lottoDateLabel.textColor = .gray
        lottoDateLabel.textAlignment = .right
        
        underlineUIView.backgroundColor = .systemGray6
    
        resultLabel.attributedText = resultTitle()
        
        reloadDrawNumbers()
        
        bonusLabel.text = "보너스"
        bonusLabel.font = .systemFont(ofSize: 13, weight: .medium)
        bonusLabel.textColor = .gray
    }
    
    func resultTitle() -> NSAttributedString {
        let title = currentDraw + " 당첨결과"
        let attributedString = NSMutableAttributedString(string: title)
        let stringLength = attributedString.length
        attributedString.addAttributes([.foregroundColor: UIColor.lottoYellow, .font: UIFont.systemFont(ofSize: 30, weight: .semibold)],range: NSRange(location: 0, length: currentDraw.count))
        attributedString.addAttributes([.foregroundColor: UIColor.label, .font: UIFont.systemFont(ofSize: 30, weight: .medium)], range: NSRange(location: currentDraw.count, length: stringLength - currentDraw.count))
        
        return attributedString
    }
    
    func reloadDrawNumbers() {
        for index in 0...7 {
            drawingNumsLabels[index].text = drawNumber[index]
            drawingNumsLabels[index].textColor = .white
            drawingNumsLabels[index].textAlignment = .center
            drawingNumsLabels[index].font = .systemFont(ofSize: 20, weight: .semibold)
        }
        
        drawingNumsLabels[6].text = drawNumber[6]
        drawingNumsLabels[6].textColor = .black
        drawingNumsLabels[6].textAlignment = .center
        drawingNumsLabels[6].font = .systemFont(ofSize: 20, weight: .semibold)
        
        for index in 0...7 {
            drawingNumsViews[index].clipsToBounds = true
            
            if let number = Int(drawNumber[index]) {
                
                switch number {
                case 1...10:
                    drawingNumsViews[index].backgroundColor = .lottoYellow
                case 11...20:
                    drawingNumsViews[index].backgroundColor = .lottoBlue
                case 21...30:
                    drawingNumsViews[index].backgroundColor = .lottoRed
                case 31...40:
                    drawingNumsViews[index].backgroundColor = .lottoGray
                case 41...45:
                    drawingNumsViews[index].backgroundColor = .lottoGreen
                default:
                    drawingNumsViews[index].backgroundColor = .clear
                }
            }
        }
    }
}
