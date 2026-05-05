import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xvibe_offline_mp3_player/utils/app_text_theme.dart';
import 'package:xvibe_offline_mp3_player/view%20models/browse_vibe_view_model.dart';
import 'package:xvibe_offline_mp3_player/widgets/browse/browse_catalog_grid_view.dart';
import 'package:xvibe_offline_mp3_player/widgets/browse/browse_search_song_list_view.dart';

class BrowsePage extends StatefulWidget {
  const BrowsePage({super.key});

  @override
  State<BrowsePage> createState() => _BrowsePageState();
}

class _BrowsePageState extends State<BrowsePage> {
  final ValueNotifier<String> _text = ValueNotifier('');
  Timer? _debounce;
  final FocusNode _focusNode = FocusNode();
  bool _isFocus= false;

  void debounce(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      _text.value = value;
    });
  }

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
        setState(() {
          _isFocus = _focusNode.hasFocus;
        });
      }
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text("Browse", style: Theme.of(context).textTheme.pageLabel),
          backgroundColor: Colors.black,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  focusNode: _focusNode,
                  onChanged: (value) => debounce(value),
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.search),
                    hintText: "What do you want to listen to?",
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                ValueListenableBuilder(
                  valueListenable: _text,
                  builder: (_, value, _) {
                    if (!_isFocus && value.isEmpty) return BrowseCatalogGridView();

                    if (value.isEmpty || !context.mounted) return SizedBox.shrink();

                    // ignore: use_build_context_synchronously
                    Future.microtask(() async => context.read<BrowseVibeViewModel>().getSongsIdWithTitle(value));
                    return BrowseSearchSongListView();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
