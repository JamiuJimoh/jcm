class PDFs {
  final String pdf;
  final String materialID;
  PDFs({
    required this.pdf,
    required this.materialID,
  });

  factory PDFs.fromJson(Map<String, dynamic> data) {
    return PDFs(
      pdf: data['pdf'],
      materialID: data['materialID'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'pdf': pdf,
      'materialID': materialID,
    };
  }
}
