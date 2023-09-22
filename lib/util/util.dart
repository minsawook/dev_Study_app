import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/study_group_model.dart';
import 'package:intl/intl.dart';
class globalPadding extends StatefulWidget {

  globalPadding({super.key, required this.child, this.bottonPadding
  ,this.leftPadding, this.rightPadding,this.topPadding, this.backColor});

  final Widget child;
  double? bottonPadding;
  double? topPadding;
  double? leftPadding;
  double? rightPadding;
  bool? backColor = false;
  @override
  State<globalPadding> createState() => _globalPaddingState();
}

class _globalPaddingState extends State<globalPadding> {

  bool backColor = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    backColor = widget.backColor?? false;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: backColor? Colors.transparent : Colors.white,
      child: Padding(padding: EdgeInsets.only(top: widget.topPadding??5,
          left: widget.leftPadding??15,right: widget.rightPadding??15,bottom:
      widget.bottonPadding??5),
   child:widget.child
   ),
    );
  }
}

class Util {

  List<Map<String, dynamic>> convertStudyGroupListToMapList(List<StudyGroup> studyGroups) {
    List<Map<String, dynamic>> mapList = [];

    for (StudyGroup group in studyGroups) {
      Map<String, dynamic> groupMap = {
        'groupName': group['groupName'],
        'desc': group['desc'],
        'groupLeader': group['groupLeader'],
        'member': group['member'],
        'studyImg': group['studyImg'],
        'createdAt': group['createdAt'],
        'chatId' : group["chatId"]
      };

      // positionList를 변환하여 추가
      List<Map<String, dynamic>> positionList = [];
      for (PositionList position in group['positionList']) {
        Map<String, dynamic> positionMap = {
          'positionName': position['positionName'],
          'max': position['max'],
          'current': position['current'],
        };
        positionList.add(positionMap);
      }
      groupMap['positionList'] = positionList;

      // requestJoin을 변환하여 추가
      List<Map<String, dynamic>> requestJoinList = [];
      for (RequestJoin request in group['requestJoin']) {
        Map<String, dynamic> requestMap = {
          'name': request['name'],
          'desc': request['desc'],
          'positionName': request['positionName'],
          'profileUrl': request['profileUrl'],
          'email': request['email'],
        };
        requestJoinList.add(requestMap);
      }
      groupMap['requestJoin'] = requestJoinList;

      mapList.add(groupMap);
    }

    return mapList;
  }

  StudyGroup convertMapToStudyGroup(Map<String, dynamic> data) {
    List<PositionList> positionList = [];
    for (Map<String, dynamic> positionMap in data['positionList']) {
      PositionList position = PositionList(
        positionName: positionMap['positionName'],
        max: positionMap['max'],
        current: positionMap['current'],
      );
      positionList.add(position);
    }

    List<RequestJoin> requestJoin = [];
    for (Map<String, dynamic> requestMap in data['requestJoin']) {
      RequestJoin request = RequestJoin(
        name: requestMap['name'],
        desc: requestMap['desc'],
        positionName: requestMap['positionName'],
        profileUrl: requestMap['profileUrl'],
        email: requestMap['email'],
      );
      requestJoin.add(request);
    }

    return StudyGroup(
      groupName: data['groupName'],
      desc: data['desc'],
      groupLeader: data['groupLeader'],
      member: List<String>.from(data['member']),
      studyImg: data['studyImg'],
      createdAt: data['createdAt'],
      positionList: positionList,
      requestJoin: requestJoin,
      chatId: data['chatId']
    );
  }

   Map<String, dynamic> convertStudyGroupToMap(StudyGroup studyGroup) {
    List<Map<String, dynamic>> positionList = [];
    for (PositionList position in studyGroup.positionList ?? []) {
      Map<String, dynamic> positionMap = {
        'positionName': position.positionName,
        'max': position.max,
        'current': position.current,
      };
      positionList.add(positionMap);
    }

    List<Map<String, dynamic>> requestJoinList = [];
    for (RequestJoin requestJoin in studyGroup.requestJoin ?? []) {
      Map<String, dynamic> requestJoinMap = {
        'name': requestJoin.name,
        'desc': requestJoin.desc,
        'positionName': requestJoin.positionName,
        'profileUrl': requestJoin.profileUrl,
        'email': requestJoin.email,
      };
      requestJoinList.add(requestJoinMap);
    }

    Map<String, dynamic> studyGroupMap = {
      'groupName': studyGroup.groupName,
      'desc': studyGroup.desc,
      'groupLeader': studyGroup.groupLeader,
      'member': studyGroup.member ?? [],
      'studyImg': studyGroup.studyImg,
      'createdAt': studyGroup.createdAt,
      'positionList': positionList,
      'requestJoin': requestJoinList,
      'chatId' : studyGroup.chatId,
      'studyId' : studyGroup.studyId
    };

    return studyGroupMap;
  }

  String getTimeDifference(String iso8601Time) {
    DateTime currentTime = DateTime.now();
    DateTime parsedTime = DateTime.parse(iso8601Time);
    Duration difference = currentTime.difference(parsedTime);

    if (difference.inMinutes < 1) {
      return '1분이내';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}분전';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}시간전';
    } else if (difference.inDays <= 365) {
      return  DateFormat('MM-dd').format(currentTime);
    } else if (difference.inDays > 365) {
      return DateFormat('yy-MM-dd').format(currentTime);
    } else {
      return "";
    }
  }

  String timeToMessege(String iso8601Time) {
    try {
      final dateTime = DateTime.parse(iso8601Time);
      final formattedTime = DateFormat('h:mm a').format(dateTime);
      return formattedTime;
    } catch (e) {
      return 'Invalid Time';
    }
  }

  String timeToCommunity(String iso8601Time){
    try {
      final dateTime = DateTime.parse(iso8601Time);
      final formattedTime = DateFormat('yyyy.MM.d').format(dateTime);
      return formattedTime;
    } catch (e) {
      return 'Invalid Time';
    }
  }
}
