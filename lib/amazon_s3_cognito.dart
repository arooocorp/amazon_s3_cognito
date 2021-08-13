import 'dart:async';

import 'package:flutter/services.dart';

class AmazonS3Cognito {
  static const MethodChannel _channel =
      const MethodChannel('amazon_s3_cognito');

  static Future<String?> upload(
      String filepath,
      String bucket,
      String identity,
      String imageName,
      String region,
      String subRegion,
      String contentType,
      S3AccessControl accessControl) async {
    final Map<String, dynamic> params = <String, dynamic>{
      'filePath': filepath,
      'bucket': bucket,
      'identity': identity,
      'imageName': imageName,
      'region': region,
      'subRegion': subRegion,
      'contentType': contentType,
      'accessControl': accessControl.index
    };
    final String? imagePath =
        await _channel.invokeMethod('uploadImage', params);
    return imagePath;
  }

  static Future<String?> delete(String bucket, String identity,
      String imageName, String region, String subRegion) async {
    final Map<String, dynamic> params = <String, dynamic>{
      'bucket': bucket,
      'identity': identity,
      'imageName': imageName,
      'region': region,
      'subRegion': subRegion
    };
    final String? imagePath =
        await _channel.invokeMethod('deleteImage', params);
    return imagePath;
  }

  static Future<List<String>> listFiles(String bucket, String identity,
      String prefix, String region, String subRegion) async {
    final Map<String, dynamic> params = <String, dynamic>{
      'bucket': bucket,
      'identity': identity,
      'prefix': prefix,
      'region': region,
      'subRegion': subRegion
    };
    List<String> files = new List.empty(growable: true);
    try {
      List<dynamic> keys = await (_channel.invokeMethod('listFiles', params)
          as FutureOr<List<dynamic>>);
      for (String key in keys as Iterable<String>) {
        files.add("https://s3-$region.amazonaws.com/$bucket/$key");
      }
    } on PlatformException catch (e) {
      print(e.toString());
    }

    return files;
  }
}

class AwsRegion {
  static const AP_NORTHEAST_1 = "AP_NORTHEAST_1";
  static const AP_NORTHEAST_2 = "AP_NORTHEAST_2";
  static const AP_SOUTH_1 = "AP_SOUTH_1";
  static const AP_SOUTHEAST_1 = "AP_SOUTHEAST_1";
  static const AP_SOUTHEAST_2 = "AP_SOUTHEAST_2";
  static const CA_CENTRAL_1 = "CA_CENTRAL_1";
  static const CN_NORTH_1 = "CN_NORTH_1";
  static const CN_NORTHWEST_1 = "CN_NORTHWEST_1";
  static const EU_CENTRAL_1 = "EU_CENTRAL_1";
  static const EU_WEST_1 = "EU_WEST_1";
  static const EU_WEST_2 = "EU_WEST_2";
  static const EU_WEST_3 = "EU_WEST_3";
  static const SA_EAST_1 = "SA_EAST_1";
  static const US_EAST_1 = "US_EAST_1";
  static const US_EAST_2 = "US_EAST_2";
  static const US_WEST_1 = "US_WEST_1";
  static const US_WEST_2 = "US_WEST_2";

  static const ME_SOUTH_1 = "ME_SOUTH_1";
  static const AP_EAST_1 = "AP_EAST_1";
  static const EU_NORTH_1 = "EU_NORTH_1";
  static const US_GOV_EAST_1 = "US_GOV_EAST_1";
  static const US_GOV_WEST_1 = "us-gov-west-1";
}

enum S3AccessControl {
  unknown,
  private,
  publicRead,
  publicReadWrite,
  authenticatedRead,
  awsExecRead,
  bucketOwnerRead,
  bucketOwnerFullControl
}
