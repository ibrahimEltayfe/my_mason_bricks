import 'package:graphql_flutter/graphql_flutter.dart';
{{#injectable}}import 'package:injectable/injectable.dart';{{/injectable}}
import '../../../test/data/mappers/inputs/user_childrens_inputs_mappers.dart';
import '../data_sources/{{className.pascalCase()}}_remote.dart';
import '../../../../common/domain/exceptions/exceptions.dart';
import '../../../../common/domain/exceptions/status_codes.dart';

{{#injectable}}@LazySingleton(as: {{className.pascalCase()}}Repository){{/injectable}}
class {{className.pascalCase()}}RepositoryImpl implements {{className.pascalCase()}}Repository{
  final {{className.pascalCase()}}Remote _{{className.camelCase()}}Remote;
  const {{className.pascalCase()}}RepositoryImpl(this._{{className.camelCase()}}Remote);

  {{#mutations}}@override
  Future<{{{functionReturnType}}}> {{name}}({{#variables}}{{{parameterType}}} {{parameterName}},{{/variables}}) async{
    final result = await _{{className.camelCase()}}Remote.{{name}}({{#variables}}{{#isModel}}{{parameterName}}.mapToApiInput,{{/isModel}}{{^isModel}}{{parameterName}},{{/isModel}}{{/variables}});

    if (result.hasException || result.data == null) {
      throw const ServerException();
    } else {
      final request =
        _.fromJson(result.data!)._;

      final data = request?.data;
      if (request?.code == StatusCodes.success && data != null) {
        //return data.mapToEntity;
      } else {
        throw ApiRequestException(
            request?.code ?? StatusCodes.unknown, request?.message ?? "");
      }
    }
  }
  {{/mutations}}
  {{#queries}}@override
  Future<{{{functionReturnType}}}> {{name}}({{#variables}}{{{parameterType}}} {{parameterName}},{{/variables}}) async{
    final result = await _{{className.camelCase()}}Remote.{{name}}({{#variables}}{{#isModel}}{{parameterName}}.mapToApiInput,{{/isModel}}{{^isModel}}{{parameterName}},{{/isModel}}{{/variables}});

    if (result.hasException || result.data == null) {
      throw const ServerException();
    } else {
      final request =
        _.fromJson(result.data!)._;

      final data = request?.data;
      if (request?.code == StatusCodes.success && data != null) {
        //return data.mapToEntity;
      } else {
        throw ApiRequestException(
            request?.code ?? StatusCodes.unknown, request?.message ?? "");
      }
    }
  }{{/queries}}
}

