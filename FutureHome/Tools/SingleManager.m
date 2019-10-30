//
//  SingleManager.m
//  Huamu
//
//  Created by baimifan on 15/9/24.
//  Copyright © 2015年 lyl. All rights reserved.
//

#import "SingleManager.h"
#import <AddressBook/AddressBook.h>
#import "sys/utsname.h"
#import "ClearCaChe.h"
@interface SingleManager()
//@property (nonatomic,strong) NSArray *allFirendDataArray;
//@property (nonatomic,strong) NSMutableArray *allNewFirendDataArray;
//@property (nonatomic,strong) NSMutableDictionary *allNameDictionary;
@end

@implementation SingleManager

static id shareObj = nil;
+ (instancetype)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareObj = [[self alloc] init];  //不用关心内存管理，内部自己管理。
    });
    return shareObj;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

// 为了严谨，也要重写copyWithZone 和 mutableCopyWithZone
- (id)copyWithZone:(NSZone *)zone
{
    return shareObj;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    return shareObj;
}

- (NSString *)changeDateStrToDateStrWithInDateFormate:(NSString *)inFormate withOutFormate:(NSString *)outFormate withDateStr:(NSString *)date withShiJianChuoStr:(NSString *)shijianchuo withDate:(NSDate *)dateTwo{
    
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc]init];
    }
    if (!inFormate) {
        [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }else{
        [_dateFormatter setDateFormat:inFormate];
    }
    
    NSDate* inputDate = nil;
    if (shijianchuo) {
        inputDate = [NSDate dateWithTimeIntervalSince1970:[shijianchuo doubleValue]];
    }else if (date) {
        inputDate = [_dateFormatter dateFromString:date];
    }else if (dateTwo){
        inputDate = dateTwo;
    }
    if (!inputDate) {
        return @"暂无时间";
    }
    if (!outFormate) {
        [_dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }else {
        [_dateFormatter setDateFormat:outFormate];
    }
    
    if ([outFormate rangeOfString:@"eeee"].length > 0) {
        [_dateFormatter setWeekdaySymbols:@[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"]];
    }
    
    NSString *dateStr = nil;
    dateStr = [_dateFormatter stringFromDate:inputDate];
    return dateStr;
}


- (NSString *)getSundayWithShiJianChuoStr:(NSString *)shijianchuo{
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc]init];
    }
   [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* inputDate = [NSDate dateWithTimeIntervalSince1970:[shijianchuo doubleValue]];
    if (!inputDate) {
        return @"暂无时间";
    }
    [_dateFormatter setDateFormat:@"eeee"];
    [_dateFormatter setWeekdaySymbols:@[@"日",@"一",@"二",@"三",@"四",@"五",@"六"]];

    NSString *dateStr = nil;
    dateStr = [_dateFormatter stringFromDate:inputDate];
    return dateStr;
}


- (NSString *)getDateStrWithInDateFormate:(NSString *)inFormate withOutFormate:(NSString *)outFormate withDateStr:(NSString *)date withShiJianChuoStr:(NSString *)shijianchuo withDate:(NSDate *)dateTwo {
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc]init];
    }
    if (!inFormate) {
        [_dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }else{
        [_dateFormatter setDateFormat:inFormate];
    }
    NSDate* inputDate = nil;
    if (shijianchuo) {
        inputDate = [NSDate dateWithTimeIntervalSince1970:[shijianchuo doubleValue]];
    }else if (date) {
        inputDate = [_dateFormatter dateFromString:date];
        
    }else if (dateTwo){
        inputDate = dateTwo;
    }
    
    if (!inputDate) {
        return @"暂无时间";
    }
    
    static double oneDaySeconds = 24*60*60;
    NSDate *today = [NSDate date];
    [_dateFormatter setDateFormat:@"dd"];
    NSDate *beforeYesterday, *yesterday;
    yesterday = [today dateByAddingTimeInterval: - oneDaySeconds];
    beforeYesterday = [today dateByAddingTimeInterval: - (2 * oneDaySeconds)];
    
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    NSString * beforeYesterdayString = [[beforeYesterday description] substringToIndex:10];
    NSString * dateString = [[inputDate description] substringToIndex:10];
    
    if ([dateString isEqualToString:todayString]){ /* 今天*/
        return @"今天";
    } else if ([dateString isEqualToString:yesterdayString]){ /* 昨天*/
        return @"昨天";
    }else if ([dateString isEqualToString:beforeYesterdayString]){ /* 前天*/
        return @"前天";
    }else {/* 对应输出格式*/
        if (!outFormate) {
            [_dateFormatter setDateFormat:@"yyyy-MM-dd"];
        }else {
            [_dateFormatter setDateFormat:outFormate];
        }
        if ([outFormate rangeOfString:@"eeee"].length > 0) {
            [_dateFormatter setWeekdaySymbols:@[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"]];
        }
        NSString *dateStr = nil;
        dateStr = [_dateFormatter stringFromDate:inputDate];
        return dateStr;
    }
}

- (NSString *)getBeforDateStrWithInDateInFormate:(NSString *)inFormate withOutFormate:(NSString *)outFormate withDateStr:(NSString *)dateStr withShiJianChuoStr:(NSString *)shijianchuo withDate:(NSDate *)date {
    
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc]init];
    }
    if (!inFormate) {
        [_dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }else{
        [_dateFormatter setDateFormat:inFormate];
    }
    NSDate* inputDate = nil;
    if (shijianchuo) {
        inputDate = [NSDate dateWithTimeIntervalSince1970:[shijianchuo doubleValue]];
    }else if (dateStr) {
        inputDate = [_dateFormatter dateFromString:dateStr];
        
    }else if (date){
        inputDate = date;
    }
    if (!inputDate) {
        return @"暂无时间";
    }
    NSDate *nowDate = [NSDate date];
    NSTimeInterval cha = [nowDate timeIntervalSince1970] - [inputDate timeIntervalSince1970];
    NSInteger iMinute = cha/60;
    NSInteger iHours = cha/3600;
    NSInteger iDays = cha/(24*3600);
    NSInteger iMonth = cha/(30*24*3600);
    NSInteger iYear = cha/(365*24*3600*30);
    NSString *timeString = @"";
    if (iYear > 0) {
        timeString = [NSString stringWithFormat:@"%ld年前",(long)iYear];
    }else if (iMonth > 0){
        timeString = [NSString stringWithFormat:@"%ld月前",(long)iMonth];
    }else if (iDays > 0){
        timeString = [NSString stringWithFormat:@"%ld天前",(long)iDays];
    }else if (iHours > 0){
        timeString = [NSString stringWithFormat:@"%ld小时前",(long)iHours];
    }else if (iMinute > 0){
        timeString = [NSString stringWithFormat:@"%ld分前",(long)iMinute];
    } else if (cha > 0 && cha < 60){
        timeString = @"刚刚";
        
    }
    return timeString;
}

