import 'dart:io';

///
///
///
class HttpService {
  final HttpClient client = HttpClient()
    ..badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);

  ///
  ///
  ///
  HttpService();

  ///
  ///
  ///
  Future<HttpClientResponse> get(Uri uri) async {
    final HttpClientRequest request = await client.getUrl(uri);
    return request.close();
  }

  ///
  ///
  ///
  void close() {
    client.close();
  }
}
