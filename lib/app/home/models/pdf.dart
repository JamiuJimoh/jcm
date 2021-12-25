class PDF {
  final String pdfID;
  final String pdf;
  final String materialID;
  PDF({
    required this.pdfID,
    required this.pdf,
    required this.materialID,
  });

  factory PDF.fromJson(Map<String, dynamic> data, String documentId) {
    return PDF(
      pdfID: documentId,
      pdf: data['pdf'],
      materialID: data['materialID'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'pdfID': pdfID,
      'pdf': pdf,
      'materialID': materialID,
    };
  }
}