- (NSString *)getDateStrWithOutFormate:(NSString *)outFormate withDateStr:(NSString *)date withShiJianChuoStr:(NSString *)shijianchuo withDate:(NSDate *)dateTwo {
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc]init];
    }
    
    [_dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* inputDate = nil;
    if (shijianchuo) {
        inputDate = [NSDate dateWithTimeIntervalSince1970:[shijianchuo doubleValue]];
    }else if (date) {
        inputDate = [_dateFormatter dateFromString:date];
    }else if (dateTwo){
        inputDate = dateTwo;
    }
    
    if (!inputDate) {
        return @"暂无时间";
    }
    
    static double oneDaySeconds = 24*60*60;
    NSDate *today = [NSDate date];
    [_dateFormatter setDateFormat:@"dd"];
    NSDate *beforeYesterday, *yesterday;
    yesterday = [today dateByAddingTimeInterval: - oneDaySeconds];
    beforeYesterday = [today dateByAddingTimeInterval: - (2 * oneDaySeconds)];
    
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    NSString * beforeYesterdayString = [[beforeYesterday description] substringToIndex:10];
    NSString * dateString = [[inputDate description] substringToIndex:10];
    
    if ([dateString isEqualToString:todayString]){ /* 今天*/
        [_dateFormatter setDateFormat:@"HH:mm"];
        NSString *confromTimespStr = [_dateFormatter stringFromDate:inputDate];
        confromTimespStr = [NSString stringWithFormat:@"今天 %@",confromTimespStr];
        return confromTimespStr;
    } else if ([dateString isEqualToString:yesterdayString]){ /* 昨天*/
        [_dateFormatter setDateFormat:@"HH:mm"];
        NSString *confromTimespStr = [_dateFormatter stringFromDate:inputDate];
        confromTimespStr = [NSString stringWithFormat:@"昨天 %@",confromTimespStr];
        return confromTimespStr;
    }else if ([dateString isEqualToString:beforeYesterdayString]){ /* 前天*/
        [_dateFormatter setDateFormat:@"HH:mm"];
        NSString *confromTimespStr = [_dateFormatter stringFromDate:inputDate];
        confromTimespStr = [NSString stringWithFormat:@"前天 %@",confromTimespStr];
        return confromTimespStr;
    }else {/* 对应输出格式*/
        if (!outFormate) {
            [_dateFormatter setDateFormat:@"yyyy-MM-dd"];
        }else {
            [_dateFormatter setDateFormat:outFormate];
        }
        if ([outFormate rangeOfString:@"eeee"].length > 0) {
            [_dateFormatter setWeekdaySymbols:@[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"]];
        }
        NSString *dateStr = nil;
        dateStr = [_dateFormatter stringFromDate:inputDate];
        return dateStr;
    }
}

- (NSString *)getDateStrWithOutFormate:(NSString *)outFormate withShiJianChuoStr:(NSString *)shijianchuo{
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc]init];
    }
    
    [_dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* inputDate = nil;
    if (shijianchuo) {
        inputDate = [NSDate dateWithTimeIntervalSince1970:[shijianchuo doubleValue]];
    }
    
    if (!inputDate) {
        return @"暂无时间";
    }
    
    static double oneDaySeconds = 24*60*60;
    NSDate *today = [NSDate date];
    [_dateFormatter setDateFormat:@"dd"];
    NSDate *beforeYesterday, *yesterday;
    yesterday = [today dateByAddingTimeInterval: - oneDaySeconds];
    beforeYesterday = [today dateByAddingTimeInterval: - (2 * oneDaySeconds)];
    
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    NSString * beforeYesterdayString = [[beforeYesterday description] substringToIndex:10];
    NSString * dateString = [[inputDate description] substringToIndex:10];
    
    if ([dateString isEqualToString:todayString]){ /* 今天*/
        [_dateFormatter setDateFormat:@"HH:mm"];
        NSString *confromTimespStr = [_dateFormatter stringFromDate:inputDate];
        return confromTimespStr;
    } else if ([dateString isEqualToString:yesterdayString]){ /* 昨天*/
        return @"昨天";
    }else if ([dateString isEqualToString:beforeYesterdayString]){ /* 前天*/
        return @"前天";
    }else {/* 对应输出格式*/
        if (!outFormate) {
            [_dateFormatter setDateFormat:@"yyyy-MM-dd"];
        }else {
            [_dateFormatter setDateFormat:outFormate];
        }
        if ([outFormate rangeOfString:@"eeee"].length > 0) {
            [_dateFormatter setWeekdaySymbols:@[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"]];
        }
        NSString *dateStr = nil;
        dateStr = [_dateFormatter stringFromDate:inputDate];
        return dateStr;
    }
}


#pragma mark - pushSound
-(void)playSound{
    
    if ([SingleManager shareManager].soundNotice) {
        
        [self systemSound];
    }
    if ([SingleManager shareManager].sharkNotice) {
        [self systemShark];
    }
}

- (void)systemSound{
    
    SystemSoundID soundID;
    NSString *path =[[NSBundle mainBundle]pathForResource:@"message" ofType:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)([NSURL fileURLWithPath:path]), &soundID);
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)([NSURL fileURLWithPath:path]), &soundID);
    AudioServicesPlaySystemSound(soundID);
    
