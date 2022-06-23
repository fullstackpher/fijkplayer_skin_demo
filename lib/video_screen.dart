import 'package:fijkplayer/fijkplayer.dart';
import 'package:fijkplayer_skin/fijkplayer_skin.dart';
import 'package:fijkplayer_skin/schema.dart' show VideoSourceFormat;
import 'package:flutter/material.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({Key? key}) : super(key: key);

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

// 这里实现一个皮肤显示配置项
class PlayerShowConfig implements ShowConfigAbs {
  @override
  bool drawerBtn = true;
  @override
  bool nextBtn = true;
  @override
  bool speedBtn = true;
  @override
  bool topBar = true;
  @override
  bool lockBtn = true;
  @override
  bool autoNext = true;
  @override
  bool bottomPro = true;
  @override
  bool stateAuto = true;
  @override
  bool isAutoPlay = true;
}

class _VideoScreenState extends State<VideoScreen> {
  // FijkPlayer实例
  final FijkPlayer player = FijkPlayer();

  // 当前tab的index，默认0
  int _curTabIdx = 0;

  // 当前选中的tablist index，默认0
  int _curActiveIdx = 0;

  ShowConfigAbs vCfg = PlayerShowConfig();

  // 视频源列表，请参考当前videoList完整例子
  Map<String, List<Map<String, dynamic>>> videoList = {
    "video": [
      {
        "name": "说英雄谁是英雄",
        "list": [
          {
            "url": "https://vod1.bdzybf7.com/20220524/YBMeX374/index.m3u8",
            "name": "第10集"
          },
          {
            "url": "https://vod1.bdzybf7.com/20220525/oKlvalX1/index.m3u8",
            "name": "第11集"
          },
          {
            "url": "https://vod1.bdzybf7.com/20220525/yUqMCBY0/index.m3u8",
            "name": "第12集"
          },
          {
            "url": "https://vod1.bdzybf7.com/20220530/XlNvCa4u/index.m3u8",
            "name": "第13集"
          },
          {
            "url": "https://vod1.bdzybf7.com/20220530/hIjkx2XI/index.m3u8",
            "name": "第14集"
          },
          {
            "url": "https://vod1.bdzybf7.com/20220531/WuoyA8kn/index.m3u8",
            "name": "第15集"
          },
          {
            "url": "https://vod1.bdzybf7.com/20220531/pmetSE1w/index.m3u8",
            "name": "第16集"
          }
        ]
      },
      {
        "name": "神秘家族",
        "list": [
          {
            "url": "https://vod2.bdzybf7.com/20220330/kki9MgAy/index.m3u8",
            "name": "ckm3u8"
          },
        ]
      },
    ]
  };

  VideoSourceFormat? _videoSourceTabs;

  @override
  void initState() {
    super.initState();
    _videoSourceTabs = VideoSourceFormat.fromJson(videoList);
    // 这句不能省，必须有
    speed = 1.0;
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  // 播放器内部切换视频钩子，回调，tabIdx 和 activeIdx
  void onChangeVideo(int curTabIdx, int curActiveIdx) {
    setState(() {
      _curTabIdx = curTabIdx;
      _curActiveIdx = curActiveIdx;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Fijkplayer Example")),
      body: Container(
          alignment: Alignment.center,
          // 这里 FijkView 开始为自定义 UI 部分
          child: FijkView(
            height: 240,
            color: Colors.black,
            fit: FijkFit.cover,
            player: player,
            panelBuilder: (
              FijkPlayer player,
              FijkData data,
              BuildContext context,
              Size viewSize,
              Rect texturePos,
            ) {
              /// 使用自定义的布局
              return CustomFijkPanel(
                player: player,
                // 传递 context 用于左上角返回箭头关闭当前页面，不要传递错误 context，
                // 如果要点击箭头关闭当前的页面，那必须传递当前组件的根 context
                pageContent: context,
                viewSize: viewSize,
                texturePos: texturePos,
                // 标题 当前页面顶部的标题部分，可以不传，默认空字符串
                playerTitle: "标题",
                // 当前视频改变钩子，简单模式，单个视频播放，可以不传
                onChangeVideo: onChangeVideo,
                // 当前视频源tabIndex
                curTabIdx: _curTabIdx,
                // 当前视频源activeIndex
                curActiveIdx: _curActiveIdx,
                // 显示的配置
                showConfig: vCfg,
                // json格式化后的视频数据
                videoFormat: _videoSourceTabs,
              );
            },
          )),
    );
  }
}
