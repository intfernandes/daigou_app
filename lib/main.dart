import 'package:get/get.dart';
import 'package:shop_app_client/config/color_config.dart';
import 'package:shop_app_client/config/global_inject.dart';
import 'package:shop_app_client/config/routers.dart';
import 'dart:async';
import 'package:shop_app_client/config/wechat_config.dart';
import 'package:shop_app_client/events/application_event.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shop_app_client/extension/translation.dart';
import 'package:shop_app_client/services/common_service.dart';
import 'package:shop_app_client/views/components/caption.dart';
import 'package:shop_app_client/views/components/load_image.dart';
import 'package:shop_app_client/views/shop/goods_detail/goods_detail_binding.dart';
import 'package:shop_app_client/views/shop/goods_detail/goods_detail_view.dart';
import 'package:shop_app_client/views/tabbar/tabbar_binding.dart';
import 'package:logger/logger.dart';
import 'package:shop_app_client/storage/user_storage.dart';

void main() async {
  SystemUiOverlayStyle systemUiOverlayStyle =
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent);
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  WidgetsFlutterBinding.ensureInitialized();
  //传入可能的登录用户
  await dotenv.load(fileName: ".env");
  await GlobalInject.init();

  // 初始化 Firebase
  // await Firebase.initializeApp();
  Timer(Duration(seconds: 2), () => {
    runApp(const MyApp())
  });
  // runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // 创建一个MethodChannel
  static const platform = const MethodChannel('channel:wakeupSchemeJump');
  _MyAppState() {
    //监听事件
    final eventBus = EventBus(sync: true);
    ApplicationEvent.getInstance().event = eventBus;
  }

  @override
  void initState() {
    super.initState();
    WechatConfig().initConfig();
    platform.setMethodCallHandler(_handleMethod);
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    print(call.method);
    print('原生事件监听回调');
    switch (call.method) {
      case 'wakeupSchemeJump':
        String url = call.arguments;
        // 在这里处理接收到的URL参数
        print('Received URL: $url');
        break;
        default:
        throw MissingPluginException();
    }
  }

  initClipboadListener() {
    SystemChannels.lifecycle.setMessageHandler((message) async {
      if (message == 'AppLifecycleState.resumed') {
        // 从后台切换到前台
        getClipboardData();
      }

      return message;
    });
  }

  void registerWakeup() {
    //注册iOS调用flutter方法
    const channel = MethodChannel('channel:wakeupSchemeJump');
    channel.setMethodCallHandler((MethodCall call) async {
      if (call.method == 'wakeupSchemeJump') {
        Logger().d("call.arguments = ${call.arguments}");
        return (schemeJump(Get.context!, call.arguments));
      }
    });
  }

  /// 路由跳转 context schemeUrl
  void schemeJump(BuildContext context, String schemeUrl) {
    print(schemeUrl);
    if(schemeUrl.contains('/details')) {
      //   跳转商品详情页
      Uri uri = Uri.parse(schemeUrl);
      Map<String, String> queryParameters = uri.queryParameters;
      // 传递的参数
      if(queryParameters['id']!=null&&queryParameters['url']!=null) {
        GlobalPages.toPage(
          GoodsDetailView(goodsId: queryParameters['id'].toString()),
          arguments: {'url': queryParameters['url']},
          binding: GoodsDetailBinding(tag: queryParameters['id'].toString()),
          authCheck: true,
        );
      }
    }
  }

  void getClipboardData() async {
    var data = await Clipboard.getData(Clipboard.kTextPlain);

    if ((data?.text ?? '').isNotEmpty) {
      // 解析剪贴板
      var text = data!.text!;
      var currentRoute = Get.currentRoute;
      if (text.contains('yangkeduo') ||
          text.contains('m.tb.cn') ||
          text.contains('m.jd.com') ||
          text.contains('qr.1688.com')) {
        showDialog(text, currentRoute);
      }
    }
  }

  // 检测商品详情
  getGoodsDetail(String data, String currentRoute) async {
    if (data.contains('m.tb.cn') || data.contains('qr.1688.com')) {
      var params = {'word': data};
      if (data.contains('qr.1688.com')) {
        RegExp regex = RegExp(r'https?:\/\/[^s]+');
        var res = regex.firstMatch(data);
        if (res?[0] != null) {
          params['word'] = res![0]!;
          params['platform'] = '1688';
        }
      }
      var url = await CommonService.getGoodsUrl(params);

      if (url != null) {
        GlobalPages.toPage(
          GoodsDetailView(goodsId: url),
          arguments: {'url': url},
          binding: GoodsDetailBinding(tag: url),
          authCheck: true,
        );
      }else {
      //   跳转手动填单
        EasyLoading.showToast('未找到商品，请手动填单'.inte);
        GlobalPages.push(GlobalPages.manualOrder);
      }
    } else {
      GlobalPages.toPage(
        GoodsDetailView(goodsId: data),
        arguments: {'url': data},
        binding: GoodsDetailBinding(tag: data),
        authCheck: true,
      );
    }
  }

  showDialog(String data, String currentRoute) async {
    var res = await Get.dialog<bool?>(
      Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            10.verticalSpace,
            ImgItem(
              'Shop/result',
              width: 100.w,
            ),
            5.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: Text(
                '监测到一个商品链接，是否立即跳转到商品详情'.inte,
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15.h),
              height: 40.h,
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: AppStyles.line),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Obx(() => GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            // height: 30.h,
                            alignment: Alignment.center,
                            color: Colors.transparent,
                            child: AppText(
                              str: '取消'.inte,
                              alignment: TextAlign.center,
                              color: AppStyles.textGrayC9,
                            ),
                          ),
                        )),
                  ),
                  AppGaps.columnsLine,
                  Expanded(
                    child: Obx(
                      () => GestureDetector(
                        onTap: () {
                          Get.back(result: true);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          color: Colors.transparent,
                          child: AppText(
                            str: '确定'.inte,
                            alignment: TextAlign.center,
                            color: AppStyles.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    await Clipboard.setData((const ClipboardData(text: '')));
    if (res == true) {
      getGoodsDetail(data, currentRoute);
    }
  }

  PageTransitionsBuilder createTransition() {
    return const CupertinoPageTransitionsBuilder();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 667),
      builder: (context, child) => GetMaterialApp(
        color: Colors.white,
        theme: ThemeData(
            pageTransitionsTheme: PageTransitionsTheme(
              builders: <TargetPlatform, PageTransitionsBuilder>{
                TargetPlatform.iOS: createTransition(),
                TargetPlatform.android: createTransition(),
              },
            ),
            primaryColor: AppStyles.primary,
            canvasColor: Colors.white,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              systemOverlayStyle: SystemUiOverlayStyle.dark,
            )),
        showSemanticsDebugger: false,
        debugShowCheckedModeBanner: false,
        getPages: GlobalPages.routes,
        initialRoute: CommonStorage.getNewUser() == 1?GlobalPages.loggedGuide:GlobalPages.home,
        initialBinding: TabbarLinker(),
        builder: EasyLoading.init(),
        onReady: () {
          initClipboadListener();
          registerWakeup();
          // getClipboardData();
        },
      ),
    );
  }
}
