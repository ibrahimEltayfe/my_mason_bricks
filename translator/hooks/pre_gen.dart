import 'package:mason/mason.dart';
import 'package:translator/translator.dart';

void run(HookContext context) async{
  bool keepGoing = true;
  List<Map<String,dynamic>> englishMap = [];
  List<Map<String,dynamic>> arabicMap = [];

  while(keepGoing){
    final key = context.logger.prompt('key: ');
    final value = context.logger.prompt('value: ');
    Map<String,dynamic> enMap = {
      "key" : key,
      "value" : value
    };

    englishMap.add(enMap);

    final translator = GoogleTranslator();
    final translatedValue = await translator.translate(value, from: 'en', to: 'ar');

    Map<String,dynamic> arMap = {
      "key" : key,
      "value" : translatedValue.text
    };

    arabicMap.add(arMap);

    String isContinue = context.logger.prompt('continue?',defaultValue: "yes");
    if(isContinue == "yes"){
      keepGoing = true;
    }else{
      keepGoing = false;
    }

  }

  context.logger.success("---- English ----\n");
  context.logger.write("{\n");
  for(Map<String,dynamic> item in englishMap){
    context.logger.write("  \"${item['key']}\" : \"${item['value']}\",\n");
  }
  context.logger.write("}\n\n");


  context.logger.success("---- Arabic ----\n");
  context.logger.write("{\n");
  for(Map<String,dynamic> item in arabicMap){
    context.logger.write("  \"${item['key']}\" : \"${item['value']}\",\n");
  }
  context.logger.write("}\n\n");

  for(Map<String,dynamic> item in englishMap){
    context.logger.write("static String get ${item['key']} => _localizer.translate(\"${item['key']}\");\n");
  }

  context.logger.write("\n");

}
