import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

import 'package:reusemart/component/form_component.dart';
import 'package:reusemart/client/user_client.dart';
import 'package:reusemart/view/home_page.dart';
import 'package:reusemart/view/navbar.dart';

// import 'package:main/entity/user.dart';
import 'package:reusemart/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class LoginPage extends StatefulWidget {
  final Map? data;

  const LoginPage({super.key, this.data});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  TextEditingController emailPhoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Map? dataForm;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    dataForm = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFFFFFF),
                Color(0xFFFFEFDF),
              ],
              stops: [0.64, 0.85],
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'images/logo/titlereuse.png',
                        width: 200,
                        height: 120,
                      ),
                      Text(
                        'L O G I N',
                        style: TextStyle(
                          fontSize: 35.0,
                          color: Color.fromARGB(255, 4, 121, 2),
                        ),
                      ),
                    ],
                  ),
            
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20.0),
                    height: MediaQuery.of(context).size.height * 0.4,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 241, 237, 233),
                      border: Border.all(
                        color: Color.fromARGB(255, 166, 166, 166),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Center(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // email 
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Text(
                                "EMAIL",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            InputFormWidget(
                              validasi: (p0) {
                                if (p0 == null || p0.isEmpty) {
                                  return "Email tidak boleh kosong";
                                }
                                return null;
                              },
                              controller: emailPhoneController,
                              hintTxt: "Email"
                            ),
                            
                            // password
                            SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Text(
                                "PASSWORD",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            InputFormWidget(
                              validasi: (p0) {
                                if (p0 == null || p0.isEmpty) {
                                  return "Password tidak boleh kosong";
                                } else if (p0.length < 8) {
                                  return "Password minimal 8 karakter";
                                }
                                return null;
                              },
                              password: true,
                              controller: passwordController,
                              hintTxt: "Password"
                            ),
                            
                            if (_errorMessage != null)
                              Padding(
                                padding: EdgeInsets.only(top: 5.0),
                                child: Text(
                                  _errorMessage!,
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            
                            SizedBox(height: 10.0),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: _isLoading ? null : _login,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color.fromARGB(255, 4, 121, 2),
                                  ),
                                  child: _isLoading
                                    ? SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2.0,
                                        ),
                                      )
                                    : const Text(
                                        'LOGIN',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                                ),
                                
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Anda belum memiliki akun? Daftar di situs website kami.",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color.fromARGB(127, 24, 36, 24),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                ],
              )
            ),
          ),
        ),
      ),
    );
  }

  void showSnackBar(BuildContext context, String message, MaterialColor color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        var email = emailPhoneController.text;
        var password = passwordController.text;

        var result = await UserClient.login(email, password);

        // Jika login berhasil, navigasi ke halaman home
        var userType = result['user_type'];
        var token = result['token'];
        var statusCode = result['statusCode'];
        var userId = result['user_id'];
        var jabatan = result['jabatan'];

        if(jabatan.length > 0) {
          userType = jabatan;
        }

        print('Token: $token');
        print('Status Code: $statusCode');
        print('User type: $userType');
        print('Jabatan: $jabatan');

        if (statusCode == 200 || statusCode == 201) {
          String? fcmToken = await UserClient.getFcmToken();
          if (fcmToken != null) {
            await UserClient.sendFcmTokenToBackend(userId, userType, fcmToken, token);
          }

          // Refresh user data setelah login
          final notifier = ProviderScope.containerOf(context).read(userListProvider.notifier);
          await notifier.refresh();

          AwesomeDialog(
            context: context,
            animType: AnimType.leftSlide,
            headerAnimationLoop: false,
            dialogType: DialogType.success,
            showCloseIcon: false,
            dismissOnTouchOutside: false,
            title: 'Success',
            desc: 'Login Berhasil! Selamat datang di ReuseMart',
            btnOkOnPress: () {
              Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => NavBar(userType: userType)),
              (Route<dynamic> route) => false,
              );
            },
            btnOkIcon: Icons.check_circle,
          ).show();
        }
      } catch (e) {
        AwesomeDialog(
          context: context,
          animType: AnimType.leftSlide,
          headerAnimationLoop: false,
          dialogType: DialogType.error,
          showCloseIcon: true,
          dismissOnTouchOutside: false,
          title: 'Error',
          desc: 'Login gagal. Silahkan coba lagi.',
          btnOkOnPress: () {},
          btnOkColor: Colors.red,
        ).show();
        print('Login error: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

}