//    AudioServicesPlaySystemSound(1050);
  
}

-(void)systemShark{
      AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);//让手机震动
}



//-(void)xys_canGetAddressBook{
//    //声明一个通讯簿的引用
//    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
//    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
//        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error){
//            CFErrorRef *error1 = NULL;
//            if (granted == YES) {
//                ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error1);
//                _allNewFirendDataArray = [[NSMutableArray alloc] init];
//                _allNameDictionary = [[NSMutableDictionary alloc] init];
//                [self getAllPhoneNumber:addressBook];
//            }
//        });
//    }else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized){
//        
//        CFErrorRef *error = NULL;
//        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
//        _allNewFirendDataArray = [[NSMutableArray alloc] init];
//        _allNameDictionary = [[NSMutableDictionary alloc] init];
//        [self getAllPhoneNumber:addressBook];
//    }else {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            // 用户不给权限
//            //                UIAlertView * alart = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请您设置允许APP访问您的通讯录\nSettings>General>Privacy" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            //                [alart show];
//        });
//    }
//}
//
//- (void)getAllPhoneNumber:(ABAddressBookRef)ref{
//    //获取通讯录
//    if (_allFirendDataArray.count > 0) {
//        return;
//    }
//    
//    NSArray *addressArray = (__bridge NSArray *)ABAddressBookCopyArrayOfAllPeople(ref);
//    for (int i = 0; i < addressArray.count; i++ ) {
//        ABRecordRef ref = (__bridge ABRecordRef)([addressArray objectAtIndex:i]);
//        NSString *name = (__bridge NSString*)ABRecordCopyCompositeName(ref);
//        ABMutableMultiValueRef multi = ABRecordCopyValue(ref, kABPersonPhoneProperty);
//        NSString *phone = (__bridge NSString *)(ABMultiValueCopyValueAtIndex(multi, 0));
//        
//        AddressBookModel *model = [[AddressBookModel alloc] init];
//        model.name = name;
//        model.phone = phone;
//        if (name.length > 0 ) {
//            //获取首字,uppercaseString是将首字母转换成大写
//            model.namePinyin = [NSString chineseToPinyinWithShengDiao:name];
//            NSString *letterStr = [[model.namePinyin  substringWithRange:NSMakeRange(0, 1)] uppercaseString];
//            model.nameLetter = letterStr;
//            [_allNewFirendDataArray addObject:model];
//            
//        }
//    }
//    [self getAllNames];
//
//    CFRelease(ref);
//}
//
//#pragma mark - 将首字母相同的放在一起
//- (void)getAllNames
//{
//    
//    NSMutableArray *nameArr = [[NSMutableArray alloc]init];
//    //遍历
//    for (AddressBookModel *model in _allNewFirendDataArray) {
//        NSMutableArray *letterArr = _allNameDictionary[model.nameLetter];
//        //判断数组里是否有元素，如果为nil，则实例化该数组，并在cityDict字典中插入一条新的数据
//        if (letterArr == nil) {
//            letterArr = [[NSMutableArray alloc] init];
//            [_allNameDictionary setObject:letterArr forKey:model.nameLetter];
//        }
//        //将新数据放到数组里
//        [letterArr addObject:model];
//        
//        if (![model.phone isEqualToString:@""] && model.phone != nil) {
//            [nameArr addObject:model.phone];
//        }
//    }
//    
//    if (![nameArr containsObject:@"88066557"]) {
//        [self addFrishNumber];
//    }
//    
//}
//#pragma mark -- 将声优的号码写入到通讯录中
//- (void)addFrishNumber{
//    // 初始化一个ABAddressBookRef对象，使用完之后需要进行释放，
//    // 这里使用CFRelease进行释放
//    // 相当于通讯录的一个引用
//    ABAddressBookRef addressBook = ABAddressBookCreate();
//    // 新建一个联系人
//    // ABRecordRef是一个属性的集合，相当于通讯录中联系人的对象
//    // 联系人对象的属性分为两种：
//    // 只拥有唯一值的属性和多值的属性。
//    // 唯一值的属性包括：姓氏、名字、生日等。
//    // 多值的属性包括:电话号码、邮箱等。
//    ABRecordRef person = ABPersonCreate();
//    NSString *firstName = @"高质量通话";
//    NSString *lastName = @"声优";
//    // 电话号码数组
//    NSArray *phones = [NSArray arrayWithObjects:@"88066557",@"0571 88066557",nil];
//    // 电话号码对应的名称
//    NSArray *labels = [NSArray arrayWithObjects:@"iphone",@"home",nil];
//    // 保存到联系人对象中，每个属性都对应一个宏，例如：kABPersonFirstNameProperty
//    // 设置firstName属性
//    ABRecordSetValue(person, kABPersonFirstNameProperty,(__bridge CFStringRef)firstName, NULL);
//    // 设置lastName属性
//    ABRecordSetValue(person, kABPersonLastNameProperty, (__bridge CFStringRef)lastName, NULL);
//    // ABMultiValueRef类似是Objective-C中的NSMutableDictionary
//    ABMultiValueRef mv =ABMultiValueCreateMutable(kABMultiStringPropertyType);
//    // 添加电话号码与其对应的名称内容
//    for (int i = 0; i < [phones count]; i ++) {
//        ABMultiValueIdentifier mi = ABMultiValueAddValueAndLabel(mv,(__bridge CFStringRef)[phones objectAtIndex:i], (__bridge CFStringRef)[labels objectAtIndex:i], &mi);
//    }
//    // 设置phone属性
//    ABRecordSetValue(person, kABPersonPhoneProperty, mv, NULL);
//    // 释放该数组
//    if (mv) {
//        CFRelease(mv);
//    }
//    // 将新建的联系人添加到通讯录中
//    ABAddressBookAddRecord(addressBook, person, NULL);
//    // 保存通讯录数据
//    ABAddressBookSave(addressBook, NULL);
//    // 释放通讯录对象的引用
//    if (addressBook) {
//        CFRelease(addressBook);
//    }
//}
//

