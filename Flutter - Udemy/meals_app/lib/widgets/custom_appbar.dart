import 'package:flutter/material.dart';

customAppBar(ctx, title) {
  return AppBar(
      title: Text(
    title,
    style: Theme.of(ctx).textTheme.bodyLarge,
  ));
}
