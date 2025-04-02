import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class CloudinaryService {
  static const String cloudName = 'djo8r4dsl';
  static const String uploadPreset = 'chat_app_upload';

  static Future<String?> uploadFile(File file) async {
    final mimeType = lookupMimeType(file.path);
    if (mimeType == null) {
      print('❌ Không xác định được mimeType.');
      return null;
    }

    final typeParts = mimeType.split('/');
    final fileType = typeParts[0]; 

    final uploadUrl = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/$fileType/upload');

    final request = http.MultipartRequest('POST', uploadUrl)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath(
        'file',
        file.path,
        contentType: MediaType(typeParts[0], typeParts[1]),
      ));

    final response = await request.send();

    if (response.statusCode == 200) {
      final resStr = await response.stream.bytesToString();
      final resData = jsonDecode(resStr);
      return resData['secure_url']; 
    } else {
      print('❌ Upload thất bại: ${response.statusCode}');
      return null;
    }
  }
}




