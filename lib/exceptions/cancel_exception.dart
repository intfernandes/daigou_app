import 'package:jiyun_app_client/exceptions/http_exception.dart';

class CancelException extends HttpException {
  CancelException([String? message]) : super(message);
}
