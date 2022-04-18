class UserModel {
  String? id;
  String? status;
  String? GPS;
  String? time;
  String? type;
  String? battery;
  UserModel(this.id, this.status, this.GPS, this.time, this.type, this.battery);
  factory UserModel.fromJson(dynamic json) {
    return UserModel(
        json['ID'] as String?,
        json['Status'] as String?,
        json['GPS'] as String?,
        json['Time'] as String?,
        json['Type'] as String?,
        json['Battery'] as String?);
  }
  @override
  String toString() {
    return '{ ${this.id}, ${this.status}, ${this.GPS}, ${this.time}, ${this.type}, ${this.battery} }';
  }
}
