import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:pm/UI/ui.dart';

class Header extends StatelessWidget {
  final String header;
  final String? subHeader;

  Header({
    required this.header,
    this.subHeader,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText(
            header,
            style: TextStyle(
              color: Palette.primaryDark,
              fontSize: Font.h2,
              fontWeight: FontWeight.w700,
            ),
            minFontSize: 4.0,
            maxLines: 1,
          ),
          if (subHeader != null) Spacers.h16,
          if (subHeader != null)
            AutoSizeText(
              subHeader!,
              style: TextStyle(
                color: Palette.secondaryDark,
                fontSize: Font.h4,
              ),
              minFontSize: 4.0,
              maxLines: 2,
            ),
        ],
      ),
    );
  }
}
