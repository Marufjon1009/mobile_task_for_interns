import 'dart:isolate';
import 'dart:ui';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_task_for_interns/models/service/video_service.dart';
import 'package:mobile_task_for_interns/pages/main_page/main_provider.dart';
import 'package:mobile_task_for_interns/pages/widgets/book_widget.dart';
import 'package:mobile_task_for_interns/pages/widgets/custom_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  late final VideoService? videoService;

  final ReceivePort _receivePort = ReceivePort();
  bool? isHomework;

  Future download(String url) async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      final baseStorage = await getExternalStorageDirectory();

      await FlutterDownloader.enqueue(
        url: url,
        headers: {}, // optional: header send with url (auth token etc)
        savedDir: baseStorage!.path,
        showNotification:
            true, // show download progress in status bar (for Android)
        openFileFromNotification:
            true, // click on notification to open downloaded file (for Android)
      );
    }
  }

  final ReceivePort _port = ReceivePort();
  @override
  void initState() {
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];

      if (status == DownloadTaskStatus.complete) {
        print('Download complate');
      }
      setState(() {});
    });

    FlutterDownloader.registerCallback(downloadCallback);
    context.read<MainProvider>();
    videoService = VideoService();
    super.initState();
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    videoService!.dispose();
    super.dispose();
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send!.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        bottomOpacity: 0.0,
        title: Text(
          'ROUNDED TASK',
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 18.h),
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: const DecorationImage(
                                  image: AssetImage('assets/images/person.png'),
                                  fit: BoxFit.cover)),
                          width: 96.w,
                          height: 96.w,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 16.h,
                            ),
                            Text(
                              'Lesson 2',
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey),
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
                            Text(
                              'How to talk about nation Asilbek Asqarov Asilbek',
                              style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              side: BorderSide(width: 2.w, color: Colors.blue)),
                          child: SizedBox(
                            height: 40.h,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Saqlab qo\'yish ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 13.sp)),
                                const Icon(
                                  Icons.bookmark_border_outlined,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(14),
                        child: Container(
                          width: 160.w,
                          height: 40.h,
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(8)),
                          child: TextButton(
                            style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Yuklab olish ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                      fontSize: 13.sp),
                                ),
                                const Icon(
                                  Icons.cloud_download_outlined,
                                  color: Colors.white,
                                )
                              ],
                            ),
                            onPressed: () => download(
                                'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4'),
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 24.h, bottom: 24.h),
                    child: const Divider(
                      height: 5,
                      thickness: 1.5,
                      endIndent: 15,
                      indent: 15,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Consumer<MainProvider>(builder: (context, value, _) {
                  isHomework = value.isHomework;
                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) => SimpleDialog(
                                    children: [
                                      Card(
                                        child: SizedBox(
                                          height: 180,
                                          child: Chewie(
                                              controller: videoService!.chewie),
                                        ),
                                      ),
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.black,
                                          textStyle:
                                              const TextStyle(fontSize: 10),
                                        ),
                                        onPressed: () async {
                                          await videoService!.chewie.pause();

                                          // ignore: use_build_context_synchronously
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text(
                                          'EXIT',
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ));
                        },
                        child: Container(
                          height: 160.h,
                          width: 344.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: const DecorationImage(
                                  image: AssetImage('assets/images/child.png'),
                                  fit: BoxFit.cover)),
                          child: Container(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.6),
                                    Colors.black.withOpacity(0.3),
                                    Colors.black.withOpacity(0.0),
                                  ],
                                  tileMode: TileMode.mirror,
                                ),
                                borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 16.w),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'How to speak like a native',
                                    style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  ),
                                  Icon(
                                    Icons.play_circle_outlined,
                                    color: Colors.white,
                                    size: 30.sp,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 14.h,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomWidget(
                              onDoubleTap: () => value.enableGrammar(false),
                              onTripleTap: () => value.enableGrammar(true),
                              child: BookWidgets(
                                isBlock: !value.isGrammar,
                                color: Colors.blue,
                                iconData: Icons.book_online,
                                title: 'Grammar',
                              ),
                            ),
                            CustomWidget(
                              onDoubleTap: () => value.enableVocabulary(false),
                              onTripleTap: () => value.enableVocabulary(true),
                              child: BookWidgets(
                                isBlock: value.isVocabulary,
                                color: Colors.green,
                                iconData: Icons.menu_book_rounded,
                                title: 'Vocabulary',
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomWidget(
                              onDoubleTap: () => value.enableSpeaking(false),
                              onTripleTap: () => value.enableSpeaking(true),
                              child: BookWidgets(
                                isBlock: value.isSpeaking,
                                color: Colors.deepPurple,
                                iconData: Icons.record_voice_over_outlined,
                                title: 'Speaking',
                              ),
                            ),
                            CustomWidget(
                              onDoubleTap: () => value.enableListening(false),
                              onTripleTap: () => value.enableListening(true),
                              child: BookWidgets(
                                isBlock: value.isListening,
                                color: Colors.orange,
                                iconData: Icons.headphones,
                                title: 'Listening',
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      CustomWidget(
                        onDoubleTap: () => value.enableHomework(false),
                        onTripleTap: () => value.enableHomework(true),
                        child: isHomework!
                            ? Container(
                                width: 344.w,
                                height: 131.h,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: const Color(0xFF27244b)),
                                child: Stack(
                                  children: [
                                    Positioned(
                                        top: 0.0,
                                        right: 0.0,
                                        child: SvgPicture.asset(
                                            'assets/images/Vector.svg')),
                                    Positioned(
                                        top: 25.h,
                                        right: 20.w,
                                        child: Image.asset(
                                            'assets/images/trophy.png')),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(14.w),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Homework',
                                                  style: TextStyle(
                                                      fontSize: 16.sp,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                SizedBox(
                                                  height: 8.h,
                                                ),
                                                Text(
                                                  'Bu joyda barcha ishtirokchilar \ndarajalari bilan tanishing',
                                                  style: TextStyle(
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.white),
                                                ),
                                                SizedBox(
                                                  height: 14.h,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    SizedBox(
                                                      height: 8.h,
                                                      width: 100.w,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        child:
                                                            LinearProgressIndicator(
                                                          minHeight: 8.h,
                                                          value: 0.0,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    ),
                                                    const Text(
                                                      ' 0%',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ],
                                                ),
                                              ]),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            : Container(
                                width: 344.w,
                                height: 131.h,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: const Color(0xFF27244b)),
                                child: Container(
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          Colors.black.withOpacity(0.2),
                                          Colors.black.withOpacity(0.2),
                                          Colors.black.withOpacity(0.2),
                                        ],
                                        // tileMode: TileMode.decal,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                      image: const DecorationImage(
                                          image: AssetImage(
                                              'assets/images/crown.png'))),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                          top: 0.0,
                                          right: 0.0,
                                          child: SvgPicture.asset(
                                              'assets/images/Vector.svg')),
                                      Positioned(
                                          top: 25.h,
                                          right: 20.w,
                                          child: Image.asset(
                                              'assets/images/trophy.png')),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(14.w),
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Homework',
                                                    style: TextStyle(
                                                        fontSize: 16.sp,
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                  SizedBox(
                                                    height: 8.h,
                                                  ),
                                                  Text(
                                                    'Bu joyda barcha ishtirokchilar \ndarajalari bilan tanishing',
                                                    style: TextStyle(
                                                        fontSize: 12.sp,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.grey),
                                                  ),
                                                  SizedBox(
                                                    height: 14.h,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      SizedBox(
                                                        height: 8.h,
                                                        width: 100.w,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          child:
                                                              LinearProgressIndicator(
                                                            minHeight: 8.h,
                                                            value: 0.0,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      ),
                                                      const Text(
                                                        ' 0%',
                                                        style: TextStyle(
                                                            color: Colors.grey),
                                                      )
                                                    ],
                                                  )
                                                ]),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      ),
                      SizedBox(
                        height: 16.h,
                      )
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