#pragma mark -- 获取当前设备类型
- (NSString*)xys_getDeviceString

{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    
    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad mini";
    
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    
    if ([deviceString isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    
    if ([deviceString isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
    
    NSLog(@"NOTE: Unknown device type: %@", deviceString);
    
    return deviceString;
    
}


//5.型号
-(NSString *)getCurrentDevice
{
    int mib[2];
    size_t len;
    char *machine;
    
//    mib[0] = CTL_HW;
//    mib[1] = HW_MACHINE;
//    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
//    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4s (A1387/A1431)";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    //添加 7 判断
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G (A1213)";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G (A1219/A1337)";
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (A1395)";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (A1396)";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (A1397)";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 (A1395+New Chip)";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G (A1432)";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G (A1454)";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G (A1455)";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (A1416)";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (A1403)";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (A1430)";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 (A1458)";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 (A1459)";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 (A1460)";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G (A1489)";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G (A1490)";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G (A1491)";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}

#pragma mark  -- 获取2G 3G 4G WIFI
- (NSString *)xys_getNetWorkStates{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"]subviews];
    NSString *state = [[NSString alloc]init];
    int netType = 0;
    //获取到网络返回码
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏
            netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];
            
            switch (netType) {
                case 0:
                    state = @"无网络";
                    //无网模式
                    break;
                case 1:
                    state = @"2G";
                    break;
                case 2:
                    state = @"3G";
                    break;
                case 3:
                    state = @"4G";
                    break;
                case 5:
                {
                    state = @"WIFI";
                }
                    break;
                default:
                    break;
            }
        }
    }
    //根据状态选择
    return state;
}

- (float)getCaChe{
//    NSString * cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES) firstObject ];
//    float MuchBit=[ClearCaChe folderSizeAtPath:cachPath];
    
//
//    return MuchBit;

    
    
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains (NSCachesDirectory , NSUserDomainMask , YES) firstObject];
    return [ self folderSizeAtPath :cachePath];
}


