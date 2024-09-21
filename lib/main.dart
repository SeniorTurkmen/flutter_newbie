import 'package:flutter/material.dart';
import 'package:newbietrainee/models/post_model.dart';
import 'package:newbietrainee/network.dart';
import 'package:newbietrainee/theme.dart';
import 'package:newbietrainee/util.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;

    // Retrieves the default theme for the platform
    //TextTheme textTheme = Theme.of(context).textTheme;

    // Use with Google Fonts package to use downloadable fonts
    TextTheme textTheme = createTextTheme(context, "Inter", "Inter");

    MaterialTheme theme = MaterialTheme(textTheme);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: brightness == Brightness.light ? theme.light() : theme.dark(),
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
              TextButton(
                onPressed: () {},
                child: const Text(
                  'şifremi unuttum',
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

class BlankPage extends StatefulWidget {
  const BlankPage({super.key});

  @override
  State<BlankPage> createState() => _BlankPageState();
}

class _BlankPageState extends State<BlankPage> {
  List<PostModel> response = [];

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => LoginPage()));
            }
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Blank Page'),
        actions: [
          IconButton(
            onPressed: () {
              showMenu(
                context: context,
                position: const RelativeRect.fromLTRB(1, 100, 0, 0),
                items: [
                  const PopupMenuItem(
                    child: Text('item 1'),
                  ),
                  const PopupMenuItem(
                    child: Text('item 2'),
                  ),
                  const PopupMenuItem(
                    child: Text('item 3'),
                  ),
                ],
              );
            },
            icon: const Icon(Icons.apps_rounded),
          )
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!isLoading)
                Flexible(
                  child: ListView.builder(
                    itemCount: response.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          response[index].title ?? '',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        subtitle: Text(response[index].body ?? ''),
                      );
                    },
                  ),
                ),
              if (isLoading) const CircularProgressIndicator.adaptive(),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  await Future.delayed(const Duration(seconds: 2));
                  var res = await NetworkLayer().getList();
                  setState(() {
                    response = res;
                    isLoading = false;
                  });
                },
                child: const Text('getPosts'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
