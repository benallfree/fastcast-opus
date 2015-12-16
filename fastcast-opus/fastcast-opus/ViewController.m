//
//  ViewController.m
//  fastcast-opus
//
//  Created by Uncovered on 12/16/15.
//  Copyright © 2015 Allfree Group LLC. All rights reserved.
//

#import "ViewController.h"
#import "Novocaine.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    Novocaine *audioManager = [Novocaine audioManager];
    [audioManager setInputBlock:^(float *newAudio, UInt32 numSamples, UInt32 numChannels) {
        NSLog([NSString stringWithFormat:@"%d", (unsigned int)numSamples]);
        // Now you're getting audio from the microphone every 20 milliseconds or so. How's that for easy?
        // Audio comes in interleaved, so,
        // if numChannels = 2, newAudio[0] is channel 1, newAudio[1] is channel 2, newAudio[2] is channel 1, etc.
    }];
    [audioManager play];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
