# BBExpandableTextView
Storyboard based simple to use UITextView subclass that is keyboard-aware &amp; has placeholder-text capability. Install this library via cocoapods or manually, then drag a UITextView in your storyboard and set its class as BBExpandableTextView. Tweak the parameters in the storyboard and enjoy!

### Installing with CocoaPods

[CocoaPods](http://cocoapods.org) is very popular dependency manager for iOS projects. It automates and simplifies the process of using 3rd-party libraries like BBLocation in your projects. If you don't have cocoapods installed in your mac already, you can install it with the following command:

```bash
$ gem install cocoapods
```

#### Podfile
If you already have a Podfile, add the following line in your podfile:

```ruby
pod 'BBExpandableTextView'
```

If you already dont have a podfile, To integrate BBExpandableTextView into your Xcode project using CocoaPods, create and add it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '7.0'

target 'YourTargetName' do
pod 'BBExpandableTextView'
end
```

Then, run the following command:

```bash
$ pod install
```
And the pod should be installed in your project. **PLEASE NOTE:** Close the yourProject.xcodeProj and open the yourProject.xcworkspace, as the pod has been initiated, from now one use the yourProject.xcworkspace to work with. Please refer to [CocoaPods](http://cocoapods.org) for detailed info.

#### Manual Installation
Just add the BBExpandableTextView.h and BBExpandableTextView.m files in your project [From Here](https://github.com/benzamin/BBExpandableTextView/tree/master/BBExpandableTextView/Classes). Drag a UITextView in your storeyboard and set its class as BBExpandableTextView.
