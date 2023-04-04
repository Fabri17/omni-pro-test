import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:omni_pro_test/models/photo_model.dart';
import 'package:omni_pro_test/services/photos_services.dart';

void main() {
  group('PhotosService', () {
    late PhotosService photosService;

    setUp(() {
      final client = MockClient((request) async {
        if (request.url.toString() ==
            'https://jsonplaceholder.typicode.com/photos?_page=1&_limit=10') {
          return http.Response(
            jsonEncode([
              {
                "albumId": 1,
                "id": 1,
                "title": "accusamus beatae ad facilis cum similique qui sunt",
                "url": "https://via.placeholder.com/600/92c952",
                "thumbnailUrl": "https://via.placeholder.com/150/92c952"
              },
              {
                "albumId": 1,
                "id": 2,
                "title": "reprehenderit est deserunt velit ipsam",
                "url": "https://via.placeholder.com/600/771796",
                "thumbnailUrl": "https://via.placeholder.com/150/771796"
              },
              {
                "albumId": 1,
                "id": 3,
                "title": "officia porro iure quia iusto qui ipsa ut modi",
                "url": "https://via.placeholder.com/600/24f355",
                "thumbnailUrl": "https://via.placeholder.com/150/24f355"
              }
            ]),
            200,
          );
        } else {
          return http.Response('Not found', 404);
        }
      });

      photosService = PhotosService(client);
    });

    test('getPhotos returns a list of photos', () async {
      final photos = await photosService.getPhotos(1);

      expect(photos, isA<List<Photo>>());
      expect(photos.length, equals(3));
      expect(photos[0].id, equals(1));
      expect(photos[0].title,
          equals('accusamus beatae ad facilis cum similique qui sunt'));
    });

    test('getPhotos throws an exception when the server returns an error',
        () async {
      try {
        await photosService.getPhotos(2);
      } catch (e) {
        expect(e, isA<Exception>());
        expect(e.toString(), equals('Exception: Error al cargar las fotos'));
      }
    });
  });
}
