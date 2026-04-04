import 'package:flutter/material.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:xvibe_offline_mp3_player/data/application_database.dart';
import 'package:xvibe_offline_mp3_player/data/contracts/i_playlist_repository.dart';
import 'package:xvibe_offline_mp3_player/models/playlist.dart';

class PlaylistRepository implements IPlaylistRepository {
  late final Future<Database> _db;
  final String tablePlaylist = "playlist";

  PlaylistRepository({required ApplicationDatabase appDb}) {
    _db = appDb.database;
  }

  @override
  Future<void> add(Playlist playlist) async {
    final db = await _db;

    await db.insert(tablePlaylist, playlist.toMap());
  }

  @override
  Future<List<Playlist>> getAll() async {
    final db = await _db;
    final List<dynamic> playlist = await db.query(tablePlaylist);
    
    return playlist.map((plylst) => Playlist.toObject(plylst)).toList();
  }

  @override
  Future<Playlist> get(String id) async {
    final db = await _db;
    final playlist = await db.query(
                  tablePlaylist, 
                  where: "id = ?", 
                  whereArgs: [id]
                ); 

    if (playlist.isNotEmpty) return Playlist.toObject(playlist.first);

    return Playlist(
      id: "No Id",
      name: "No Name", 
      backgroundColor: Colors.white
    );
  }

  @override
  Future<void> update(String id, Playlist playlist) async {
    final db = await _db;

    await db.update(
      tablePlaylist, 
      playlist.toMap(),
      where: "id = ?",
      whereArgs: [id]
    );
  }

  @override
  Future<void> delete(String id) async {
    final db = await _db;

    await db.delete(
      tablePlaylist, 
      where: "id = ?",
      whereArgs: [id]
    );
  }
}