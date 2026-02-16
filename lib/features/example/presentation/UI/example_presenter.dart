import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../bloc/example_bloc.dart';
import '../bloc/example_event.dart';
import '../bloc/example_state.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Spaceflight News"),
      ),
      body: BlocProvider(
        create: (_) => NewsBloc(),
        child: BlocBuilder<NewsBloc, NewsState>(
          builder: (context, state) {
            if (state is NewsLoading) {
             EasyLoading.show();
            }

            if (state is NewsLoaded) {
              EasyLoading.dismiss();
              return ListView.builder(
                itemCount: state.articles?.length,
                itemBuilder: (context, index) {
                  final article = state.articles![index];
                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      leading: article.imageUrl.isNotEmpty
                          ? Image.network(
                        article.imageUrl,
                        width: 100,
                        fit: BoxFit.cover,
                      )
                          : null,
                      title: Text(article.title),
                      subtitle: Text(
                        article.summary,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                },
              );
            }

            if (state is NewsError) {
              return Center(child: Text(state.message));
            }

            return Center(
              child: ElevatedButton(
                onPressed: () {
                  context.read<NewsBloc>().add(FetchNews());
                },
                child: const Text("Load News"),
              ),
            );
          },
        ),
      ),
    );
  }
}
