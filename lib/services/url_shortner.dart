import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:inshort_app/core/constants/api_constants.dart';

// class TinyUrlWithDio extends StatefulWidget {
//   @override
//   _TinyUrlWithDioState createState() => _TinyUrlWithDioState();
// }

// class _TinyUrlWithDioState extends State<TinyUrlWithDio> {
//   final TextEditingController _urlController = TextEditingController();
//   String? _shortUrl;
//   bool _loading = false;

//   final Dio _dio = Dio();

//   // Replace with your actual TinyURL API key
//   final String tinyUrlApiKey = ApiConstants.apiShortNerToken;

//   Future<void> shortenUrl(String longUrl) async {
//     setState(() {
//       _loading = true;
//       _shortUrl = null;
//     });

//     final apiUrl = 'https://api.tinyurl.com/create';

//     try {
//       final response = await _dio.post(
//         apiUrl,
//         options: Options(
//           headers: {
//             'Authorization': 'Bearer $tinyUrlApiKey',
//             'Content-Type': 'application/json',
//           },
//         ),
//         data: {
//           'url': longUrl,
//           'domain': 'tinyurl.com', // or 'tiny.one'
//         },
//       );

//       final shortUrl = response.data['data']['tiny_url'];

//       setState(() {
//         _shortUrl = shortUrl;
//       });
//     } catch (e) {
//       print('Error: $e');
//       setState(() {
//         _shortUrl = 'Error generating short URL';
//       });
//     } finally {
//       setState(() {
//         _loading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('TinyURL Shortener (Dio)')),
//       body: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           children: [
//             TextField(
//               controller: _urlController,
//               decoration: InputDecoration(
//                 labelText: 'Enter long URL',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {
//                 final url = _urlController.text.trim();
//                 if (url.isNotEmpty) {
//                   shortenUrl(url);
//                 }
//               },
//               child: Text('Shorten URL'),
//             ),
//             SizedBox(height: 16),
//             if (_loading) CircularProgressIndicator(),
//             if (_shortUrl != null) SelectableText('Short URL: $_shortUrl'),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:dio/dio.dart';

Future<String?> shortenUrlWithTinyUrl({
  required String longUrl,
  required String apiKey, // Your TinyURL API key
}) async {
  final Dio dio = Dio();
  const String apiUrl = 'https://api.tinyurl.com/create';

  try {
    final response = await dio.post(
      apiUrl,
      options: Options(
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
      ),
      data: {
        'url': longUrl,
        'domain': 'tinyurl.com', // or 'tiny.one'
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data['data']['tiny_url'];
    } else {
      print('Failed to shorten URL: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error shortening URL: $e');
    return null;
  }
}
