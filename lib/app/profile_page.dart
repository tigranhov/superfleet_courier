import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:superfleet_courier/super_icons_icons.dart';
import 'package:superfleet_courier/widgets/buttons/sf_button.dart';
import 'package:superfleet_courier/theme/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(children: [
            _TopPanel(
              onExitPage: () {
                Navigator.of(context).pop();
              },
            ),
            SizedBox(height: 1.h),
            const _ProfileInfoCard(),
            _ChangePasswordCard(onTap: () {
              
            },),
            _ChangeLanguageCard(onTap: () {
              
            },),
            _LogoutButton(onTap: () {
              
            },)
          ]),
        ),
      ),
    );
  }
}

class _TopPanel extends StatelessWidget {
  const _TopPanel({super.key, required this.onExitPage});
  final Function() onExitPage;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1.sp,
      color: Colors.white,
      child: SizedBox(
        height: 48.h,
        child: Stack(
          children: [
            IconButton(
                padding: REdgeInsets.all(17),
                iconSize: 14.sp,
                onPressed: onExitPage,
                icon: const Icon(Icons.close)),
            Center(
                child: Text(
              'Profile',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
            ))
          ],
        ),
      ),
    );
  }
}

class _ProfileInfoCard extends StatelessWidget {
  const _ProfileInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(height: 12.h),
          Center(
              child: Text(
            'SAS Supermarket',
            style: TextStyle(color: const Color(0xff888888), fontSize: 14.sp),
          )),
          SizedBox(height: 12.h),
          Container(
            width: 88.w,
            height: 88.h,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage('https://picsum.photos/200'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'Levon Martirosyan',
            style: TextStyle(fontSize: 20.sp),
          ),
          SizedBox(height: 4.h),
          Text(
            '@lyovakyova',
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
          ),
          SizedBox(height: 24.h),
          Divider(height: 1.h, thickness: 1.h),
          SizedBox(height: 15.h),
          Padding(
            padding: EdgeInsets.only(left: 26.w, bottom: 16.h),
            child: const _IconText(
              iconData: Icons.phone,
              text: '+37491 555 555',
              iconColor: Color(0xffE99700),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 26.w, bottom: 16.h),
            child: const _IconText(
              iconData: Icons.mail,
              text: 'levon.martirosyan@gmail.com',
              iconColor: Color(0xff4F9E52),
            ),
          )
        ],
      ),
    );
  }
}

class _IconText extends StatelessWidget {
  const _IconText(
      {super.key,
      required this.iconData,
      required this.text,
      required this.iconColor});
  final IconData iconData;
  final String text;
  final Color iconColor;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          iconData,
          color: iconColor,
          size: 18.sp,
        ),
        SizedBox(width: 11.w),
        Text(text, style: TextStyle(fontSize: 14.sp)),
      ],
    );
  }
}

class _ChangePasswordCard extends StatelessWidget {
  const _ChangePasswordCard({super.key, required this.onTap});

  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 12.w, top: 12.h, right: 12.w),
      child: InkWell(
        onTap: onTap,
        child: Card(
          elevation: 1,
          child: Padding(
            padding: EdgeInsets.only(
                left: 12.w, top: 18.h, right: 19.5.w, bottom: 16.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.key,
                  color: Color(0xffCA1E1E),
                  size: 22.sp,
                ),
                SizedBox(width: 9.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Change Password',
                        style: TextStyle(
                            fontSize: 14.sp, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4.h),
                      AutoSizeText(
                        'It\'s a good idea to use a strong password that you\'re not using elsewhere',
                        minFontSize: 14.sp,
                        stepGranularity: 1.sp,
                      )
                    ],
                  ),
                ),
                Icon(
                  SuperIcons.double_arrow,
                  size: 24.sp,
                  color: const Color(0xff888888),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChangeLanguageCard extends StatelessWidget {
  const _ChangeLanguageCard({super.key, required this.onTap});
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: REdgeInsets.only(left: 12, top: 12, right: 12),
      child: InkWell(
        onTap: onTap,
        child: Card(
          elevation: 1,
          child: Padding(
            padding:
                REdgeInsets.only(left: 12, top: 18, right: 19.5, bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.language,
                  color: superfleetBlue,
                  size: 22.sp,
                ),
                SizedBox(width: 9.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Change Language',
                        style: TextStyle(
                            fontSize: 14.sp, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4.h),
                      AutoSizeText(
                        'App language: English',
                        minFontSize: 14.sp,
                        stepGranularity: 1.sp,
                      )
                    ],
                  ),
                ),
                Icon(
                  SuperIcons.double_arrow,
                  size: 24.sp,
                  color: const Color(0xff888888),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton({super.key, required this.onTap});
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: REdgeInsets.all(24.0),
      child: SFButton(
        width: 212.w,
        height: 56.h,
        text: 'Log Out',
        onPressed: onTap,
        inverse: true,
        mainColor: const Color(0xffCA1E1E),
        secondaryColor: Colors.white,
        borderColor: Colors.grey,
      ),
    );
  }
}
