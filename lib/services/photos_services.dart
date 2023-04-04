import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/photo_model.dart';

class PhotosService {
  final baseUrl = 'https://jsonplaceholder.typicode.com';

  final http.Client client;

  PhotosService(this.client);

  Future<List<Photo>> getPhotos(int page) async {
    try {
      final url = Uri.parse('$baseUrl/photos?_page=$page&_limit=10');
      final response = await client.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> body = jsonDecode(response.body);
        final List<Photo> photos =
            body.map((dynamic item) => Photo.fromJson(item)).toList();
        return photos;
      }

      throw Exception('Error al cargar las fotos');
    } on Exception catch (_) {
      throw Exception('Error al cargar las fotos');
    }
  }
}
