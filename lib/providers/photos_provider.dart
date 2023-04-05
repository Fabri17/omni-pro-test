import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/photo_model.dart';
import '../services/photos_services.dart';

class PhotosProvider with ChangeNotifier {
  final PhotosService _photosService = PhotosService(http.Client());

  final List<Photo> _photos = [];
  Photo? _selectedPhoto;
  int _currentPage = 1;
  bool _isLoading = false;
  String _error = '';

  List<Photo> get photos => _photos;
  Photo? get selectedPhoto => _selectedPhoto;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> loadMorePhotos() async {
    try {
      if (_isLoading) return;

      _isLoading = true;

      notifyListeners();

      final List<Photo> newPhotos = await _photosService.getPhotos(
        _currentPage,
      );

      _photos.addAll(newPhotos);
      _isLoading = false;

      if (_currentPage == 1 && _photos.isNotEmpty) {
        selectPhoto(_photos.first);
      }

      _currentPage++;
      _error = '';
      notifyListeners();
    } catch (e) {
      _error = e.toString().substring(11);
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectPhoto(Photo photo) {
    if (photo != selectedPhoto) {
      _selectedPhoto = photo;
      notifyListeners();
    }
  }

  //Increment current page
  void incrementPage() {
    _currentPage++;
    notifyListeners();
  }
}
