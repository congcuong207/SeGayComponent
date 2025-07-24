import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:se_gay_components/common/sg_button_icon_v2.dart';
import 'package:se_gay_components/common/sg_search_box.dart';
import 'package:se_gay_components/constants/index.dart';
import '../common/sg_button_icon_with_popup.dart';
import '../common/sg_popup_menu.dart';

class SGHeader extends StatefulWidget {
  final Widget? navUserMenu;

  final double height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Decoration? decoration;

  final String? imageLogoLeft;
  final String? imageLogoRight;

  const SGHeader({
    super.key,
    this.height = 65,
    this.padding,
    this.margin,
    this.decoration,
    this.navUserMenu,
    this.imageLogoLeft,
    this.imageLogoRight,
  });

  @override
  State<SGHeader> createState() => _SGHeaderState();
}

class _SGHeaderState extends State<SGHeader> {
  // Helper method for time options in popup
  Widget _buildTimeOption(String title) {
    return InkWell(
      onTap: () {
        debugPrint('$title selected');
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(title),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      margin: widget.margin,
      decoration: widget.decoration,
      child: Row(
        children: [
          widget.imageLogoLeft != null ? SvgPicture.asset(widget.imageLogoLeft!) : SvgPicture.asset(SGAppSvgs.iconLogo),
          const SizedBox(width: 24),
          Expanded(
            child: widget.navUserMenu ??
                Row(
                  children: [
                    const SGSearchBox(
                      width: 280,
                      margin: EdgeInsets.only(left: 24),
                    ),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        spacing: 10,
                        children: [
                          // SGButton(
                          //   prefixWidget: Padding(
                          //     padding: const EdgeInsets.only(right: 6),
                          //     child: SvgPicture.asset(
                          //       SGAppSvgs.iconPlus,
                          //       width: 12,
                          //       height: 12,
                          //     ),
                          //   ),
                          //   onclick: () {},
                          //   state: SGButtonState.active,
                          //   text: "Thêm mới",
                          //   color: SGAppColors.colorFE9F43,
                          //   loadingColor: SGAppColors.neutral0,
                          //   borderRadius: 6,
                          //   height: 30,
                          //   textStyle: SGAppFont.headline6(
                          //     color: SGAppColors.neutral0,
                          //     fontWeight: FontWeight.w400,
                          //   ),
                          // ),
                          Container(
                            width: 1,
                            height: 24,
                            color: Colors.grey.shade300,
                          ),
                          SGButtonIconV2(
                            icon: SGAppSvgs.iconSetting,
                            onclick: (_) {},
                          ),
                          SGButtonIconWithPopup(
                            icon: SGAppSvgs.iconChat,
                            popupOffset: const Offset(-83, 10),
                            popupId: 'header_chat',
                            popupItems: [
                              SGPopupMenuItem(
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildTimeOption('Today'),
                                    _buildTimeOption('Yesterday'),
                                    _buildTimeOption('Last 7 days'),
                                    _buildTimeOption('This month'),
                                    _buildTimeOption('Custom range'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SGButtonIconWithPopup(
                            icon: SGAppSvgs.iconTime,
                            popupOffset: const Offset(-83, 10),
                            popupId: 'header_time',
                            popupItems: [
                              SGPopupMenuItem(
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildTimeOption('Today'),
                                    _buildTimeOption('Yesterday'),
                                    _buildTimeOption('Last 7 days'),
                                    _buildTimeOption('This month'),
                                    _buildTimeOption('Custom range'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 5),
                          const CircleAvatar(
                            radius: 18,
                            backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=3'), // random avatar
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
          ),
        ],
      ),
    );
  }
}
