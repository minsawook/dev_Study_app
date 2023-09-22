import 'package:flutter/material.dart';

import '../common/enum.dart';

class TextView extends StatelessWidget {
  TextView({
    Key? key,
    @required this.txt,
    this.size,
    this.color,
    this.width,
    this.height,
    this.align,
    this.left,
    this.top,
    this.right,
    this.bottom,
    this.lineSpacing,
    this.letterSpacing,
    this.click,
    this.ignoreClick,
    this.disable,
    this.multiline,
    this.underline,
    this.isEllipsis,
    this.maxLen,
    this.isShortMode,
    this.fontWeight
  }) : super(key: key);
  String? txt = "";
  //폰트 사이즈
  double? size=5;
  //글씨 컬러
  Color? color = Colors.black;
  //위젯 넓이
  double? width = double.infinity;
  //위젯 높이
  double? height = double.infinity;
  //정렬
  Alignment? align;
  //패딩 값들
  double? left;
  double? top;
  double? right;
  double? bottom;
  //줄 간격
  double? lineSpacing;
  //글자 간격
  double? letterSpacing;
  //클릭 시 실행 함수
  Function(String txt)? click;
  //클릭 무시 유무
  bool? ignoreClick = true;
  //활성화 유무
  bool? disable;
  //단어 들어갈 자리 없을 시 줄넘김 사용 유무
  bool? multiline;
  //밑줄 사용 유무
  bool? underline;
  //글자 초과시 ...표현 사용 유무
  bool? isEllipsis;
  //최대 글자 수
  int? maxLen;
  //짧은 글 모드 실행 유무
  bool? isShortMode;

  FontWeight? fontWeight= FontWeight.w400;

  ///위젯 빌드
  @override
  Widget build(BuildContext context) {
    double pl = 0;
    if(left != null)pl = left!;
    double pt = 0;
    if(top != null)pt = top!;
    double pr = 0;
    if(right != null)pr = right!;
    double pb = 0;
    if(bottom != null)pb = bottom!;

    double lineSpace = 1.3;
    if(lineSpacing != null)lineSpace = lineSpacing!;

    double letterSpace = 0;
    if(letterSpacing != null)letterSpace = letterSpacing!;

    double textOpacity = 1;
    if(disable != null) {
      if(disable!)
      {
        textOpacity = 0.3;
      }
      else
      {
        textOpacity = 1;
      }
    }

    bool ignoreClickEvent = true;
    if(ignoreClick != null)
    {
      if(ignoreClick!)
      {
        ignoreClickEvent = ignoreClick!;
      }
      else
      {
        ignoreClickEvent = false;
      }
    }
    else
    {
      ignoreClickEvent = true;
    }
    //폰트타입

    TextStyle style = TextStyle(
        color: (color != null)?color:Colors.black,
        fontSize: (size != null)?size!:15,
        height: lineSpace,
        letterSpacing: letterSpace,
        decoration: (underline != null)?TextDecoration
            .underline:TextDecoration.none,
        fontWeight: fontWeight
    );

    return Container(
      width: (width != double.infinity)?width:double.infinity,
      height: (height != double.infinity)?height:double.infinity,
      alignment: align??Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(left:pl, top:pt, right:pr, bottom:pb),
        child: (!ignoreClickEvent)?GestureDetector(
          onTap: () {
            if(textOpacity < 1)return;
            if(click != null)
            {
              click!(txt!);
            }
          },
          child: getText(lineSpace, letterSpace, textOpacity, (multiline != null)?multiline!:true, style),
        ):getText(lineSpace, letterSpace, textOpacity, (multiline != null)?multiline!:true,  style),
      ),
    );
  }

  Widget getText(double lineSpace, double letterSpace, double opacity, bool multiLineMode, TextStyle textStyle) {
    //Log(">> multiLineMode : $multiLineMode");
    bool shortMode = isShortMode??false;
    //Log('>> shortMode : $shortMode');
    if(shortMode)
    {
      txt = '${txt!.substring(0, 6)}...${txt!.substring(txt!.length - 4, txt!.length)}';
    }
    return Opacity(
      opacity: opacity,
      child: Stack(
        children: [
          Text(
            txt!,
            textScaleFactor: 1.0,
            softWrap: multiLineMode,
            style: textStyle,
            maxLines: null,
            overflow: (isEllipsis != null)?TextOverflow.ellipsis:null,
          ),
        ],
      ),
    );
  }
}