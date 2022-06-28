part of 'theme_bloc.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent([List props = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

class ThemeChanged extends ThemeEvent {
  final AppTheme theme;

  const ThemeChanged({
    required this.theme,
  });

  @override
  List<Object> get props => [theme];
}
