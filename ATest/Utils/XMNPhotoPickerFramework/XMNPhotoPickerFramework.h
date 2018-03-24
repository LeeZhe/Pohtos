//
//  XMNPhotoPickerFramework.h
//  XMNPhotoPickerFrameworkExample
//  Created by XMFraker on 16/1/28.
//  Copyright © 2016年 XMFraker. All rights reserved.
//
#ifndef XMNPhotoPickerFramework_h
#define XMNPhotoPickerFramework_h


//! Project version number for XMNPhotoPickerFramework.
FOUNDATION_EXPORT double kXMNPhotoPickerFrameworkVersionNumber;

//! Project version string for XMNPhotoPickerFramework.
FOUNDATION_EXPORT const unsigned char kXMNPhotoPickerFrameworkVersionString[];

#if __has_include(<XMNPhotoPickerFramework/XMNPhotoPickerFramework.h>)
#import <XMNPhotoPickerFramework/XMNPhotoManager.h>
#import <XMNPhotoPickerFramework/XMNPhotoPicker.h>
#import <XMNPhotoPickerFramework/XMNPhotoPickerController.h>
#else
#import "XMNPhotoManager.h"
#import "XMNPhotoPicker.h"
#import "XMNPhotoPickerController.h"
#endif


#endif /* XMNPhotoPickerFramework_h */
