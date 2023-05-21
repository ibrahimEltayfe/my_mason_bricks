abstract class {{name.pascalCase()}}Repository{
 {{#mutations}}Future<{{{functionReturnType}}}> {{name}}({{#variables}}{{{parameterType}}} {{parameterName}},{{/variables}});
 {{/mutations}}
 {{#queries}}Future<{{{functionReturnType}}}> {{name}}({{#variables}}{{{parameterType}}} {{parameterName}},{{/variables}});
 {{/queries}}
}
