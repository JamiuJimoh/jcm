import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jamiu_class_manager/common_widgets/show_exception_alert_dialog.dart';
import 'package:jamiu_class_manager/services/auth.dart';
import 'package:provider/provider.dart';

import 'email_sign_change_model.dart';
import 'form_submit_button.dart';
import 'sign_in_text_field.dart';
import 'social_sign_in_button.dart';

class EmailSignInForm extends StatefulWidget {
  EmailSignInForm({required this.model});
  final EmailSignInChangeModel model;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<EmailSignInChangeModel>(
      create: (_) => EmailSignInChangeModel(auth: auth),
      child: Consumer<EmailSignInChangeModel>(
        builder: (_, model, __) => EmailSignInForm(model: model),
      ),
    );
  }

  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  var _obscureText = true;
  var _isLoading = false;

  EmailSignInChangeModel get model => widget.model;

  Future<void> _submit() async {
    try {
      await model.submit();
    } on FirebaseAuthException catch (error) {
      showExceptionAlertDialog(
        context,
        title: 'Sign in failed',
        exception: error,
      );
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      if (model.formType == EmailSignInFormType.register &&
          model.userType == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Row(
            children: [
              Icon(Icons.warning, color: Colors.yellow),
              const SizedBox(width: 6.0),
              Text('Register as a teacher or a student'),
            ],
          )),
        );
      } else {
        await model.signInWithGoogle();
      }
    } on Exception catch (e) {
      _showSignInError(context, e);
    }
  }

  void _showSignInError(BuildContext context, Exception exception) {
    if (exception is FirebaseException &&
        exception.code == 'ERROR_ABORTED_BY_USER') {
      return;
    }
    showExceptionAlertDialog(
      context,
      title: 'Sign in failed',
      exception: exception,
    );
  }

  void _toggleFormType() {
    model.toggleFormType();

    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(model.userType);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: _buildForm(),
    );
  }

  List<Widget> _buildForm() {
    return <Widget>[
      SignInTextField(
        controller: _emailController,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.emailAddress,
        enabled: model.isLoading == false,
        onChanged: model.updateEmail,
        errorText: model.emailErrorText,
        labelText: 'Email',
        prefixIcon: Icon(Icons.email),
      ),
      const SizedBox(height: 10.0),
      SignInTextField(
        controller: _passwordController,
        // textInputAction: TextInputAction.next,
        keyboardType: TextInputType.visiblePassword,
        enabled: model.isLoading == false,
        onChanged: model.updatePassword,
        errorText: model.passwordErrorText,
        labelText: 'Password',
        prefixIcon: Icon(Icons.lock),
        suffixIcon: _buildPasswordFieldSuffixIcon(),
        obscureText: _obscureText,
      ),
      const SizedBox(height: 10.0),
      if (model.formType == EmailSignInFormType.register)
        SignInTextField(
          controller: _confirmPasswordController,
          // textInputAction: TextInputAction.done,
          keyboardType: TextInputType.visiblePassword,
          enabled: model.isLoading == false,
          onChanged: model.updateConfirmPassword,
          errorText: model.confirmPasswordErrorText,
          labelText: 'Confirm Password',
          prefixIcon: Icon(Icons.lock),
          suffixIcon: _buildPasswordFieldSuffixIcon(),
          obscureText: _obscureText,
        ),
      if (model.formType == EmailSignInFormType.register)
        const SizedBox(height: 15.0),
      if (model.formType == EmailSignInFormType.register)
        Text(
          'Register as a: ',
          style: Theme.of(context).textTheme.bodyText1,
        ),
      if (model.formType == EmailSignInFormType.register)
        const SizedBox(height: 10.0),
      if (model.formType == EmailSignInFormType.register)
        RadioListTile<UserType>(
          title: Text('Teacher'),
          value: UserType.teacher,
          groupValue: model.userType,
          onChanged: (user) {
            setState(() {
              model.userType = user;
            });
          },
        ),
      if (model.formType == EmailSignInFormType.register)
        RadioListTile<UserType>(
          title: Text('Student'),
          value: UserType.student,
          groupValue: model.userType,
          onChanged: (user) {
            setState(() {
              model.userType = user;
            });
          },
        ),
      const SizedBox(height: 20.0),
      FormSubmitButton(
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                    // backgroundColor: kWhiteColor,
                    ))
            : Text(
                model.primaryButtonText,
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
              ),
        onPressed: model.canSubmit ? _submit : null,
      ),
      const SizedBox(height: 15.0),
      GestureDetector(
        onTap: !model.isLoading ? _toggleFormType : null,
        child: Text(
          model.secondaryButtonText,
          style: Theme.of(context).textTheme.bodyText1?.copyWith(
                color: Theme.of(context).primaryColor,
              ),
          textAlign: TextAlign.center,
        ),
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
        assetName: 'assets/images/google-logo.png',
        text: Text(
          'Sign In With Google',
          style: Theme.of(context).textTheme.bodyText1?.copyWith(
                fontSize: 16.0,
              ),
        ),
        onPressed: () => _signInWithGoogle(context),
      ),
    ];
  }

  Widget _buildPasswordFieldSuffixIcon() {
    final icon = Icon(
      _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
    );
    return GestureDetector(
      child: icon,
      onTap: () {
        setState(() {
          _obscureText = !_obscureText;
        });
      },
    );
  }
}
