//
//  ViewController.swift
//  Example
//
//  Created by Alex on 18/05/20.
//  Copyright © 2020 StethIO. All rights reserved.
//

import UIKit
import StethIO
import AVFoundation

let API_KEY = "+b8i2KirhtItVb//IvrzXw1d5HWZ/23CFfXhfIczPfE=";
//let API_KEY = "+YqThBGUgSWvsCc/8np7N85NyrXHWWZbyQF3ojGHfHhbbFLLs/mSv/t75cDHOcOO";

class ViewController: UIViewController, StethIOManagerDelegate {

    
    @IBOutlet var actionToolBar: ActionToolBar!
    @IBOutlet var clearSwitch: UISwitch!
    @IBOutlet var debugSwitch: UISwitch!

    @IBOutlet var durationLabel: UILabel!
    @IBOutlet var bpmabel: UILabel!
    @IBOutlet var graph: SpectrumGLKView!

    var graphViewController: SpectrumGLKViewController!
    
    let manager = StethIOManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        manager.audioSessionPort = .headphones
        manager.environment = .stagging
        manager.delegate = self
        manager.apiKey = API_KEY
        manager.examType = .heart //for heart
        manager.sampleType = .none
        manager.debug = true
        /// UI
        self.durationLabel.text = 0.formatSecondsToString()
        actionToolBar.isActive(false)
        // Do any additional setup after loading the view.
    }
    
    // MARK: Button Action
    @IBAction func startButtonAction(_ sender: Any) {
        guard let button = sender as? UIButton else {
            return
        }
//        do {
//            try AVAudioSession.sharedInstance().change(audioSessionPort: .headsetMic)
//        } catch {
//            print(error)
//            showAlert("Error", message: "unable to change port \(error.localizedDescription)")
//            return
//        }
//
//        if !manager.isHeadphonesConnected {
//            showAlert("Error", message: "Please connect wired Steth IO Spot to continue the examination.")
//            return
//        }
        
        
        if manager.isRecording {
            manager.isPause = !manager.isPause
            button.setTitle( manager.isPause ? "Resume": "Pause", for: .normal)
            return
        }
        button.setTitle("Pause", for: .normal)
        do {
            try manager.start()
        }
        catch {
            print(error)
        }
        print("isHeadphonesConnected", manager.isHeadphonesConnected)
        
    }
  
    @IBAction func stopButtonAction(_ sender: UIButton) {
        manager.finish(clear: clearSwitch.isOn)
    }
    
    @IBAction func restartAction(_ sender: UIButton) {
        manager.cancel()
        do {
            try manager.start()
//            let vc = SpectrumGLKViewController()
//            self.present(vc, animated: true)
        }
        catch {
            print(error)
        }
    }
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        manager.cancel()
    }
    @IBAction func changeTypeAction(_ sender: UISegmentedControl) {
        manager.examType = StethIOManager.ExamType.`init`(rawValue: sender.selectedSegmentIndex)
    }
    @IBAction func audoSampleAction(_ sender: UISegmentedControl) {
        manager.sampleType = StethIOManager.AudioSampleOutputType.init(rawValue: sender.selectedSegmentIndex) ?? .none
    }
    @IBAction func debugChange(_ sender: UISwitch) {
        manager.debug = sender.isOn
    }
    // MARK:  Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "GraphViewController"){
            graphViewController = segue.destination as? SpectrumGLKViewController
//            let graph = graphViewController.view as? SpectrumGLKView
//            graph?.spectrumWindowWidthSeconds = SpectrumWindowWidthSeconds(hearts: 3.5, lungs: 10.5)
        }
    }
    
    // MARK: StethIO Delegate
    func stethIOManagerReadyToStart() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            self.actionToolBar.reset()
        }
    }
    
    func stethIOManagerDidStarted() {
        self.actionToolBar.isActive(true)
    }
    
    func stethIOManagerDidCancelled() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            self.actionToolBar.reset()
            self.durationLabel.text = 0.formatSecondsToString()
        }
    }
    func stethIOManagerDidUpdateDuration(_ seconds: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            self.durationLabel.text = seconds.formatSecondsToString()
        }
    }
    func stethIOManagerDidFinished(url: URL?) {
        print("stethIOManagerDidFinished", url ?? "No audio")
        if let url = url, let filename = url.pathComponents.last?.description, let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first{
            let toURL = "\(documentsPath)/\(filename)"
            try?    FileManager.default.moveItem(at: url, to: .init(fileURLWithPath: toURL))
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            self.actionToolBar.reset()
            self.actionToolBar.isActive(false)
            self.actionToolBar.buttonStart.isActive = true
        }
    }
    func stethIOManagerDidUpdateHeartBPM(_ bpm: Double) {
//        print("stethIOManagerDidUpdateHeartBPM", bpm)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            self.bpmabel.text = "\(bpm)"
        }
    }
    
}

extension StethIOManager.ExamType {
    static func `init`(rawValue: Int)->StethIOManager.ExamType {
        if rawValue == 0{
            return StethIOManager.ExamType.heart
        }else if rawValue == 1 {
            return StethIOManager.ExamType.lungs
        }
        return StethIOManager.ExamType.vascular
    }
}

extension ViewController{
     func showAlert(_ title:String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
