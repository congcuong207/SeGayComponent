/// Model class for Asset data
class AssetModel {
  final String assetId;
  final String assetName;
  final DateTime? registrationDate;
  final DateTime? useDate;
  final String department;
  final String childAssetCount;
  final String assetAppendixCount;
  final String note;
  final String assetAccount;
  final String project;
  final String assetModel;
  final String originalPrice;
  final String initialDepreciationValue;
  final String initialDepreciationPeriod;
  final String initialRemainingValue;
  final String incurredDepreciationValue;
  final String incurredDepreciationPeriod;
  final String remainingDepreciationValue;
  final String remainingDepreciationPeriod;

  AssetModel({
    required this.assetId,
    required this.assetName,
    this.registrationDate,
    this.useDate,
    required this.department,
    required this.childAssetCount,
    required this.assetAppendixCount,
    required this.note,
    required this.assetAccount,
    required this.project,
    required this.assetModel,
    required this.originalPrice,
    required this.initialDepreciationValue,
    required this.initialDepreciationPeriod,
    required this.initialRemainingValue,
    required this.incurredDepreciationValue,
    required this.incurredDepreciationPeriod,
    required this.remainingDepreciationValue,
    required this.remainingDepreciationPeriod,
  });

  factory AssetModel.fromCsv(Map<String, dynamic> map) {
    DateTime? parseDate(String dateStr) {
      if (dateStr.isEmpty) return null;
      try {
        return DateTime.parse(dateStr);
      } catch (e) {
        return null;
      }
    }

    return AssetModel(
      assetId: map['Mã tài sản'] ?? '',
      assetName: map['Tên tài sản'] ?? '',
      registrationDate: parseDate(map['Ngày vào sổ'] ?? ''),
      useDate: parseDate(map['Ngày sử dụng'] ?? ''),
      department: map['Đơn vị sử dụng'] ?? '',
      childAssetCount: map['Số lượng TS con'] ?? '',
      assetAppendixCount: map['Số lượng Phụ lục ts'] ?? '',
      note: map['Ghi chú'] ?? '',
      assetAccount: map['Tài khoản tài sản'] ?? '',
      project: map['Dự án'] ?? '',
      assetModel: map['Mô hình tài sản'] ?? '',
      originalPrice: map['Nguyên giá tài sản'] ?? '',
      initialDepreciationValue: map['Giá trị Khấu hao ban đầu'] ?? '',
      initialDepreciationPeriod: map['Kỳ khấu hao ban đầu'] ?? '',
      initialRemainingValue: map['GTCL ban đầu'] ?? '',
      incurredDepreciationValue: map['Giá trị Khấu hao phát sinh'] ?? '',
      incurredDepreciationPeriod: map['Kỳ khấu hao phát sinh'] ?? '',
      remainingDepreciationValue: map['Giá trị khấu hao còn lại'] ?? '',
      remainingDepreciationPeriod: map['Kỳ khấu hao còn lại'] ?? '',
    );
  }
} 