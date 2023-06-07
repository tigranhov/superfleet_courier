import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:superfleet_courier/features/login/logic/auth_notifier.dart';
import 'package:superfleet_courier/super_icons_icons.dart';
import 'package:superfleet_courier/theme/colors.dart';
import 'package:superfleet_courier/widgets/buttons/sf_button.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(children: [
            _TopPanel(
              onExitPage: () {
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(height: 1),
            const _ProfileInfoCard(),
            _ChangePasswordCard(
              onTap: () {},
            ),
            _ChangeLanguageCard(
              onTap: () {},
            ),
            _LogoutButton(
              onTap: () {
                ref.read(authNotifierProvider.notifier).logout();
              },
            )
          ]),
        ),
      ),
    );
  }
}

class _TopPanel extends StatelessWidget {
  const _TopPanel({required this.onExitPage});
  final Function() onExitPage;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      color: Colors.white,
      child: SizedBox(
        height: 48,
        child: Stack(
          children: [
            IconButton(
                padding: const EdgeInsets.all(17),
                iconSize: 14,
                onPressed: onExitPage,
                icon: const Icon(Icons.close)),
            const Center(
                child: Text(
              'Profile',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ))
          ],
        ),
      ),
    );
  }
}

class _ProfileInfoCard extends StatelessWidget {
  const _ProfileInfoCard();

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 12),
          const Center(
              child: Text(
            'SAS Supermarket',
            style: TextStyle(color: Color(0xff888888), fontSize: 14),
          )),
          const SizedBox(height: 12),
          Container(
            width: 88,
            height: 88,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage('https://picsum.photos/200'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Levon Martirosyan',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 4),
          const Text(
            '@lyovakyova',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 24),
          const Divider(height: 1, thickness: 1),
          const SizedBox(height: 15),
          const Padding(
            padding: EdgeInsets.only(left: 26, bottom: 16),
            child: _IconText(
              iconData: Icons.phone,
              text: '+37491 555 555',
              iconColor: Color(0xffE99700),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 26, bottom: 16),
            child: _IconText(
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
      {required this.iconData, required this.text, required this.iconColor});
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
          size: 18,
        ),
        const SizedBox(width: 11),
        Text(text, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}

class _ChangePasswordCard extends StatelessWidget {
  const _ChangePasswordCard({required this.onTap});

  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 12, top: 12, right: 12),
      child: InkWell(
        onTap: onTap,
        child: const Card(
          elevation: 1,
          child: Padding(
            padding: EdgeInsets.only(
                left: 12, top: 18, right: 19.5, bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.key,
                  color: Color(0xffCA1E1E),
                  size: 22,
                ),
                SizedBox(width: 9),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Change Password',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      AutoSizeText(
                        'It\'s a good idea to use a strong password that you\'re not using elsewhere',
                        minFontSize: 14,
                        stepGranularity: 1,
                      )
                    ],
                  ),
                ),
                Icon(
                  SuperIcons.rightArrow,
                  size: 24,
                  color: Color(0xff888888),
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
  const _ChangeLanguageCard({required this.onTap});
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 12, top: 12, right: 12),
      child: InkWell(
        onTap: onTap,
        child: const Card(
          elevation: 1,
          child: Padding(
            padding: EdgeInsets.only(
                left: 12, top: 18, right: 19.5, bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.language,
                  color: superfleetBlue,
                  size: 22,
                ),
                SizedBox(width: 9),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Change Language',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      AutoSizeText(
                        'App language: English',
                        minFontSize: 14,
                        stepGranularity: 1,
                      )
                    ],
                  ),
                ),
                Icon(
                  SuperIcons.rightArrow,
                  size: 24,
                  color: Color(0xff888888),
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
  const _LogoutButton({required this.onTap});
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SFButton(
        width: 212,
        height: 56,
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
