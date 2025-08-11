enum RequestStatus { pending, approved, rejected, cancelled }

enum RequestType { leave, overtime, attendance, worklog }

// Extension để convert enum to string
extension RequestStatusToString on RequestStatus {
  String toStringValue() {
    switch (this) {
      case RequestStatus.pending:
        return 'pending';
      case RequestStatus.approved:
        return 'approved';
      case RequestStatus.rejected:
        return 'rejected';
      case RequestStatus.cancelled:
        return 'cancelled';
    }
  }
}

extension RequestTypeToString on RequestType {
  String toStringValue() {
    switch (this) {
      case RequestType.leave:
        return 'leave';
      case RequestType.overtime:
        return 'overtime';
      case RequestType.attendance:
        return 'attendance';
      case RequestType.worklog:
        return 'worklog';
    }
  }
}

// Extension để convert string to enum
extension StringToRequestStatus on String {
  RequestStatus toRequestStatus() {
    switch (this.toLowerCase()) {
      case 'pending':
      case 'sent': // Map 'sent' to 'pending' for backward compatibility
        return RequestStatus.pending;
      case 'approved':
        return RequestStatus.approved;
      case 'rejected':
        return RequestStatus.rejected;
      case 'cancelled':
        return RequestStatus.cancelled;
      default:
        return RequestStatus.pending;
    }
  }
}

extension StringToRequestType on String {
  RequestType toRequestType() {
    switch (this.toLowerCase()) {
      case 'leave':
        return RequestType.leave;
      case 'overtime':
        return RequestType.overtime;
      case 'attendance':
        return RequestType.attendance;
      case 'worklog':
        return RequestType.worklog;
      default:
        return RequestType.leave;
    }
  }
}
