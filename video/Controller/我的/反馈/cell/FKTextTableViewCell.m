//
//  FKTextTableViewCell.m
//  video
//
//  Created by macbook on 2021/6/20.
//

#import "FKTextTableViewCell.h"
@interface FKTextTableViewCell ()<UITextViewDelegate>

@end

@implementation FKTextTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.NeiRongTextView.delegate=self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.text.length < 1){
        textView.text = @"请输入内容";
        textView.textColor = [UIColor grayColor];
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:@"请输入内容"]){
        textView.text=@"";
        textView.textColor=[UIColor blackColor];
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text

{

    if (range.location>=254)
    {

        return NO;

    }

    else

    {

        return YES;

    }

}
@end
