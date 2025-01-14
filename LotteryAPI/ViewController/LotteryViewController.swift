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
        <#code#>
    }
    
    func configLayout() {
        <#code#>
    }
    
    func configView() {
        <#code#>
    }
    
    
}