//由于缓存文件存在沙箱中，我们可以通过NSFileManager API来实现对缓存文件大小的计算。
// 遍历文件夹获得文件夹大小，返回多少 M
- ( float ) folderSizeAtPath:( NSString *) folderPath{
    
    NSFileManager * manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath :folderPath]) return 0 ;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator];
    NSString * fileName;
    long long folderSize = 0 ;
    while ((fileName = [childFilesEnumerator nextObject]) != nil ){
        //获取文件全路径
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        folderSize += [ self fileSizeAtPath :fileAbsolutePath];
    }
    return folderSize/( 1024.0 * 1024.0);
    
}

// 计算 单个文件的大小
- ( long long ) fileSizeAtPath:( NSString *) filePath{
    NSFileManager * manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath :filePath]){
        return [[manager attributesOfItemAtPath :filePath error : nil] fileSize];
    }
    return 0;
}

- (BOOL)isOpenAccount{

    NSString *statusStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERINFOSTATUS"];
    if (statusStr == nil || statusStr.length == 0) {
        return NO;
    }
    if ((statusStr.intValue & 2) == 2) {
        return YES;
    }
    return NO;
}

- (BOOL)isHasInvest{
    NSString *statusStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERINFOSTATUS"];
    if (statusStr == nil || statusStr.length == 0) {
        return NO;
    }
    if ((statusStr.intValue & 8) == 8) {
        return YES;
    }
    return NO;
}

