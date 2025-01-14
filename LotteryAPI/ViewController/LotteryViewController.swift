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
        
        bonusLabel.text = "sdsddddd"
    }
    
    
}
