import 'dart:io';

import 'package:mason/mason.dart';

import '../dart_types.dart';
import '../model_type_enum.dart';

Future _generateModelFile({
  required String path,
  String modelName = '',
  bool isModel = false,
  bool isInputMapper = false,
  bool isModelMapper = false,
  bool isUseCase = false,
  Map<String,dynamic> useCaseData = const{},
}) async{
  final brick = Brick.path("/Volumes/Macintosh/mason_bricks/gql/file_maker");
  final generator = await MasonGenerator.fromBrick(brick);
  final target = DirectoryGeneratorTarget(Directory.fromUri(Uri.file(path)));
  await generator.generate(target, vars: <String, dynamic>{
    'modelName': modelName,
    'isInputMapper' : isInputMapper,
    'isModelMapper': isModelMapper,
    'isModel' : isModel,
    "isUseCase" : isUseCase,
    "useCaseData" : useCaseData,
  });
}

Future makeModelFile({
  required ModelType modelType,
  required String parameterType,
  Map<String,dynamic> useCaseData = const{},
}) async{
  if(!dartDataType.contains(parameterType)){
    final currentPath = Directory.current.path;

    if(modelType == ModelType.input){
      await _generateModelFile(
        path: currentPath + "/data/models/inputs",
        modelName: "Api" + parameterType,
        isModel: true
      );
      await _generateModelFile(
        path: currentPath + "/domain/entities/inputs",
        modelName: parameterType,
        isModel: true
      );
      await _generateModelFile(
        path: currentPath + "/data/mappers/inputs",
        modelName: parameterType,
        isInputMapper: true,
      );
    }else if(modelType == ModelType.model){
      await _generateModelFile(
        path: currentPath + "/data/models",
        modelName: "Api" + parameterType + "Model",
        isModel: true
      );
      await _generateModelFile(
        path: currentPath + "/domain/entities",
        modelName: parameterType + "Entity",
        isModel: true
      );
      await _generateModelFile(
        path: currentPath + "/data/mappers",
        modelName: parameterType,
        isModelMapper: true,
      );
    }else if(modelType == ModelType.useCase){
      final filename = (useCaseData["name"] as String).splitMapJoin(RegExp("[a-z]*",caseSensitive: true),onMatch: (value) => '${value[0]} ',);
      await _generateModelFile(
        path: currentPath + "/domain/use_cases",
        modelName: filename +" usecase",
        useCaseData: useCaseData,
        isUseCase: true,
      );
    }
  }
}