#pragma mark  -- 是否是登录状态
- (BOOL)isLogin{
    NSString *loginStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"PERSONLOGIN"];
    if ([loginStr isEqualToString:@"YES"]) {
        return YES;
    }
    return NO;
}
- (NSString *)getPersonPhone{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"PERSONPHONE"];
}

//判断手机号格式是否正确
- (BOOL)valiMobile:(NSString *)mobile
{
    //去掉所有的空格
    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (mobile.length != 11)
    {
        return NO;
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];

        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
        }else{
            return NO;
        }
    }
}
/** 匹配用户密码是否合法，6-16位数字和字母组合,只能输入由数字和26个英文字母组成的字符串*/
- (BOOL)checkPassword:(NSString *)password
{
    NSString *pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,16}$";
    NSRegularExpression *expression = [[NSRegularExpression alloc]initWithPattern:pattern options:NSRegularExpressionDotMatchesLineSeparators error:nil];
    if ([expression firstMatchInString:password options:NSMatchingReportProgress range:NSMakeRange(0, password.length)]) {
        return YES;
    }
    return NO;
}
//只能输入 英文字母和数字
- (BOOL)checkIsPassword:(NSString *) password
{
    NSString *pattern = @"[A-Za-z]";
    NSString *num =  @"[0-9]*";
    NSPredicate *predNum = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", num];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    if ([pred evaluateWithObject:password] || [predNum evaluateWithObject:password]) {
        return YES;
    }
    return NO;
}
//传入时间戳字符串 转成时间 
- (NSString *)stringWithTimeIntervalString:(NSString *)TimeIntervalString
                           formatterString:(NSString *)formatterString{
    NSString *timeStampString  = TimeIntervalString;
    // iOS 生成的时间戳是10位
    NSTimeInterval interval    =[timeStampString doubleValue] / 1000.0;
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatterString];
    NSString *dateString       = [formatter stringFromDate: date];
    return dateString;
}

- (NSString *)configTradeType:(NSString *)tradeType{
    if ([tradeType isEqualToString:@"INVEST"]) {
        return @"投资";
    }
    else if ([tradeType isEqualToString:@"RECHARGE"]){
        return @"充值";
    }
    else if ([tradeType isEqualToString:@"WITHDRAW"]){
        return @"提现";
    }
    else if ([tradeType isEqualToString:@"RECOVER"]){
        return @"回款";
    }
    else if ([tradeType isEqualToString:@"ACTIVITY"]){
        return @"活动";
    }
    else if ([tradeType isEqualToString:@"SUP"]){
        return @"体验金";
    }
    else if ([tradeType isEqualToString:@"DEDUCTION"]){
        return @"返现红包";
    }
    else if ([tradeType isEqualToString:@"CRASH"]){
        return @"活动现金";
    }
    else if ([tradeType isEqualToString:@"FRIEND"]){
        return @"邀友";
    }
    return tradeType;
}

@end
