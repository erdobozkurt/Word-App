import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:word_app/view/screens/canvas.dart';

class WordCardWidget extends ConsumerWidget {
  const WordCardWidget({
    Key? key,
    required this.word,
    required this.pronunciation,
  }) : super(key: key);

  final String word;
  final String pronunciation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isVisible = ref.watch(visibilityProvider);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      height: MediaQuery.of(context).size.height * (isVisible ? 0.42 : 0.5),
      width: MediaQuery.of(context).size.width * 0.9,
      child: Card(
        elevation: 20,
        color: Colors.deepPurple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.0),
        ),
        child: Stack(
          children: [
            //* Word
            Center(
              child: Text(
                style: Theme.of(context)
                    .textTheme
                    .displaySmall!
                    .copyWith(color: Colors.white),
                word,
              ),
            ),
            //* Pronunciation
            Align(
              alignment: const Alignment(0, 0.5),
              child: Text(pronunciation,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.white70)),
            ),
            Positioned(
              right: 16,
              bottom: 16,
              child: IconButton(
                onPressed: () {},
                icon:
                    const Icon(Icons.volume_up_rounded, color: Colors.white70),
              ),
            )
          ],
        ),
      ),
    );
  }
}
