````md
# flutter_baidu_mapapi_map

一个用于 **百度地图（Baidu Map）** 的 Flutter 插件，支持 **Android / iOS** 平台。

> 本仓库是 `flutter_baidu_mapapi_map` 的维护分支（fork 版本），  
> 已移除不受支持的 HarmonyOS（OHOS）相关代码，用于保证在新版本 Flutter 下的稳定性。

---

## ✨ 功能特性

- 百度地图 SDK Flutter 封装
- 支持 **Android / iOS**
- 地图展示、标注（Marker）、覆盖物等基础能力
- 适配较新的 Flutter Stable 版本
- ❌ **不支持 HarmonyOS / OHOS**

---

## 🚫 关于 HarmonyOS（OHOS）

本 fork **已明确移除所有 HarmonyOS（OHOS）相关代码**，包括但不限于：

- `TargetPlatform.ohos`
- `OhosView`
- `ohos/` 平台目录

### 移除原因

- Flutter 官方目前 **不支持 HarmonyOS**
- OHOS 分支在新版本 Flutter 中可能导致 **编译失败 / 运行异常**
- 本仓库仅专注于 **Android / iOS 的稳定使用**

---

## 📦 安装方式

推荐使用 **Git 方式依赖**，避免 pub cache 被覆盖：

```yaml
dependencies:
  flutter_baidu_mapapi_map:
    git:
      url: https://github.com/你的用户名/flutter_baidu_mapapi_map.git
```
````

然后执行：

```bash
flutter pub get
```

---

## 🔧 平台配置

### Android 配置

1. 在 `AndroidManifest.xml` 中配置 **百度地图 AK**
2. 添加必要权限（网络、定位等）
3. 按百度地图 Android SDK 官方文档完成初始化

---

### iOS 配置

1. 在 `AppDelegate` 中初始化 **百度地图 AK**
2. 开启定位与网络相关权限
3. 确保当前网络环境可以正常访问百度地图服务

> ⚠️ 无线调试时请确保已允许 **本地网络（Local Network）权限**

---

## 🧪 示例工程

插件自带示例工程，位于 `example/` 目录：

```bash
cd example
flutter run
```

---

## 🛠️ 维护说明

- 本插件为 fork 版本，用于项目长期维护
- 不会因 `flutter pub get` 或清理缓存而丢失修改
- 欢迎提交 Issue 或 PR 进行改进

---

## 📄 许可证

本项目遵循原始 `flutter_baidu_mapapi_map` 插件的许可证协议。
详见 [LICENSE](LICENSE) 文件。

```

---

```
