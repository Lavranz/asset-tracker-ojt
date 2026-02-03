import 'package:apollo_tracker_mobile/commons/forms/users.form.dart';
import 'package:apollo_tracker_mobile/commons/services/auth.service.dart';
import 'package:apollo_tracker_mobile/commons/services/toast.service.dart';
import 'package:apollo_tracker_mobile/commons/utils/image.util.dart';
import 'package:apollo_tracker_mobile/theme/colors.dart';
import 'package:apollo_tracker_mobile/widgets/custom_image_view.dart';
import 'package:apollo_tracker_mobile/widgets/custom_inputs.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:apollo_tracker_mobile/theme/texts.dart';
import 'package:go_router/go_router.dart';
import "package:fl_query_hooks/fl_query_hooks.dart";
import 'package:reactive_forms/reactive_forms.dart';

LoginForm loginForm = LoginForm();

class LoginPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    // Hook state variables for the email and password
    useEffect(() {
      loginForm.form.reset();
      return () => {loginForm.form.reset()};
    }, []);

    final loginMutation = useMutation(
      'login',
      (data) => auth$.login(data),
      onData: (data, revData) async {
        await auth$.setToken(data.agent.agentCode);
        GoRouter.of(context).go('/tickets');
      },
      onError: (DioException error, recoveryData) {
        if (error.response!.data != null) {
          final Map<String, dynamic> errors = error.response!.data;
          loginForm.setFormErrors(errors);

          if (errors.containsKey('status')) {
            dangerNativeToast(errors['status']['message'] ?? '');
          }
        }
      },
    );

    submit() async {
      if (loginForm.form.invalid) {
        loginForm.form.markAllAsTouched();
        return;
      }
      loginMutation.mutate(loginForm.form.value);
      FocusScope.of(context).unfocus();
    }

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomImageView(
                      imagePath: IconConstant.logo,
                      width: 218.3,
                      height: 26.49,
                    ),
                    const SizedBox(height: 20),
                    Text("Login your account",
                        style: AppTextTheme.H4SemiBoldPrimary),
                    Text("Enter your email and password to continue.",
                        style: AppTextTheme.BodySmSecondary)
                  ],
                ),
                const SizedBox(height: 32),
                ReactiveForm(
                  formGroup: loginForm.form,
                  child: const Column(
                    children: [
                      ReactiveTextInput(
                        label: 'Email or username',
                        formControlName: 'username',
                        hintText: 'Enter your email or username',
                      ),
                      SizedBox(height: 32),
                      ReactiveTextInput(
                        label: 'Password',
                        formControlName: 'password',
                        hintText: 'Enter your password',
                        obscureText: true,
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: loginMutation.isMutating ? null : submit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 0),
                    backgroundColor: AppColors.primary500,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: loginMutation.isMutating
                      ? const SizedBox(
                          width: 20.0,
                          height: 20.0,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text('Login', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ));
  }
}
