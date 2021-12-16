import 'package:jamiu_class_manager/app/home/models/classroom_convo_thread.dart';

import 'user_profile.dart';

class UserThread {
  final ClassroomConvoThread thread;
  final UserProfile? userProfile;

  UserThread({required this.thread, required this.userProfile});
}
