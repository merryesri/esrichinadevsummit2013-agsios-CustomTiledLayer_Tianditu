//
//  TianDiTuWMTSLayerInfoDelegate.h
//  CustomTiledLayerV10.11
//
//  Created by EsriChina_Mobile_MaY on 13-3-28.
//
//

#import <Foundation/Foundation.h>
#import "TianDiTuWMTSLayerInfo.h"
#import "TianDiTuWMTSLayer.h"

@interface TianDiTuWMTSLayerInfoDelegate : NSObject
-(TianDiTuWMTSLayerInfo*)getLayerInfo:(TianDiTuLayerTypes) tiandituType;
@end
