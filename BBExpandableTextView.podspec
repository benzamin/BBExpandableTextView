Pod::Spec.new do |s|
  s.name     = 'BBExpandableTextView'
  s.version  = '1.0'
  #s.license  = 'MIT'
  s.description  = <<-DESC
            Storyboard based easy to use UITextView subclass that is keyboard-aware & has placeholder-text capability. And BBKeyboardAwareTextField\ is keyboard aware, auto pushes textfield up if its about to go under keyboard, and shows done button.
                   DESC

  s.summary  = 'Storyboard based easy to use UITextView subclass that is keyboard-aware & has placeholder-text capability.'
  s.homepage = 'https://github.com/benzamin/BBExpandableTextView'
  #s.screenshots  = "https://raw.githubusercontent.com/benzamin/BBExpandableTextView/master/screens/sc.gif"
  s.social_media_url = 'http://twitter.com/benzamin1985'
  s.authors  = { 'Benzamin Basher' => 'benzamin1985@gmail.com' }
  s.source   = { :git => 'https://github.com/benzamin/BBExpandableTextView.git', :tag => s.version }
  s.requires_arc = true
  
  s.public_header_files = 'BBExpandableTextView/Classes/BBExpandableTextView.h, BBExpandableTextView/Classes/BBKeyboardAwareTextField.h'
  s.source_files  = "BBExpandableTextView/Classes/BBExpandableTextView.{h,m}, BBExpandableTextView/Classes/BBKeyboardAwareTextField.{h,m}"
  s.ios.deployment_target = '7.0'
  end