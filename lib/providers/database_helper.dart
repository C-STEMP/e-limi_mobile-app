import 'dart:io';
import 'package:elimiafrica/models/course_db_model.dart';
import 'package:elimiafrica/models/section_db_model.dart';
import 'package:elimiafrica/models/video_db_model.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'offline.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE video_list(
          id INTEGER PRIMARY KEY,
          title TEXT,
          path TEXT,
          lesson_id INTEGER,
          course_id INTEGER,
          section_id INTEGER,
          course_title TEXT,
          section_title TEXT,
          thumbnail TEXT,
          download_id TEXT
      )
      ''');
    await db.execute('''
      CREATE TABLE course_list(
          id INTEGER PRIMARY KEY,
          course_id INTEGER,
          course_title TEXT,
          thumbnail TEXT
      )
      ''');
    await db.execute('''
      CREATE TABLE section_list(
          id INTEGER PRIMARY KEY,
          course_id INTEGER,
          section_id INTEGER,
          section_title TEXT
      )
      ''');
  }

  Future<List<VideoModel>> getVideos() async {
    Database db = await instance.database;
    var videos = await db.query('video_list', orderBy: 'title');
    List<VideoModel> videoList = videos.isNotEmpty
        ? videos.map((c) => VideoModel.fromMap(c)).toList()
        : [];
    return videoList;
  }

  Future<List<Map<String, dynamic>>> queryAllRows(table) async {
    Database db = await instance.database;
    var result = await db.query(table);
    return result.toList();
  }

  Future<int> addVideo(VideoModel video) async {
    Database db = await instance.database;
    return await db.insert('video_list', video.toMap());
  }

  Future<int> removeVideo(int id) async {
    Database db = await instance.database;
    return await db.delete('video_list', where: 'id = ?', whereArgs: [id]);
  }

  Future<bool> lessonExists(id) async {
    dynamic result;
    int? exists;
    if (_database != null) {
      result = await _database!.rawQuery(
        'SELECT EXISTS(SELECT * FROM video_list WHERE lesson_id="$id")',
      );
      exists = Sqflite.firstIntValue(result);
    } else {
      exists = 0;
    }
    return exists == 1;
  }

  // Future<int> update(VideoModel grocery) async {
  //   Database db = await instance.database;
  //   return await db.update('groceries', grocery.toMap(),
  //       where: "id = ?", whereArgs: [grocery.id]);
  // }

  Future<List<CourseDbModel>> getCourse() async {
    Database db = await instance.database;
    var courses = await db.query('course_list', orderBy: 'id');
    List<CourseDbModel> courseList = courses.isNotEmpty
        ? courses.map((c) => CourseDbModel.fromMap(c)).toList()
        : [];
    return courseList;
  }

  Future<int> addCourse(CourseDbModel course) async {
    Database db = await instance.database;
    return await db.insert('course_list', course.toMap());
  }

  Future<int> removeCourse(id) async {
    Database db = await instance.database;
    return await db
        .delete('course_list', where: 'course_id = ?', whereArgs: [id]);
  }

  Future<bool> courseExists(id) async {
    var result = await _database!.rawQuery(
      'SELECT EXISTS(SELECT * FROM course_list WHERE course_id="$id")',
    );
    int? exists = Sqflite.firstIntValue(result);
    return exists == 1;
  }

  Future<bool> courseExist(id) async {
    dynamic result;
    int? exists;
    if (_database != null) {
      result = await _database!.rawQuery(
        'SELECT EXISTS(SELECT * FROM video_list WHERE course_id="$id")',
      );
      exists = Sqflite.firstIntValue(result);
    } else {
      exists = 0;
    }
    return exists == 1;
  }

  //Section_List

  Future<List<SectionDbModel>> getSection(id) async {
    Database db = await instance.database;
    var sections =
        await db.query('section_list', orderBy: 'id', where: 'course_id = $id');
    List<SectionDbModel> sectionList = sections.isNotEmpty
        ? sections.map((c) => SectionDbModel.fromMap(c)).toList()
        : [];
    return sectionList;
  }

  Future<List<Map<String, dynamic>>> queryAllSections(id) async {
    Database db = await instance.database;
    var result =
        await db.query('section_list', orderBy: 'id', where: 'course_id = $id');
    return result.toList();
  }

  Future<int> addSection(SectionDbModel section) async {
    Database db = await instance.database;
    return await db.insert('section_list', section.toMap());
  }

  Future<int> removeSection(id) async {
    Database db = await instance.database;
    return await db
        .delete('section_list', where: 'section_id = ?', whereArgs: [id]);
  }

  Future<bool> sectionExists(id) async {
    var result = await _database!.rawQuery(
      'SELECT EXISTS(SELECT * FROM section_list WHERE section_id="$id")',
    );
    int? exists = Sqflite.firstIntValue(result);
    return exists == 1;
  }

  Future<bool> sectionExist(id) async {
    dynamic result;
    int? exists;
    if (_database != null) {
      result = await _database!.rawQuery(
        'SELECT EXISTS(SELECT * FROM video_list WHERE section_id="$id")',
      );
      exists = Sqflite.firstIntValue(result);
    } else {
      exists = 0;
    }
    return exists == 1;
  }
}
