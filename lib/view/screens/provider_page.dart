import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:word_app/providers/data_provider.dart';

class ProviderPage extends ConsumerWidget {
  const ProviderPage({Key? key}) : super(key: key);
  static const routeName = 'providerPage';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(wordDataProvider);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Provider Page'),
        ),
        body: data.when(
            data: (data) => Center(
                  child: Text(data.word ?? ''),
                ),
            loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
            error: (error, stack) => const Center(
                  child: Text('Error'),
                )));
  }
}
