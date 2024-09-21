import 'dart:io';

import 'package:dio/dio.dart';
import 'package:newbietrainee/models/post_model.dart';

class NetworkLayer {
  late final Dio dio;

  NetworkLayer() {
    dio = Dio(
      BaseOptions(
          baseUrl: 'https://jsonplaceholder.typicode.com',
          connectTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 3),
          headers: {}),
    );
  }

  Future<List<PostModel>> getList() async {
    final response = await dio.get('/posts',
        options: Options(headers: {
          HttpHeaders.authorizationHeader: 'Bearer token',
        }));

    return response.statusCode == 200
        ? response.data.map<PostModel>((e) => PostModel.fromMap(e)).toList()
        : throw Exception('Failed to load data');
  }
}
