// Copyright 2012 ESRI
//
// All rights reserved under the copyright laws of the United States
// and applicable international laws, treaties, and conventions.
//
// You may freely redistribute and use this sample code, with or
// without modification, provided you include the original copyright
// notice and use restrictions.
//
// See the use restrictions at http://help.arcgis.com/en/sdk/10.0/usageRestrictions.htm
//

#import "CustomLayerViewController.h"
#import "TianDiTuWMTSLayer.h"
@implementation CustomLayerViewController

@synthesize mapView=_mapView;


- (void)viewDidLoad {
    [super viewDidLoad];
	NSError* err;
    ///* sr:Mercator(102100)
    TianDiTuWMTSLayer* TianDiTuLyr = [[TianDiTuWMTSLayer alloc]initWithLayerType: TIANDITU_IMAGE_MERCATOR LocalServiceURL:nil error:&err];
    TianDiTuWMTSLayer* TianDiTuLyr_Anno = [[TianDiTuWMTSLayer alloc]initWithLayerType:TIANDITU_VECTOR_ANNOTATION_CHINESE_MERCATOR LocalServiceURL:nil error:&err];
    
    /* sr:CGCS2000(4490)
     TianDiTuWMTSLayer* TianDiTuLyr = [[TianDiTuWMTSLayer alloc]initWithLayerType:TIANDITU_VECTOR_2000 LocalServiceURL:nil error:&err];
     TianDiTuWMTSLayer* TianDiTuLyr_Anno = [[TianDiTuWMTSLayer alloc]initWithLayerType:TIANDITU_VECTOR_ANNOTATION_CHINESE_2000 LocalServiceURL:nil error:&err];
    */

    /* localhost service,eg:"http://t0.tianditu.cn/vec_c/wmts"
    NSURL *localService = [NSURL URLWithString:@"http://t0.tianditu.cn/vec_c/wmts"];
     TianDiTuWMTSLayer* TianDiTuLyr = [[TianDiTuWMTSLayer alloc]initWithLayerType:TIANDITU_VECTOR_MERCATOR LocalServiceURL:localService error:&err];
     TianDiTuWMTSLayer* TianDiTuLyr_Anno = [[TianDiTuWMTSLayer alloc]initWithLayerType:TIANDITU_VECTOR_ANNOTATION_CHINESE_MERCATOR LocalServiceURL:localService error:&err];
     */
    
	//If layer was initialized properly, add to the map
	if(TianDiTuLyr!=nil && TianDiTuLyr_Anno !=nil){
		[self.mapView addMapLayer:TianDiTuLyr withName:@"TianDiTu Layer"];
        [self.mapView addMapLayer:TianDiTuLyr_Anno withName:@"TianDiTu Annotation Layer"];

	}else{
		//layer encountered an error
		NSLog(@"Error encountered: %@", err);
	}
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
