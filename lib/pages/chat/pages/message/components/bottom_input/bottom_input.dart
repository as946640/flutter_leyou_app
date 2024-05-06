import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mall_community/common/app_config.dart';
import 'package:mall_community/common/comm_style.dart';
import 'package:mall_community/components/button/button.dart';
import 'package:mall_community/components/emoji_icon/icon_svg.dart';
import 'package:mall_community/components/text_field_custom/field_custom.dart';
import 'package:mall_community/components/text_field_custom/custom_field_module.dart';
import 'package:mall_community/pages/chat/controller/chat_controller.dart';
import 'package:mall_community/pages/chat/pages/message/components/bottom_input/bottom_menu.dart';
import 'package:mall_community/mixn/key_board_visible_mixn.dart';
import 'package:mall_community/pages/chat/pages/message/components/msg_type_widget/quote_pop.dart';
import 'package:mall_community/pages/chat/pages/message/components/bottom_input/sound_input.dart';

/// 页面底部菜单切换类型
/// hide 关闭菜单
/// more 更多
/// emjoi 表情
/// key 切换到键盘关闭菜单
enum MenuTypes { hide, more, emoji, key }

/// 聊天页面底部输入框
class MsgBotInput extends StatefulWidget {
  const MsgBotInput({super.key});

  @override
  State<MsgBotInput> createState() => _MsgBotInputState();
}

