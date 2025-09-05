import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../../common/dio_helper.dart';
import '../../common/shared_preferences_helper.dart';
import 'injection.config.dart';


final GetIt getIt = GetIt.instance;

@InjectableInit(
  initializerName: r'$initGetIt',
  preferRelativeImports: true,
  asExtension: false,
)

Future<GetIt> configureInjection() async {
  await SharedPreferencesHelper.init();
  return $initGetIt(getIt);
}

@module
abstract class InjectableModule {
  @singleton
  DioNetwork get dio => DioNetwork(
    baseUrl: 'https://res.mustafafares.com/api',
  );
}
