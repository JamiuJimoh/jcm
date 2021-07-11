import 'package:flutter/material.dart';
import 'package:jamiu_class_manager/services/auth.dart';
import 'package:provider/provider.dart';

import 'course_container.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Courses'),
        actions: [
          Consumer<AuthBase>(
            builder: (_, auth, __) => IconButton(
              onPressed: auth.signOut,
              icon: Icon(Icons.logout),
            ),
          ),
        ],
      ),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('add course');
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CourseContainer(
              courseCode: Text(
                'CSC 401',
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 20.0,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
              courseTitle: Text(
                'AUTOMATA & DATA STRUCTURE',
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 20.0,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
              teacherName: Text(
                'DR. JAMIU O. JIMOH',
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 15.0,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
              onPressed: () {
                print('hello');
              },
            ),
            const SizedBox(height: 10.0),
            CourseContainer(
              courseCode: Text(
                'CSC 401',
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 20.0,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
              courseTitle: Text(
                'AUTOMATA & DATA STRUCTURE',
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 20.0,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
              teacherName: Text(
                'DR. JAMIU O. JIMOH',
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 15.0,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
              onPressed: () {
                print('hello');
              },
            ),
            const SizedBox(height: 10.0),
            CourseContainer(
              courseCode: Text(
                'CSC 401',
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 20.0,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
              courseTitle: Text(
                'AUTOMATA & DATA STRUCTURE',
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 20.0,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
              teacherName: Text(
                'DR. JAMIU O. JIMOH',
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 15.0,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
              onPressed: () {
                print('hello');
              },
            ),
            const SizedBox(height: 10.0),
            CourseContainer(
              courseCode: Text(
                'CSC 401',
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 20.0,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
              courseTitle: Text(
                'AUTOMATA & DATA STRUCTURE',
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 20.0,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
              teacherName: Text(
                'DR. JAMIU O. JIMOH',
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 15.0,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
              onPressed: () {
                print('hello');
              },
            ),
            const SizedBox(height: 10.0),
            CourseContainer(
              courseCode: Text(
                'CSC 401',
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 20.0,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
              courseTitle: Text(
                'AUTOMATA & DATA STRUCTURE',
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 20.0,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
              teacherName: Text(
                'DR. JAMIU O. JIMOH',
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 15.0,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
              onPressed: () {
                print('hello');
              },
            ),
            const SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
}
