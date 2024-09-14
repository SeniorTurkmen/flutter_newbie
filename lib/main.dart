import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.purple,
        body: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * .8,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const FlutterLogo(),
                  CustomTextField(
                    controller: emailController,
                    validator: (item) {
                      if (item?.contains('@') ?? false) {
                        return null;
                      }
                      return 'Lütfen geçerli bir mail giriniz';
                    },
                    label: 'email',
                  ),
                  const Divider(),
                  CustomTextField(
                      isPasswordField: true,
                      controller: passwordController,
                      validator: (item) {
                        if (item?.isNotEmpty ?? false) {
                          return null;
                        }
                        return 'Parola boş olamaz';
                      },
                      label: 'pasword'),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () {
                      if (formKey.currentState?.validate() ?? false) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => const BlankPage()),
                        );
                      }
                    },
                    child: const Text('login'),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'şifremi unuttum',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    this.isPasswordField = false,
    required this.controller,
    required this.label,
    this.validator,
  });
  final bool isPasswordField;
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isObscured = true;

  changeObscureStyle() {
    isObscured = !isObscured;
    setState(() {});
  }

  @override
  void initState() {
    isObscured = widget.isPasswordField;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textAlign: TextAlign.center,
      obscureText: isObscured,
      validator: widget.validator,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: widget.label,
        alignLabelWithHint: true,
        errorStyle: const TextStyle(
          color: Colors.white,
        ),
        suffixIcon: widget.isPasswordField
            ? InkWell(
                onTap: () => changeObscureStyle(),
                child: Icon(isObscured
                    ? Icons.remove_red_eye_outlined
                    : Icons.remove_red_eye),
              )
            : Opacity(
                opacity: 0,
                child: Icon(isObscured
                    ? Icons.remove_red_eye_outlined
                    : Icons.remove_red_eye),
              ),
      ),
    );
  }
}

class BlankPage extends StatelessWidget {
  const BlankPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
