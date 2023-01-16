import 'package:flutter/material.dart';
import 'package:flutter_application_1/widget/auth/auth_model.dart';
import 'package:provider/provider.dart';

class AuthWidget extends StatefulWidget {
  const AuthWidget({super.key});

  @override
  State<AuthWidget> createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login to your account"),
      ),
      body: ListView(
        children: const [
          _HeaderWidget(),
          _FormWidget(),
        ],
      ),
    );
  }
}

class _HeaderWidget extends StatelessWidget {
  const _HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 16, color: Colors.black);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 25,
          ),
          const Text(
              "In order to use the editing and rating capabilities of TMDB, as well as get personal recommendations you will need to login to your account. If you do not have an account, registering for an account is free and simple",
              style: textStyle),
          const SizedBox(height: 5),
          TextButton(
            onPressed: (() => {}),
            child: const Text(
              "Register",
              textAlign: TextAlign.start,
            ),
          ),
          const SizedBox(height: 5),
          const Text("If you signed up but didn't get your verification email.",
              style: textStyle),
          const SizedBox(
            height: 5,
          ),
          TextButton(
            onPressed: (() => {}),
            child: const Text("verify email"),
          )
        ],
      ),
    );
  }
}

class _FormWidget extends StatelessWidget {
  const _FormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.read<AuthViewModel>();
    const textStyle = TextStyle(fontSize: 16, color: Colors.black);
    const textDecorator = InputDecoration(
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blueGrey),
        borderRadius: BorderRadius.horizontal(
          left: Radius.circular(50),
          right: Radius.circular(50),
        ),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      isCollapsed: true,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const _MessageErrorWidget(),
          const Text(
            "username",
            style: textStyle,
            textAlign: TextAlign.left,
          ),
          const SizedBox(
            height: 5,
          ),
          TextField(
            controller: model.authController,
            decoration: textDecorator,
          ),
          const SizedBox(
            height: 15,
          ),
          const Text(
            "password",
            style: textStyle,
            textAlign: TextAlign.start,
          ),
          const SizedBox(
            height: 5,
          ),
          TextField(
            controller: model.passController,
            obscureText: true,
            decoration: textDecorator,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
            child: Row(
              children: [
                const _AuthButtonWidget(),
                const SizedBox(
                  width: 30,
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text("Reset password"),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _AuthButtonWidget extends StatelessWidget {
  const _AuthButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<AuthViewModel>();
    return ElevatedButton(
      onPressed: model.canStartAuth != true ? () => model.auth(context) : null,
      child: const Text("Login"),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
          foregroundColor: MaterialStateProperty.all(Colors.white),
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          )),
    );
  }
}

class _MessageErrorWidget extends StatelessWidget {
  const _MessageErrorWidget({super.key});
  @override
  Widget build(BuildContext context) {
    final errorMessage = context.select((AuthViewModel m) => m.errorMessage);
    if (errorMessage == "null") return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Text(
        errorMessage.toString(),
        style: const TextStyle(color: Colors.red, fontSize: 17),
      ),
    );
  }
}
