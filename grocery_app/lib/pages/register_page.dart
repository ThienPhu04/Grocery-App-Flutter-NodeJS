import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/api/api_service.dart';
import 'package:grocery_app/config.dart';
import 'package:http/http.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  static final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  bool isAsyncCallProcess = false;
  String? fullName;
  String? password;
  String? confirmPassword;
  String? email;
  bool hidePassword = true;
  bool hideconfirmPassword = true;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ProgressHUD(
          child: Form(
            key: globalKey,
            child: _regitserUI(context),
          ), // Form
          inAsyncCall: isAsyncCallProcess,
          opacity: .3,
          key: UniqueKey(),
        ), // ProgressHUD
      ),
    );
  }

  Widget _regitserUI(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/images/pic1.png",
                  fit: BoxFit.contain,
                  width: 150,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Grocery App",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                ),
              )
            ],
          ),
          const Center(
            child: Text(
              "Register",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.deepOrangeAccent),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          //FullName
          FormHelper.inputFieldWidget(
            context,
            "fullName",
            "Full Name",
            (onValidate) {
              if (onValidate.isEmpty) {
                return "* Require";
              }

              return null;
            },
            (onSaved) {
              fullName = onSaved.toString().trim();
            },
            showPrefixIcon: true,
            prefixIcon: Icon(Icons.face),
            borderRadius: 10,
            contentPadding: 15,
            fontSize: 14,
            prefixIconPaddingLeft: 10,
            borderColor: Colors.grey.shade400,
            textColor: Colors.black,
            prefixIconColor: Colors.black,
            hintColor: Colors.black.withOpacity(0.6),
            backgroundColor: Colors.grey.shade100,
            borderFocusColor: Colors.grey.shade200,
          ),
          const SizedBox(
            height: 10,
          ),
          //Email
          FormHelper.inputFieldWidget(
            context,
            "email",
            "Email",
            (onValidate) {
              if (onValidate.isEmpty) {
                return "* Require";
              }

              bool emailValid =
                  RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                      .hasMatch(onValidate);

              if (!emailValid) {
                return "!Invalid Email";
              }

              return null;
            },
            (onSaved) {
              email = onSaved.toString().trim();
            },
            showPrefixIcon: true,
            prefixIcon: Icon(Icons.email_outlined),
            borderRadius: 10,
            contentPadding: 15,
            fontSize: 14,
            prefixIconPaddingLeft: 10,
            borderColor: Colors.grey.shade400,
            textColor: Colors.black,
            prefixIconColor: Colors.black,
            hintColor: Colors.black.withOpacity(0.6),
            backgroundColor: Colors.grey.shade100,
            borderFocusColor: Colors.grey.shade200,
          ),
          const SizedBox(
            height: 10,
          ),
          //Password
          FormHelper.inputFieldWidget(
              context,
              "password",
              "Pass Word",
              (onValidate) {
                if (onValidate.isEmpty) {
                  return "* Require";
                }

                return null;
              },
              (onSaved) {
                password = onSaved.toString().trim();
              },
              showPrefixIcon: true,
              prefixIcon: Icon(Icons.password_outlined),
              borderRadius: 10,
              contentPadding: 15,
              fontSize: 14,
              prefixIconPaddingLeft: 10,
              borderColor: Colors.grey.shade400,
              textColor: Colors.black,
              prefixIconColor: Colors.black,
              hintColor: Colors.black.withOpacity(0.6),
              backgroundColor: Colors.grey.shade100,
              borderFocusColor: Colors.grey.shade200,
              obscureText: hidePassword,
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    hidePassword = !hidePassword;
                  });
                },
                color: Colors.red,
                icon: Icon(
                    hidePassword ? Icons.visibility_off : Icons.visibility),
              ),
              onChange: (val) {
                password = val;
              }),
          const SizedBox(
            height: 10,
          ),
          //confirm pass word
          FormHelper.inputFieldWidget(
            context,
            "confirmpassword",
            "Confirm Pass Word",
            (onValidate) {
              if (onValidate.isEmpty) {
                return "* Require";
              }

              if (onValidate != password) {
                return "Confirm PassWord not match";
              }

              return null;
            },
            (onSaved) {
              confirmPassword = onSaved.toString().trim();
            },
            showPrefixIcon: true,
            prefixIcon: Icon(Icons.password_outlined),
            borderRadius: 10,
            contentPadding: 15,
            fontSize: 14,
            prefixIconPaddingLeft: 10,
            borderColor: Colors.grey.shade400,
            textColor: Colors.black,
            prefixIconColor: Colors.black,
            hintColor: Colors.black.withOpacity(0.6),
            backgroundColor: Colors.grey.shade100,
            borderFocusColor: Colors.grey.shade200,
            obscureText: hideconfirmPassword,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  hideconfirmPassword = !hideconfirmPassword;
                });
              },
              color: Colors.red,
              icon: Icon(hideconfirmPassword
                  ? Icons.visibility_off
                  : Icons.visibility),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: FormHelper.submitButton(
              "Sign Up",
              () {
                if (validateSave()) {
                  //API request
                  setState(() {
                    isAsyncCallProcess = true;
                  });
                  APIService.registerUser(
                    fullName!,
                    email!,
                    password!,
                  ).then((respone) {
                    setState(() {
                      isAsyncCallProcess = false;
                    });
                    if (respone) {
                      FormHelper.showSimpleAlertDialog(
                        context,
                        Config.appName,
                        "Register completed successfully ",
                        "Ok",
                        () {
                          Navigator.of(context).pop();
                        },
                      );
                    } else {
                      FormHelper.showSimpleAlertDialog(
                        context,
                        Config.appName,
                        "This E-mail already registed ",
                        "Ok",
                        () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              "/login", (router) => false);
                        },
                      );
                    }
                  });
                }
              },
              btnColor: Colors.deepOrange,
              borderColor: Colors.white,
              txtColor: Colors.white,
              borderRadius: 20,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                ), // TextStyle
                children: <TextSpan>[
                  TextSpan(text: "Already have an account? "),
                  TextSpan(
                    text: "Sign In",
                    style: TextStyle(
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            "/login", (route) => false);
                      },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool validateSave() {
    final form = globalKey.currentState;

    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }
}
