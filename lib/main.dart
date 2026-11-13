import 'package:material_ui/material_ui.dart';

import 'screens/calendar_screen.dart';

void main() {
  runApp(const TaskFlowApp());
}

// Contas cadastradas durante a execução do aplicativo.
final Map<String, Map<String, String>> contasCadastradas = {};

const roxo = Color(0xFF873BFF);
const roxoClaro = Color(0xFFAD75FF);
const fundoEscuro = Color(0xFF130824);

class TaskFlowApp extends StatelessWidget {
  const TaskFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TaskFlow',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(seedColor: roxo),
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();

  bool ocultarSenha = true;
  bool mostrarCadastro = false;

  @override
  void dispose() {
    nomeController.dispose();
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  void cadastrar() {
    final nome = nomeController.text.trim();
    final email = emailController.text.trim().toLowerCase();
    final senha = senhaController.text;

    if (nome.isEmpty || email.isEmpty || senha.isEmpty) {
      mostrarMensagem('Preencha todos os campos.');
      return;
    }

    if (!email.contains('@') || !email.contains('.')) {
      mostrarMensagem('Digite um e-mail válido.');
      return;
    }

    if (contasCadastradas.containsKey(email)) {
      mostrarMensagem('Este e-mail já está cadastrado.');
      return;
    }

    contasCadastradas[email] = {'nome': nome, 'senha': senha};

    setState(() {
      mostrarCadastro = false;
      emailController.text = email;
      senhaController.clear();
      nomeController.clear();
    });

    mostrarMensagem('Conta criada com sucesso! Faça seu login.');
  }

  void entrar() {
    final email = emailController.text.trim().toLowerCase();
    final senha = senhaController.text;

    if (email.isEmpty || senha.isEmpty) {
      mostrarMensagem('Informe seu e-mail e sua senha.');
      return;
    }

    final conta = contasCadastradas[email];

    if (conta == null || conta['senha'] != senha) {
      mostrarMensagem('E-mail ou senha incorretos.');
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const CalendarScreen()),
    );
  }

  void mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mensagem)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fundoEscuro,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF35105D), Color(0xFF190A30), fundoEscuro],
              ),
            ),
          ),

          Positioned(top: -100, right: -100, child: glow(280, 0.25)),
          Positioned(bottom: 100, left: -130, child: glow(300, 0.16)),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 30,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 15),

                    Container(
                      width: 82,
                      height: 82,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        gradient: const LinearGradient(
                          colors: [roxoClaro, roxo],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: roxo.withValues(alpha: 0.45),
                            blurRadius: 30,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.checklist_rounded,
                        color: Colors.white,
                        size: 46,
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      'TaskFlow',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 37,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),

                    const SizedBox(height: 9),

                    const Text(
                      'ORGANIZE SUA VIDA. ALCANCE SEUS OBJETIVOS.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFBBA9D2),
                        fontSize: 10,
                        letterSpacing: 1.7,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 42),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFEFF),
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.25),
                            blurRadius: 35,
                            offset: const Offset(0, 15),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            mostrarCadastro
                                ? 'Criar conta'
                                : 'Bem-vindo de volta!',
                            style: const TextStyle(
                              color: Color(0xFF211632),
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            mostrarCadastro
                                ? 'Preencha seus dados para começar.'
                                : 'Entre na sua conta e continue sua jornada.',
                            style: const TextStyle(
                              color: Color(0xFF88818F),
                              fontSize: 13,
                            ),
                          ),

                          const SizedBox(height: 28),

                          if (mostrarCadastro) ...[
                            campo(
                              'Nome completo',
                              Icons.person_outline_rounded,
                              controller: nomeController,
                            ),
                            const SizedBox(height: 17),
                          ],

                          campo(
                            'E-mail',
                            Icons.email_outlined,
                            controller: emailController,
                          ),

                          const SizedBox(height: 17),

                          TextField(
                            controller: senhaController,
                            obscureText: ocultarSenha,
                            decoration: InputDecoration(
                              labelText: 'Senha',
                              prefixIcon: const Icon(
                                Icons.lock_outline_rounded,
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    ocultarSenha = !ocultarSenha;
                                  });
                                },
                                icon: Icon(
                                  ocultarSenha
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                ),
                              ),
                              filled: true,
                              fillColor: const Color(0xFFF6F3FA),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),

                          if (!mostrarCadastro)
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  mostrarMensagem(
                                    'Entre em contato para recuperar sua senha.',
                                  );
                                },
                                child: const Text(
                                  'Esqueceu sua senha?',
                                  style: TextStyle(color: roxo),
                                ),
                              ),
                            ),

                          const SizedBox(height: 15),

                          Container(
                            height: 56,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              gradient: const LinearGradient(
                                colors: [roxoClaro, roxo],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: roxo.withValues(alpha: 0.3),
                                  blurRadius: 15,
                                  offset: const Offset(0, 7),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: mostrarCadastro ? cadastrar : entrar,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: Text(
                                mostrarCadastro ? 'CRIAR CONTA' : 'ENTRAR',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 22),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  mostrarCadastro
                                      ? 'Já possui uma conta?'
                                      : 'Ainda não tem uma conta?',
                                  style: const TextStyle(
                                    color: Color(0xFF88818F),
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    mostrarCadastro = !mostrarCadastro;
                                  });
                                },
                                child: Text(
                                  mostrarCadastro ? 'Entrar' : 'Cadastre-se',
                                  style: const TextStyle(
                                    color: roxo,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    const Text(
                      'TASKFLOW  •  SUA ROTINA SOB CONTROLE',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF88749E),
                        fontSize: 10,
                        letterSpacing: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget glow(double tamanho, double opacidade) {
    return Container(
      width: tamanho,
      height: tamanho,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: roxo.withValues(alpha: opacidade),
        boxShadow: [
          BoxShadow(
            color: roxo.withValues(alpha: opacidade),
            blurRadius: 100,
            spreadRadius: 30,
          ),
        ],
      ),
    );
  }

  Widget campo(
    String titulo,
    IconData icone, {
    TextEditingController? controller,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: titulo,
        prefixIcon: Icon(icone),
        filled: true,
        fillColor: const Color(0xFFF6F3FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
