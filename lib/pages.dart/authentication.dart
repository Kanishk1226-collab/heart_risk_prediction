import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:heart_rate/bloc/auth_bloc.dart';
import 'package:heart_rate/bloc/bottomNavBar.dart';
import 'package:heart_rate/utils/AuthDetails.dart';

class AuthenticationComponent extends StatefulWidget {
  const AuthenticationComponent({Key? key}) : super(key: key);

  @override
  _AuthenticationComponentState createState() =>
      _AuthenticationComponentState();
}

class _AuthenticationComponentState extends State<AuthenticationComponent> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Builder(builder: (context) {
          final TabController tabController = DefaultTabController.of(context)!;

          return Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Color(0xFFFFFFFF),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                    child: Column(
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                  image: AssetImage('images/icon4.png'),
                                  width: 125,
                                  height: 125),
                              const SizedBox(
                                width: 10,
                              ),
                              // Column(
                              //     mainAxisAlignment:
                              //         MainAxisAlignment.spaceEvenly,
                              //     crossAxisAlignment: CrossAxisAlignment.center,
                              //     children: [
                              //       Text(
                              //         'Cardiovascular',
                              //         style: TextStyle(
                              //           fontSize: 32,
                              //           color: Colors.yellow,
                              //         ),
                              //       ),
                              //     ]),
                            ]),
                        // Center(
                        //   child: Text(
                        //     'Risk Prediction',
                        //     style: TextStyle(
                        //       fontSize: 32,
                        //       color: Colors.yellow,
                        //     ),
                        //   ),
                        // ),

                        SizedBox(height: 20),
                        // Text(
                        //   "Take care of your Heart",
                        //   style: TextStyle(
                        //       fontFamily: "Poppins",
                        //       color: Colors.black,
                        //       fontSize: 20,
                        //       fontWeight: FontWeight.w600),
                        // ),
                        // SizedBox(height: 30),
                        // Divider(
                        //   endIndent: 0,
                        //   indent: 0,
                        // ),
                        TabBar(
                          labelColor: Color.fromARGB(255, 96, 0, 144),
                          unselectedLabelColor: Colors.black,
                          indicatorColor: Color.fromARGB(255, 96, 0, 144),
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: "Comfortaa"),
                          tabs: const [
                            Tab(
                              text: 'Login',
                            ),
                            Tab(text: 'Signup'),
                          ],
                        ),
                        SizedBox(height: 20),
                        Container(
                            child: Expanded(
                          child:
                              TabBarView(controller: tabController, children: [
                            Consumer<AuthenticationBloc>(
                              builder: (context, auth, child) {
                                return LoginComp(authData: auth);
                              },
                            ),
                            Consumer<AuthenticationBloc>(
                              builder: (context, auth, child) {
                                return SignUpComponent(authData: auth);
                              },
                            ),
                          ]),
                        ))
                      ],
                    )),
              ));
        }));
  }
}

class LoginComp extends StatefulWidget {
  final authData;
  const LoginComp({Key? key, required this.authData}) : super(key: key);

  @override
  _LoginCompState createState() => _LoginCompState();
}

