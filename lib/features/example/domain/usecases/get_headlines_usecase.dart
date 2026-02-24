import 'package:cropmodel/features/example/data/model/article_model.dart';
import 'package:cropmodel/features/example/data/service/news_services.dart';

class GetHeadlinesUseCase {

  NewsServices services = NewsServices();

  Future<List<ArticleModel>?> call() {
    return services.getHeadlines(3);
  }
}
