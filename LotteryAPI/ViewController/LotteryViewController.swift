//
//  LotteryViewController.swift
//  LotteryAPI
//
//  Created by Lee Wonsun on 1/14/25.
//

import UIKit
import SnapKit

class LotteryViewController: UIViewController {
    
    let lottoDrawTextfield = UITextField()
    let subtitleLabel = UILabel()
    let lottoDateLabel = UILabel()
    let resultLabel = UILabel()
    let bonusLabel = UILabel()
    var drawingNumsLabels: [UILabel] = []
    let lottoDrawPicker = UIPickerView()
    let underlineUIView = UIView()
    
    var currentDraw: String = "913회"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        for _ in 0...6 {
            drawingNumsLabels.append(UILabel())
        }
       
        configHierarchy()
        configLayout()
        configView()
    }
 
}

extension LotteryViewController: LotteryResult {
    
    func configHierarchy() {
        view.addSubview(lottoDrawTextfield)
        view.addSubview(subtitleLabel)
        view.addSubview(lottoDateLabel)
        view.addSubview(resultLabel)
        view.addSubview(bonusLabel)
        view.addSubview(underlineUIView)
//        view.addSubview(lottoDrawPicker)
        
        for index in 0...6 {
            view.addSubview(drawingNumsLabels[index])
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
        

        let title = currentDraw + " 당첨결과"
        let attributedString = NSMutableAttributedString(string: title)
        let stringLength = attributedString.length
        attributedString.addAttributes([.foregroundColor: UIColor.lottoYellow, .font: UIFont.systemFont(ofSize: 30, weight: .semibold)],range: NSRange(location: 0, length: currentDraw.count))
        attributedString.addAttributes([.foregroundColor: UIColor.label, .font: UIFont.systemFont(ofSize: 30, weight: .medium)], range: NSRange(location: currentDraw.count, length: stringLength - currentDraw.count))
        resultLabel.attributedText = attributedString
    }
    
    
}
