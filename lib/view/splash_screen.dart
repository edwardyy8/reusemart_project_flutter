import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reusemart/view/login_page.dart';
import 'package:reusemart/view/navbar.dart';

class SplashScrenn extends StatefulWidget {
  const SplashScrenn({super.key});

  @override
  State<SplashScrenn> createState() => _SplashScrennState();
}

class _SplashScrennState extends State<SplashScrenn> 
    with SingleTickerProviderStateMixin {
  
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        // Navigator.of(context).pushReplacement(
        //   MaterialPageRoute(
        //     builder: (_) => const LoginPage(),
        //   )
        // );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => NavBar(userType: "lain")),
          (Route<dynamic> route) => false,
        );
      }
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, 
        overlays: SystemUiOverlay.values);
    super.dispose();
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'images/logo/logoreuse.png',
                width: 250,
                height: 200,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 40),
              Text(
                'Technology meets mindful living.',
                style: TextStyle(
                  fontSize: 15,
                  color: Color.fromARGB(255, 4, 121, 2),
                ),
              ),
              Text(
                'Where every purchase helps create a greener earth',
                style: TextStyle(
                  fontSize: 15,
                  color: Color.fromARGB(255, 4, 121, 2),
                ),
              ),
              Text(
                'for the future',
                style: TextStyle(
                  fontSize: 15,
                  color: Color.fromARGB(255, 4, 121, 2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}