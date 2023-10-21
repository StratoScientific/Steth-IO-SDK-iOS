# Steth-IO-SDK

## Example

To run the example project, clone the repo from the Example directory first.

## Requirements
- The recording frequency must be 44.1khz because the filters are designed in such way.
- The heart/lung filters will work as expected only with Steth IO hardware.

## Installation 📱

### CocoaPods

Use [CocoaPods](http://www.cocoapods.org).

1. Add `pod 'Steth-IO-SDK'` to your *Podfile* with source like below.

```ruby
pod 'Steth-IO-SDK', :git => 'https://github.com/StratoScientific/Steth-IO-SDK-iOS.git'
```
2. Install the pod(s) by running `pod install`.
3. Add `import StethIO` in the .swift files where you want to use it



### SDK Usage ✨
1. In ViewController
```swift
    //Initializer
    StethIOBase.shared.apiKey =  "YOUR_API_KEY"
    StethIOBase.shared.debug = true
    StethIOBase.shared.onReady {
    }
```  
2. Prepare for exam
```swift         
    let stethManager = StethIOManager()
    
    //Set delegate to receive bpm and saved samples url
    stethManager.delegate = self
    
    //set the filter mode to heart/lung
    stethManager.examType = .heart // heart/lungs
    
    //set the sample type to none/processedSamples/rawSamples
    stethManager.sampleType = .none
    
    //This will start the recording
    try stethManager.start(StethIOExamOption())
    
    //This will stop the recording
    stethManager.finish()
    
    // cancel session
    stethManager.cancel()
```
    
### StethIOManagerDelegate

```
    ///MARK:- StethIO Delegate
    func stethIOManagerDidStarted() {
        // exam started
    }
    
    func stethIOManagerDidCancelled() {
      // exam cancelled by user
    }
    func stethIOManagerDidUpdateDuration(_ seconds: TimeInterval) {
       // while taking the exam exation duration will be update
    }
    func stethIOManagerUpdateSpectrum(_ graph: OpaquePointer?, examType: StethIOManager.ExamType) {
         spectrumView.update(graph: graph, examType: examType)
    }
    func stethIOManagerDidFinished(url: URL?) {
     // after finish the example, return the audio sample local file path
    }
    func stethIOManagerDidUpdateHeartBPM(_ bpm: Double) {
        // it will be trigger only type heart
    }
    
```   


### SpectrumGLKView 
SpectrumGLKViewController is help to display the Spectrum graph in view-controller mode
SpectrumGLKView is help to display the Spectrum graph in view mode

present programatically  or embbed with storyboard

```
        let vc = SpectrumGLKViewController()
        present(vc, animated: true)
        
        let view = SpectrumGLKView(frame: <#>)
        container.addSubView(view);

```




|Param |   Type    | Required   | Description  | 
|:--- | :---:| :---:| :--- |
|apiKey| String|✅|requied valid api key|
|environment| Environment | | default `production`, change the environment `STAGING` or `PRODUCTION`|
|debug| Boolean ||default value is `false`|


StethIOManager

|Param |   Type    | Required   | Description  | 
|:--- | :---:| :---:| :--- |
|delegate| `StethIOManagerDelegate`|✅|callback events|
|isPause| Boolean | | recording of pause status `Boolean`|
|isRecording| Boolean | | recording is active or not `Boolean`|
|isHeadphonesConnected| Boolean | | Headphones is Connected or not  `Boolean`|
|isActiveNoiseCancel| Boolean ||default value is `true`|
|start| Function |✅|start the exam, when API key are valid and audio permission|
|pause| Function | | pause  recording, if recording is running|
|resume| Function | | resume  recording, if recording is pause|
|cancel| Function | | cancel  recording, if recording is running|
|finish| Function | | finish  recording, if recording is running|

Exam Properties `StethIOExamOption`

|Param |   Type    | Required  | Default  | Description  | 
|:--- | :---:| :---:| :---:| :--- |
|examType| `ExamType` |✅| `heart` | ExamType  `heart`,`lungs`, `vascular`|
|sampleType| `AudioSampleOutputType` |✅| `rawSamples` | SampleType `none`, `rawSamples`, `processedSamples`, `autoGain`|
|heartMinimumGain| `Float` |✅| `heart` | Automatic heart gain will never drop below this setting values of 2 to 10 are probably best|
|lungTargetLevel| `Float` |✅| `0.1` | This sets the target average level for the automatic lung gain. levels between 0.1 and 1.0 are probably best|
|heartTargetLevel| `Float` |✅| `2.0` | This is the target peak level for the automatic heart gain, prior to limiting. A level greater than 1.0 is no problem, although by 4.0 the distortion might be audible. This can be set from 0.5 to 4.0, settings from 1.0 to 3.0 are probably best|




## Important ⚠️
The `API_KEY` in the example application will only work for the example application. Using the same key in another application will not work.

## Author

StethIO, stethio@ionixxtech.com

## License

Steth-IO-SDK is available under the MIT license. See the LICENSE file for more info.
