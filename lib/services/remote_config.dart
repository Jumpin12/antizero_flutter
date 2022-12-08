import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future<String> getCurrentVersion() async {
  final PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String version = packageInfo.version;
  return version;
}

class RemoteConfigService {
  final RemoteConfig _remoteConfig;
  static RemoteConfigService _instance;
  static Future<RemoteConfigService> getInstance() async {
    if (_instance == null) {
      _instance = RemoteConfigService(
        remoteConfig: RemoteConfig.instance,
      );
    }
    return _instance;
  }

  RemoteConfigService({RemoteConfig remoteConfig})
      : _remoteConfig = remoteConfig;

  Future<String> _enforcedVersion() async {
    // final RemoteConfig _remoteConfig = RemoteConfig.instance;
    // _remoteConfig.setConfigSettings(
    //   RemoteConfigSettings(
    //     fetchTimeout: const Duration(milliseconds: 0),
    //     minimumFetchInterval: Duration.zero,
    //   ),
    // );
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: Duration(seconds: 60),
        minimumFetchInterval: Duration(seconds: 0),
      ),
    );
    await _remoteConfig.fetchAndActivate();
    return _remoteConfig.getString('enforced_version');
  }

  Future initializeConfig() async {
    await _enforcedVersion();
    // try {
    //   await _fetchAndActivate();
    //   return _remoteConfig.getString('enforced_version');
    // } catch (e) {
    //   debugPrint('Remote Config Fetch Failed: $e');
    // }
  }

  // Future _fetchAndActivate() async {
  //   await _remoteConfig.setConfigSettings(
  //     RemoteConfigSettings(
  //       fetchTimeout: Duration(seconds: 60),
  //       minimumFetchInterval: Duration(seconds: 0),
  //     ),
  //   );
  //   return _remoteConfig.fetchAndActivate;
  // }

  Future<bool> get needsUpdate async
  {
    final List<int> currentVersion = await getCurrentVersion().then(
      (value) =>
          value.split('.').map((String number) => int.parse(number)).toList(),
    );
    print('Current Version: $currentVersion');
    final List<int> enforcedVersion = await _enforcedVersion().then(
      (value) =>
          value.split('.').map((String number) => int.parse(number)).toList(),
    );
    print('Enforced Version: $enforcedVersion');
    // while (enforcedVersion[0] >= currentVersion[0])
    // {
    //   if (enforcedVersion[1] > currentVersion[1] ||
    //       enforcedVersion[2] > currentVersion[2]) {
    //     return true;
    //   } else if (enforcedVersion[1] == currentVersion[1] &&
    //       enforcedVersion[2] == currentVersion[2]) {
    //     return false;
    //   }
    // }
    if(Platform.isAndroid)
      {
        for (int i = 0; i < 2; i++)
        {
          // print('Enforced Version: $enforcedVersion');
          // print('Current Version: $currentVersion');
          if (enforcedVersion[i] > currentVersion[i]) return true;
        }
      }
    else if(Platform.isIOS)
      {
        for (int i = 0; i < 3; i++) {
          if (enforcedVersion[i] > currentVersion[i]) return true;
        }
      }
    else
      {
         return false;
      }
    return false;
  }
}
