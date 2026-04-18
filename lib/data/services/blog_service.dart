import '../../core/constants/api_constants.dart';
import '../models/blog_model.dart';
import 'api_service.dart';

class BlogService {
  final ApiService _apiService;

  const BlogService({ApiService? apiService})
      : _apiService = apiService ?? const ApiService();

  Future<List<BlogModel>> getBlogs() async {
    final response = await _apiService.get(ApiConstants.blogs);
    final blogsJson = response['data'] as List<dynamic>;

    return blogsJson
        .map((item) => BlogModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<BlogModel> getBlogDetail(String slug) async {
    final response = await _apiService.get('${ApiConstants.blogs}/$slug');
    return BlogModel.fromJson(response['data'] as Map<String, dynamic>);
  }
}
