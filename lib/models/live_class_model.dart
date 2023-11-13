class LiveClassModel {
  ZoomLiveClassDetails? zoomLiveClassDetails;
  String? meetingInviteLink;

  LiveClassModel({this.zoomLiveClassDetails, this.meetingInviteLink});

  LiveClassModel.fromJson(Map<String, dynamic> json) {
    zoomLiveClassDetails = json['zoom_live_class_details'] != null
        ? ZoomLiveClassDetails.fromJson(json['zoom_live_class_details'])
        : null;
    meetingInviteLink = json['meeting_invite_link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (zoomLiveClassDetails != null) {
      data['zoom_live_class_details'] = zoomLiveClassDetails!.toJson();
    }
    data['meeting_invite_link'] = meetingInviteLink;
    return data;
  }
}

class ZoomLiveClassDetails {
  String? id;
  String? courseId;
  String? date;
  String? time;
  String? zoomMeetingId;
  String? zoomMeetingPassword;
  String? noteToStudents;
  String? meetingInviteLink;

  ZoomLiveClassDetails(
      {this.id,
      this.courseId,
      this.date,
      this.time,
      this.zoomMeetingId,
      this.zoomMeetingPassword,
      this.noteToStudents,
      this.meetingInviteLink});

  ZoomLiveClassDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    courseId = json['course_id'];
    date = json['date'];
    time = json['time'];
    zoomMeetingId = json['zoom_meeting_id'];
    zoomMeetingPassword = json['zoom_meeting_password'];
    noteToStudents = json['note_to_students'];
    meetingInviteLink = json['meeting_invite_link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['course_id'] = courseId;
    data['date'] = date;
    data['time'] = time;
    data['zoom_meeting_id'] = zoomMeetingId;
    data['zoom_meeting_password'] = zoomMeetingPassword;
    data['note_to_students'] = noteToStudents;
    data['meeting_invite_link'] = meetingInviteLink;
    return data;
  }
}

// class LiveClassModel {
//   ZoomLiveClassDetails? zoomLiveClassDetails;
//   String? zoomApiKey;
//   String? zoomSecretKey;

//   LiveClassModel(
//       {this.zoomLiveClassDetails, this.zoomApiKey, this.zoomSecretKey});

//   LiveClassModel.fromJson(Map<String, dynamic> json) {
//     zoomLiveClassDetails = json['zoom_live_class_details'] != null
//         ? ZoomLiveClassDetails.fromJson(json['zoom_live_class_details'])
//         : null;
//     zoomApiKey = json['zoom_api_key'];
//     zoomSecretKey = json['zoom_secret_key'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     if (zoomLiveClassDetails != null) {
//       data['zoom_live_class_details'] = zoomLiveClassDetails!.toJson();
//     }
//     data['zoom_api_key'] = zoomApiKey;
//     data['zoom_secret_key'] = zoomSecretKey;
//     return data;
//   }
// }

// class ZoomLiveClassDetails {
//   String? id;
//   String? courseId;
//   String? date;
//   String? time;
//   String? zoomMeetingId;
//   String? zoomMeetingPassword;
//   String? noteToStudents;

//   ZoomLiveClassDetails(
//       {this.id,
//       this.courseId,
//       this.date,
//       this.time,
//       this.zoomMeetingId,
//       this.zoomMeetingPassword,
//       this.noteToStudents});

//   ZoomLiveClassDetails.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     courseId = json['course_id'];
//     date = json['date'];
//     time = json['time'];
//     zoomMeetingId = json['zoom_meeting_id'];
//     zoomMeetingPassword = json['zoom_meeting_password'];
//     noteToStudents = json['note_to_students'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['course_id'] = courseId;
//     data['date'] = date;
//     data['time'] = time;
//     data['zoom_meeting_id'] = zoomMeetingId;
//     data['zoom_meeting_password'] = zoomMeetingPassword;
//     data['note_to_students'] = noteToStudents;
//     return data;
//   }
// }
