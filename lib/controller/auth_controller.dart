import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev_studygroup_app/scene/login/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../common/common.dart';

import '../component/loading.dart';
import '../model/study_group_model.dart';
import '../model/user_model.dart';
import '../scene/home/home.dart';

class AuthController extends GetxController{
  static AuthController instance = Get.find();
  late Rx<User?> _user;
  FirebaseAuth authentication = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var userModel = UserModel().obs;
  RxList studyGroupModelList = [].obs;

  @override
  void onReady(){
    super.onReady();
    _user = Rx<User?>(authentication.currentUser);
    _user.bindStream(authentication.userChanges());
    ever(_user, (callback) => _moveToPage);
  }

  initUser() async{
    CollectionReference user =  firestore.collection('users');
    final checkUser = await user.doc(authentication.currentUser!.email).get();
    if(checkUser.data() == null){
      await user.doc(authentication.currentUser!.email).set({
        "uid" : authentication.currentUser!.uid,
        "name" : authentication.currentUser!.email,
        "desc" : "",
        "email" : authentication.currentUser!.email,
        "profileUrl" : "",
        "creationTime" : authentication.currentUser!.metadata.creationTime!
            .toIso8601String(),
        "lastSignInTime" : authentication.currentUser!.metadata.lastSignInTime!
            .toIso8601String(),
        "updatedTime" : DateTime.now().toIso8601String(),
        //"chats": [],
      });

       user.doc(authentication.currentUser!.email).collection("chats");
    }
    else{
     await user.doc(authentication.currentUser!.email).update({
        "lastSignInTime" : authentication.currentUser!.metadata.lastSignInTime!
            .toIso8601String(),
      });
    }

    final currUser = await user.doc(authentication.currentUser!.email).get();
    final currUserData = currUser.data() as Map<String, dynamic>;

    userModel(UserModel.fromJson(currUserData));

    final listChat = await user.doc(authentication.currentUser!.email)
        .collection("chats").get();

    if(listChat.docs.length !=0){

      List<ChatUser> dataListChat = [];
      listChat.docs.forEach((element) {
        var dataDocChat = element.data();
        var dataDocChatId = element.id;
        dataListChat.add(ChatUser(
          chatId:  dataDocChatId,
          connection: dataDocChat["connection"],
          lastTime: dataDocChat["lastTime"],
          totalUnread: dataDocChat["totalUnread"],
          lastChat: dataDocChat["lastChat"]
        ));
      });
      userModel.update((user) {
        user!.chats = dataListChat;
      });
    }
    else{
      userModel.update((user) {
        user!.chats = [];
      });
    }

    userModel.refresh();

    await getStudyGroupModel();
    }

  _moveToPage(User? user)async{
    if(user != null && Common.autoLogin){
      await initUser();
      Get.offAll(Home());
    }
    else{
      Get.offAll(Login());
    }
  }

  void register(String email, password) async{
    try{
      final newUser = await authentication.createUserWithEmailAndPassword(
          email: email,
          password: password);
      if(newUser.user !=null){
        await initUser();
        Get.offAll(const Home());
      }
    }
    catch(e){
      print('error : ${e}');
    }
  }


  void login(String email, password, bool autoLogin) async {
    try {
      await authentication.signInWithEmailAndPassword(email: email, password: password);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isAutoLogin', autoLogin);

      await initUser();
      Get.offAll(const Home());
    } catch (e) {
      print(e);
      Get.snackbar(
        "로그인 실패",
        '이메일 혹은 패스워드를 다시 확인해 주세요',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }


  void logout(){
    authentication.signOut();
  }

  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    final UserCredential authResult =  await FirebaseAuth.instance
        .signInWithCredential(credential);

    if(authResult.user != null){
      await initUser();

      Get.offAll(const Home());
    }
  }

  void changeProfile(String name, String desc, var profileUrl){
    String date = DateTime.now().toIso8601String();
    CollectionReference user =  firestore.collection('users');



    user.doc(authentication.currentUser!.email).update({
      "name": name,
      "desc" : desc,
      "lastSignInTime" : authentication.currentUser!.metadata.lastSignInTime!
          .toIso8601String(),
      "updatedTIme" : date,
      "profileUrl" : profileUrl
    });

    userModel(UserModel(
      name : name,
      desc : desc,
      lastSignInTime: authentication.currentUser!.metadata.lastSignInTime!
          .toIso8601String(),
      updatedTime: date,
      profileUrl: profileUrl
    ));
  }


  Future<dynamic> getStudyGroupModel() async{
    studyGroupModelList.clear();

    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('studyGroup')
          .orderBy('createdAt', descending: true) // 'createdAt' 필드를 기준으로 역순으로 정렬
          .get();
      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        StudyGroup model = StudyGroup.fromJson(documentSnapshot.data() as Map<String,
            dynamic>);
        studyGroupModelList.add(model);
      }
    } catch(e) {
      print('Firebase 스터디 그룹 데이터 가져오기 실패: $e');
    }
  }


  Future<void> deleteImageUrl(url) async {
    try {
      if(url == "") return;
      // Firebase Storage 인스턴스를 가져옵니다.
      final FirebaseStorage storage = FirebaseStorage.instance;

      // 이미지 URL을 사용하여 이미지를 삭제합니다.
      await storage.refFromURL(url).delete();

      print('이미지 삭제 성공');
    } catch (error) {
      print('이미지 삭제 실패: $error');
    }
  }

  Future<String> getName(String email) async {
    String name = '';
    var data = await firestore
        .collection('users')
        .doc(email)
        .get();
    return data['name'];
  }
}