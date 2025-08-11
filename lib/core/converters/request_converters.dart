import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:timesheet_project/core/enums/request_enums.dart';

class RequestStatusConverter implements JsonConverter<RequestStatus, String> {
  const RequestStatusConverter();

  @override
  RequestStatus fromJson(String status) {
    return status.toRequestStatus();
  }

  @override
  String toJson(RequestStatus status) {
    return status.toStringValue();
  }
}

class RequestTypeConverter implements JsonConverter<RequestType, String> {
  const RequestTypeConverter();

  @override
  RequestType fromJson(String type) {
    return type.toRequestType();
  }

  @override
  String toJson(RequestType type) {
    return type.toStringValue();
  }
}
