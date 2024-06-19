import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AvatarScreen extends StatelessWidget {
  const AvatarScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: SvgPicture.string('''
<svg xmlns="http://www.w3.org/2000/svg" width="83" height="83" viewBox="0 0 83 83" fill="none">
<path d="M41.4998 6.91666C22.4098 6.91666 6.9165 22.41 6.9165 41.5C6.9165 60.59 22.4098 76.0833 41.4998 76.0833C60.5898 76.0833 76.0832 60.59 76.0832 41.5C76.0832 22.41 60.5898 6.91666 41.4998 6.91666ZM41.4998 20.75C48.1744 20.75 53.604 26.1796 53.604 32.8542C53.604 39.5287 48.1744 44.9583 41.4998 44.9583C34.8253 44.9583 29.3957 39.5287 29.3957 32.8542C29.3957 26.1796 34.8253 20.75 41.4998 20.75ZM41.4998 69.1667C34.4794 69.1667 26.1794 66.3308 20.2657 59.2067C26.3233 54.4539 33.8003 51.8709 41.4998 51.8709C49.1994 51.8709 56.6764 54.4539 62.734 59.2067C56.8203 66.3308 48.5203 69.1667 41.4998 69.1667Z" fill="#1B5694"/>
</svg>

'''),
    );
  }
}
