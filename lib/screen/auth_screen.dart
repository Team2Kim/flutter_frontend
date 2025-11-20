import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:gukminexdiary/provider/auth_provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _emailController = TextEditingController();
  
  String _selectedLanguage = '한국어';
  bool _keepLoggedIn = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isSignupMode = false;

  final List<String> _languages = ['한국어', 'English', '日本語', '中文'];
  
  // 중복 확인을 위한 Timer
  Timer? _loginIdTimer;
  Timer? _emailTimer;

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nicknameController.dispose();
    _emailController.dispose();
    _loginIdTimer?.cancel();
    _emailTimer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _checkKeepLoggedIn();
  }

  void _checkKeepLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    _keepLoggedIn = prefs.getBool('keepLoggedIn') ?? false;
    if (_keepLoggedIn) {
      _idController.text = prefs.getString('loginId') ?? '';
      _passwordController.text = prefs.getString('password') ?? '';
      _handleLogin();
    }
  }

  void _toggleMode() {
    setState(() {
      _isSignupMode = !_isSignupMode;
      _formKey.currentState?.reset();
    });
    
    // 중복 확인 상태 초기화
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.clearDuplicateCheckStatus();
  }

  // ID 중복 확인 (debounce)
  void _checkLoginIdDuplicate(String loginId) {
    _loginIdTimer?.cancel();
    _loginIdTimer = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        authProvider.checkLoginIdDuplicate(loginId);
      }
    });
  }

  // 이메일 중복 확인 (debounce)
  void _checkEmailDuplicate(String email) {
    _emailTimer?.cancel();
    _emailTimer = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        authProvider.checkEmailDuplicate(email);
      }
    });
  }

  // 회원가입 버튼 활성화 조건 확인
  bool _canSignup(AuthProvider authProvider) {
    // 모든 필수 필드가 입력되었는지 확인
    final isAllFieldsFilled = _idController.text.trim().isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        _nicknameController.text.trim().isNotEmpty &&
        _emailController.text.trim().isNotEmpty;

    // 비밀번호가 일치하는지 확인
    final isPasswordMatch = _passwordController.text == _confirmPasswordController.text;

    // 중복 확인이 완료되었는지 확인
    final isDuplicateCheckComplete = authProvider.loginIdAvailable == true &&
        authProvider.emailAvailable == true;

    // 로딩 중이 아닌지 확인
    final isNotLoading = !authProvider.isLoading;

    return isAllFieldsFilled && isPasswordMatch && isDuplicateCheckComplete && isNotLoading;
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.login(
      loginId: _idController.text.trim(),
      password: _passwordController.text,
    );

    if (success) {
      if (_keepLoggedIn) {
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool('keepLoggedIn', true);
        prefs.setString('accessToken', authProvider.accessToken ?? '');
        prefs.setString('refreshToken', authProvider.refreshToken ?? '');
        prefs.setString('loginId', _idController.text.trim());
        prefs.setString('password', _passwordController.text);
      }
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.errorMessage ?? '로그인에 실패했습니다.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    // 중복 확인 상태 검증
    if (authProvider.loginIdAvailable != true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('아이디 중복 확인을 완료해주세요.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    if (authProvider.emailAvailable != true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('이메일 중복 확인을 완료해주세요.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final success = await authProvider.signup(
      loginId: _idController.text.trim(),
      password: _passwordController.text,
      nickname: _nicknameController.text.trim(),
      email: _emailController.text.trim(),
    );

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('회원가입이 완료되었습니다. 로그인해주세요.'),
            backgroundColor: Colors.green,
          )
        );
        setState(() {
          _isSignupMode = false;
        });
        authProvider.clearDuplicateCheckStatus();
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.errorMessage ?? '회원가입에 실패했습니다.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [Colors.white, const Color.fromRGBO(241, 248, 255, 1)],
                radius: 0.7,
                stops: const [0.3, 0.7],
              ),
            ),
            child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    // 로고 또는 제목
                    Center(
                      child: Image.asset('assets/images/app_sub.png', width: 200, height: 200),
                    ),
                    const SizedBox(height: 40),
                    
                    // 아이디 입력
                    TextFormField(
                      controller: _idController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromARGB(187, 255, 255, 255),
                        labelText: '아이디',
                        prefixIcon: const Icon(Icons.person),
                        border: const OutlineInputBorder(),
                        suffixIcon: _isSignupMode ? Consumer<AuthProvider>(
                          builder: (context, authProvider, child) {
                            if (authProvider.isCheckingLoginId) {
                              return const SizedBox(
                                width: 20,
                                height: 20,
                                child: Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                              );
                            } else if (authProvider.loginIdAvailable == true) {
                              return const Icon(Icons.check_circle, color: Colors.green);
                            } else if (authProvider.loginIdAvailable == false) {
                              return const Icon(Icons.cancel, color: Colors.red);
                            }
                            return const SizedBox.shrink();
                          },
                        ) : null,
                      ),
                      onChanged: _isSignupMode ? (value) {
                        setState(() {
                          // 버튼 상태 업데이트를 위해 setState 호출
                        });
                        _checkLoginIdDuplicate(value.trim());
                      } : null,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '아이디를 입력해주세요';
                        }
                        if (value.length < 3) {
                          return '아이디는 3자 이상이어야 합니다';
                        }
                        if (_isSignupMode) {
                          final authProvider = Provider.of<AuthProvider>(context, listen: false);
                          if (authProvider.loginIdAvailable == false) {
                            return '이미 사용 중인 아이디입니다';
                          }
                        }
                        return null;
                      },
                    ),
                    // 아이디 중복 확인 메시지
                    if (_isSignupMode) Consumer<AuthProvider>(
                      builder: (context, authProvider, child) {
                        if (authProvider.loginIdCheckMessage != null) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              authProvider.loginIdCheckMessage!,
                              style: TextStyle(
                                color: authProvider.loginIdAvailable == true ? Colors.green : Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // 비밀번호 입력
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: '비밀번호',
                        filled: true,
                        fillColor: const Color.fromARGB(187, 255, 255, 255),
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: _isSignupMode ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // 비밀번호 일치 상태 아이콘 (회원가입 모드에서만)
                            if (_confirmPasswordController.text.isNotEmpty && _passwordController.text.isNotEmpty)
                              Icon(
                                _confirmPasswordController.text == _passwordController.text
                                    ? Icons.check_circle
                                    : Icons.cancel,
                                color: _confirmPasswordController.text == _passwordController.text
                                    ? Colors.green
                                    : Colors.red,
                                size: 20,
                              ),
                            const SizedBox(width: 8),
                            // 비밀번호 표시/숨김 토글
                            IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ],
                        ) : IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: _isSignupMode ? (value) {
                        setState(() {
                          // 상태 업데이트를 위해 setState 호출
                        });
                        // 비밀번호가 변경되면 비밀번호 확인 필드도 다시 검증
                        if (_confirmPasswordController.text.isNotEmpty) {
                          _formKey.currentState?.validate();
                        }
                      } : null,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '비밀번호를 입력해주세요';
                        }
                        if (value.length < 6) {
                          return '비밀번호는 6자 이상이어야 합니다';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // 회원가입 모드일 때만 표시
                    if (_isSignupMode) ...[
                      // 비밀번호 확인 입력
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirmPassword,
                        decoration: InputDecoration(
                          labelText: '비밀번호 확인',
                          filled: true,
                          fillColor: const Color.fromARGB(187, 255, 255, 255),
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // 비밀번호 일치 상태 아이콘
                              if (_confirmPasswordController.text.isNotEmpty)
                                Icon(
                                  _confirmPasswordController.text == _passwordController.text
                                      ? Icons.check_circle
                                      : Icons.cancel,
                                  color: _confirmPasswordController.text == _passwordController.text
                                      ? Colors.green
                                      : Colors.red,
                                  size: 20,
                                ),
                              const SizedBox(width: 8),
                              // 비밀번호 표시/숨김 토글
                              IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirmPassword = !_obscureConfirmPassword;
                                  });
                                },
                              ),
                            ],
                          ),
                          border: const OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            // 상태 업데이트를 위해 setState 호출
                          });
                          // 비밀번호 확인이 변경되면 다시 검증
                          if (_passwordController.text.isNotEmpty) {
                            _formKey.currentState?.validate();
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '비밀번호 확인을 입력해주세요';
                          }
                          if (value != _passwordController.text) {
                            return '비밀번호가 일치하지 않습니다';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // 닉네임 입력
                      TextFormField(
                        controller: _nicknameController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color.fromARGB(187, 255, 255, 255),
                          labelText: '닉네임',
                          prefixIcon: Icon(Icons.badge),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            // 버튼 상태 업데이트를 위해 setState 호출
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '닉네임을 입력해주세요';
                          }
                          if (value.length < 2) {
                            return '닉네임은 2자 이상이어야 합니다';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // 이메일 입력
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: '이메일',
                          filled: true,
                          fillColor: const Color.fromARGB(187, 255, 255, 255),
                          prefixIcon: const Icon(Icons.email),
                          border: const OutlineInputBorder(),
                          suffixIcon: Consumer<AuthProvider>(
                            builder: (context, authProvider, child) {
                              if (authProvider.isCheckingEmail) {
                                return const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  ),
                                );
                              } else if (authProvider.emailAvailable == true) {
                                return const Icon(Icons.check_circle, color: Colors.green);
                              } else if (authProvider.emailAvailable == false) {
                                return const Icon(Icons.cancel, color: Colors.red);
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            // 버튼 상태 업데이트를 위해 setState 호출
                          });
                          _checkEmailDuplicate(value.trim());
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '이메일을 입력해주세요';
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                            return '올바른 이메일 형식을 입력해주세요';
                          }
                          final authProvider = Provider.of<AuthProvider>(context, listen: false);
                          if (authProvider.emailAvailable == false) {
                            return '이미 사용 중인 이메일입니다';
                          }
                          return null;
                        },
                      ),
                      // 이메일 중복 확인 메시지
                      Consumer<AuthProvider>(
                        builder: (context, authProvider, child) {
                          if (authProvider.emailCheckMessage != null) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                authProvider.emailCheckMessage!,
                                style: TextStyle(
                                  color: authProvider.emailAvailable == true ? Colors.green : Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                    
                    // 언어 선택
                    // DropdownButtonFormField<String>(
                    //   value: _selectedLanguage,
                    //   decoration: InputDecoration(
                    //     filled: true,
                    //     fillColor: const Color.fromARGB(187, 255, 255, 255),
                    //     labelText: '언어 선택',
                    //     prefixIcon: Icon(Icons.language),
                    //     border: OutlineInputBorder(),
                    //   ),
                    //   items: _languages.map((String language) {
                    //     return DropdownMenuItem<String>(
                    //       value: language,
                    //       child: Text(language),
                    //     );
                    //   }).toList(),
                    //   onChanged: (String? newValue) {
                    //     setState(() {
                    //       _selectedLanguage = newValue!;
                    //     });
                    //   },
                    // ),
                    // const SizedBox(height: 16),
                    
                    // 로그인 유지 체크박스 (로그인 모드일 때만)
                    if (!_isSignupMode) ...[
                      Row(
                        children: [
                          Checkbox(
                            value: _keepLoggedIn,
                            onChanged: (bool? value) {
                              setState(() {
                                _keepLoggedIn = value!;
                              });
                            },
                          ),
                          const Text('로그인 상태 유지'),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                    
                    // 에러 메시지 표시
                    if (authProvider.errorMessage != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          border: Border.all(color: Colors.red.shade200),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.error, color: Colors.red.shade600, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                authProvider.errorMessage!,
                                style: TextStyle(color: Colors.red.shade600),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    
                    // 로그인/회원가입 버튼
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: authProvider.isLoading 
                            ? null 
                            : (_isSignupMode 
                                ? (_canSignup(authProvider) ? _handleSignup : null)
                                : _handleLogin),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isSignupMode && !_canSignup(authProvider) 
                              ? Colors.grey 
                              : Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: authProvider.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : Text(
                                _isSignupMode ? '회원가입' : '로그인',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // 모드 전환 버튼
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                        onPressed: _toggleMode,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.blue,
                          side: const BorderSide(color: Colors.blue),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          _isSignupMode ? '로그인으로 돌아가기' : '회원가입',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          )
          );
        },
      ),
    );
  }
}
