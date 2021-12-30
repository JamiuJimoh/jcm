class PDF {
  final String pdfID;
  final String title;
  final String url;
  final String classworkItemID;
  PDF({
    required this.pdfID,
    required this.title,
    required this.url,
    required this.classworkItemID,
  });

  factory PDF.fromJson(Map<String, dynamic> data, String documentId) {
    return PDF(
      pdfID: documentId,
      title: data['title'],
      url: data['url'],
      classworkItemID: data['classworkItemID'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'pdfID': pdfID,
      'title': title,
      'url': url,
      'classworkItemID': classworkItemID,
    };
  }
}
