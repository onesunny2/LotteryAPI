//
//  LotteryViewController.swift
//  LotteryAPI
//
//  Created by Lee Wonsun on 1/14/25.
//

import UIKit

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
        
        for count in 0...6 {
            drawingNumsLabels.append(UILabel())
        }
       
    }
 
}

extension LotteryViewController: LotteryResult {
    func configHierarchy() {
        view.addSubview(lottoDrawTextfield)
        view.addSubview(subtitleLabel)
        view.addSubview(lottoDateLabel)
        view.addSubview(resultLabel)
        view.addSubview(bonusLabel)
        view.addSubview(lottoDrawPicker)
        
        for index in 0...6 {
            view.addSubview(drawingNumsLabels[index])
        }
    }
    
    func configLayout() {
        <#code#>
    }
    
    func configView() {
        <#code#>
    }
    
    
}
