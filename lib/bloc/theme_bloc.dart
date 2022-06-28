import 'dart:html';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mobile_motivation/enums/app_theme.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  @override
  ThemeState get initialState => ThemeState(themeData: appThemeData[AppTheme.]);

  ThemeBloc() : super(ThemeInitial()) {
    on<ThemeEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
