import 'dart:io';

import 'package:flukit/example/example.dart';
import 'package:flukit/flukit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 商品详情
class GoodsDetail extends StatelessWidget {
  const GoodsDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: MvScrollView(),
    );
  }
}

class MvScrollView extends StatefulWidget {
  const MvScrollView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MvScrollViewState();
  }
}

class _MvScrollViewState extends State<MvScrollView> {
  final ScrollController _controller = ScrollController();

  //顶部轮播区高度
  double expandedHeight = 230.0;

  //轮播区是否隐藏
  bool isFlexibleSpaceHide = false;

  //测试图片集合
  List<Image> images = [
    Image.asset('images/image.png', fit: BoxFit.fitWidth),
    Image.asset("images/image2.png", fit: BoxFit.fitWidth),
    Image.asset('images/image3.png', fit: BoxFit.fitWidth)
  ];

  //测试标签
  List<String> tabs = ["门店", "须知", "详情"];

  //礼包控件key
  var giftKey = GlobalKey();
  double giftY = 0;

  //门店控件key
  var storeKey = GlobalKey();
  double storeY = 0;

  //商品须知控件key
  var noticeKey = GlobalKey();
  double noticeY = 0;

  //商品详情key
  var detailKey = GlobalKey();
  double detailY = 0;

  //是否显示标签栏
  bool isShowTabBar = false;

  var tabKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      double offset = _controller.offset;
      setState(() {
        isFlexibleSpaceHide = offset >= (expandedHeight - kToolbarHeight);
        isShowTabBar = offset >= (storeY - (2 * kToolbarHeight + MediaQuery.of(context).padding.top) + 10);
      });
      if(offset >= (noticeY - (2 * kToolbarHeight + MediaQuery.of(context).padding.top) + 10)){
        print("=====tab====");
        DefaultTabController.of(tabKey.currentContext!)?.animateTo(1);
      }
      if(offset >= (detailY - (2 * kToolbarHeight + MediaQuery.of(context).padding.top) + 10)){
        print("=====tab====");
        DefaultTabController.of(tabKey.currentContext!)?.animateTo(2);
      }
    });

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      giftY = getY(giftKey.currentContext);
      storeY = getY(storeKey.currentContext);
      noticeY = getY(noticeKey.currentContext);
      detailY = getY(detailKey.currentContext);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        CustomScrollView(
          controller: _controller,
          slivers: <Widget>[
            ///顶部轮播区
            SliverAppBar(
              //标题栏是否固定
              pinned: true,
              //合并高度，默认为状态栏高度加AppBar高度
              expandedHeight: expandedHeight,
              backgroundColor: Colors.white,
              //是否显示在状态栏下面，false会占领状态栏高度
              primary: true,
              centerTitle: true,
              //左侧的图标或文字
              leading: IconButton(
                  onPressed: () {
                    if(Platform.isAndroid){
                      SystemNavigator.pop();
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: isFlexibleSpaceHide ? Colors.black : Colors.white,
                  )),
              //内容区
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  '美味不用等',
                  style: TextStyle(
                      color: isFlexibleSpaceHide ? Colors.black : Colors.transparent,
                      fontSize: 16),
                ),
                centerTitle: true,
                collapseMode: CollapseMode.pin,
                background: Container(
                    constraints: const BoxConstraints.tightForFinite(),
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                            child: Swiper(
                          autoStart: false,
                          circular: false,
                          children: images,
                          indicator: NumberSwiperIndicator(),
                          indicatorAlignment: AlignmentDirectional.bottomCenter,
                        )),
                        Container(
                          alignment: Alignment.bottomLeft,
                          margin: const EdgeInsets.only(left: 20, bottom: 20),
                          child: const Text("火爆度：9999"),
                        )
                      ],
                    )),
              ),
            ),

            SliverToBoxAdapter(
              child: Container(
                key: giftKey,
                color: Colors.orange,
                height: 200,
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                key: storeKey,
                color: Colors.green,
                height: 300,
                margin: EdgeInsets.only(top: 10),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                key: noticeKey,
                color: Colors.blue,
                height: 400,
                margin: EdgeInsets.only(top: 10),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                key: detailKey,
                color: Colors.blue,
                height: 1400,
                margin: EdgeInsets.only(top: 10),
              ),
            ),
          ],
        ),
        MvTabView(tabs: tabs, overlapsContent: isShowTabBar,key: tabKey,),
      ],
    );
  }
}

class MvTabView extends StatelessWidget {
  final List<String> tabs;

  final bool overlapsContent;

  const MvTabView({Key? key, required this.tabs, required this.overlapsContent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: tabs.length,
        child: Container(
          key: key,
          margin: EdgeInsets.only(
              top: kToolbarHeight + MediaQuery.of(context).padding.top),
          color: Colors.white,
          child: Visibility(
            visible: overlapsContent,
            maintainSize: false,
            child: TabBar(
              labelColor: Colors.black,
              tabs: tabs
                  .map((e) => Tab(
                        text: e,
                      ))
                  .toList(),
            ),
          ),
        ));
  }
}

/// 获取控件距离屏幕顶端距离
double getY(BuildContext? buildContext) {
  RenderBox renderBox = buildContext?.findRenderObject() as RenderBox;
  var offset = renderBox.localToGlobal(Offset.zero);
  return offset.dy;
}
