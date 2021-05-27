//
//  KJMidiPlayerVC.m
//  KJPlayerDemo
//
//  Created by 杨科军 on 2021/2/2.
//  Copyright © 2021 杨科军. All rights reserved.
//  https://github.com/yangKJ/KJPlayerDemo

#import "KJMidiPlayerVC.h"
#import "KJMIDIPlayer.h"
@interface KJMidiPlayerVC ()<UIPickerViewDataSource, UIPickerViewDelegate>{
    NSInteger index;
}
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel1;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel2;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic,strong) NSArray *temps;

@end

@implementation KJMidiPlayerVC
- (void)dealloc{
    [KJMIDIPlayer kj_attempDealloc];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
}
- (void)setUI{
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    self.label.text = [NSString stringWithFormat:@"midi音源：%@",self.temps[[self.pickerView selectedRowInComponent:0]]];
}
- (IBAction)play:(id)sender {
    NSURL *URL = [[NSBundle mainBundle] URLForResource:self.temps[index] withExtension:@"mid"];
    KJMIDIPlayer.shared.videoURL = URL;
    [KJMIDIPlayer.shared kj_play];
}
- (IBAction)pause:(id)sender {
    [KJMIDIPlayer.shared kj_pause];
}
- (IBAction)repause:(id)sender {
    [KJMIDIPlayer.shared kj_resume];
}
- (IBAction)stop:(id)sender {
    [KJMIDIPlayer.shared kj_stop];
}
- (IBAction)slider:(UISlider*)sender {
    NSLog(@"----%f",sender.value);
}
- (IBAction)seekPlay:(UIButton*)sender {
    CGFloat seek = [self.textField.text floatValue];
    if (![KJMIDIPlayer.shared isPlaying]) {
        NSURL *URL = [[NSBundle mainBundle] URLForResource:self.temps[index] withExtension:@"mid"];
        KJMIDIPlayer.shared.videoURL = URL;
        [KJMIDIPlayer.shared kj_play];
    }
    KJMIDIPlayer.shared.kVideoAdvanceAndReverse(seek,nil);
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.temps.count;
}
#pragma mark - UIPickerViewDelegate
- (NSString*)pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.temps[row];
}
- (void)pickerView:(UIPickerView*)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.label.text = [NSString stringWithFormat:@"midi音源：%@",self.temps[row]];
    index = row;
}
#pragma mark - lazy
- (NSArray*)temps{
    if (!_temps) {
        _temps = @[@"绮想轮旋曲",@"命运交响曲第一章",@"埃克赛斯舞曲",@"致爱丽丝"];
    }
    return _temps;
}
@end
