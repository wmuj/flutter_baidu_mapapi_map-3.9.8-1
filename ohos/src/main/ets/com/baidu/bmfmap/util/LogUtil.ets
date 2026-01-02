const LOG_TAG = 'flutter_baidu_map'
const OPEN = true

export default class LogUtil {
  static debug(msg: string) {
    if (OPEN) {
      console.debug(LOG_TAG, msg)
    }
  }

  static error(msg: string) {
    console.error(LOG_TAG, msg)
  }
}