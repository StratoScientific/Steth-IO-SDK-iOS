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
import AVKit

let API_KEY = "+b8i2KirhtItVb//IvrzXw1d5HWZ/23CFfXhfIczPfE=";
//let API_KEY = "+YqThBGUgSWvsCc/8np7N85NyrXHWWZbyQF3ojGHfHhbbFLLs/mSv/t75cDHOcOO";

class ExamViewController: UIViewController, StethIOManagerDelegate {
    
    
    @IBOutlet var actionToolBar: ActionToolBar!
    
    @IBOutlet var durationLabel: UILabel!
    @IBOutlet var bpmabel: UILabel!
    @IBOutlet var playButton: UIButton!
    
    let manager = StethIOManager()
    
    var examOption: StethIOExamOption!
    
    
    var audioURL: URL?{
        didSet{
            playButton.isHidden = audioURL == nil
        }
    }
    var spectrumGLKViewController: SpectrumGLKViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        manager.audioSessionPort = .headphones
        StethIOBase.shared.environment = .stagging
        StethIOBase.shared.apiKey = API_KEY
        StethIOBase.shared.debug = true
        StethIOBase.shared.onReady {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                self.actionToolBar.reset()
            }
        }
        manager.delegate = self
        manager.sampleType = .processedSamples
        manager.isActiveNoiseCancel = true
        /// UI
        self.durationLabel.text = 0.formatSecondsToString()
        actionToolBar.isActive(false)
        audioURL = nil
        // Do any additional setup after loading the view.
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        manager.cancel()
    }
  
    // MARK: Button Action
    @IBAction func startButtonAction(_ sender: Any) {
        guard let button = sender as? UIButton else {
            return
        }
        if manager.isRecording {
            manager.isPause = !manager.isPause
            button.setTitle( manager.isPause ? "Resume": "Pause", for: .normal)
            return
        }
        button.setTitle("Pause", for: .normal)
        do {
            audioURL = nil
            try manager.start(examOptions:  examOption)
        }
        catch {
            showAlert("Start Error", message: error.localizedDescription)
        }
        print("isHeadphonesConnected", manager.isHeadphonesConnected)
        
    }
    
    @IBAction func stopButtonAction(_ sender: UIButton) {
        manager.finish()
    }
    
    @IBAction func restartAction(_ sender: UIButton) {
        manager.cancel()
        do {
            try manager.start(examOptions: examOption)
        }
        catch {
            showAlert("Re-Start Error", message: error.localizedDescription)
        }
    }
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        manager.cancel()
    }
    @IBAction func backButtonAction(_ sender: UIButton) {
        manager.cancel()
        self.dismiss(animated: true)
    }

   
    @IBAction func debugChange(_ sender: UISwitch) {
        StethIOBase.shared.debug = sender.isOn
    }
    @IBAction func playButton(_ sender: UIButton) {
        let player = AVPlayer(url: audioURL!)
        let avController = AVPlayerViewController()
        avController.player = player
        present(avController, animated: true)
        player.play()
        
    }
    
    // MARK: StethIO Delegate
   
    func stethIOManagerDidStarted() {
        self.actionToolBar.isActive(true)
    }
    
    func stethIOManagerDidCancelled() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            self.actionToolBar.reset()
            self.durationLabel.text = 0.formatSecondsToString()
        }
    }
    func stethIOManagerUpdateSpectrum(_ graph: OpaquePointer?, examType: StethIOManager.ExamType) {
        if let spectrumView = spectrumGLKViewController.view as? SpectrumGLKView{
            spectrumView.update(graph: graph, examType: examType)
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
            let toURLString = "\(documentsPath)/\(filename)"
            let toURL = URL.init(fileURLWithPath: toURLString)
            try?    FileManager.default.moveItem(at: url, to: toURL)
            audioURL = toURL
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            self.actionToolBar.reset()
            self.actionToolBar.isActive(false)
            self.actionToolBar.buttonStart.isActive = true
        }
    }
    func stethIOManagerDidUpdateHeartBPM(_ bpm: Double) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            self.bpmabel.text = "\(bpm)"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "spectrumGLKViewController" {
            spectrumGLKViewController = segue.destination as? SpectrumGLKViewController
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

extension ExamViewController{
    func showAlert(_ title:String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
