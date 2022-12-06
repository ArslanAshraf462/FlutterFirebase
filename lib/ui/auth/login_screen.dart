import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '/ui/auth/login_with_phone_number.dart';
import '/ui/posts/post_screen.dart';
import '../../utils/utilities.dart';
import '/ui/auth/signup_screen.dart';
import '../../widgets/round_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false;
  final _formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn();
  // GoogleSignInAccount? _user;
  // GoogleSignInAccount get user => _user!;
  Future signInWithGoogle() async{
    final googleUser = await googleSignIn.signIn();
    if(googleUser==null) return;
    //_user = googleUser;
    final googleAuthentication = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuthentication.idToken,
      accessToken: googleAuthentication.accessToken,
    );
    await _auth.signInWithCredential(credential).then((value){
      Utils().toastMessage(value.user!.email.toString());
      Navigator.push(context,
        MaterialPageRoute(
          builder: (context) => const PostScreen(),),
      );
      setState(() {
        loading=false;
      });
    });
    debugPrint("Google User Name :${googleUser.displayName}");
  }

  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);

    //final userData = await FacebookAuth.instance.getUserData();

   // var userEmail = userData['email'];

    // Once signed in, return the UserCredential
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    emailController;
    passwordController;
    super.dispose();
  }

  void login(){
    setState(() {
      loading=true;
    });
    _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
    ).then((value) {
      Utils().toastMessage(value.user!.email.toString());
      Navigator.push(context,
          MaterialPageRoute(
            builder: (context) => const PostScreen(),),
      );
      setState(() {
        loading=false;
      });
    }).onError((error, stackTrace){
      Utils().toastMessage(error.toString());
      setState(() {
        loading=false;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        decoration: const InputDecoration(
                          hintText: 'Email',
                          prefixIcon: Icon(Icons.alternate_email),
                        ),
                        validator: (value) {
                          if(value!.isEmpty){
                            return "Enter email";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10,),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          hintText: 'Password',
                          prefixIcon: Icon(Icons.lock_open_outlined),
                        ),
                        validator: (value) {
                          if(value!.isEmpty){
                            return "Enter password";
                          }
                          return null;
                        },
                      ),
                    ],
                  )),
              const SizedBox(height: 50,),
              RoundButton(
                loading: loading,
                onTap: () {
                  if(_formkey.currentState!.validate()){
                    login();
                  }
                },
                  title: 'Login',
              ),
              const SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                  const Text("Don't have an account"),
                TextButton(onPressed: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const SignUpScreen(),));
                },
                    child: const Text('Sign up'))
                ],
              ),
              const SizedBox(height: 30,),
              RoundButton(
                loading: loading,
                onTap: () {
                  signInWithGoogle();
                },
                title: 'Login with Google with firebase',
              ),
              const SizedBox(height: 5,),
              RoundButton(
                loading: loading,
                onTap: () {
                  signInWithFacebook().then((value){
                    Utils().toastMessage(value.user!.email.toString());
                    Navigator.push(context,
                      MaterialPageRoute(
                        builder: (context) => const PostScreen(),),
                    );
                    setState(() {
                      loading=false;
                    });
                  });
                },
                title: 'Login with Facebook with firebase',
              ),
              // InkWell(
              //   onTap: () {
              //     Navigator.push(context,
              //         MaterialPageRoute(builder: (context) => const LoginWithPhoneNumber(),));
              //   },
              //   child: Container(
              //     height: 50,
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(50),
              //       border: Border.all(
              //         color: Colors.black
              //       ),
              //     ),
              //     child: const Center(
              //       child: Text('Login with phone number'),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
