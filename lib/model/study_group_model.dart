class StudyGroup {
  String? groupName;
  String? desc;
  String? groupLeader;
  List<String>? member;
  String? studyImg;
  String? createdAt;
  List<PositionList>? positionList;
  List<RequestJoin>? requestJoin;
  String? chatId;
  String? studyId;
  StudyGroup(
      {this.groupName,
      this.desc,
      this.groupLeader,
      this.member,
      this.studyImg,
      this.createdAt,
      this.positionList,
      this.requestJoin,
      this.chatId,
      this.studyId});

  // [] 연산자 메서드 추가
  dynamic operator [](String key) {
    switch (key) {
      case 'groupName':
        return groupName;
      case 'desc':
        return desc;
      case 'groupLeader':
        return groupLeader;
      case 'member':
        return member;
      case 'studyImg':
        return studyImg;
      case 'positionList':
        return positionList;
      case 'createdAt' :
        return createdAt;
      case 'requestJoin':
        return requestJoin;
      case 'chatId':
        return chatId;
      case 'studyId':
        return studyId;
      default:
        throw ArgumentError('Invalid key: $key');
    }
  }

  StudyGroup.fromJson(Map<String, dynamic> json) {
    groupName = json['groupName'];
    desc = json['desc'];
    groupLeader = json['groupLeader'];
    member = json['member'].cast<String>();
    studyImg = json['studyImg'];
    createdAt = json['createdAt'];
    chatId = json['chatId'];
    studyId = json['studyId'];
    if (json['positionList'] != null) {
      positionList = <PositionList>[];
      json['positionList'].forEach((v) {
        positionList?.add(PositionList.fromJson(v));
      });
    }
    if (json['RequestJoin'] != null) {
      requestJoin = <RequestJoin>[];
      json['RequestJoin'].forEach((v) {
        requestJoin?.add(RequestJoin.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['groupName'] = groupName;
    data['desc'] = desc;
    data['groupLeader'] = groupLeader;
    data['member'] = member;
    data['studyImg'] = studyImg;
    data['createdAt'] = createdAt;
    data['chatId'] = chatId;
    data['studyId'] = studyId;
    if (positionList != null) {
      data['positionList'] = positionList?.map((v) => v.toJson()).toList();
    }
    if (requestJoin != null) {
      data['RequestJoin'] = requestJoin?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PositionList {
  String? positionName;
  int? max;
  int? current;

  PositionList({this.positionName, this.max, this.current});

  dynamic operator [](String key) {
    switch (key) {
      case 'positionName':
        return positionName;
      case 'max':
        return max;
      case 'current':
        return current;
      default:
        throw ArgumentError('Invalid key: $key');
    }
  }

  PositionList.fromJson(Map<String, dynamic> json) {
    positionName = json['positionName'];
    max = json['max'];
    current = json['current'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['position'] = positionName;
    data['max'] = max;
    data['current'] = current;
    return data;
  }
}

class RequestJoin {
  String? name;
  String? desc;
  String? positionName;
  String? profileUrl;
  String? email;

  RequestJoin(
      {this.name, this.desc, this.positionName, this.profileUrl,
        this.email});

  dynamic operator [](String key) {
    switch (key) {
      case 'name':
        return name;
      case 'desc':
        return desc;
      case 'positionName':
        return positionName;
      case 'profileUrl':
        return profileUrl;
      case 'email':
        return email;
      default:
        throw ArgumentError('Invalid key: $key');
    }
  }

  RequestJoin.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    desc = json['desc'];
    positionName = json['positionName'];
    profileUrl = json['profileUrl'];
    email = json['email'];
  }

   Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['desc'] = desc;
    data['position'] = positionName;
    data['profileUrl'] = profileUrl;
    data['email'] = email;
    return data;
  }
}
