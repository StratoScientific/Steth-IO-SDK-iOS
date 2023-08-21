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

    production or stagging
    manager.environment = .stagging

    
    //here we need to process the biquad files and apply filter
    try stethManager.prepare()
    
    //This will start the recording
    try self.stethManager.start()
    
    //This will stop the recording
    try self.stethManager.finish()
    
    cancel session
    try self.stethManager.cancel()
    ```
    
###StethIODelegate

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


###StethIODelegate 
SpectrumGLKViewController is help to display the Spectrum graph in view-controller mode
SpectrumGLKView is help to display the Spectrum graph in view mode

present programatically  or embbed with storyboard

```
        let vc = SpectrumGLKViewController()
        present(vc, animated: true)
        
        let view = SpectrumGLKView(frame: <#>)
        container.addSubView(view);

```
## Important ⚠️
The `API_KEY` in the example application will only work for the example application. Using the same key in another application will not work.

## Author

StethIO, stethio@ionixxtech.com

## License

Steth-IO-SDK is available under the MIT license. See the LICENSE file for more info.
