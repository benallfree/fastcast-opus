//
//  ViewController.h
//  FastOpus
//
//  Created by Altair on 12/16/15.
//  Copyright © 2015 altair. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSIOpusEncoder.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController<AVCaptureAudioDataOutputSampleBufferDelegate>
{
    
}

@property (strong) AVCaptureDevice *microphone;
@property (strong) AVCaptureAudioDataOutput *audio;
@property (strong) AVCaptureSession *captureSession;

@property (strong) CSIOpusEncoder *encoder;


@property (assign) double sampleRate;

@end

