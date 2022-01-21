import 'package:editor_page/data/join_or_login.dart';
import 'package:editor_page/helper/login_background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

// 3시간 50분 39초
class AuthPage extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _psswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(
          size: size,
          painter:
              Loginbackground(isJoin: Provider.of<JoinOrLogin>(context).isJoin),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            _logoImage,
            Stack(
              children: <Widget>[
                _inputForm(size),
                _authButton(size),
                // Container(width: 100, height: 50, color: Colors.black,),
              ],
            ),
            Container(
              height: size.height * 0.1,
            ),
            Consumer<JoinOrLogin>(
              builder: (context, joinOrLogin, child) => GestureDetector(
                onTap: () {
                  joinOrLogin.toggle();
                },
                child: Text(
                  joinOrLogin.isJoin
                      ? "Already have an Account? Sign in"
                      : "Don't Have an Account? Create One",
                  style: TextStyle(
                      color: joinOrLogin.isJoin ? Colors.red : Colors.blue),
                ),
              ),
            ),
            Container(
              height: size.height * 0.05,
            )
          ],
        )
      ],
    ));
  }

  Widget _authButton(Size size) {
    return Positioned(
      left: size.width * 0.15,
      right: size.width * 0.15,
      bottom: 0,
      child: SizedBox(
        height: 50,
        child: Consumer<JoinOrLogin>(
          builder: (context, joinOrLogin, child) => ElevatedButton(
            child: Text(
              joinOrLogin.isJoin ? 'Join' : 'Login',
              style: TextStyle(fontSize: 20),
            ),
            style: ElevatedButton.styleFrom(
                primary: joinOrLogin.isJoin ? Colors.red : Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25))),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                joinOrLogin.isJoin
                    ? _register(context)
                    : _login(context); // 로그인 회원가입 실행 버튼
              }
            },
          ),
        ),
      ),
    );
  }

  void _register(BuildContext context) async {
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: _emailController.text,
    password: _psswordController.text
    );
    final User user = userCredential.user as User;
    if (user == null) {
      final snackBar = SnackBar(
        content: Text("Please try again later."),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }
    // Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage(email: user.email)));
  }

  void _login(BuildContext context) async {
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _psswordController.text
    );
    final User user = userCredential.user as User;
    print(user);
    if (user == null) {
      final snackBar = SnackBar(
        content: Text("Please try again later."),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }
    // Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage(email: user.email)));
  }

  Widget get _logoImage => Expanded(
        child: Padding(
          padding: EdgeInsets.only(top: 40, left: 24, right: 24),
          child: FittedBox(
            fit: BoxFit.contain,
            child: CircleAvatar(
              backgroundImage: NetworkImage("https://i.gifer.com/2eRY.gif"),
            ),
          ),
        ),
      );

  Widget _inputForm(Size size) {
    return Padding(
      padding: EdgeInsets.all(size.width * 0.05), // 그림자
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16) // border-radius
            ),
        elevation: 6,
        child: Padding(
          // 패딩
          padding: EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 32),
          // 패딩
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      icon: Icon(Icons.account_circle), labelText: "Email"),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return "Please input correct Email.";
                    } else {
                      return null;
                    }
                  },
                ),
                TextFormField(
                  obscureText: true, // 비밀번호 **로 표시
                  controller: _psswordController,
                  decoration: InputDecoration(
                      icon: Icon(Icons.vpn_key), labelText: "Password"),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return "Please input correct Password.";
                    } else {
                      return null;
                    }
                  },
                ),
                Container(
                  height: 8,
                ),
                Consumer<JoinOrLogin>(
                  builder: (context, value, child) => Opacity(
                      // show display 같은것 0 이면 false
                      opacity: value.isJoin ? 0 : 1,
                      child: Text('Forgot Password')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
