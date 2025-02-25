//
//  LotteryView.swift
//  LotteryAPI
//
//  Created by Lee Wonsun on 2/24/25.
//

import UIKit
import SnapKit

final class LotteryView: UIView, LotteryResult {
    
    let lottoDrawTextfield = UITextField()
    private let subtitleLabel = UILabel()
    let lottoDateLabel = UILabel()
    let resultLabel = UILabel()
    private let bonusLabel = UILabel()
    var drawingNumsLabels: [UILabel] = []
    var drawingNumsViews: [UIView] = []
    let lottoDrawPicker = UIPickerView()
    private let underlineUIView = UIView()
    let observableButton = UIButton()
    let singleButton = UIButton()
    
    private lazy var drawStackView = {
        let stackview = UIStackView()
        stackview.axis = .horizontal
        stackview.distribution = .equalSpacing
        stackview.alignment = .center
        
        return stackview
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configHierarchy()
        configLayout()
        configView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        drawStackView.arrangedSubviews.forEach {
            $0.layer.cornerRadius = $0.frame.width / 2
        }
    }
    
    func configHierarchy() {
        [lottoDrawTextfield, subtitleLabel, lottoDateLabel, underlineUIView, resultLabel, drawStackView, bonusLabel, observableButton, singleButton].forEach {
            self.addSubview($0)
        }
        
        for _ in 0...7 {
            drawingNumsLabels.append(UILabel())
            drawingNumsViews.append(UIView())
        }
        
        for index in 0...7 {
            drawingNumsViews[index].addSubview(drawingNumsLabels[index])
            drawStackView.addArrangedSubview(drawingNumsViews[index])
        }
    }
    
    func configLayout() {
        lottoDrawTextfield.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(30)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(50)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide).inset(24)
            make.top.equalTo(lottoDrawTextfield.snp.bottom).offset(30)
        }
        
        lottoDateLabel.snp.makeConstraints { make in
            make.trailing.equalTo(self.safeAreaLayoutGuide).inset(24)
            make.centerY.equalTo(subtitleLabel)
        }
        
        underlineUIView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(2)
        }
        
        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(underlineUIView.snp.bottom).offset(40)
            make.centerX.equalTo(self.safeAreaLayoutGuide)
        }
        
        drawStackView.snp.makeConstraints { make in
            make.top.equalTo(resultLabel.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(24)
        }
        
        for index in 0...7 {
            drawingNumsViews[index].snp.makeConstraints { make in
                make.size.equalTo(40)
            }
            drawingNumsLabels[index].snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }
        
        bonusLabel.snp.makeConstraints { make in
            make.trailing.equalTo(self.safeAreaLayoutGuide).inset(27)
            make.top.equalTo(drawStackView.snp.bottom).offset(4)
        }
        
        observableButton.snp.makeConstraints { make in
            make.top.equalTo(bonusLabel.snp.bottom).offset(30)
            make.centerX.equalTo(self.safeAreaLayoutGuide)
            make.width.equalTo(200)
            make.height.equalTo(70)
        }
        
        singleButton.snp.makeConstraints { make in
            make.top.equalTo(observableButton.snp.bottom).offset(10)
            make.centerX.equalTo(self.safeAreaLayoutGuide)
            make.width.equalTo(200)
            make.height.equalTo(70)
        }
    }
    
    func configView() {
        self.backgroundColor = .white
        
        lottoDrawTextfield.inputView = lottoDrawPicker
        lottoDrawPicker.selectedRow(inComponent: 0)
        
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
        
        bonusLabel.text = "보너스"
        bonusLabel.font = .systemFont(ofSize: 13, weight: .medium)
        bonusLabel.textColor = .gray
        
        let observableText = NSAttributedString(string: "Observable 조회", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .semibold)])
        observableButton.setAttributedTitle(observableText, for: .normal)
        observableButton.setTitleColor(.white, for: .normal)
        observableButton.backgroundColor = .black
        observableButton.layer.cornerRadius = 10
        observableButton.clipsToBounds = true
        
        let singleText = NSAttributedString(string: "Single 조회", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .semibold)])
        singleButton.setAttributedTitle(singleText, for: .normal)
        singleButton.setTitleColor(.white, for: .normal)
        singleButton.backgroundColor = .black
        singleButton.layer.cornerRadius = 10
        singleButton.clipsToBounds = true
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
