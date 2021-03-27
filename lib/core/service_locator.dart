import 'package:get_it/get_it.dart';

import 'supabase.dart' as supabase;
import 'todo_repository.dart';

final sl = GetIt.instance;

void initServiceLocator() {
  sl.registerSingleton<TodoRepository>(TodoRepository(supabase.client));
}
