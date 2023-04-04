import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../providers/photos_provider.dart';
import 'widgets/background_image.dart';
import 'widgets/photo_item.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        var provider = Provider.of<PhotosProvider>(context, listen: false);
        provider.loadMorePhotos();

        _scrollController.addListener(() {
          if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent) {
            provider.incrementPage();
            provider.loadMorePhotos();
          }
        });
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var photosProvider = Provider.of<PhotosProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            BackgroundImage(url: photosProvider.selectedPhoto?.url ?? ''),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    photosProvider.selectedPhoto?.title.toUpperCase() ?? '',
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    textAlign: TextAlign.start,
                  ),
                  const Spacer(),
                  Text(
                    "Fotos (${photosProvider.isLoading ? 'Cargando...' : photosProvider.photos.length})",
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    textAlign: TextAlign.start,
                  ),
                  if (photosProvider.error.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: Text(
                        photosProvider.error,
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      clipBehavior: Clip.none,
                      separatorBuilder: (context, index) => const SizedBox(
                        width: 16,
                      ),
                      shrinkWrap: true,
                      itemCount: photosProvider.photos.length,
                      controller: _scrollController,
                      itemBuilder: (context, index) => PhotoItem(
                        photo: photosProvider.photos[index],
                        isSelected: photosProvider.selectedPhoto ==
                            photosProvider.photos[index],
                        onTap: () => photosProvider.selectPhoto(
                          photosProvider.photos[index],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
