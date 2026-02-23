import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_headlines_usecase.dart';
import 'example_event.dart';
import 'example_state.dart';


class NewsBloc extends Bloc<NewsEvent, NewsState> {
  NewsBloc() : super(NewsInitial()) {
    on<FetchNews>((event, emit) async {
      emit(NewsLoading());
      try {
        final articles = await GetHeadlinesUseCase().call();
        emit(NewsLoaded(articles));
      } catch (e) {
        emit(NewsError(e.toString()));
      }
    });
  }
}
