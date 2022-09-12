import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:word_app/providers/data_provider.dart';
import 'package:word_app/view/widgets/custom_button.dart';
import 'package:word_app/view/widgets/detail_card_widget.dart';
import 'package:word_app/view/widgets/word_card_widget.dart';


final visibilityProvider = StateProvider<bool>((ref) => false);

class MainProviderPage extends ConsumerStatefulWidget {
  const MainProviderPage({Key? key}) : super(key: key);

  static const routeName = 'mainProviderPage';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MainProviderPageState();
}

class _MainProviderPageState extends ConsumerState<MainProviderPage> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(wordDataProvider);
    bool isVisible = ref.watch(visibilityProvider);
    return Scaffold(
        backgroundColor: Colors.grey.shade300,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: data.when(
          data: ((data) => Stack(
                children: [
                  _animatedWidget(
                      isVisible: isVisible,
                      child: DetailCardWidget(
                        type: data.meanings![0].partOfSpeech ?? '',
                        definition:
                            data.meanings![0].definitions![0].definition ?? '',
                        example:
                            data.meanings![0].definitions![0].example ?? '',
                      ),
                      alignmentFirst: const Alignment(0, 0.2),
                      alignmentSecond: const Alignment(0, 0.42)),
                  _animatedWidget(
                      isVisible: isVisible,
                      child: WordCardWidget(
                          word: data.word ?? '',
                          pronunciation: data.phonetics![0].text ?? ''),
                      alignmentFirst: const Alignment(0, -0.5),
                      alignmentSecond: const Alignment(0, -0.58)),
                  Align(
                    alignment: const Alignment(0, 0.8),
                    child: _buttonRow(isVisible),
                  ),
                ],
              )),
          error: (error, stack) => const Center(
            child: Text('Error'),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        ));
  }

  Row _buttonRow(bool isVisible) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CustomButtonWidget(
          color: Colors.grey.shade200,
          icon: const Icon(
            Icons.list_alt,
            color: Colors.orange,
          ),
          onPressed: () {},
        ),
        CustomButtonWidget(
            color: isVisible ? Colors.orange : Colors.grey.shade200,
            icon: isVisible
                ? const Icon(
                    Icons.visibility,
                    color: Colors.white,
                  )
                : const Icon(
                    Icons.visibility_off,
                    color: Colors.grey,
                  ),
            onPressed: () async {
              Future.delayed(Duration.zero, () {
                ref.read(visibilityProvider.state).state = !isVisible;
                // isVisible = !isVisible;
              });
            }),
        CustomButtonWidget(
            color: isFavorite ? Colors.orange : Colors.grey.shade200,
            icon: isFavorite
                ? const Icon(
                    Icons.star_outlined,
                    color: Colors.white,
                  )
                : const Icon(
                    Icons.star_border_outlined,
                    color: Colors.grey,
                  ),
            onPressed: () async {
              Future.delayed(Duration.zero, () {
                setState(() {
                  isFavorite = !isFavorite;
                });
              });
            }),
      ],
    );
  }

  AnimatedAlign _animatedWidget(
      {required bool isVisible,
      required Widget child,
      required Alignment alignmentFirst,
      required Alignment alignmentSecond}) {
    return AnimatedAlign(
      duration: const Duration(milliseconds: 400),
      alignment: !isVisible ? alignmentFirst : alignmentSecond,
      child: child,
    );
  }
}
