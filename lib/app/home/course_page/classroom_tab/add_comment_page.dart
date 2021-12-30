import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../common_widgets/user_circle_avatar.dart';
import '../../../../services/auth.dart';
import '../../../../services/database.dart';
import '../../../utils/format_date.dart';
import '../../list_items_builder.dart';
import '../../models/classroom_convo_thread.dart';
import '../../models/user_classroom.dart';
import '../../models/user_thread.dart';
import 'build_bottom_textfield.dart';
import 'class_convo_bloc.dart';

class AddCommentPage extends StatelessWidget {
  const AddCommentPage({
    Key? key,
    required this.userClassroom,
    required this.thread,
    required this.database,
    required this.bloc,
    required this.auth,
  }) : super(key: key);
  final UserClassroom userClassroom;
  final ClassroomConvoThread? thread;
  final Database database;
  final ClassConvoBloc bloc;
  final AuthBase auth;

  static Future<void> show(
    BuildContext context, {
    required UserClassroom userClassroom,
    ClassroomConvoThread? thread,
  }) async {
    final auth = Provider.of<AuthBase>(context, listen: false);

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Provider<Database>(
          create: (_) =>
              FireStoreDatabase(uid: userClassroom.userProfile!.userID),
          child: Consumer<Database>(
            builder: (_, database, __) => Provider<ClassConvoBloc>(
              create: (_) => ClassConvoBloc(database: database),
              child: Consumer<ClassConvoBloc>(
                builder: (_, bloc, __) => AddCommentPage(
                  userClassroom: userClassroom,
                  thread: thread,
                  database: database,
                  bloc: bloc,
                  auth: auth,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(child: _buildBody(context)),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  dense: true,
                  contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
                  title: Text(
                    '${userClassroom.userProfile?.name} ${userClassroom.userProfile?.surname}',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.copyWith(fontSize: 16.0),
                  ),
                  subtitle: Row(
                    children: [
                      Text(
                        FormatDate.getDate(userClassroom.classroom.createdAt),
                      ),
                    ],
                  ),
                  leading: UserCircleAvatar(
                    imageUrl: userClassroom.userProfile?.imageUrl,
                    radius: 35.0,
                  ),
                ),
                ..._buildDivider(),
                Text(
                  userClassroom.classroom.message,
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 17.0,
                      ),
                ),
                const SizedBox(height: 45.0),
                ..._buildDivider(),
                const Text('Class Comments'),
                const SizedBox(height: 10.0),
                StreamBuilder<List<UserThread>>(
                    stream: bloc.userThreadStreamCombiner(
                        userClassroom.classroom.classroomID),
                    builder: (context, snapshot) {
                      return Expanded(
                        child: ListItemsBuilder<UserThread>(
                          reverseList: false,
                          snapshot: snapshot,
                          emptyStateTitle: 'Thread is silent',
                          emptyStateMessage: 'Start the discussion',
                          itemBuilder: (_, userThread) => Column(
                            children: [
                              ListTile(
                                leading: UserCircleAvatar(
                                  imageUrl: userThread.userProfile?.imageUrl,
                                ),
                                title: Text(
                                  '${userThread.userProfile?.name} ${userThread.userProfile?.surname}',
                                  style: const TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w600),
                                ),
                                subtitle: Text(userThread.thread.message),
                                trailing: Text(
                                  FormatDate.getDate(
                                      userThread.thread.createdAt),
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10.0),
                            ],
                          ),
                        ),
                      );
                    }),
              ],
            ),
          ),
        ),
        BuildBottomTextField(
          thread: thread,
          uid: auth.currentUser!.uid,
          classroomID: userClassroom.classroom.classroomID,
          database: database,
        ),
      ],
    );
  }

  List<Widget> _buildDivider() {
    return [
      const SizedBox(height: 5.0),
      const Divider(
        thickness: 1.0,
      ),
      const SizedBox(height: 10.0),
    ];
  }
}
