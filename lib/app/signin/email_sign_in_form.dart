import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jamiu_class_manager/common_widgets/show_exception_alert_dialog.dart';
import 'package:jamiu_class_manager/services/auth.dart';
import 'package:jamiu_class_manager/services/database.dart';
import 'package:provider/provider.dart';

import '../landing_page.dart';
import 'email_sign_change_model.dart';
import 'form_submit_button.dart';
import 'sign_in_text_field.dart';

class EmailSignInForm extends StatefulWidget {
  EmailSignInForm({required this.model, required this.database});
  final EmailSignInChangeModel model;
  final Database database;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Provider<Database>(
      create: (_) => FireStoreDatabase(uid: auth.currentUser?.uid),
      child: Consumer<Database>(
        builder: (_, database, __) =>
            ChangeNotifierProvider<EmailSignInChangeModel>(
          create: (_) => EmailSignInChangeModel(auth: auth, database: database),
          child: Consumer<EmailSignInChangeModel>(
            builder: (_, model, __) => EmailSignInForm(
              model: model,
              database: database,
            ),
          ),
        ),
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
      setState(() {
        _isLoading = true;
      });
      await model.submit();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => LandingPage()),
      );
      setState(() {
        _isLoading = false;
      });
    } on Exception catch (error) {
      showExceptionAlertDialog(
        context,
        title: 'Sign in failed',
        exception: error,
      );
      setState(() {
        _isLoading = false;
      });
    }
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
      const SizedBox(height: 20.0),
      FormSubmitButton(
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                ),
              )
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
