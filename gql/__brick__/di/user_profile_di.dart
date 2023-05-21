class {{className.pascalCase()}}Di {
  static Future<void> initialize() async {
    injector.registerLazySingleton< {{className.pascalCase()}}Repository>(() => {{className.pascalCase()}}RepositoryImpl(injector()));
    injector.registerLazySingleton< {{className.pascalCase()}}Repository>(() =>  {{className.pascalCase()}}RepositoryImpl(injector()));
    {{#mutations}}injector.registerFactory(() => {{name.pascalCase()}}UseCase(injector()));
    {{/mutations}}
    {{#queries}}injector.registerFactory(() => {{name.pascalCase()}}UseCase(injector()));
    {{/queries}}
  }
}