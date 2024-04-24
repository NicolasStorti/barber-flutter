import 'package:barbearia/components/snackbar.dart';
import 'package:barbearia/screens/cadastro_screen.dart';
import 'package:flutter/material.dart';
import 'package:barbearia/services/auth_services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  final AuthServices _authUser = AuthServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 130,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/logo.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const Text(
                  'Barber App',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'E-mail',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(30)),
                              ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira seu e-mail.';
                            }
                            return null;
                          }),
                      const SizedBox(height: 20),
                      TextFormField(
                          controller: _senhaController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Senha',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(30)),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira sua senha.';
                            }
                            if (value.length < 6) {
                              return 'Senha inválida';
                            }
                            return null;
                          }),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => onButtonEntrarClicked(context),
                        child: const Text('Entrar'),
                      ),
                      const SizedBox(height: 15),
                      TextButton(
                        onPressed: () => onButtonCadastroClicked(context),
                        child: const Text('Cadastre-se aqui'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onButtonEntrarClicked(BuildContext context) {
    if (_formKey.currentState!.validate()){
      final email = _emailController.text;
      final senha = _senhaController.text;

      _authUser.entrarUser(email: email, senha: senha).then((String? erro){
        if(erro != null){
          showSnackbar(context: context, text: erro);
        }
      });
    }
  }

  void onButtonCadastroClicked(BuildContext context) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const CadastroScreen()));
  }
}