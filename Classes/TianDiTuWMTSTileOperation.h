//
//  TiandituTileOperation.h
//  CustomTiledLayerSample
//
//  Created by EsriChina_Mobile_MaY on 13-3-27.
//
//

#import <Foundation/Foundation.h>
#import <ArcGIS/ArcGIS.h>
#import "TianDiTuWMTSLayerInfo.h"

@interface TianDiTuWMTSTileOperation : NSOperation

@property (nonatomic,retain) AGSTileKey* tileKey;
@property (nonatomic,retain) id target;
@property (nonatomic,assign) SEL action;
@property (nonatomic,retain) NSData* imageData;
@property (nonatomic,retain) TianDiTuWMTSLayerInfo* layerInfo;

- (id)initWithTileKey:(AGSTileKey *)tileKey TiledLayerInfo:(TianDiTuWMTSLayerInfo *)layerInfo target:(id)target action:(SEL)action;
@end