class _LoginCompState extends State<LoginComp> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void login_user() async {
    widget.authData.auth_pending();
    // authBloc.eventSink.add({'status': AuthEvent.AUTH_PENDING});
    try {
      Dio dio = new Dio();
      dio.options.headers['content-Type'] = 'application/json';
      // dio.options.headers["authorization"] =
      //     "Bearer ${authDetails['access_token']}";
      FormData formData = FormData.fromMap(
          {'email': emailController.text, 'password': passwordController.text});
      await dio
          .post("https://heartrisk-api.herokuapp.com/v1/login/", data: formData)
          .then((value) {
        widget.authData.auth_success(AuthDetails.fromJson(value.data['data']));
        Navigator.pushReplacementNamed(context, '/dashboard');
      });
    } on DioError catch (err) {
      if (err.response != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${err.response?.data["detail"]}'),
            duration: const Duration(milliseconds: 2000),
            width: 320.0, // Width of the SnackBar.
            padding: const EdgeInsets.symmetric(
              horizontal: 30.0, // Inner padding for SnackBar content.
              vertical: 12.0,
            ),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        );
        widget.authData.auth_failure(err.response?.data["detail"]);
      }
    }
  }

  @override
  void dispose() {
    // Don't forget to close all the stream
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: emailController,
            style: TextStyle(fontSize: 14),
            cursorColor: Color.fromARGB(255, 96, 0, 144),
            // decoration: InputDecoration(
            //     focusColor: Colors.yellow,
            //     enabledBorder: OutlineInputBorder(
            //         borderRadius: BorderRadius.all(Radius.circular(3)),
            //         borderSide: BorderSide(color: Colors.yellow, width: 1.5)),
            //     contentPadding: EdgeInsets.fromLTRB(15, 15, 15, 15),
            //     labelText: 'Email',
            //     border: OutlineInputBorder(
            //         borderRadius: BorderRadius.all(Radius.circular(3)),
            //         borderSide: BorderSide(color: Colors.yellow, width: 2))),
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                contentPadding: EdgeInsets.only(top: 15, left: 20),
                // labelText: 'Enter Email ID',
                labelText: 'Email',
                labelStyle: TextStyle(
                    fontFamily: 'Comfortaa',
                    fontWeight: FontWeight.normal,
                    fontSize: 13.0,
                    color: Colors.black),
                // focusedBorder: UnderlineInputBorder(
                //     borderSide: BorderSide(color: Colors.red.shade400))
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 96, 0, 144),
                    ),
                    borderRadius: BorderRadius.circular(25.0))),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Email is required';
              }
            },
          ),
          SizedBox(
            height: 25,
          ),
          TextFormField(
            controller: passwordController,
            style: TextStyle(fontSize: 14),
            obscureText: true,
            cursorColor: Color.fromARGB(255, 96, 0, 144),

            // decoration: InputDecoration(
            //     enabledBorder: OutlineInputBorder(
            //         borderRadius: BorderRadius.all(Radius.circular(3)),
            //         borderSide: BorderSide(color: Colors.yellow, width: 1.5)),
            //     contentPadding: EdgeInsets.fromLTRB(15, 15, 15, 15),
            //     labelText: 'Password',
            //     border: OutlineInputBorder(
            //         borderRadius: BorderRadius.all(Radius.circular(3)),
            //         borderSide: BorderSide(color: Colors.yellow, width: 2))),
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                contentPadding: EdgeInsets.only(top: 15, left: 20),
                // labelText: 'Enter Email ID',
                labelText: 'Password',
                labelStyle: TextStyle(
                    fontFamily: 'Comfortaa',
                    fontWeight: FontWeight.normal,
                    fontSize: 13.0,
                    color: Colors.black),
                // focusedBorder: UnderlineInputBorder(
                //     borderSide: BorderSide(color: Colors.red.shade400))
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 96, 0, 144),
                    ),
                    borderRadius: BorderRadius.circular(25.0))),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Password is required';
              }
            },
          ),
          SizedBox(height: 40),
          // SizedBox(
          //   width: double.infinity,
          //   height: 50,
          //   child: ElevatedButton(
          //       onPressed: () {
          //         FocusScope.of(context).unfocus();
          //         login_user();
          //       },
          //       child: Text("Login"),
          //       style: ButtonStyle(
          //           backgroundColor:
          //               MaterialStateProperty.all<Color>(Colors.yellow),
          //           shape: MaterialStateProperty.all(RoundedRectangleBorder(
          //               borderRadius: BorderRadius.circular(3.0),
          //               side: BorderSide(color: Colors.yellow))))),
          // )
          Spacer(),
          InkWell(
            onTap: () {
              FocusScope.of(context).unfocus();
              login_user();
            },
            child: Container(
              height: 45.0,
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  // border: Border.all(
                  //   color: Colors.white,
                  //   style: BorderStyle.solid,
                  //   width: 1.0,
                  // ),
                  color: Color.fromARGB(255, 96, 0, 144),

                  borderRadius: BorderRadius.circular(25.0),
                  boxShadow: [
                    BoxShadow(
                        //   color: Color.fromRGBO(0, 44, 123, 0.08),
                        // color: Color.fromARGB(218, 163, 57, 163),
                        color: Color.fromARGB(218, 135, 135, 135),
                        offset: Offset(0, 0),
                        blurRadius: 7,
                        spreadRadius: 0),
                  ],
                ),
                // child: Expanded(
                child: Center(
                  child: Text('LOGIN',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Comfortaa',
                        color: Colors.white,
                      )),
                ),
                //  ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SignUpComponent extends StatefulWidget {
  final authData;
  const SignUpComponent({Key? key, required this.authData}) : super(key: key);

  @override
  _SignUpComponentState createState() => _SignUpComponentState();
}

