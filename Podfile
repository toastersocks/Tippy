use_frameworks!

workspace 'Tippy.xcworkspace'
xcodeproj 'Tippy.xcodeproj'
xcodeproj '../Tipout/Tipout.xcodeproj'


def rac_pod
    
    pod 'ReactiveCocoa'
    
end

def testing_pods
    
    pod 'Nimble', '1.0.0-rc.1'
    pod 'Quick', '>=0.3.0'
    pod 'NimbleFox', :git => 'https://github.com/toastersocks/NimbleFox.git', :branch => 'toastersocks-xcode-6.3'
    
end


target :'Tippy' do
    xcodeproj 'Tippy.xcodeproj'
    rac_pod
end

target :'TippyTests' do
    xcodeproj 'Tippy.xcodeproj'
    rac_pod
    testing_pods
end

target :'TipoutTests' do
    xcodeproj '../Tipout/Tipout.xcodeproj'
    testing_pods
end
