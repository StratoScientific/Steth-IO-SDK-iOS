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
    let stethManager = StethIOManager.shared
    
    //Enter your API key here
    stethManager.apiKey = "YOUR_API_KEY"
    
    //Set delegate to receive bpm and saved samples url
    stethManager.delegate = self
    
    //set the filter mode to heart/lung
    stethManager.examType = .heart // heart/lungs
    
    //set the sample type to none/processedSamples/rawSamples
    stethManager.sampleType = .none

    // production or stagging
    stethManager.environment = .production
    
    //This will start the recording
    try stethManager.start()
    
    //This will stop the recording
    stethManager.finish()
    
    // cancel session
    stethManager.cancel()
    ```
    
### StethIOManagerDelegate

```
    ///MARK:- StethIO Delegate
    func stethIOManagerReadyToStart() {
        SDK read to start the exam. your api key is valid
    }
    
    func stethIOManagerDidStarted() {
        // exam started
    }
    
    func stethIOManagerDidCancelled() {
      // exam cancelled by user
    }
    func stethIOManagerDidUpdateDuration(_ seconds: TimeInterval) {
       // while taking the exam exation duration will be update
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
|:--- | :---:| :---:| :--- | ---|
|delegate| `StethIOManagerDelegate`|✅|callback events|
|apiKey| String|✅|requied valid api key|
|examType| `ExamType` |✅|ExamType  `heart`,`lungs`, `vascular`|
|sampleType| `AudioSampleOutputType` |✅|SampleType `NONE`, `RAW_AUDIO`, `PROCESSED_AUDIO`|
|isReady| Boolean | | SDK is ready for exam|
|isPause| Boolean | | recording of pause status `Boolean`|
|isRecording| Boolean | | recording is active or not `Boolean`|
|environment| Environment | | default `production`, change the environment `STAGING` or `PRODUCTION`|
|isHeadphonesConnected| Boolean | | Headphones is Connected or not  `Boolean`|
|debug| Boolean ||default value is `false`|
|start| Function |✅|start the exam, when API key are valid and audio permission|
|pause| Function | | pause  recording, if recording is running|
|resume| Function | | resume  recording, if recording is pause|
|cancel| Function | | cancel  recording, if recording is running|
|finish| Function | | finish  recording, if recording is running|


## Important ⚠️
The `API_KEY` in the example application will only work for the example application. Using the same key in another application will not work.

## Author

StethIO, stethio@ionixxtech.com

## License

Steth-IO-SDK is available under the MIT license. See the LICENSE file for more info.
