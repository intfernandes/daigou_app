// 成功回调
import 'dart:io';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/events/un_authenticate_event.dart';
import 'package:jiyun_app_client/models/model.dart';
import 'package:jiyun_app_client/storage/user_storage.dart';
import 'package:dio/dio.dart';
import 'package:jiyun_app_client/common/http_response.dart';
import 'package:jiyun_app_client/exceptions/bad_request_exception.dart';
import 'package:jiyun_app_client/exceptions/bad_service_exception.dart';
import 'package:jiyun_app_client/exceptions/cancel_exception.dart';
import 'package:jiyun_app_client/exceptions/http_exception.dart';
import 'package:jiyun_app_client/exceptions/network_exception.dart';
import 'package:jiyun_app_client/exceptions/unauthorised_exception.dart';
import 'package:jiyun_app_client/exceptions/unknown_exception.dart';
import 'package:jiyun_app_client/transformer/default_http_transformer.dart';
import 'package:provider/provider.dart';
import 'http_transformer.dart';

//解析处理响应
HttpResponse handleResponse(Response? response,
    {HttpTransformer? httpTransformer}) {
  httpTransformer ??= DefaultHttpTransformer.getInstance();

  // 返回值异常
  if (response == null) {
    return HttpResponse.failureFromError();
  }

  // token失效
  if (_isTokenTimeout(response.statusCode)) {
    return HttpResponse.failureFromError(
        UnauthorisedException(message: "没有权限", code: response.statusCode));
  }
  // 接口调用成功
  if (_isRequestSuccess(response.statusCode)) {
    return httpTransformer.parse(response);
  } else {
    // 接口调用失败
    return HttpResponse.failure(
        errorMsg: response.statusMessage, errorCode: response.statusCode);
  }
}

HttpResponse handleException(Exception exception) {
  var parseException = _parseException(exception);
  if (parseException is UnauthorisedException) {
    // token 失效
    ApplicationEvent.getInstance().event.fire(UnAuthenticateEvent());
  } else if (parseException is NetworkException) {
    EasyLoading.showError('网络错误, 请重试');
  }
  return HttpResponse.failureFromError(parseException);
}

/// 鉴权失败
bool _isTokenTimeout(int? code) {
  return code == 401;
}

/// 请求成功
bool _isRequestSuccess(int? statusCode) {
  return (statusCode != null && statusCode >= 200 && statusCode < 300);
}

HttpException _parseException(Exception error) {
  if (error is DioError) {
    switch (error.type) {
      case DioErrorType.connectTimeout:
      case DioErrorType.receiveTimeout:
      case DioErrorType.sendTimeout:
        return NetworkException(message: error.message);
      case DioErrorType.cancel:
        return CancelException(error.message);
      case DioErrorType.response:
        try {
          int? errCode = error.response?.statusCode;
          switch (errCode) {
            case 400:
              return BadRequestException(message: "请求语法错误", code: errCode);
            case 401:
              return UnauthorisedException(message: "没有权限", code: errCode);
            case 403:
              return BadRequestException(message: "服务器拒绝执行", code: errCode);
            case 404:
              return BadRequestException(message: "无法连接服务器", code: errCode);
            case 405:
              return BadRequestException(message: "请求方法被禁止", code: errCode);
            case 500:
              return BadServiceException(message: "服务器内部错误", code: errCode);
            case 502:
              return BadServiceException(message: "无效的请求", code: errCode);
            case 503:
              return BadServiceException(message: "服务器挂了", code: errCode);
            case 505:
              return UnauthorisedException(
                  message: "不支持HTTP协议请求", code: errCode);
            default:
              return UnknownException(error.message);
          }
        } on Exception catch (_) {
          return UnknownException(error.message);
        }

      case DioErrorType.other:
        if (error.error is SocketException) {
          return NetworkException(message: error.message);
        } else {
          return UnknownException(error.message);
        }
      default:
        return UnknownException(error.message);
    }
  } else {
    return UnknownException(error.toString());
  }
}
