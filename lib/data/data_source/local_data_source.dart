import 'package:dukkantek/data/network/error_handler.dart';
import 'package:dukkantek/data/responses/responses.dart';

const CACHE_HOME_KEY = "CACHE_HOME_KEY";
const CACHE_HOME_INTERVAL = 60 * 1000; // 1 MINUTE IN MILLIS// 30s in millis

abstract class LocalDataSource {

  Future<void> saveHomeToCache(HomeResponse homeResponse);

  void clearCache();

  void removeFromCache(String key);

}

class LocalDataSourceImplementer implements LocalDataSource {
  // run time cache
  Map<String, CachedItem> cacheMap = Map();


  @override
  Future<void> saveHomeToCache(HomeResponse homeResponse) async {
    cacheMap[CACHE_HOME_KEY] = CachedItem(homeResponse);
  }

  @override
  void clearCache() {
    cacheMap.clear();
  }

  @override
  void removeFromCache(String key) {
    cacheMap.remove(key);
  }
}

class CachedItem {
  dynamic data;

  int cacheTime = DateTime.now().millisecondsSinceEpoch;

  CachedItem(this.data);
}

extension CachedItemExtension on CachedItem {
  bool isValid(int expirationTime) {
    // expirationTime is 60 secs
    int currentTimeInMillis =
        DateTime.now().millisecondsSinceEpoch; // time now is 1:00:00 pm

    bool isCacheValid = currentTimeInMillis - expirationTime <
        cacheTime; // cache time was in 12:59:30
    // false if current time > 1:00:30
    // true if current time <1:00:30
    return isCacheValid;
  }
}
