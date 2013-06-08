//
//  WMTSmetadataParserDelegate.m
//  CustomTiledLayerSample
//
//  Created by EsriChina_Mobile on 13-3-27.
//
//

#import "WMTSmetadataParserDelegate.h"
#import <ArcGIS/ArcGIS.h>

#define kWMTS @"http://t0.tianditu.cn/vec_c/wmts?SERVICE=WMTS&REQUEST=GetTile&VERSION=1.0.0&LAYER=cva&STYLE=default&TILEMATRIXSET=c&TILEMATRIX=11&TILEROW=286&TILECOL=1690&FORMAT=tiles"
//?SERVICE=WMTS&REQUEST=GetTile&VERSION=1.0.0
//LAYER:<ows:Identifier>
//STYLE:
//TILEMATRIXSET
//TILEMATRIX
//TILEROW
//TILECOL
//FORMAT

/* LAYER
 <Layer>
 <ows:Title>vec</ows:Title>
 <ows:Abstract>vec</ows:Abstract>
 <ows:Identifier>vec</ows:Identifier>
 <ows:WGS84BoundingBox>
 <ows:LowerCorner>-180.0 -90.0</ows:LowerCorner>
 <ows:UpperCorner>180.0 90.0</ows:UpperCorner>
 </ows:WGS84BoundingBox>
 <ows:BoundingBox>
 <ows:LowerCorner>-180.0 -90.0</ows:LowerCorner>
 <ows:UpperCorner>180.0 90.0</ows:UpperCorner>
 </ows:BoundingBox>
 <Style>
 <ows:Identifier>default</ows:Identifier>
 </Style>
 <Format>tiles</Format>
 <TileMatrixSetLink>
 <TileMatrixSet>c</TileMatrixSet>
 </TileMatrixSetLink>
 </Layer>

 */

/* TileMatrixSet
 <ows:Identifier>c</ows:Identifier>
 <ows:SupportedCRS>urn:ogc:def:crs:EPSG::4490</ows:SupportedCRS>
 <TileMatrix>
 <ows:Identifier>1</ows:Identifier>
 <ScaleDenominator>2.958293554545656E8</ScaleDenominator>
 <TopLeftCorner>90.0 -180.0</TopLeftCorner>
 <TileWidth>256</TileWidth>
 <TileHeight>256</TileHeight>
 <MatrixWidth>2</MatrixWidth>
 <MatrixHeight>1</MatrixHeight>
 </TileMatrix>
 */

@implementation WMTSmetadataParserDelegate
@synthesize currentElement = _currentElement;
@synthesize tileFormat = _tileFormat;
@synthesize WKT = _WKT;
@synthesize tileOrigin = _tileOrigin;
@synthesize lod = _lod;
@synthesize lods = _lods;
@synthesize spatialReference = _spatialReference;
@synthesize fullEnvelope = _fullEnvelope;
@synthesize tileInfo = _tileCacheInfo;
@synthesize error = _error;

#pragma mark -
#pragma mark NSXMLParserDelegate methods
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    //Save the error
	self.error = parseError;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
	self.currentElement = elementName;
    if ([self.currentElement isEqualToString:@"TileMatrixSet"]){
		self.lods = [NSMutableArray array] ;
    }
}


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)value
{
    if ([self.currentElement isEqualToString:@"XMin"]){
		_xmin = [value doubleValue];
	} else if ([self.currentElement isEqualToString:@"YMin"]){
		_ymin = [value doubleValue];
	} else if ([self.currentElement isEqualToString:@"XMax"]){
		_xmax = [value doubleValue];
	} else if ([self.currentElement isEqualToString:@"YMax"]){
		_ymax = [value doubleValue];
	}else if ([self.currentElement isEqualToString:@"WKID"]) {
		_WKID = [value intValue];
    }else if ([self.currentElement isEqualToString:@"WKT"]) {
		if(self.WKT!=nil){
			[self.WKT appendString:value];
		}else {
			self.WKT = [[NSMutableString alloc] initWithString:value];
		}
    }else if ([self.currentElement isEqualToString:@"X"]){
        _tileOriginX = [value doubleValue];
    }else if ([self.currentElement isEqualToString:@"Y"]){
        _tileOriginY = [value doubleValue];
    }else if ([self.currentElement isEqualToString:@"TileCols"]){
		_tileHeight = [value floatValue];
    }else if ([self.currentElement isEqualToString:@"TileRows"]){
        _tileWidth = [value floatValue];
    }else if ([self.currentElement isEqualToString:@"DPI"]){
        _dpi = 96;//[value intValue];
    }else if ([self.currentElement isEqualToString:@"LevelID"]){
        _level = [value intValue];
    }else if ([self.currentElement isEqualToString:@"Scale"]){
        _scale = [value doubleValue];
    }else if ([self.currentElement isEqualToString:@"Resolution"]){
        _resolution = [value doubleValue];
    }else if ([self.currentElement isEqualToString:@"CacheTileFormat"]){
		self.tileFormat = value;
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
    if ([elementName isEqualToString:@"LODInfo"]){
        self.lod = [[AGSLOD alloc]initWithLevel:_level resolution:_resolution scale:_scale];
		[self.lods addObject:_lod];
	}else if ([elementName isEqualToString:@"CacheInfo"]){
		_tileSize = CGSizeMake(_tileWidth, _tileHeight);
		self.spatialReference = [[AGSSpatialReference alloc] initWithWKID:_WKID WKT:_WKT];
		self.tileOrigin = [[AGSPoint alloc] initWithX:_tileOriginX y:_tileOriginY spatialReference:_spatialReference];
		self.fullEnvelope = [AGSEnvelope envelopeWithXmin:_xmin
                                                     ymin:_ymin
                                                     xmax:_xmax
                                                     ymax:_ymax
                                         spatialReference:_spatialReference];
		self.tileInfo = [[AGSTileInfo alloc] initWithDpi: _dpi
                                                  format:_tileFormat
                                                    lods:_lods
                                                  origin:_tileOrigin
                                        spatialReference:_spatialReference
                                                tileSize:_tileSize];
	}	
}        

- (void)parserDidEndDocument:(NSXMLParser *)parser 
{
	//Compute the start/end tile for each row & column
	if(self.fullEnvelope!=nil)
		[self.tileInfo computeTileBounds:_fullEnvelope];
}
@end
