Pod::Spec.new do |spec|
    spec.name         = 'Novocaine'
    spec.version      = '0.0.1'
    spec.summary      = 'Novocaine'
    spec.source_files = 'Novocaine/'
    spec.requires_arc = false
    spec.ios.deployment_target = '6.0'
    spec.frameworks = 'AudioToolbox','Accelerate'
    spec.libraries = 'stdc++'
end
