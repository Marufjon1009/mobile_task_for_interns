import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_task_for_interns/models/post_model.dart';
import 'package:mobile_task_for_interns/models/service/api_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class MainProvider with ChangeNotifier {
  late final connectivity;
  late final StreamSubscription subscription;

  bool isGrammar = false;
  bool isVocabulary = false;
  bool isSpeaking = false;
  bool isListening = false;
  bool isHomework = false;
  Post? post;

  late BuildContext context;
  MainProvider(this.context) {
    connectivity = Connectivity();
    subscription =
        connectivity.onConnectivityChanged.listen(connectivityListener);
  }

  void onDowlander() async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      final externalDir = await getExternalStorageDirectory();

      final id = await FlutterDownloader.enqueue(
        url:
            'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
        savedDir: externalDir!.path,
        fileName: 'download',
        showNotification: true,
        openFileFromNotification: true,
      );
    } else {
      print('permission deined');
    }
  }

  void enableGrammar(bool value) {
    isGrammar = value;
    notifyListeners();
  }

  void enableVocabulary(bool value) {
    isVocabulary = value;
    notifyListeners();
  }

  void enableSpeaking(bool value) {
    isSpeaking = value;
    notifyListeners();
  }

  void enableListening(bool value) {
    isListening = value;
    notifyListeners();
  }

  void enableHomework(bool value) {
    isHomework = value;
    notifyListeners();
  }

  connectivityListener(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.bluetooth:
        break;
      case ConnectivityResult.wifi:
        assert(post == null);
        post = await DioService.getPostResponse();
        show(context);
        notifyListeners();
        break;
      case ConnectivityResult.ethernet:
        break;
      case ConnectivityResult.mobile:
        assert(post == null);
        post = await DioService.getPostResponse();
        show(context);
        notifyListeners();
        break;
      case ConnectivityResult.none:
        break;
      case ConnectivityResult.vpn:
        break;
    }
  }

  void show(BuildContext context) {
    assert(post != null);
    showDialog(
        context: context,
        builder: (context) => Dialog(
              child: Container(
                height: 346.h,
                width: 327.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color(0xFFFFFFFF)),
                child: Column(children: [
                  Padding(
                    padding: EdgeInsets.only(left: 250.w, top: 3.h),
                    child: IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Text(
                    'Har safar yangi rasm, siz uchun',
                    style:
                        TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.h),
                    child: Container(
                      width: 295.w,
                      height: 178.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: post!.urls!.small!,
                        placeholder: (context, url) => const SizedBox(),
                        errorWidget: (context, url, error) =>
                            const Text('Error'),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(right: 16.h, left: 16.h, bottom: 16.h),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 295.w,
                        height: 48.h,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(15)),
                        child: Text(
                          "To'xtatish",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                              fontSize: 13.sp),
                        ),
                      ),
                    ),
                  )
                ]),
              ),
            ));
  }

  void close() {
    subscription.cancel();
    notifyListeners();
  }
}
