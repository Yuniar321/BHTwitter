//
//  BHTdownloadManager.m
//  BHT
//
//  Created by BandarHelal on 24/12/1441 AH.
//

#import "BHTManager.h"


@implementation BHTManager
+ (bool)isDMVideoCell:(T1InlineMediaView *)view {
    if (view.playerIconViewType == 4) {
        return true;
    } else {
        return false;
    }
}
+ (void)cleanCache {
    NSArray <NSURL *> *DocumentFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:[NSURL fileURLWithPath:NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).firstObject] includingPropertiesForKeys:@[] options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
    
    for (NSURL *file in DocumentFiles) {
        if ([file.pathExtension.lowercaseString isEqualToString:@"mp4"]) {
            [[NSFileManager defaultManager] removeItemAtURL:file error:nil];
        }
    }
    
    NSArray <NSURL *> *TempFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:[NSURL fileURLWithPath:NSTemporaryDirectory()] includingPropertiesForKeys:@[] options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
    
    for (NSURL *file in TempFiles) {
        if ([file.pathExtension.lowercaseString isEqualToString:@"mp4"]) {
            [[NSFileManager defaultManager] removeItemAtURL:file error:nil];
        }
        if ([file.pathExtension.lowercaseString isEqualToString:@"mov"]) {
            [[NSFileManager defaultManager] removeItemAtURL:file error:nil];
        }
        if ([file.pathExtension.lowercaseString isEqualToString:@"tmp"]) {
            [[NSFileManager defaultManager] removeItemAtURL:file error:nil];
        }
        if ([file hasDirectoryPath]) {
            if ([BHTManager isEmpty:file]) {
                [[NSFileManager defaultManager] removeItemAtURL:file error:nil];
            }
        }
    }
}
+ (BOOL)isEmpty:(NSURL *)url {
    NSArray *FolderFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:url includingPropertiesForKeys:@[] options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
    if (FolderFiles.count == 0) {
        return true;
    } else {
        return false;
    }
}
+ (NSString *)getDownloadingPersent:(float)per {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterPercentStyle];
    NSNumber *number = [NSNumber numberWithFloat:per];
    return [numberFormatter stringFromNumber:number];
}
+ (NSString *)getVideoQuality:(NSString *)url {
    NSMutableArray *q = [NSMutableArray new];
    NSArray *splits = [url componentsSeparatedByString:@"/"];
    for (int i = 0; i < [splits count]; i++) {
        NSString *item = [splits objectAtIndex:i];
        NSArray *dir = [item componentsSeparatedByString:@"x"];
        for (int k = 0; k < [dir count]; k++) {
            NSString *item2 = [dir objectAtIndex:k];
            if (!(item2.length == 0)) {
                if ([BHTManager doesContainDigitsOnly:item2]) {
                    if (!(item2.integerValue > 10000)) {
                        if (!(q.count == 2)) {
                            [q addObject:item2];
                        }
                    }
                }
            }
        }
    }
    if (q.count == 0) {
        return @"GIF";
    }
    return [NSString stringWithFormat:@"%@x%@", q.firstObject, q.lastObject];
}
+ (BOOL)isVideoCell:(T1StatusInlineActionsView *)cell {
    TFSTwitterEntityMedia *i = cell.viewModel.entities.media.firstObject;
    if (i.videoInfo == nil) {
        return false;
    } else {
        return true;
    }
}
+ (void)save:(NSURL *)url {
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:url];
    } error:nil];
}
+ (void)showSaveVC:(NSURL *)url {
    UIActivityViewController *acVC = [[UIActivityViewController alloc] initWithActivityItems:@[url] applicationActivities:nil];
    [topMostController() presentViewController:acVC animated:true completion:nil];
}

