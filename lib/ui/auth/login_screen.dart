import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase/ui/posts/post_screen.dart';
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
            ],
          ),
        ),
      ),
    );
  }
}
