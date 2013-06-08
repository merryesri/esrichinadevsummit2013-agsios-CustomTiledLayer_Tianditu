//
//  TiandituWMTSLayer_Vec.h
//  CustomTiledLayerSample
//
//  Created by EsriChina_Mobile_MaY on 13-3-27.
//
//
#import <Foundation/Foundation.h>
#import <ArcGIS/ArcGIS.h>
#import "TianDiTuWMTSLayerInfo.h"
typedef enum {
    TIANDITU_VECTOR_MERCATOR = 0,	/*!< 天地图矢量墨卡托投影地图服务 */
    TIANDITU_VECTOR_ANNOTATION_CHINESE_MERCATOR,	/*!< 天地图矢量墨卡托中文标注 */
    TIANDITU_VECTOR_ANNOTATION_ENGLISH_MERCATOR,     /*!< 天地图矢量墨卡托英文标注 */
    TIANDITU_IMAGE_MERCATOR,     /*!< 天地图影像墨卡托投影地图服务 */
    TIANDITU_IMAGE_ANNOTATION_CHINESE_MERCATOR,     /*!< 天地图影像墨卡托投影中文标注 */
    TIANDITU_IMAGE_ANNOTATION_ENGLISH_MERCATOR,     /*!< 天地图影像墨卡托投影英文标注 */
    TIANDITU_TERRAIN_MERCATOR,     /*!< 天地图地形墨卡托投影地图服务 */
    TIANDITU_TERRAIN_ANNOTATION_CHINESE_MERCATOR,     /*!< 天地图地形墨卡托投影中文标注 */
    TIANDITU_VECTOR_2000 = 8,     /*!< 天地图矢量国家2000坐标系地图服务 */
    TIANDITU_VECTOR_ANNOTATION_CHINESE_2000,     /*!< 天地图矢量国家2000坐标系中文标注 */
    TIANDITU_VECTOR_ANNOTATION_ENGLISH_2000,     /*!< 天地图矢量国家2000坐标系英文标注 */
    TIANDITU_IMAGE_2000,     /*!< 天地图影像国家2000坐标系地图服务 */
    TIANDITU_IMAGE_ANNOTATION_CHINESE_2000,     /*!< 天地图影像国家2000坐标系中文标注 */
    TIANDITU_IMAGE_ANNOTATION_ENGLISH_2000,     /*!< 天地图影像国家2000坐标系中文标注 */
    TIANDITU_TERRAIN_2000,     /*!< 天地图地形国家2000坐标系地图服务 */
    TIANDITU_TERRAIN_ANNOTATION_CHINESE_2000,     /*!< 天地图地形国家2000坐标系中文标注 */
} TianDiTuLayerTypes;

@interface TianDiTuWMTSLayer : AGSTiledServiceLayer
{
    @protected
	AGSTileInfo* _tileInfo;
	AGSEnvelope* _fullEnvelope;
	AGSUnits _units;
    TianDiTuWMTSLayerInfo* layerInfo;
    NSOperationQueue* requestQueue;
}
/* ogc wmts url,like ""
//LocalServiceURL can be nil if use "http://t0.tianditu.cn/vec_c/wmts",otherwise input your local service url.
 */
-(id)initWithLayerType:(TianDiTuLayerTypes) tiandituType LocalServiceURL:(NSString *)url error:(NSError**) outError;
@end
