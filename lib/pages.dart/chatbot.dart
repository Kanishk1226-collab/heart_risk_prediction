// import 'package:custom_bottom_navigation_bar/custom_bottom_navigation_bar_item.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:heart_rate/bloc/auth_bloc.dart';
import 'package:heart_rate/bloc/bottomNavBar.dart';
import 'package:heart_rate/utils/MedicalRecord.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:loading_indicator/loading_indicator.dart';
import 'package:circle_bottom_navigation_bar/circle_bottom_navigation_bar.dart';
import 'package:circle_bottom_navigation_bar/widgets/tab_data.dart';
import 'package:kommunicate_flutter/kommunicate_flutter.dart';

class Chatbot extends StatefulWidget {
  const Chatbot({Key? key}) : super(key: key);

  @override
  _ChatbotState createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 96, 0, 144),
          title: const Text(
            "ChatBot",
            style: TextStyle(fontFamily: "Comfortaa", fontSize: 16),
          ),
          elevation: 4,
          automaticallyImplyLeading: false,
        ),
        backgroundColor: Color(0xFFffffff),
        bottomNavigationBar:
            Consumer<BottomNavBarBloc>(builder: (context, provider, child) {
          return BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.receipt_rounded),
                label: 'Heart Risk',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.assistant),
                label: 'ChatBot',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.logout),
                label: 'Logout',
              ),
            ],
            currentIndex: provider.currentIndex,
            selectedItemColor: Color.fromARGB(255, 96, 0, 144),
            unselectedItemColor: Colors.grey,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: TextStyle(
                fontFamily: "Comfortaa",
                fontWeight: FontWeight.normal,
                fontSize: 12),
            unselectedLabelStyle: TextStyle(
                fontFamily: "Comfortaa",
                fontWeight: FontWeight.normal,
                fontSize: 12),
            onTap: (int index) {
              if (index != provider.currentIndex) {
                provider.setIndex(index);
                if (index == 0) {
                  Navigator.pushNamed(context, '/dashboard');
                }
                if (index == 1) {
                  Navigator.pushReplacementNamed(context, '/addrecord');
                }
                if (index == 3) {
                  Provider.of<AuthenticationBloc>(context, listen: false)
                      .logout_user();
                  Navigator.pushReplacementNamed(context, '/auth');
                }
              }
            },
          );
        }),
        body: SingleChildScrollView(
          child: SafeArea(
              //  child: Text("Chatbot"),
              child: FloatingActionButton(
            onPressed: () async {
              try {
                dynamic conversationObject = {
                  'appId':
                      '2395aa8106e8baf1c765327cc8516bbc5', // The [APP_ID](https://dashboard.kommunicate.io/settings/install) obtained from kommunicate dashboard.
                };

                KommunicateFlutterPlugin.buildConversation(conversationObject)
                    .then((clientConversationId) {
                  print("Conversation builder success : " +
                      clientConversationId.toString());
                }).catchError((error) {
                  print("Conversation builder error : " + error.toString());
                });
              } on Exception catch (e) {
                print("Conversation builder error occured : " + e.toString());
              }
            },
          )),
        ));
  }
}
