//
//  TiandituWMTSLayer_Vec.m
//  CustomTiledLayerSample
//
//  Created by EsriChina_Mobile_MaY on 13-3-27.
//
//

#import "TianDiTuWMTSLayer.h"
#import "TianDiTuWMTSTileOperation.h"
#import "TianDiTuWMTSLayerInfo.h"
#import "TianDiTuWMTSLayerInfoDelegate.h"

#define kGetablility "%@?SERVICE=WMTS&REQUEST=getcapabilities"
@implementation TianDiTuWMTSLayer
-(AGSUnits)units{
	return _units;
}

-(AGSSpatialReference *)spatialReference{
	return _fullEnvelope.spatialReference;
}

-(AGSEnvelope *)fullEnvelope{
	return _fullEnvelope;
}

-(AGSEnvelope *)initialEnvelope{
	//Assuming our initial extent is the same as the full extent
	return _fullEnvelope;
}

-(AGSTileInfo*) tileInfo{
	return _tileInfo;
}

#pragma mark -
-(id)initWithLayerType:(TianDiTuLayerTypes) tiandituType LocalServiceURL:(NSString *)url error:(NSError**) outError{
    if (self = [super init]) {

        requestQueue = [[NSOperationQueue alloc] init];
        [requestQueue setMaxConcurrentOperationCount:16];
        /*get the currect layer info
         */
        layerInfo = [[TianDiTuWMTSLayerInfoDelegate alloc]getLayerInfo:tiandituType];
        
        if ([url isEqual:[NSNull null]]) {
            layerInfo.url = url;
        }
        
       
        
        AGSSpatialReference* sr = [AGSSpatialReference spatialReferenceWithWKID:layerInfo.srid];
        _fullEnvelope = [[AGSEnvelope alloc] initWithXmin:layerInfo.xMin
                                                     ymin:layerInfo.yMin
                                                     xmax:layerInfo.xMax
                                                     ymax:layerInfo.yMax
                                         spatialReference:sr];

        _tileInfo = [[AGSTileInfo alloc]
                     initWithDpi:layerInfo.dpi
                     format :@"PNG"
                     lods:layerInfo.lods
                     origin:layerInfo.origin
                     spatialReference :self.spatialReference
                     tileSize:CGSizeMake(layerInfo.tileWidth,layerInfo.tileHeight)
                     ];
        [_tileInfo computeTileBounds:self.fullEnvelope];
        
         /*
         //get metadata from wmts
         NSURL *urlMetadata = [NSURL URLWithString:[NSString stringWithFormat:kGetablility,url.relativeString]];
         //Parse xml
         NSXMLParser* xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:urlMetadata];
         WMTSmetadataParserDelegate* parserDelegate = [[WMTSmetadataParserDelegate alloc] init];
         [xmlParser setDelegate:parserDelegate];
         [xmlParser parse];
         
         //If XML files were parsed properly...
         if([parserDelegate tileInfo]!= nil && [parserDelegate fullEnvelope]!=nil ){
         //... get the metadata
         _tileInfo = [parserDelegate tileInfo];
         _fullEnvelope = [parserDelegate fullEnvelope];
         _units = MakeAGSUnits(_fullEnvelope.spatialReference.wkt);
         //Now that we have all the information required...
         //Inform the superclass that we're done
         [super layerDidLoad];
         }else {
         //... return error
         if (outError != NULL) {
         *outError = [parserDelegate error];
         } 
         return nil;
         }
          */
         
        [super layerDidLoad];
    }
    return self;
}

#pragma mark -
#pragma AGSTiledLayer (ForSubclassEyesOnly)
- (void)requestTileForKey:(AGSTileKey *)key{
    //Create an operation to fetch tile from local cache
	TianDiTuWMTSTileOperation *operation =
    [[TianDiTuWMTSTileOperation alloc] initWithTileKey:key
                                                TiledLayerInfo:layerInfo 
                                                target:self
                                                action:@selector(didFinishOperation:)];
    
    
	//Add the operation to the queue for execution
    //[ [AGSRequestOperation sharedOperationQueue] addOperation:operation]; //you do bad things
    [requestQueue addOperation:operation];
}

- (void)cancelRequestForKey:(AGSTileKey *)key{
    //Find the OfflineTileOperation object for this key and cancel it
    for(NSOperation* op in [AGSRequestOperation sharedOperationQueue].operations){
        if( [op isKindOfClass:[TianDiTuWMTSTileOperation class]]){
            TianDiTuWMTSTileOperation* offOp = (TianDiTuWMTSTileOperation*)op;
            if([offOp.tileKey isEqualToTileKey:key]){
                [offOp cancel];
            }
        }
    }
}

- (void) didFinishOperation:(TianDiTuWMTSTileOperation*)op {
    //... pass the tile's data to the super class
    [super setTileData: op.imageData  forKey:op.tileKey];
}
@end