class _SignUpComponentState extends State<SignUpComponent> {
  final authBloc = new AuthenticationBloc();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void signup_user() async {
    widget.authData.auth_pending();
    Provider.of<BottomNavBarBloc>(context, listen: false).setIndex(0);
    // authBloc.eventSink.add({'status': AuthEvent.AUTH_PENDING});
    try {
      Dio dio = new Dio();
      dio.options.headers['content-Type'] = 'application/json';

      Map<String, String> data = {
        'email': emailController.text,
        'password': passwordController.text,
        'username': usernameController.text,
        'phone': phoneController.text
      };

      await dio
          .post("https://heartrisk-api.herokuapp.com/v1/signup/", data: data)
          .then((value) {
        widget.authData.auth_success(AuthDetails.fromJson(value.data['data']));
        Navigator.pushReplacementNamed(context, '/dashboard');
      });
    } on DioError catch (err) {
      if (err.response != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${err.response?.data["detail"]}'),
            duration: const Duration(milliseconds: 2000),
            width: 320.0, // Width of the SnackBar.
            padding: const EdgeInsets.symmetric(
              horizontal: 30.0, // Inner padding for SnackBar content.
              vertical: 12.0,
            ),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        );
        widget.authData.auth_failure(err.response?.data["detail"]);
      }
    }
  }

  @override
  void dispose() {
    // Don't forget to close all the stream
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: usernameController,
            style: TextStyle(fontSize: 14),
            // decoration: InputDecoration(
            //     enabledBorder: OutlineInputBorder(
            //         borderRadius: BorderRadius.all(Radius.circular(3)),
            //         borderSide: BorderSide(color: Colors.yellow, width: 1.5)),
            //     contentPadding: EdgeInsets.fromLTRB(15, 15, 15, 15),
            //     labelText: 'Username',
            //     border: OutlineInputBorder(
            //         borderRadius: BorderRadius.all(Radius.circular(3)),
            //         borderSide: BorderSide(color: Colors.yellow, width: 2))),

            cursorColor: Color.fromARGB(255, 96, 0, 144),
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                contentPadding: EdgeInsets.only(top: 15, left: 20),
                // labelText: 'Enter Email ID',
                labelText: 'User Name',
                labelStyle: TextStyle(
                    fontFamily: 'Comfortaa',
                    fontWeight: FontWeight.normal,
                    fontSize: 13.0,
                    color: Colors.black),
                // focusedBorder: UnderlineInputBorder(
                //     borderSide: BorderSide(color: Colors.red.shade400))
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 96, 0, 144),
                    ),
                    borderRadius: BorderRadius.circular(25.0))),

            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Username is required';
              }
            },
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: emailController,
            style: TextStyle(fontSize: 14),
            // decoration: InputDecoration(
            //     enabledBorder: OutlineInputBorder(
            //         borderRadius: BorderRadius.all(Radius.circular(3)),
            //         borderSide: BorderSide(color: Colors.yellow, width: 1.5)),
            //     contentPadding: EdgeInsets.fromLTRB(15, 15, 15, 15),
            //     labelText: 'Email',
            //     border: OutlineInputBorder(
            //         borderRadius: BorderRadius.all(Radius.circular(3)),
            //         borderSide: BorderSide(color: Colors.yellow, width: 2))),

            cursorColor: Color.fromARGB(255, 96, 0, 144),
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                contentPadding: EdgeInsets.only(top: 15, left: 20),
                // labelText: 'Enter Email ID',
                labelText: 'Email',
                labelStyle: TextStyle(
                    fontFamily: 'Comfortaa',
                    fontWeight: FontWeight.normal,
                    fontSize: 13.0,
                    color: Colors.black),
                // focusedBorder: UnderlineInputBorder(
                //     borderSide: BorderSide(color: Colors.red.shade400))
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 96, 0, 144),
                    ),
                    borderRadius: BorderRadius.circular(25.0))),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Email is required';
              }
            },
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: phoneController,
            style: TextStyle(fontSize: 14),
            // decoration: InputDecoration(
            //     enabledBorder: OutlineInputBorder(
            //         borderRadius: BorderRadius.all(Radius.circular(3)),
            //         borderSide: BorderSide(color: Colors.yellow, width: 1.5)),
            //     contentPadding: EdgeInsets.fromLTRB(15, 15, 15, 15),
            //     labelText: 'Phone',
            //     border: OutlineInputBorder(
            //         borderRadius: BorderRadius.all(Radius.circular(3)),
            //         borderSide: BorderSide(color: Colors.yellow, width: 2))),

            cursorColor: Color.fromARGB(255, 96, 0, 144),
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                contentPadding: EdgeInsets.only(top: 15, left: 20),
                // labelText: 'Enter Email ID',
                labelText: 'Phone Number',
                labelStyle: TextStyle(
                    fontFamily: 'Comfortaa',
                    fontWeight: FontWeight.normal,
                    fontSize: 13.0,
                    color: Colors.black),
                // focusedBorder: UnderlineInputBorder(
                //     borderSide: BorderSide(color: Colors.red.shade400))
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 96, 0, 144),
                    ),
                    borderRadius: BorderRadius.circular(25.0))),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Phone is required';
              }
            },
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: passwordController,
            style: TextStyle(fontSize: 14),
            obscureText: true,
            // decoration: InputDecoration(
            //     enabledBorder: OutlineInputBorder(
            //         borderRadius: BorderRadius.all(Radius.circular(3)),
            //         borderSide: BorderSide(color: Colors.yellow, width: 1.5)),
            //     contentPadding: EdgeInsets.fromLTRB(15, 15, 15, 15),
            //     labelText: 'Password',
            //     border: OutlineInputBorder(
            //         borderRadius: BorderRadius.all(Radius.circular(3)),
            //         borderSide: BorderSide(color: Colors.yellow, width: 2))),
            cursorColor: Color.fromARGB(255, 96, 0, 144),
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                contentPadding: EdgeInsets.only(top: 15, left: 20),
                // labelText: 'Enter Email ID',
                labelText: 'Password',
                labelStyle: TextStyle(
                    fontFamily: 'Comfortaa',
                    fontWeight: FontWeight.normal,
                    fontSize: 13.0,
                    color: Colors.black),
                // focusedBorder: UnderlineInputBorder(
                //     borderSide: BorderSide(color: Colors.red.shade400))
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 96, 0, 144),
                    ),
                    borderRadius: BorderRadius.circular(25.0))),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Password is required';
              }
            },
          ),
          SizedBox(height: 40),
          // SizedBox(
          //   width: double.infinity,
          //   height: 50,
          //   child: ElevatedButton(
          //       onPressed: () {
          //         FocusScope.of(context).unfocus();
          //         signup_user();
          //       },
          //       child: Text("Signup"),
          //       style: ButtonStyle(
          //           backgroundColor:
          //               MaterialStateProperty.all<Color>(Colors.yellow),
          //           shape: MaterialStateProperty.all(RoundedRectangleBorder(
          //               borderRadius: BorderRadius.circular(3.0),
          //               side: BorderSide(color: Colors.yellow))))),
          // )
          Spacer(),
          InkWell(
            onTap: () {
              FocusScope.of(context).unfocus();
              signup_user();
            },
            child: Container(
              height: 45.0,
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  // border: Border.all(
                  //   color: Colors.white,
                  //   style: BorderStyle.solid,
                  //   width: 1.0,
                  // ),
                  color: Color.fromARGB(255, 96, 0, 144),

                  borderRadius: BorderRadius.circular(25.0),
                  boxShadow: [
                    BoxShadow(
                        //   color: Color.fromRGBO(0, 44, 123, 0.08),
                        // color: Color.fromARGB(218, 163, 57, 163),
                        color: Color.fromARGB(218, 135, 135, 135),
                        offset: Offset(0, 0),
                        blurRadius: 7,
                        spreadRadius: 0),
                  ],
                ),
                child: Center(
                  child: Text('REGISTER',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Comfortaa',
                        color: Colors.white,
                      )),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
