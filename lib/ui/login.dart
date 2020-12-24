
import 'package:fetch_data_using_api/ui/listview.dart';
import 'package:fetch_data_using_api/widget/bezierContainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fetch_data_using_api/api/api_service.dart';
import 'package:fetch_data_using_api/model/login_model.dart';
import 'package:fetch_data_using_api/widget/ProgressHUD.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool hidePassword = true;
  bool isApiCallProcess = false;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  LoginRequestModel loginRequestModel;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    loginRequestModel = new LoginRequestModel();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: _uiSetup(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
    );
  }

  Widget _uiSetup(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
        Container(
                  height: 250,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                          top: -height * .15,
                          right: -MediaQuery.of(context).size.width * .4,
                          child: BezierContainer())
        ]
                  )),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Form(
                key: globalFormKey,
                child: Column(
                  children: <Widget>[
                    //SizedBox(height: 150),
                    Container(
                      padding: EdgeInsets.only(right: 60.0),
                      child: Text(
                        "Login",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 55.0,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          border: Border.all(
                            color: Colors.black12
                          )
                        ),
                        child: new TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          onSaved: (input) => loginRequestModel.email = input,
                          validator: (input) => !input.contains('@')
                              ? "Email Id should be valid"
                              : null,
                          decoration: new InputDecoration(
                            hintText: "Email Address",
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0, right: 30.0,top: 10.0),
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                            color: Colors.white24,
                            border: Border.all(
                                color: Colors.black12
                            )
                        ),
                        child: new TextFormField(
                          // style:
                          // TextStyle(color: Theme.of(context).accentColor),
                          keyboardType: TextInputType.text,
                          onSaved: (input) =>
                          loginRequestModel.password = input,
                          validator: (input) => input.length < 3
                              ? "Password should be more than 3 characters"
                              : null,
                          obscureText: hidePassword,
                          decoration: new InputDecoration(
                            hintText: "Password",
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.lock,
                                color: Colors.orange,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  hidePassword = !hidePassword;
                                });
                              },
                              color: Colors.orange,
                              icon: Icon(hidePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 50),
                    FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0)
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: 18, horizontal: 130),
                      onPressed: () {
                        if (validateAndSave()) {
                          print(loginRequestModel.toJson());

                          setState(() {
                            isApiCallProcess = true;
                          });

                          APIService apiService = new APIService();
                          apiService.login(loginRequestModel).then((value) {
                            if (value != null) {
                              setState(() {
                                isApiCallProcess = false;
                              });

                              if (value.token.isNotEmpty) {
                                // final snackBar = SnackBar(
                                //     content: Text("Login Successful"));
                                // scaffoldKey.currentState
                                //     .showSnackBar(snackBar);
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context)=> HomePage()));
                              } else {
                                final snackBar =
                                SnackBar(content: Text(value.error));
                                scaffoldKey.currentState
                                    .showSnackBar(snackBar);
                              }
                            }
                          });
                        }

                      },
                      child: Text(
                        "Login",
                        style: TextStyle(color: Colors.white,
                        fontSize: 18.0),
                      ),
                      color: Colors.orange,
                    ),
                    SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
