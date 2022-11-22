import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BookWidgets extends StatelessWidget {
  Color? color;
  IconData? iconData;
  String? title;
  bool? isBlock;
  BookWidgets({
    required this.color,
    required this.iconData,
    required this.title,
    required this.isBlock,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isBlock!
        ? Container(
            width: 164.w,
            height: 164.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: color,
            ),
            child: Stack(
              children: [
                Positioned(
                    top: 0.0,
                    right: 0.0,
                    child: SvgPicture.asset('assets/images/Vector.svg')),
                Padding(
                  padding: EdgeInsets.all(14.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        iconData,
                        color: Colors.white,
                        size: 37.sp,
                      ),
                      SizedBox(
                        height: 50.h,
                      ),
                      Text(
                        title!,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                        ),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            height: 8.h,
                            width: 100.w,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                minHeight: 8.h,
                                value: 0.0,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          const Text(
                            ' 0%',
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        : Container(
            width: 164.w,
            height: 164.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: color,
            ),
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
                      image: AssetImage('assets/images/crown.png'))),
              child: Stack(
                children: [
                  Positioned(
                      top: 0.0,
                      right: 0.0,
                      child: SvgPicture.asset('assets/images/Vector.svg')),
                  Padding(
                    padding: EdgeInsets.all(14.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          iconData,
                          color: Colors.grey,
                          size: 37.sp,
                        ),
                        SizedBox(
                          height: 50.h,
                        ),
                        Text(
                          title!,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 18.sp,
                          ),
                        ),
                        Row(
                          children: [
                            SizedBox(
                              height: 8.h,
                              width: 100.w,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: LinearProgressIndicator(
                                  minHeight: 8.h,
                                  value: 0.0,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            const Text(
                              ' 0%',
                              style: TextStyle(color: Colors.grey),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