+ (BOOL)DownloadingVideos {
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    return [userDef boolForKey:@"dw_v"];
}
+ (BOOL)DirectSave {
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    return [userDef boolForKey:@"direct_save"];
}
+ (BOOL)VoiceFeature {
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    return [userDef boolForKey:@"voice"];
}
+ (BOOL)LikeConfirm {
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    return [userDef boolForKey:@"like_con"];
}
+ (BOOL)TweetConfirm {
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    return [userDef boolForKey:@"tweet_con"];
}
+ (BOOL)HidePromoted {
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    return [userDef boolForKey:@"hide_promoted"];
}
+ (BOOL)FLEX {
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    return [userDef boolForKey:@"flex_twitter"];
}
+ (void)showSettings:(UIViewController *)_self {
    HBSection *main_section = [HBSection sectionWithTitle:@"BHTwitter Preferences" footer:nil];
    HBSection *debug = [HBSection sectionWithTitle:@"Debugging" footer:nil];
    HBSection *developer = [HBSection sectionWithTitle:@"Developer" footer:nil];
    
    HBSwitchCell *download = [[HBSwitchCell alloc] initSwitchCellWithImage:nil Title:@"Downloading videos" DetailTitle:@"this option will enabel downloading videos" switchKey:@"dw_v" withBlock:^(UISwitch *weakSender) {
        if (weakSender.isOn) {
            [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"dw_v"];
        } else {
            [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"dw_v"];
        }
    }];
    
    HBSwitchCell *direct_save = [[HBSwitchCell alloc] initSwitchCellWithImage:nil Title:@"Direct save" DetailTitle:@"Save video directly after downloading" switchKey:@"direct_save" withBlock:^(UISwitch *weakSender) {
        if (weakSender.isOn) {
            [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"direct_save"];
        } else {
            [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"direct_save"];
        }
    }];
    
    HBSwitchCell *hide_ads = [[HBSwitchCell alloc] initSwitchCellWithImage:nil Title:@"Hide ads" DetailTitle:@"this option will remove all promoted tweet" switchKey:@"hide_promoted" withBlock:^(UISwitch *weakSender) {
        if (weakSender.isOn) {
            [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"hide_promoted"];
        } else {
            [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"hide_promoted"];
        }
    }];
    
    HBSwitchCell *voice = [[HBSwitchCell alloc] initSwitchCellWithImage:nil Title:@"Voice Feature" DetailTitle:@"this option will enabel voice in tweet and DM" switchKey:@"voice" withBlock:^(UISwitch *weakSender) {
        if (weakSender.isOn) {
            [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"voice"];
        } else {
            [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"voice"];
        }
    }];
    
    HBSwitchCell *like_confirm = [[HBSwitchCell alloc] initSwitchCellWithImage:nil Title:@"Like confirm" DetailTitle:@"Show a confirm alert when you press like button" switchKey:@"like_con" withBlock:^(UISwitch *weakSender) {
        if (weakSender.isOn) {
            [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"like_con"];
        } else {
            [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"like_con"];
        }
    }];
    HBSwitchCell *tweet_confirm = [[HBSwitchCell alloc] initSwitchCellWithImage:nil Title:@"Tweet confirm" DetailTitle:@"Show a confirm alert when you press tweet button" switchKey:@"tweet_con" withBlock:^(UISwitch *weakSender) {
        if (weakSender.isOn) {
            [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"tweet_con"];
        } else {
            [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"tweet_con"];
        }
    }];
    
    HBSwitchCell *flex = [[HBSwitchCell alloc] initSwitchCellWithImage:nil Title:@"Enable FLEX" DetailTitle:@"Show FLEX on twitter app" switchKey:@"flex_twitter" withBlock:^(UISwitch *weakSender) {
        if (weakSender.isOn) {
            [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"flex_twitter"];
        } else {
            [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"flex_twitter"];
        }
        [FLEXAlert makeAlert:^(FLEXAlert *make) {
            make.title(@"Note");
            make.message(@"Close the app and open it again to apply changes.");
            make.button(@"ok").cancelStyle();
        } showFrom:_self];
    }];
    
    HBTwitterCell *bandarhl = [[HBTwitterCell alloc] initTwitterCellWithTitle:@"BandarHelal" detail:@"@BandarHL" AccountLink:@"https://twitter.com/BandarHL"];
    HBGithubCell *sourceCode = [[HBGithubCell alloc] initGithubCellWithTitle:@"BHTwitter" detailTitle:@"Code source of BHTwitter" GithubURL:@"https://github.com/BandarHL/BHTwitter/"];
    
    [main_section addCell:download];
    [main_section addCell:hide_ads];
    [main_section addCell:direct_save];
    [main_section addCell:voice];
    [main_section addCell:like_confirm];
    [main_section addCell:tweet_confirm];
    [debug addCell:flex];
    [developer addCell:bandarhl];
    [developer addCell:sourceCode];
    HBPreferences *hollow_pref = [HBPreferences tableWithSections:@[main_section, debug, developer] title:@"BHTwitter" TableStyle:UITableViewStyleGrouped SeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_self.navigationController pushViewController:hollow_pref animated:true];
}

// https://stackoverflow.com/a/45356575/9910699
+ (BOOL)doesContainDigitsOnly:(NSString *)string {
    NSCharacterSet *nonDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];

    BOOL containsDigitsOnly = [string rangeOfCharacterFromSet:nonDigits].location == NSNotFound;

    return containsDigitsOnly;
}

+ (BOOL)doesContainNonDigitsOnly:(NSString *)string {
    NSCharacterSet *digits = [NSCharacterSet decimalDigitCharacterSet];

    BOOL containsNonDigitsOnly = [string rangeOfCharacterFromSet:digits].location == NSNotFound;

    return containsNonDigitsOnly;
}

@end
