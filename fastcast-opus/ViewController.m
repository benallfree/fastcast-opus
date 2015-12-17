//
//  ViewController.m
//  fastcast-opus
//
//  Created by Uncovered on 12/16/15.
//  Copyright © 2015 Allfree Group LLC. All rights reserved.
//

#import "ViewController.h"
#import "Novocaine.h"
#import "RingBuffer.h"

@interface ViewController()
    @property (nonatomic, assign) RingBuffer *ringBuffer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    __weak ViewController * wself = self;
    
    self.ringBuffer = new RingBuffer(32768, 2);

    Novocaine *audioManager = [Novocaine audioManager];
    
    // Make some NOISE
//    [audioManager setOutputBlock:^(float *newdata, UInt32 numFrames, UInt32 thisNumChannels)
//    {
//        for (int i = 0; i < numFrames * thisNumChannels; i++) {
//            newdata[i] = (rand() % 100) / 100.0f / 2;
//        }
//    }];
    

    // Play-through
    __weak typeof(self)wself = self;
    
        [audioManager setInputBlock:^(float *data, UInt32 numFrames, UInt32 numChannels) {
            float volume = 0.5;
            vDSP_vsmul(data, 1, &volume, data, 1, numFrames*numChannels);
            wself.ringBuffer->AddNewInterleavedFloatData(data, numFrames, numChannels);
        }];
    
    
        [audioManager setOutputBlock:^(float *outData, UInt32 numFrames, UInt32 numChannels) {
            wself.ringBuffer->FetchInterleavedData(outData, numFrames, numChannels);
        }];
    
//    [audioManager setInputBlock:^(float *newAudio, UInt32 numSamples, UInt32 numChannels) {
//        NSLog([NSString stringWithFormat:@"%d", (unsigned int)numSamples]);
//        // Now you're getting audio from the microphone every 20 milliseconds or so. How's that for easy?
//        // Audio comes in interleaved, so,
//        // if numChannels = 2, newAudio[0] is channel 1, newAudio[1] is channel 2, newAudio[2] is channel 1, etc.
//    }];
    [audioManager play];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
