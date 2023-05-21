import 'dart:io';

import 'package:mason/mason.dart';

import 'common/dart_types.dart';
import 'common/methods/make_model_file.dart';
import 'common/model_type_enum.dart';

void run(HookContext context) async{
  context.logger.info("variable format => Key : ValueName as ValueType\n");
  context.vars = {
    ...context.vars,
    "variables" : <Map<String,dynamic>>[],
    "mutations" : <Map<String,dynamic>>[],
    "queries" : <Map<String,dynamic>>[],
  };

  await _addQueries(context);
  await _addMutations(context);

}

Future<void> _addMutations(HookContext context) async{
  bool keepGoing = true;
  List<Map<String,dynamic>> mutations = [];

  context.logger.write("Mutations \n");

  while(keepGoing){
    String mutationName = context.logger.prompt('Name:').trim();

    if(mutationName.isEmpty){
      keepGoing = false;
      break;
    }

    mutationName = mutationName.replaceAll("Mutation", "");

    final map = await _queryMutationInputHandler(context: context, name: mutationName);
    mutations.add(map);

  }

  context.vars['mutations'] = mutations;
}

Future<void> _addQueries(HookContext context) async{
  bool keepGoing = true;
  List<Map<String,dynamic>> queries = [];

  context.logger.write("Queries \n");

  while(keepGoing){
    String queryName = context.logger.prompt('Name:').trim();

    if(queryName.trim().isEmpty){
      keepGoing = false;
      break;
    }
    queryName = queryName.replaceAll("Query", "");

    final map = await _queryMutationInputHandler(context: context, name: queryName);
    queries.add(map);
  }

  context.vars['queries'] = queries;
}

Future<Map<String,dynamic>> _queryMutationInputHandler({
  required String name,
  required HookContext context,
}) async{
  bool keepGoing = true;
  List<Map<String,dynamic>> variableMaps = [];

  while(keepGoing){
    var variable = context.logger.prompt('variable:').trim();

    if(variable.isEmpty){
      keepGoing = false;
      break;
    }
    Map<String,dynamic> map;

    try{
      map = await _handleVariable(variable);
    }catch(e){
      context.logger.err("variable format => Key : ValueName as ValueType\n");
      variable = context.logger.prompt('variable:').trim();

      if(variable.trim().isEmpty){
        keepGoing = false;
        break;
      }

      map = await _handleVariable(variable);
    }

    variableMaps.add(map);
  }
  
  String functionReturnType = context.logger.prompt('Function Return Type:',defaultValue: "void").trim();

  String refineForModelType = functionReturnType.replaceAll(RegExp(".+<|>|(model|entity|api)",caseSensitive: false), '');

  await makeModelFile(
    parameterType: refineForModelType,
    modelType: ModelType.model,
  );

  await makeModelFile(
      parameterType: functionReturnType,
      modelType: ModelType.useCase,
      useCaseData: {
        "name" : name,
        "variables": variableMaps,
        "functionReturnType" : functionReturnType,
        "noVariables" : variableMaps.isEmpty,
        "className": context.vars['className']
      }
  );

  return {
    "name" : name,
    "variables": variableMaps,
    "functionReturnType" : functionReturnType,
    "noVariables" : variableMaps.isEmpty
  };
}

Future<Map<String,dynamic>> _handleVariable(String variable) async{
  variable = variable.replaceAll(RegExp("(\"|\')|  +"), '');

  Map<String,dynamic> map = {};
  List<String> splitKeyFromString = variable.split(':');
  map["variableKey"] = splitKeyFromString[0].trim();

  List<String> splitValueNameAndType = splitKeyFromString[1].split(' as ');
  map["parameterName"] = splitValueNameAndType[0].trim();
  map["parameterType"] = splitValueNameAndType[1].trim();

  String refineParameterType = map["parameterType"].replaceAll(RegExp(".+<|>|(model|entity|api)",caseSensitive: false), '');

  if(!dartDataType.contains(refineParameterType)){
    map["isModel"] = true;
    await makeModelFile(parameterType: refineParameterType,modelType: ModelType.input);
  }else{
    map["isModel"] = false;
  }

  return map;
}

