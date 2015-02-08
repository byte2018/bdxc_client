//
//  validation.m
//  ValidateIt
//
//  Created by Arpi Dermardirousian on 1/27/14.
//  Copyright (c) 2014 Arpi Dermardirousian. All rights reserved.
//

#import "validation.h"

@implementation validation

- (id)init {
    self = [super init];
    if (self) {
        self.errorMsg = [[NSMutableArray alloc]init];
        self.requiredErrorMsg = [[NSMutableArray alloc]init];
        self.emailErrorMsg = [[NSMutableArray alloc]init];
        self.lettersSpaceOnlyMsg = [[NSMutableArray alloc]init];
        self.maxLengthErrorMsg = [[NSMutableArray alloc]init];
        self.minLengthErrorMsg = [[NSMutableArray alloc]init];
        self.requiredError = [[NSMutableArray alloc]initWithObjects:@"1", nil];
        
        self.maxLengthError = [NSMutableArray arrayWithObjects:@"1", nil];
            self.minLengthError = [NSMutableArray arrayWithObjects:@"1", nil];
            self.lettersSpaceOnly = [NSMutableArray arrayWithObjects:@"1", nil];
            self.emailError = [NSMutableArray arrayWithObjects:@"1",nil];
        
    }
    return self;
}

//===========  Email Address ========//
-(void) Email: (NSString *) emailAddress FieldName: (NSString *) textFieldName{
    
    if(emailAddress.length > 0){
        NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
        NSString *msg = @"邮箱地址错误.";
        if ([emailTest evaluateWithObject:emailAddress] == NO) {
            [self.emailError replaceObjectAtIndex:0 withObject:@"1"];
            [self.emailErrorMsg addObject:msg];
            return;
        }else{
            [self.emailError replaceObjectAtIndex:0 withObject:@"0"];
            return;
        }
    }
}
//=========== TEL ========//
- (void) Tel : (NSString *) telNumber FieldName: (NSString *) textFieldName
{
    
    if(telNumber.length > 0){
        
        NSString *msg = @"电话号码必须为纯数字.";
        if (![self isPureInt:telNumber]) {
            [self.emailError replaceObjectAtIndex:0 withObject:@"1"];
            [self.emailErrorMsg addObject:msg];
            return;
        }else{
            [self.emailError replaceObjectAtIndex:0 withObject:@"0"];
            return;
        }
    }else{
        [self.emailError replaceObjectAtIndex:0 withObject:@"1"];
        [self.emailErrorMsg addObject:@"电话号码不能为空"];
    }
    
}
#pragma  mark 判断数子是否为整形
- (BOOL)isPureInt:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    int val;
    
    return[scan scanInt:&val] && [scan isAtEnd];
    
}

//=========== Letters And Space Only ========//
-(void) LettersSpaceOnly: (NSString *) textField FieldName: (NSString *) textFieldName {
    
    NSString *lettersSpaceRegex = @"[a-zA-z]+([ '-][a-zA-Z]+)*$";
    NSPredicate *lettersSpaceTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", lettersSpaceRegex];
    if(textField.length > 0){
        if([lettersSpaceTest evaluateWithObject:textField] == NO){
            [self.lettersSpaceOnly replaceObjectAtIndex:0 withObject:@"1"];
            NSString *msg = [NSString stringWithFormat:@"%@%s",textFieldName," should contain letters and space only."];
            [self.lettersSpaceOnlyMsg addObject:msg];
            return;
        }else{
            [self.lettersSpaceOnly replaceObjectAtIndex:0 withObject:@"0"];
            return;
        }
    }
}

//=========== Required ========//
-(void) Required: (NSString *) textField FieldName: (NSString *) textFieldName {
    
    if ([textField isEqualToString:@""]) {
        [self.requiredError replaceObjectAtIndex:0 withObject:@"1"];
        NSString *msg = [NSString stringWithFormat:@"%@%@",textFieldName, @" 不能为空"];
        [self.requiredErrorMsg addObject:msg];
        return;
    }
    else
    {
        [self.requiredError replaceObjectAtIndex:0 withObject:@"0"];
        return;
    }
}

