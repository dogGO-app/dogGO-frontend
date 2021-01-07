import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Testing regular expressions for email validation', () {
    final _emailRegexp = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$",
        caseSensitive: false, multiLine: false);

    final String exampleValidEmail = 'admin@gmail.pl';
    final String exampleInvalidEmail = 'adminwp.pl';
    final String exampleInvalidEmail2 = 'admin@wppl';

    expect(_emailRegexp.hasMatch(exampleValidEmail), true);
    expect(_emailRegexp.hasMatch(exampleInvalidEmail), false);
    expect(_emailRegexp.hasMatch(exampleInvalidEmail2), false);
  });

  test('Testing password regular expression for password validation', () {
    final _passwordRegexp = RegExp(
        r"^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,128}$",
        caseSensitive: true,
        multiLine: false);

    final String exampleValidPassword = 'PAssword123';
    final String exampleInvalidPassword = 'abcde';
    final String exampleInvalidPassword2 = 'abcdefghi1';

    expect(_passwordRegexp.hasMatch(exampleValidPassword), true);
    expect(_passwordRegexp.hasMatch(exampleInvalidPassword), false);
    expect(_passwordRegexp.hasMatch(exampleInvalidPassword2), false);
  });
}