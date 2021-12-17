import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import '../../../../common_widgets/user_circle_avatar.dart';
import '../../../../services/auth.dart';
import '../../../../services/database.dart';
import '../../list_items_builder.dart';
import '../../models/user_classroom.dart';
import '../share_with_class_container.dart';
import 'add_comment_page.dart';
import 'class_convo_bloc.dart';
import 'edit_classroom_convo_page.dart';
import 'message_container.dart';

class ClassroomWidget extends StatelessWidget {
  const ClassroomWidget(
      {Key? key,
      required this.courseID,
      required this.auth,
      required this.bloc})
      : super(key: key);
      
  final String courseID;
  final AuthBase auth;
  final ClassConvoBloc bloc;

  static Widget create(context, {required String courseID}) {
    final auth = Provider.of<AuthBase>(context, listen: false);

    return Provider<Database>(
      create: (_) => FireStoreDatabase(uid: auth.currentUser!.uid),
      child: Consumer<Database>(
        builder: (_, database, __) => Provider<ClassConvoBloc>(
          create: (_) => ClassConvoBloc(database: database),
          child: Consumer<ClassConvoBloc>(
            builder: (_, bloc, __) =>
                ClassroomWidget(courseID: courseID, auth: auth, bloc: bloc),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('pt_BR', null);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Column(
        children: [
          ShareWithClassContainer(
            borderColor: Theme.of(context).primaryColor,
            child: Row(
              children: [
                UserCircleAvatar(),
                const SizedBox(width: 15.0),
                Text(
                  'Share with the class...',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      ?.copyWith(fontSize: 14.0),
                ),
              ],
            ),
            onPressed: () =>
                EditClassroomConvoPage.show(context, courseID: courseID),
          ),
          ..._buildDivider(),
          StreamBuilder<List<UserClassroom>>(
              stream: bloc.userClassroomStreamCombiner(courseID),
              builder: (context, snapshot) {
                return Expanded(
                  child: ListItemsBuilder<UserClassroom>(
                    snapshot: snapshot,
                    emptyStateTitle: 'Class is silent',
                    emptyStateMessage: 'Start a conversation',
                    itemBuilder: (_, userClassroom) => Column(
                      children: [
                        MessageContainer(
                          context,
                          sender:
                              '${userClassroom.userProfile?.name} ${userClassroom.userProfile?.surname}',
                          message: userClassroom.classroom.message,
                          borderColor: Theme.of(context).primaryColor,
                          time: userClassroom.classroom.createdAt,
                          leadingAvatar: UserCircleAvatar(
                              imageUrl: userClassroom.userProfile?.imageUrl),
                          onPressed: () => AddCommentPage.show(
                            context,
                            userClassroom: userClassroom,
                          ),
                        ),
                        const SizedBox(height: 20.0),
                      ],
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }

  List<Widget> _buildDivider() {
    return [
      const SizedBox(height: 10.0),
      const Divider(
        thickness: 0.7,
      ),
      const SizedBox(height: 10.0),
    ];
  }
}
