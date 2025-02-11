import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbServices {
  static DbServices dbServices = DbServices._();

  DbServices._();

  Database? _database;

  Future<Database> get database async => _database ?? await initDatabase();

  Future<Database> initDatabase() async {
    final path = await getDatabasesPath();
    final dbPath = join(path, 'voice.db');
    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        String sql = '''
        CREATE TABlE voice (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        filePath TEXT NOT NULL,
        title TEXT NOT NULL,
        date TEXT NOT NULL,
        time TEXT NOT NULL,
        duration TEXT NOT NULL
        )
        ''';
        await db.execute(sql);
      },
    );
  }

  Future<int> addDataInDatabase(String filePath, String title, String date,
      String time, String duration) async {
    final db = await database;
    String sql = '''
    INSERT INTO voice (
    filePath,title,date,time,duration
    ) VALUES (?,?,?,?,?)
    ''';
    List args = [filePath, title, date, time, duration];
    return await db.rawInsert(sql, args);
  }

  Future<List<Map<String, Object?>>> getDataFromDatabase() async {
    final db = await database;
    String sql = '''
    SELECT * FROM voice
    ''';
    return await db.rawQuery(sql);
  }

  Future<int> deleteDataFromDatabase(int id) async {
    final db = await database;
    String sql = '''
    DELETE FROM voice WHERE id = ?
    ''';
    List args = [id];
    return await db.rawDelete(sql, args);
  }

  Future<int> editDataFromDatabase(String title, int id) async {
    final db = await database;
    String sql = '''
    UPDATE voice SET title = ? WHERE id = ?
    ''';
    List args = [title, id];
    return await db.rawUpdate(sql, args);
  }
}
