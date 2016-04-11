//
//  LocationTagAnnotationView.h
//  FindCat
//
//  Created by 王晴 on 16/4/10.
//  Copyright © 2016年 王晴. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "CalloutCell.h"

@interface CalloutAnnotationView : MKAnnotationView

@property(nonatomic,retain) CalloutCell *locationTagView;

@end
