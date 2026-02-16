import 'package:cropmodel/features/example/data/service/news_api.dart';

import '../../../../core/network/api_client.dart';
import '../model/article_model.dart';

class NewsServices {
  final APIClient apiClient = APIClient();

  Future<List<ArticleModel>?> getHeadlines(int id) async {
    return await apiClient.fetch<void, List<ArticleModel>?>(
      api: NewsApi.getHeadlines,
      mapper: (response) {
        final List data = response["results"];

        return data
            .map((json) => ArticleModel.fromJson(json))
            .toList();
      },
    );
  }
}
