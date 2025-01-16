class LabApplication {
  final String? labNameTH;
  final String? labNameEN;
  final String? labResultCode;
  final String? labType;
  final String? labMax;

  LabApplication({
    this.labNameTH,
    this.labNameEN,
    this.labResultCode,
    this.labType,
    this.labMax,
  });

  factory LabApplication.fromJson(Map<String, dynamic> json) {
    return LabApplication(
      labNameTH: json['LabNameTH'] as String?,
      labNameEN: json['LabNameEN'] as String?,
      labResultCode: json['LabResultCode'] as String?,
      labType: json['LabType'] as String?,
      labMax: json['LabMax'] as String?,
    );
  }
}
