import 'package:flutter/material.dart';

import 'form_submit_button.dart';
import 'sign_in_text_field.dart';
import 'social_sign_in_button.dart';

enum User { teacher, student }

class EmailSignInForm extends StatefulWidget {
  const EmailSignInForm({Key? key}) : super(key: key);

  static Widget create(BuildContext context) {
    return EmailSignInForm();
  }

  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  User? _user;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SignInTextField(
          labelText: 'Full Name',
          prefixIcon: Icon(Icons.person),
        ),
        const SizedBox(height: 10.0),
        SignInTextField(
          labelText: 'Email',
          prefixIcon: Icon(Icons.email),
        ),
        const SizedBox(height: 10.0),
        SignInTextField(
          labelText: 'Password',
          prefixIcon: Icon(Icons.lock),
          obscureText: true,
        ),
        const SizedBox(height: 10.0),
        SignInTextField(
          labelText: 'Confirm Password',
          prefixIcon: Icon(Icons.lock),
          obscureText: true,
        ),
        const SizedBox(height: 15.0),
        Text(
          'Register as a: ',
          style: Theme.of(context).textTheme.bodyText1,
        ),
        const SizedBox(height: 10.0),
        RadioListTile<User>(
          title: Text('Teacher'),
          value: User.teacher,
          groupValue: _user,
          onChanged: (user) {
            setState(() {
              _user = user;
            });
          },
        ),
        RadioListTile<User>(
          title: Text('Student'),
          value: User.student,
          groupValue: _user,
          onChanged: (user) {
            setState(() {
              _user = user;
            });
          },
        ),
        const SizedBox(height: 20.0),
        FormSubmitButton(
          child: Text(
            'Sign Up',
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  fontSize: 16.0,
                  color: Colors.white,
                ),
          ),
          onPressed: () {},
        ),
        const SizedBox(height: 20.0),
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Row(
            children: [
              Expanded(
                child: Divider(
                  height: 1.5,
                  indent: 10.0,
                  thickness: 1.1,
                  color: Theme.of(context).dividerColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'OR',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              Expanded(
                child: Divider(
                  endIndent: 10.0,
                  height: 1.5,
                  thickness: 1.1,
                  color: Theme.of(context).dividerColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15.0),
        SocialSignInButton(
          text: Text(
            'Sign In With Google',
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  fontSize: 16.0,
                ),
          ),
          onPressed: () => print('sign in'),
        ),
      ],
    );
  }
}
