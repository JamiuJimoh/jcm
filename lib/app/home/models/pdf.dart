class PDF {
  final String pdfID;
  final String title;
  final String url;
  final String materialID;
  PDF({
    required this.pdfID,
    required this.title,
    required this.url,
    required this.materialID,
  });

  factory PDF.fromJson(Map<String, dynamic> data, String documentId) {
    return PDF(
      pdfID: documentId,
      title: data['title'],
      url: data['url'],
      materialID: data['materialID'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'pdfID': pdfID,
      'title': title,
      'url': url,
      'materialID': materialID,
    };
  }
}