class _MsgBotInputState extends State<MsgBotInput>
    with WidgetsBindingObserver, KeyboardVisibilityMixin {
  final ChatController chatController = Get.find();
  bool showkeyBoard = false;
  double baseHeight = 60.h;
  double menuHeight = 260.h;

  /// 底部动画时间 0的时候不需要动画
  int animatedDuration = 0;

  ///输入内容
  String message = '';
  setMessage(String tx) {
    setState(() {
      message = tx;
    });
    // 动态获取输入框高度
    if (showkeyBoard) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        animatedDuration = 240;
        double inputHeight = MsgBotInputModule.getInputHeight();
        double keyHeight = keyboardHeight + 36.h + inputHeight;
        if (keyHeight != bottomHeight) {
          setState(() {
            bottomHeight = keyHeight;
          });
        }
      });
    }
  }

  /// 文字输入还是语音？
  bool isText = true;
  setInputType(bool type) {
    setState(() {
      isText = type;
    });
  }

  /// 键盘高度
  double keyboardHeight = 0.0;

  /// 底部总体高度
  double bottomHeight = 60.h + ScreenUtil().bottomBarHeight;

  /// 菜单类型 0不显示 1菜单 2表情
  MenuTypes menuType = MenuTypes.hide;
  setMenuType(MenuTypes type) {
    if (type == MenuTypes.key) {
      chatController.textFocusNode.requestFocus();
      return;
    }
    animatedDuration = 200;
    if (type == menuType || type == MenuTypes.hide) {
      setState(() {
        menuType = MenuTypes.hide;
        bottomHeight = baseHeight + ScreenUtil().bottomBarHeight;
      });
      return;
    }
    setState(() {
      showkeyBoard = false;
      menuType = type;
      bottomHeight = baseHeight + menuHeight + ScreenUtil().bottomBarHeight;
    });
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  // 监听窗口高度变化设置高度
  setHeight() {
    keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    double height = baseHeight + keyboardHeight;
    animatedDuration = 0;
    menuType = MenuTypes.hide;

    /// 如果当前底部高度 > 键盘高度 就不设置
    /// 如果发现动态切换键盘高度变小了的话 就要去掉这里
    if (bottomHeight > height) return;
    bottomHeight = height;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        QuotePop(),
        AnimatedContainer(
          duration: Duration(milliseconds: animatedDuration),
          curve: Curves.easeInOut,
          height: bottomHeight,
          padding: EdgeInsets.only(bottom: ScreenUtil().bottomBarHeight),
          onEnd: () {
            if (showkeyBoard || menuType != MenuTypes.hide) {
              chatController.toBottom();
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isText
                  ? MsgInput(
                      message: message,
                      setMessage: setMessage,
                      chatController: chatController,
                      setMenuType: setMenuType,
                      setInputType: setInputType,
                      menuType: menuType,
                      showkeyBoard: showkeyBoard,
                    )
                  : SoundInput(
                      chatController: chatController,
                      setInputType: setInputType),
              if (menuType == MenuTypes.more) ChatBottomMenu(),
              if (menuType == MenuTypes.emoji)
                EmojiList(message: message, setText: setMessage)
            ],
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void onKeyboardVisibilityChanged(bool isKeyBoard) {
    showkeyBoard = isKeyBoard;
    if (!isKeyBoard) {
      if (AppConfig.keyBoardHeight < 100) {
        AppConfig.keyBoardHeight = keyboardHeight;
      }
      if (menuType == MenuTypes.hide) {
        setState(() {
          bottomHeight = 60.h + ScreenUtil().bottomBarHeight;
        });
      }
    }
  }

  @override
  void didChangeMetrics() {
    /// 这里只处理键盘出现，不处理键盘消失，避免性能浪费
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 组件激活并且键盘显示并且高度大于0
      if (mounted &&
          MediaQuery.of(context).viewInsets.bottom != 0 &&
          showkeyBoard) {
        // 本机是否缓存了键盘高度
        if (showkeyBoard && AppConfig.keyBoardHeight > 200) {
          //  针对键盘出现后 切换键盘类型导致高度二次变化
          if (keyboardHeight != MediaQuery.of(context).viewInsets.bottom) {
            setHeight();
          }
          return;
        }
        setHeight();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}

/// 好友聊天底部输入框 widget
class MsgInput extends StatefulWidget {
  const MsgInput({
    super.key,
    required this.message,
    required this.menuType,
    required this.showkeyBoard,
    required this.chatController,
    required this.setMenuType,
    required this.setInputType,
    required this.setMessage,
  });

  final String message;
  final MenuTypes menuType;
  final bool showkeyBoard;
  final ChatController chatController;
  final Function setMenuType;
  final Function setMessage;
  final Function setInputType;

  @override
  State<MsgInput> createState() => _MsgInputState();
}

class _MsgInputState extends State<MsgInput> {
  /// 发送消息
  sendMsg() {
    if (widget.message.isEmpty) return;
    widget.chatController.createTextMsg(widget.message);
    CustomFieldModule.controller.clear();
    Future.delayed(Duration.zero, () {
      widget.setMessage('');
    });
  }

  setType(showKeyIcon) {
    widget.setMenuType(showKeyIcon ? MenuTypes.key : MenuTypes.emoji);
    if (!showKeyIcon) {
      SystemChannels.textInput.invokeMethod("TextInput.hide");
    }
  }

  @override
  void initState() {
    CustomFieldModule.controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool showKeyIcon =
        !widget.showkeyBoard && widget.menuType == MenuTypes.emoji;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      constraints: BoxConstraints(maxHeight: 120.h, minHeight: 48.h),
      padding: EdgeInsets.only(right: 10.w),
      decoration: BoxDecoration(
        color: HexThemColor(cF1f1f1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          InkWell(
            onTap: () {
              widget.setInputType(false);
            },
            child: SizedBox(
              height: 48.h,
              width: 40.w,
              child: const Icon(
                IconData(0xe68d, fontFamily: 'micon'),
                size: 30,
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(
                bottom: 12.h,
                left: 4.w,
              ),
              child: FieldCustom(
                controller: CustomFieldModule.controller,
                focusNode: widget.chatController.textFocusNode,
                change: (t) {
                  widget.setMessage(t);
                },
              ),
            ),
          ),
          InkWell(
            onTap: () {
              setType(showKeyIcon);
            },
            child: SizedBox(
              height: 48.h,
              width: 40.w,
              child: showKeyIcon
                  ? const Icon(
                      IconData(0xe706, fontFamily: 'micon'),
                      size: 34,
                    )
                  : const Icon(
                      IconData(0xe644, fontFamily: 'micon'),
                      size: 26,
                    ),
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(seconds: 1),
            child: getButton(),
            layoutBuilder: (currentChild, previousChildren) {
              return getButton();
            },
          ),
          // SendButton(tx: tx, sendMsg: sendMsg, setType: setMenuType),
        ],
      ),
    );
  }

  Widget getButton() {
    if (widget.message == '') {
      return InkWell(
        onTap: () {
          widget.setMenuType(MenuTypes.more);
        },
        child: SizedBox(
          height: 48.h,
          width: 40.w,
          child: const Icon(
            IconData(0xe626, fontFamily: 'micon'),
            size: 28,
          ),
        ),
      );
    }
    return Container(
      width: 50.w,
      height: 30.h,
      margin: EdgeInsets.only(bottom: 9.h),
      child: Button(
        text: '',
        radius: 20,
        icon: const Icon(IconData(0xe652, fontFamily: 'micon')),
        borderColor: Colors.transparent,
        onPressed: () {
          sendMsg();
        },
      ),
    );
  }

  @override
  void dispose() {
    CustomFieldModule.controller.dispose();
    super.dispose();
  }
}

/// 表情列表
class EmojiList extends StatelessWidget {
  const EmojiList({super.key, required this.message, required this.setText});
  final String message;
  final Function setText;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
            ),
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  CustomFieldModule.insertText('[${svgIcons[index]['name']}]');
                  setText('$message[${svgIcons[index]['name']}]');
                },
                child: AlIconSvg(
                  name: svgIcons[index]['name'],
                ),
              );
            },
            itemCount: svgIcons.length,
            padding: const EdgeInsets.all(5.0),
          ),
          Positioned(
            right: 10.w,
            bottom: 20.h,
            child: InkWell(
              onTap: () {
                CustomFieldModule.manualDelete();
                setText(CustomFieldModule.controller.text);
              },
              child: Container(
                width: 60.w,
                height: 50.h,
                decoration: BoxDecoration(
                  color: HexThemColor(cF1f1f1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.keyboard_double_arrow_left_rounded,
                  size: 40,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

///页面底部组件公共方法暴露
///比如滚动的时候关闭底部菜单，如果菜单打开的话
class MsgBotInputModule {
  static GlobalKey bottomKey = GlobalKey();

  // 关闭当前菜单或者输入框
  static hideBootoMenu() {
    SystemChannels.textInput.invokeMethod("TextInput.hide");
    _MsgBotInputState? page = bottomKey.currentState as _MsgBotInputState;
    page.setMenuType(MenuTypes.hide);
  }

  // 获取当前输入框的高度
  static double getInputHeight() {
    final RenderBox input =
        CustomFieldModule.key.currentContext!.findRenderObject() as dynamic;
    return input.size.height;
  }
}
