//
//  PrepareExamViewController.swift
//  Example
//
//  Created by Alex on 21/10/23.
//  Copyright © 2023 StethIO. All rights reserved.
//

import UIKit
import StethIO

class PrepareExamViewController: UIViewController {
    
    @IBOutlet var examTypeSegmentedControl: UISegmentedControl!
    @IBOutlet var audioSampleSegmentedControl: UISegmentedControl!
    
    @IBOutlet var heartGainSlider: UISlider!
    @IBOutlet var lungTargetSlider: UISlider!
    @IBOutlet var heartTargetSlider: UISlider!

    
    @IBOutlet var debugSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        heartGainSlider.value = 2.0 // default value
        lungTargetSlider.value  = 0.1 // default value
        heartTargetSlider.value = 2.0 // default value
        // Do any additional setup after loading the view.
    }
    

 
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ExamViewControllerId"{
            if let controller = segue.destination as? ExamViewController {
                
                let examType = StethIOManager.ExamType.`init`(rawValue: examTypeSegmentedControl.selectedSegmentIndex)
                
                let audioSampleOutputType = StethIOManager.AudioSampleOutputType.init(rawValue: audioSampleSegmentedControl.selectedSegmentIndex) ?? .none
                
                let option = StethIOExamOption(examType: examType,audioSampleType: audioSampleOutputType, heartMinimumGain: heartGainSlider.value, lungTargetLevel: lungTargetSlider.value, heartTargetLevel: heartTargetSlider.value)
                
                StethIOBase.shared.debug = debugSwitch.isOn
                controller.examOption = option
            }
        }
    }
 

}
