import 'package:flutter/material.dart';
import 'package:flutter_google_drive_application/core/service/google_sign_in_service.dart';
import 'package:google_sign_in/google_sign_in.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter-google',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: const Color.fromARGB(255, 4, 0, 255)),
      ),
      home: const MyHomePage(title: 'Flutter-google drive Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GoogleSignInService googleSignInService = GoogleSignInService();

  GoogleSignInAccount? _account;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            _account == null ?
              Text('Log into your Google Account') :
              Text('Logged in as: ${_account?.email}'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () async {
                    final account = await googleSignInService.signIn();
                    setState(() {
                      _account = account;
                    });

                    if (account != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('User ${account.email} logged in successfully'),
                          duration: const Duration(seconds: 5),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Failed to log in user'),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.login),
                  tooltip: 'Sign In with Google',
                ),

                IconButton(
                  onPressed: (){ 
                    googleSignInService.signOut();
                    setState(() {
                      _account = null;
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('User ${_account?.email} logged out successfully'),
                        duration: const Duration(seconds: 5),
                      ),
                    );
                  },
                  icon: const Icon(Icons.logout),
                  tooltip: 'Sign out',
                ),

                IconButton(
                  onPressed: () async {
                    final token = await googleSignInService.getToken(_account);

                    if (!mounted) return; 
                    if (token == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('User not logged in or failed to get token'),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                      return;
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Access Token:\n$token'),
                        duration: const Duration(seconds: 5),
                      ),
                    );
                  },
                  icon: const Icon(Icons.get_app),
                  tooltip: 'get current user token',
                ),
              ],
            )
          ],
        ),
      ),

    );
  }
}
