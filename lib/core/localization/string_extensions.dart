import 'package:easy_localization/easy_localization.dart';

extension CustomStringTranslateExtension on String {
  String get translate => this.tr();
  String translateArgs(List<String> args) => this.tr(args: args);
  String translateGender(String gender) => this.tr(gender: gender);
  String translatePlural(int pluralValue, {String? name}) => this.tr();
  String translateNamedArgs(Map<String, String> namedArgs) => this.tr(namedArgs: namedArgs);
}
