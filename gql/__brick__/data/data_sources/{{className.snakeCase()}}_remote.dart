import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../../data/utils/graphql_extensions.dart';
{{#injectable}}import 'package:injectable/injectable.dart';{{/injectable}}
import '../data_source/graphql/mutations/{{className.snakeCase()}}_mutations.dart';
import '../data_source/graphql/queries/{{className.snakeCase()}}_queries.dart';
{{#injectable}}@lazySingleton{{/injectable}}
class {{className.pascalCase()}}Remote{
  final GraphQLClient _client;
  {{className.pascalCase()}}Remote(this._client);

  {{#mutations}}Future<QueryResult> {{name}}({{#variables}}{{{parameterType}}} {{parameterName}},{{/variables}}) async{
    return await _client.perform(
     mutation: {{name}}Mutation,{{^noVariables}}
     variables: {
       {{#variables}}"{{variableKey}}" : {{#isModel}}{{parameterName}}.toJson(),{{/isModel}}{{^isModel}}{{parameterName}},{{/isModel}}{{/variables}}
     }{{/noVariables}}
   );
 }
 {{/mutations}}
 {{#queries}}Future<QueryResult> {{name}}({{#variables}}{{{parameterType}}} {{parameterName}},{{/variables}}) async{
   return await _client.fetch(
     query: {{name}}Query,{{^noVariables}}
     variables: {
       {{#variables}}"{{variableKey}}" : {{#isModel}}{{parameterName}}.toJson(),{{/isModel}}{{^isModel}}{{parameterName}},{{/isModel}}{{/variables}}
     }{{/noVariables}}
   );
  }

  {{/queries}}
}