import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev_studygroup_app/model/study_group_model.dart';
import 'package:dev_studygroup_app/util/util.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

import '../auth_controller.dart';

class StudyInfoController extends GetxController{


  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  late Map<String,dynamic> model;
  num max= 0;
  num current = 0;

  void initModel(model){
    this.model = Util().convertStudyGroupToMap(model);

    for(var positionList in model['positionList']){
      max += positionList['max'];
      current += positionList['current'];
    };
  }

  Future<void> joinStudyGroup(String studyName, List<Map<String,dynamic>> data)
  async {
    CollectionReference studyGroup =  AuthController.instance.firestore
        .collection
      ('studyGroup');

    await studyGroup.doc(model['studyId']).update({
      "RequestJoin" : data
    });
    model['requestJoin'] = data;
  }

  String alreadyApplied(){

    if(model['member'].contains(AuthController.instance.authentication
        .currentUser!.email)) {
      return 'join';
    }
    else if(model['requestJoin'] != null){
      for(var requestJoin in model['requestJoin']!){
        if(requestJoin['email'] == AuthController.instance.authentication
            .currentUser!.email){
          return 'applied';
        }
      }
    }
    return 'none';
  }
  cancelJoin(String email) async{
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // 필드를 삭제할 문서의 참조 가져오기
    DocumentReference docRef = firestore.collection('studyGroup').doc
      (model['studyId']);

    // 현재 문서의 데이터 가져오기
    DocumentSnapshot docSnapshot = await docRef.get();

    // 데이터를 Map으로 변환
    Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;

    // RequestJoin 필드에서 인덱스 0의 요소를 삭제
    if (data.containsKey('RequestJoin') && data['RequestJoin'] is List) {
      List<dynamic> requestJoinList = data['RequestJoin'];
      if (requestJoinList.isNotEmpty) {
        int idx=0;
        for(var requestJoin in requestJoinList){
          if(requestJoin['email'] == email){
            break;
          }
          else {
            idx++;
          }
        }
        requestJoinList.removeAt(idx);
      }
    }

    await docRef.update(data);
    model = data;
    print(model['requestJoin'].length);
    update();
    await AuthController.instance.getStudyGroupModel();
    //Get.back();
  }

  addStudyMember(String email,String positionName) async {

    List<String> data = model['member'];
    data.add(email);

    List<Map<String,dynamic>> _positionList =  model['positionList'];

    int i = 0;
    for(var p in model['positionList']){
      if(p['positionName'] == positionName){
        _positionList[i]['current']++;
        break;
      }
      i++;
    }

    CollectionReference studyGroup =  AuthController.instance.firestore
        .collection
      ('studyGroup');

    await studyGroup.doc(model['studyId']).update({
      "member" : data,
      "positionList" : _positionList
    });
    current++;


    model['member'] = data;
    List<PositionList> p = [];
    for(int i =0; i<_positionList.length; i++){
      p.add(PositionList.fromJson(_positionList[i]));
    }
    model['positionList'] = _positionList;


    // chats에 사용자 추가
    CollectionReference chats =  AuthController.instance.firestore
        .collection('chats');

    await chats.doc(model['chatId']).update({
      "connection" : data,
    });

    //신규 유저 chats 갱신
    CollectionReference users =  AuthController.instance.firestore
        .collection('users')
        .doc(email).collection('chats');


    await users.doc(model['chatId']).set({
        "connection": model['groupName'],
        "chatId": model['chatId'],
        "lastTime": DateTime.now().toIso8601String(),
        "totalUnread" : 0,
        "lastChat" : "",
        "isRead" : false,
        "studyId" : model['studyId']
    });
    cancelJoin(email);
  }

  Future<void> removeGroup() async {
    AuthController.instance.deleteImageUrl(model['studyImg']);

    for(var data in model['member']){
      await deleteUserDocument(data,model['chatId']);
    }
    await deleteFolder('/chatImg/' + model['chatId']);
    await deleteChatDocument(model['chatId']);
    await deleteStudyDocument(model['studyId']);
    AuthController.instance.getStudyGroupModel();
    Get.back();

  }


  Future<void> deleteUserDocument(String memberName, String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(memberName)
          .collection('chats')
          .doc(documentId)
          .delete();
      print('문서 삭제 성공: $documentId');
    } catch (e) {
      print('문서 삭제 오류: $e');
    }
  }


  Future<void> deleteChatDocument(String documentId) async {
    final firestore = FirebaseFirestore.instance;

    await firestore
        .collection('chats')
        .doc(documentId)
        .collection('chat').get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) async {
        // 해당 컬렉션 내의 모든 문서 삭제
        await doc.reference.collection('chat').get().then((subcollectionQuery) {
          subcollectionQuery.docs.forEach((subDoc) async {
            await subDoc.reference.delete();
          });
        });

        // 문서 삭제
        await doc.reference.delete();
      });
    });

    await firestore
        .collection('chats')
        .doc(documentId)
        .delete();
  }

  Future<void> deleteStudyDocument(String documentId) async {
    try {
      print(documentId);
      await FirebaseFirestore.instance
          .collection('studyGroup')
          .doc(documentId)
          .delete();
      print('문서 삭제 성공: $documentId');
    } catch (e) {
      print('문서 삭제 오류: $e');
    }
  }

  Future<void> deleteFolder(String folderPath) async {
    final storage = FirebaseStorage.instance;

    if (folderPath == "") return;
    try{
      final ListResult listResult = await storage.ref(folderPath).list();
      for (final Reference item in listResult.items) {
        await item.delete();
      }
      await storage.ref(folderPath).delete();
      print('폴더 삭제 성공: $folderPath');
    }catch(e){
      print('폴더 삭제 실패: $e');
    }

  }

}