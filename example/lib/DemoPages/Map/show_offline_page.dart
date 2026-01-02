import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_map_example/CustomWidgets/map_appbar.dart';
import 'package:flutter_baidu_mapapi_map_example/constants.dart';

/// 离线地图示例
class ShowOfflineMapPage extends StatefulWidget {
  ShowOfflineMapPage({Key? key}) : super(key: key);

  @override
  _ShowOfflineMapPageState createState() => _ShowOfflineMapPageState();
}

class _ShowOfflineMapPageState extends State<ShowOfflineMapPage> {
  static const int TBBounds = 1024 * 1024 * 1024 * 1024;
  static const int GBBounds = 1024 * 1024 * 1024;
  static const int MBBounds = 1024 * 1024;
  static const int KBBounds = 1024;

  List<CityData> hotCityDatas = [];
  List<CityData> offlineCityall = [];
  List<UpdateData> allUpdate = [];
  OfflineController offlineController = OfflineController();

  String _city = ""; // 城市名
  String _cityid = ""; // 城市id
  int _ratio = 0; // 下载进度
  bool _downloading = false; // 下载状态

  late Size screenSize;

  void _textFieldChanged(String str) {
    _city = str;
    if (("" == _city)) {
      setState(() {
        _ratio = 0;
        _cityid = "";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    offlineController.init();
    offlineController.onGetOfflineMapStateBack(
        callback: (int? state, int? cityID) {
      switch (state) {
        case OfflineController.TYPE_DOWNLOAD_UPDATE:
          _setUpdateInfo(cityID!);
          // 处理下载进度更新提示
          break;

        case OfflineController.TYPE_NEW_OFFLINE:
          // 有新离线地图安装
          break;

        case OfflineController.TYPE_VER_UPDATE:
          // 版本更新提示
          // MKOLUpdateElement e = mOffline.getUpdateInfo(state);
          break;

        default:
          break;
      }
    });
    _getHotCity();
    _getOfflineCityList();
    _getAllUpdateInfo();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;

    return MaterialApp(
        home: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: BMFAppBar(
              title: '离线地图示例',
              onBack: () {
                Navigator.pop(context);
              },
            ),
            body: Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Column(children: <Widget>[
                Container(
                  child: _generateSearchRow(),
                ),
                Container(
                  padding: EdgeInsets.only(top: 4),
                  child: _generateControlRow(),
                ),
                Container(
                  padding: EdgeInsets.only(top: 4),
                  child: _generateHotCity(),
                ),
                Container(
                  padding: EdgeInsets.only(top: 4),
                  child: _generateWholeCountry(),
                ),
                Container(
                  padding: EdgeInsets.only(top: 4),
                  child: SingleChildScrollView(
                    child: _generateDownloaded(),
                  ),
                ),
              ]),
            )));
  }

  @override
  void dispose() {
    super.dispose();
    offlineController.destroyOfflineMap();
  }

  /// 创建搜索栏
  Row _generateSearchRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Column(
          children: <Widget>[
            Row(children: <Widget>[
              Container(
                width: 200,
                height: 40,
                child: TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 10.0),
                    hintText: '请输入下载城市',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                            color: Color(int.parse(Constants.btnColor)))),
                  ),
                  onChanged: _textFieldChanged,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20),
                child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Color(int.parse(Constants.btnColor))),
                    ),
                    child: new Text("搜索城市"),
                    onPressed: () async {
                      // 下载过程中禁止搜索城市
                      if (_downloading) {
                        return;
                      }

                      List<BMFOfflineCityRecord> cityList;
                      FocusScope.of(context).requestFocus(FocusNode());
                      setState(() {
                        _cityid = "";
                        _ratio = 0;
                      });

                      List<BMFOfflineCityRecord>? tmpCityList =
                          await offlineController.searchCity(_city);
                      if (tmpCityList == null) return;
                      cityList = tmpCityList;
                      int ratio = _getCityDownloadRatio(cityList[0].cityID!);

                      setState(() {
                        _cityid = cityList[0].cityID.toString();
                        _ratio = ratio;
                      });
                    }),
              )
            ]),
            Container(
              alignment: Alignment.center,
              width: 220,
              height: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text("城市id:$_cityid"),
                  Text(" 已下载:$_ratio%"),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }

  ///  创建下载控制栏
  Row _generateControlRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                  Color(int.parse(Constants.btnColor))),
            ),
            child: new Text("下载"),
            onPressed: () async {
              _downloading = true;
              await offlineController.startOfflineMap(int.parse(_cityid));
            }),
        SizedBox(
          width: 10,
        ),
        ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                  Color(int.parse(Constants.btnColor))),
            ),
            child: new Text("暂停"),
            onPressed: () async {
              await offlineController.pauseOfflineMap(int.parse(_cityid));
            }),
        SizedBox(
          width: 10,
        ),
        ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                  Color(int.parse(Constants.btnColor))),
            ),
            child: new Text("删除"),
            onPressed: () async {
              await offlineController.removeOfflineMap(int.parse(_cityid));
              setState(() {
                _removeCityFromDownloaded(int.parse(_cityid));
              });
            }),
      ],
    );
  }

  ///  创建热门城市栏
  Column _generateHotCity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("热门城市:",
            style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600)),
        MediaQuery.removePadding(
            removeTop: true,
            removeLeft: false,
            removeRight: false,
            context: context,
            child: new Container(
              height: 120,
              child: ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Container(
                        height: 30.0,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  width: 180,
                                  child: Text(
                                    "${hotCityDatas[index].cityNeme}",
                                    style: new TextStyle(
                                        fontSize: 18.0, color: Colors.red),
                                  )),
                              Container(
                                width: 80,
                                child: Text(
                                  "${hotCityDatas[index].cityId}",
                                  style: new TextStyle(
                                      fontSize: 18.0, color: Colors.green),
                                ),
                              ),
                              Container(
                                width: 60,
                                child: Text(
                                  _getSizeStr(hotCityDatas[index].dateSize),
                                  style: new TextStyle(
                                      fontSize: 18.0, color: Colors.blue),
                                ),
                              ),
                            ]));
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      height: 1,
                      indent: 10,
                      endIndent: 10,
                      color: Colors.black26,
                    );
                  },
                  itemCount: hotCityDatas.length),
            )),
      ],
    );
  }

  // 创建全国城市栏
  Column _generateWholeCountry() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("全国:",
            style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600)),
        MediaQuery.removePadding(
            removeTop: true,
            context: context,
            child: new Container(
                height: 120,
                child: ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return new Container(
                          alignment: Alignment.centerLeft,
                          height: 30.0,
                          child: new Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: 180,
                                  child: Text(
                                    "${offlineCityall[index].cityNeme}",
                                    style: new TextStyle(
                                        fontSize: 18.0, color: Colors.red),
                                  ),
                                ),
                                Container(
                                  width: 80,
                                  child: Text(
                                    "${offlineCityall[index].cityId}",
                                    style: new TextStyle(
                                        fontSize: 18.0, color: Colors.green),
                                  ),
                                ),
                                Container(
                                  width: 60,
                                  child: Text(
                                    _getSizeStr(offlineCityall[index].dateSize),
                                    style: new TextStyle(
                                        fontSize: 18.0, color: Colors.blue),
                                  ),
                                ),
                              ]));
                    },
                    separatorBuilder: (context, index) {
                      return Divider(
                        height: 1,
                        color: Colors.black26,
                      );
                    },
                    itemCount: offlineCityall.length))),
      ],
    );
  }

  /// 创建已下载栏
  Column _generateDownloaded() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("已下载:",
              style:
                  new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600)),
          MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: new Container(
                  height: 120,
                  child: ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return new Container(
                            height: 30.0,
                            child: new Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: 180,
                                    child: Text(
                                      "${allUpdate[index].cityName}",
                                      style: new TextStyle(
                                          fontSize: 18.0, color: Colors.red),
                                    ),
                                  ),
                                  Container(
                                    width: 80,
                                    child: Text(
                                      "${allUpdate[index].ratio}%",
                                      style: new TextStyle(
                                          fontSize: 18.0, color: Colors.green),
                                    ),
                                  ),
                                  Container(
                                    width: 60,
                                    child: Text(
                                      _getSizeStr(allUpdate[index].size ?? 0),
                                      style: new TextStyle(
                                          fontSize: 18.0, color: Colors.blue),
                                    ),
                                  ),
                                ]));
                      },
                      separatorBuilder: (context, index) {
                        return Divider(
                          height: 1,
                          color: Colors.black26,
                        );
                      },
                      itemCount: allUpdate.length)))
        ]);
  }

  /// 获取热门城市
  Future _getHotCity() async {
    List<BMFOfflineCityRecord>? cityList =
        await offlineController.getHotCityList();
    if (null == cityList) {
      return;
    }
    for (var value in cityList) {
      CityData hotCityData =
          CityData(value.cityName!, value.cityID!, value.dataSize!);
      setState(() {
        hotCityDatas.add(hotCityData);
      });
    }
  }

  /// 获取全国城市
  Future _getOfflineCityList() async {
    List<BMFOfflineCityRecord>? cityList =
        await offlineController.getOfflineCityList();
    if (null == cityList) {
      return;
    }
    for (var value in cityList) {
      CityData hotCityData =
          new CityData(value.cityName!, value.cityID!, value.dataSize!);
      setState(() {
        offlineCityall.add(hotCityData);
      });
    }
  }

  /// 获取下载状态
  void _getAllUpdateInfo() async {
    List<BMFUpdateElement>? update = await offlineController.getAllUpdateInfo();

    if (null == update) {
      return null;
    }
    for (var value in update) {
      UpdateData updateData =
          new UpdateData(value.cityName, value.ratio, value.size, value.cityID);
      setState(() {
        allUpdate.add(updateData);
      });
    }
  }

  void _setUpdateInfo(int cityID) async {
    if (!mounted) {
      return;
    }

    BMFUpdateElement? update = await offlineController.getUpdateInfo(cityID);

    if (null == update) {
      return;
    }

    if (update.cityID != int.parse(_cityid)) {
      updateDowndLoadInfo(update, false);
      return;
    }

    updateDowndLoadInfo(update, true);
  }

  void updateDowndLoadInfo(BMFUpdateElement? update, bool updateRatio) {
    setState(() {
      if (update != null) {
        if (updateRatio && update.ratio != null) {
          _ratio = update.ratio!;
        }
        if (update.ratio == 100 && !_isCityDownloaded(update.cityID!)) {
          if (updateRatio) {
            _downloading = false;
          }

          UpdateData updateData = UpdateData(
              update.cityName, update.ratio, update.size, update.cityID);
          allUpdate.add(updateData);
        }
      }
    });
  }

  int _getCityDownloadRatio(int cityID) {
    int ratio = 0;
    allUpdate.forEach((element) {
      if (element.cityId == cityID) {
        ratio = element.ratio!;
      }
    });

    return ratio;
  }

  bool _isCityDownloaded(int cityID) {
    bool downloaded = false;
    allUpdate.forEach((element) {
      if (element.cityId == cityID) {
        downloaded = true;
      }
    });

    return downloaded;
  }

  void _removeCityFromDownloaded(int cityID) {
    allUpdate.removeWhere((element) => element.cityId == cityID);
    if (_ratio > 0) {
      setState(() {
        _ratio = 0;
      });
    }
  }

  String _getSizeStr(int size) {
    String sizeStr;
    if (size >= TBBounds) {
      sizeStr = (size / TBBounds).round().toString() + "T";
    } else if (size >= GBBounds) {
      sizeStr = (size / GBBounds).round().toString() + "G";
    } else if (size >= MBBounds) {
      sizeStr = (size / MBBounds).round().toString() + "M";
    } else if (size >= KBBounds) {
      sizeStr = (size / KBBounds).round().toString() + "K";
    } else {
      sizeStr = size.toString() + "Byte";
    }

    return sizeStr;
  }
}

class CityData {
  /// 城市名称
  String cityNeme;

  /// 城市id
  int cityId;

  /// 数据大小
  int dateSize;

  CityData(this.cityNeme, this.cityId, this.dateSize);
}

class UpdateData {
  /// 城市名称
  String? cityName;

  /// 下载比率，100为下载完成
  int? ratio;

  /// 已下载数据大小
  int? size;

  /// 城市id
  int? cityId;

  UpdateData(this.cityName, this.ratio, this.size, this.cityId);
}
