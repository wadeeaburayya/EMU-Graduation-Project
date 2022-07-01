// ignore_for_file: unused_field, prefer_const_constructors, deprecated_member_use, prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  AuthForm(
    this.submitFn,
    this.isLoading,
  );

  final bool isLoading;
  final void Function(
    String email,
    String password,
    String userName,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState?.save();
      widget.submitFn(
        _userEmail.trim(),
        _userPassword.trim(),
        _userName.trim(),
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: <Widget>[
      SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(
                  "https://ichef.bbci.co.uk/news/2048/cpsprodpb/D505/production/_115033545_gettyimages-1226314512.jpg",
                ),
                fit: BoxFit.cover),
          ),
        ),
      ),
      SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 100,
              width: 350,
              margin: EdgeInsets.only(bottom: 20.0),
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 60.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color.fromRGBO(0, 0, 0, 0.5),

                // ignore: prefer_const_literals_to_create_immutables
                // boxShadow: [
                //   BoxShadow(
                //     blurRadius: 8,
                //     color: Theme.of(context).accentColor,
                //     offset: Offset(0, 2),
                //   )
                // ],
              ),
              child: FittedBox(
                child: Text(
                  'SafeCircle',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 35,
                    fontFamily: 'Squid',
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
            // Container(
            //   decoration: BoxDecoration(
            //     gradient: LinearGradient(
            //       colors: [
            //         Color.fromRGBO(0, 155, 114, 1).withOpacity(0.5),
            //         Color.fromRGBO(255, 199, 89, 1).withOpacity(0.9),
            //       ],
            //       begin: Alignment.topLeft,
            //       end: Alignment.bottomRight,
            //       stops: [0, 1],
            //     ),
            //   ),
            // ),
            Card(
              margin: EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextFormField(
                          key: const ValueKey('email'),
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          enableSuggestions: false,
                          validator: (value) {
                            if (value.isEmpty || !value.contains('@')) {
                              return 'Please enter a valid email address.';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email address',
                          ),
                          onSaved: (value) {
                            _userEmail = value;
                          },
                        ),
                        if (!_isLogin)
                          TextFormField(
                            key: ValueKey('username'),
                            autocorrect: true,
                            textCapitalization: TextCapitalization.words,
                            enableSuggestions: false,
                            validator: (value) {
                              if (value.isEmpty || value.length < 4) {
                                return 'Please enter at least 4 characters';
                              }
                              return null;
                            },
                            decoration: InputDecoration(labelText: 'Username'),
                            onSaved: (value) {
                              _userName = value;
                            },
                          ),
                        TextFormField(
                          key: ValueKey('password'),
                          validator: (value) {
                            if (value.isEmpty || value.length < 7) {
                              return 'Password must be at least 7 characters long.';
                            }
                            return null;
                          },
                          decoration: InputDecoration(labelText: 'Password'),
                          obscureText: true,
                          onSaved: (value) {
                            _userPassword = value;
                          },
                        ),
                        SizedBox(height: 12),
                        if (widget.isLoading) CircularProgressIndicator(),
                        if (!widget.isLoading)
                          RaisedButton(
                            color: Colors.red,
                            child: Text(
                              _isLogin ? 'Login' : 'Signup',
                              style: TextStyle(fontFamily: "Squid"),
                            ),
                            onPressed: _trySubmit,
                          ),
                        if (!widget.isLoading)
                          FlatButton(
                            textColor: Colors.red,
                            child: Text(_isLogin
                                ? 'Create new account'
                                : 'I already have an account'),
                            onPressed: () {
                              setState(() {
                                _isLogin = !_isLogin;
                              });
                            },
                          )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}
