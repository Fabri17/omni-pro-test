import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:omni_pro_test/models/photo_model.dart';
import 'package:omni_pro_test/screens/home/widgets/background_image.dart';
import 'package:omni_pro_test/screens/home/widgets/photo_item.dart';

void main() {
  testWidgets('PhotoItem widget test', (WidgetTester tester) async {
    // Create a mock photo
    final photo = Photo(
      id: 1,
      title: 'Photo 1',
      url: 'https://via.placeholder.com/150',
      thumbnailUrl: 'https://via.placeholder.com/150',
      albumId: 100,
    );

    // Create a mock function
    bool onTapCalled = false;
    void onTap() {
      onTapCalled = true;
    }

    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PhotoItem(
            photo: photo,
            onTap: onTap,
            isSelected: false,
          ),
        ),
      ),
    );

    // Verify the widget is displayed
    expect(find.byType(PhotoItem), findsOneWidget);

    // Verify the image is displayed
    expect(find.byType(CachedNetworkImage), findsOneWidget);

    // Tap the widget
    await tester.tap(find.byType(PhotoItem));

    // Wait for animations to complete
    await tester.pumpAndSettle();

    // Verify onTap is called
    expect(onTapCalled, true);
  });

  group('BackgroundImage widget', () {
    testWidgets('should display the correct image',
        (WidgetTester tester) async {
      // Arrange
      const imageUrl = 'https://via.placeholder.com/150';
      const widget = MaterialApp(
        home: BackgroundImage(url: imageUrl),
      );

      // Act
      await tester.pumpWidget(widget);

      // Assert
      final cachedNetworkImageFinder = find.byType(CachedNetworkImage);
      expect(cachedNetworkImageFinder, findsOneWidget);
      final cachedNetworkImageWidget =
          tester.widget<CachedNetworkImage>(cachedNetworkImageFinder);
      expect(cachedNetworkImageWidget.imageUrl, imageUrl);
    });

    testWidgets('should display a placeholder while loading',
        (WidgetTester tester) async {
      // Arrange
      const imageUrl = 'https://via.placeholder.com/150';
      const widget = MaterialApp(
        home: BackgroundImage(url: imageUrl),
      );

      // Act
      await tester.pumpWidget(widget);

      // Assert
      final placeholderFinder = find.byType(Container);
      expect(placeholderFinder, findsOneWidget);
      final placeholderWidget = tester.widget<Container>(placeholderFinder);
      expect(placeholderWidget.color, equals(Colors.grey[300]));
    });
  });
}
