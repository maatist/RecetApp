import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:RecetApp/screens/screens.dart';
import 'package:provider/provider.dart';

import 'package:RecetApp/provider/login_form_provider.dart';
import 'package:RecetApp/services/services.dart';

import 'package:RecetApp/ui/input_decorations.dart';
import 'package:RecetApp/widgets/widgets.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AuthBackground(
      child: SingleChildScrollView(
        child: Column(children: [
          const SizedBox(
            height: 300,
          ),
          CardContainer(
            child: Column(
              children: [
                const SizedBox(height: 10),
                Text('Crear cuenta',
                    style: Theme.of(context).textTheme.headline4),
                const SizedBox(height: 30),
                ChangeNotifierProvider(
                  create: (_) => LoginFormProvider(),
                  child: _LoginForm(),
                )
              ],
            ),
          ),
          const SizedBox(height: 50),
          TextButton(
            onPressed: () => Navigator.of(context).push(PageTransition(
                child: LoginScreen(),
                type: PageTransitionType.leftToRight,
                childCurrent: HomeScreen())),
            style: ButtonStyle(
              overlayColor:
                  MaterialStateProperty.all(Colors.indigo.withOpacity(0.1)),
              shape: MaterialStateProperty.all(StadiumBorder()),
            ),
            child: const Text('Ya tienes una cuenta?',
                style: TextStyle(fontSize: 18, color: Colors.black87)),
          ),
          const SizedBox(height: 50),
        ]),
      ),
    ));
  }
}

class _LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);

    return Container(
      child: Form(
          // TODO keys
          key: loginForm.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              TextFormField(
                autocorrect: true,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecorations.authInputDecoration(
                    hintText: 'John.doe@gmail.com',
                    labelText: 'Correo electronico',
                    prefixIcon: Icons.alternate_email_sharp),
                onChanged: (value) => loginForm.email = value,
                validator: (value) {
                  String pattern =
                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

                  RegExp regExp = new RegExp(pattern);

                  return regExp.hasMatch(value ?? '')
                      ? null
                      : 'El texto ingresado no parece un correo';
                },
              ),
              const SizedBox(height: 30),
              TextFormField(
                autocorrect: true,
                obscureText: true,
                keyboardType: TextInputType.text,
                decoration: InputDecorations.authInputDecoration(
                    hintText: '****',
                    labelText: 'Password',
                    prefixIcon: Icons.alternate_email_sharp),
                onChanged: (value) => loginForm.password = value,
                validator: (value) {
                  return (value != null && value.length >= 6)
                      ? null
                      : 'La contrasenna debe ser de 6 caracteres';
                },
              ),
              const SizedBox(height: 30),
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                disabledColor: Colors.grey,
                elevation: 0,
                color: Colors.deepPurple,
                onPressed: loginForm.isLoading
                    ? null
                    : () async {
                        FocusScope.of(context).unfocus();
                        final authService =
                            Provider.of<AuthService>(context, listen: false);
                        final userService =
                            Provider.of<UserService>(context, listen: false);

                        if (!loginForm.isValidForm()) return;

                        loginForm.isLoading = true;

                        final String? errorMessage = await authService
                            .createUser(loginForm.email, loginForm.password);

                        if (errorMessage == null) {
                          userService.loadUserData().then((value) => null);
                          userService.loadUsersData().then((value) => null);
                          Navigator.pushReplacementNamed(context, 'home');
                        } else {
                          print(errorMessage);
                          loginForm.isLoading = false;
                        }
                      },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                  child: Text(
                    loginForm.isLoading ? 'Espere' : 'Ingresar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
