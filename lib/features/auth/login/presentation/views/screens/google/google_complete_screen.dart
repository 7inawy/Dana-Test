import 'package:dana/core/auth/auth_session.dart';
import 'package:dana/core/di/injection_container.dart';
import 'package:dana/core/utils/app_routes.dart';
import 'package:dana/features/auth/login/data/datasources/auth_remote_data_source.dart';
import 'package:dana/features/auth/login/presentation/cubit/google_auth_cubit.dart';
import 'package:dana/features/auth/login/presentation/cubit/google_auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GoogleCompleteScreen extends StatefulWidget {
  static const String routeName = 'GoogleCompleteScreen';

  final String requestId;

  const GoogleCompleteScreen({super.key, required this.requestId});

  @override
  State<GoogleCompleteScreen> createState() => _GoogleCompleteScreenState();
}

class _ChildForm {
  final name = TextEditingController();
  final birthDate = TextEditingController(); // YYYY-MM-DD
  String gender = 'male';

  void dispose() {
    name.dispose();
    birthDate.dispose();
  }
}

class _GoogleCompleteScreenState extends State<GoogleCompleteScreen> {
  final _formKey = GlobalKey<FormState>();

  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _government = TextEditingController();
  final _address = TextEditingController();

  final List<_ChildForm> _children = [_ChildForm()];

  @override
  void dispose() {
    _phone.dispose();
    _password.dispose();
    _government.dispose();
    _address.dispose();
    for (final c in _children) {
      c.dispose();
    }
    super.dispose();
  }

  List<ChildData> _buildChildren() {
    return _children
        .map(
          (c) => ChildData(
            childName: c.name.text.trim(),
            gender: c.gender,
            birthDate: c.birthDate.text.trim(),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<GoogleAuthCubit>(),
      child: BlocListener<GoogleAuthCubit, GoogleAuthState>(
        listener: (context, state) async {
          if (state is GoogleAuthSuccess) {
            await sl<AuthSession>().setToken(state.user.token);
            if (!context.mounted) return;
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.home,
              (route) => false,
            );
          } else if (state is GoogleAuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(title: const Text('Complete account')),
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text('TempKey: ${widget.requestId}'),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phone,
                    decoration: const InputDecoration(labelText: 'Phone'),
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9+]')),
                    ],
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: _password,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (v) {
                      final s = v?.trim() ?? '';
                      if (s.isEmpty) return 'Required';
                      if (s.length < 6) return 'Min 6 chars';
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _government,
                    decoration: const InputDecoration(labelText: 'Government'),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: _address,
                    decoration: const InputDecoration(labelText: 'Address'),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  const Text('Children'),
                  const SizedBox(height: 8),
                  ..._children.asMap().entries.map((entry) {
                    final i = entry.key;
                    final c = entry.value;
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Child ${i + 1}'),
                                if (_children.length > 1)
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        final removed = _children.removeAt(i);
                                        removed.dispose();
                                      });
                                    },
                                    icon: const Icon(Icons.delete),
                                  ),
                              ],
                            ),
                            TextFormField(
                              controller: c.name,
                              decoration: const InputDecoration(
                                labelText: 'Child name',
                              ),
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? 'Required'
                                  : null,
                            ),
                            TextFormField(
                              controller: c.birthDate,
                              decoration: const InputDecoration(
                                labelText: 'Birth date (YYYY-MM-DD)',
                              ),
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? 'Required'
                                  : null,
                            ),
                            DropdownButtonFormField<String>(
                              initialValue: c.gender,
                              items: const [
                                DropdownMenuItem(
                                  value: 'male',
                                  child: Text('Male'),
                                ),
                                DropdownMenuItem(
                                  value: 'female',
                                  child: Text('Female'),
                                ),
                              ],
                              onChanged: (v) =>
                                  setState(() => c.gender = v ?? 'male'),
                              decoration:
                                  const InputDecoration(labelText: 'Gender'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  TextButton.icon(
                    onPressed: () {
                      setState(() => _children.add(_ChildForm()));
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add child'),
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<GoogleAuthCubit, GoogleAuthState>(
                    builder: (context, state) {
                      final loading = state is GoogleAuthCompleteLoading;
                      return FilledButton(
                        onPressed: loading
                            ? null
                            : () async {
                                if (!_formKey.currentState!.validate()) return;
                                await context.read<GoogleAuthCubit>().complete(
                                      requestId: widget.requestId,
                                      phone: _phone.text,
                                      password: _password.text,
                                      government: _government.text,
                                      address: _address.text,
                                      children: _buildChildren(),
                                    );
                              },
                        child: Text(loading ? 'Submitting...' : 'Complete'),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