//=========== MinLength ========//
-(void) MinLength: (NSInteger) length  textFiled: (NSString *)textField FieldName: (NSString *) textFieldName{
    
    
    if(textField.length > length || textField.length == length){
        [self.minLengthError replaceObjectAtIndex:0 withObject:@"0"];
        return ;
    }else{
        [self.minLengthError replaceObjectAtIndex:0 withObject:@"1"];
        NSString *msg = [NSString stringWithFormat:@"%@%@%i%@",textFieldName,@" 最少为 ", length , @" 位"];
        [self.minLengthErrorMsg addObject:msg];
        return;
    }
}

//=========== MaxLength ========//
-(void) MaxLength: (NSInteger) length textField: (NSString *)textField FieldName: (NSString *) textFieldName {

    if(textField.length < length || textField.length == length) {
        [self.maxLengthError replaceObjectAtIndex:0 withObject:@"0"];
        return;
    }else{
        [self.maxLengthError replaceObjectAtIndex:0 withObject:@"1"];
        NSString *msg = [NSString stringWithFormat:@"%@%@%i%@",textFieldName,@" 最多为 ", length , @" 位"];
        [self.maxLengthErrorMsg addObject:msg];
    }
}


//=========== Check If TextFields Are Valid ========//

-(BOOL) isValid {
    
    self.errors = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0", nil];
    
    if(self.emailErrorMsg.count > 0){
        for(NSString *emMsg in self.emailErrorMsg){
            [self.errorMsg addObject:emMsg];
            [self.errors replaceObjectAtIndex:0 withObject:@"1"];
        }
    }else{
        [self.errors replaceObjectAtIndex:0 withObject:@"0"];
    }
    
    if(self.requiredErrorMsg.count > 0){
        for(NSString *msg in self.requiredErrorMsg){
            [self.errorMsg addObject:msg];
            [self.errors replaceObjectAtIndex:1 withObject:@"1"];
        }
    }else{
        [self.errors replaceObjectAtIndex:1 withObject:@"0"];
    }
    
    if(self.minLengthErrorMsg.count > 0){
        for(NSString *minMsg in self.minLengthErrorMsg){
            [self.errors replaceObjectAtIndex:2 withObject:@"1"];
            [self.errorMsg addObject:minMsg];
        }
    }else{
        [self.errors replaceObjectAtIndex:2 withObject:@"0"];
    }
    
    if(self.lettersSpaceOnlyMsg.count > 0 ){
        for (NSString *ltMsg in  self.lettersSpaceOnlyMsg) {
            [self.errorMsg addObject:ltMsg];
            [self.errors replaceObjectAtIndex:3 withObject:@"1"];
        }
    }else{
        [self.errors replaceObjectAtIndex:3 withObject:@"0"];
    }
    
    if(self.maxLengthErrorMsg.count > 0){
        for(NSString *maxMsg in self.maxLengthErrorMsg){
            [self.errorMsg addObject:maxMsg];
            [self.errors replaceObjectAtIndex:4 withObject:@"1"];
        }
        
    }else{
        [self.errors replaceObjectAtIndex:4 withObject:@"0"];
    }

    
    for (NSString *item in self.errors) {
        if([[self.errors objectAtIndex:1]isEqualToString:@"1"] || [[self.errors objectAtIndex:2]isEqualToString:@"1"] || [[self.errors objectAtIndex:0]isEqualToString:@"1"] || [[self.errors objectAtIndex:3]isEqualToString:@"1"] || [[self.errors objectAtIndex:4]isEqualToString:@"1"]){
            self.textFiledIsValid = FALSE;
            NSLog(@"Not Valid %hhi",self.textFiledIsValid);
        }else{
            self.textFiledIsValid = TRUE;
            NSLog(@"Valid %hhi",self.textFiledIsValid);
        }
    }
    
    return self.textFiledIsValid;
}


@end