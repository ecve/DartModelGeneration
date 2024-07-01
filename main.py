import json
import sys
import traceback
from datetime import datetime

model_or_key_name = []


def is_valid_datetime(date_string):
    try:
        datetime.strptime(date_string, "%Y-%m-%dT%H:%M:%S.%fZ")
        return True
    except ValueError:
        return False


def is_valid_date(date_string, date_format='%Y-%m-%d'):
    try:
        datetime.strptime(date_string, date_format)
        return True
    except ValueError:
        return False


def is_valid_time(time_string, time_format='%H:%M'):
    try:
        datetime.strptime(time_string, time_format)
        return True
    except ValueError:
        return False


def get_api_helper_function_name(key_name, type_of_var, class_name: str = None):
    if type_of_var == 'bool':
        return f"APIHelper.getSafeBoolValue(json['{key_name}'])"

    if type_of_var == 'str':
        return f"APIHelper.getSafeStringValue(json['{key_name}'])"

    if type_of_var == 'int':
        return f"APIHelper.getSafeIntValue(json['{key_name}'])"

    if type_of_var == 'double':
        return f"APIHelper.getSafeDoubleValue(json['{key_name}'])"

    if type_of_var == 'DateTime':
        return f"APIHelper.getSafeDateTimeValue(json['{key_name}'])"

    if type_of_var == 'dynamic':
        return f"json['{key_name}']"

    if type_of_var.startswith("List<Single"):
        type_name = type_of_var.split('<')[-1]
        type_name = type_name.split('>')[0]
        return f"""APIHelper.getSafeListValue(json['{key_name}'])
            .map((e) => {type_name}.getAPIResponseObjectSafeValue(e))
            .toList()"""

    if type_of_var.startswith("List<String"):
        return f"""APIHelper.getSafeListValue(json['{key_name}'])
            .map((e) => APIHelper.getSafeStringValue(e))
            .toList()"""

    if type_of_var.startswith("List<double"):
        return f"""APIHelper.getSafeListValue(json['{key_name}'])
            .map((e) => APIHelper.getSafeDoubleValue(e))
            .toList()"""

    if type_of_var.startswith("List<int"):
        return f"""APIHelper.getSafeListValue(json['{key_name}'])
            .map((e) => APIHelper.getSafeIntValue(e))
            .toList()"""

    if type_of_var.startswith("List<dynamic"):
        return f"""APIHelper.getSafeListValue(json['{key_name}'])
            .map((e) => e)
            .toList()"""

    if type_of_var == 'dict':
        return f"{class_name}.getAPIResponseObjectSafeValue(json['{key_name}'])"


def to_pascal_case(input_str):
    if "_" in input_str:
        parts = input_str.split("_")
    else:
        parts = [part.capitalize() for part in input_str.split(" ") if part]
    return "".join(x.title() for x in parts)


def snake_to_camel(snake_str):
    if "_" in snake_str:
        parts = snake_str.split("_")
        camel_str = "".join(part.capitalize() for part in parts)
        camel_str = camel_str.lstrip()
        first_char_lower = camel_str[0].lower()
        rest_of_string = camel_str[1:]
        return first_char_lower + rest_of_string
    else:
        return snake_str


def generate_dart_constructor(class_name: str, variables: dict) -> str:
    constructor = f"{class_name}({{\n"
    for idx, key in enumerate(variables.keys()):
        type_name, name = variables[key]
        if type_name == 'bool':
            constructor += f"\tthis.{name} = false"

        if type_name == 'str':
            constructor += f"\tthis.{name} = ''"

        if type_name == 'int':
            constructor += f"\tthis.{name} = 0"

        if type_name == 'double':
            constructor += f"\tthis.{name} = 0.0"

        if type_name == 'DateTime':
            constructor += f"\trequired this.{name}"

        if type_name == 'dynamic':
            constructor += f"\tthis.{name}"

        if str(type_name).startswith('List'):
            constructor += f"\tthis.{name} = const []"

        if type_name == 'dict':
            constructor += f"\trequired this.{name}"

        if idx != len(variables.keys()) - 1:
            constructor += ',\n'

    constructor += '\n});'
    return constructor


def generate_dart_factory(class_name: str, variables: dict):
    factory = f"""
  factory {class_name}.fromJson(Map<String, dynamic> json) {{
    return {class_name}(\n"""
    for key in variables.keys():
        type_name, name = variables[key]
        factory += f"\t  {name}: {get_api_helper_function_name(key, type_name, to_pascal_case(name))},\n"
    factory += """    );
  }
    """
    return factory


def generate_to_json_function(variables: dict):

    json_str = """
  Map<String, dynamic> toJson() => {\n"""

    for key in variables.keys():
        type_name, name = variables[key]
        if type_name == 'dict':
            json_str += f"\t  '{key}': {name}.toJson(),\n"
        elif type_name == 'DateTime':
            json_str += f"\t  '{key}': 'APIHelper.toServerDateTimeFormattedStringFromDateTime({name})',\n"
        elif type_name == 'DateTime':
            json_str += f"\t  '{key}': 'APIHelper.toServerDateTimeFormattedStringFromDateTime({name})',\n"
        elif type_name.startswith("List<Single"):
            json_str += f"\t  '{key}': '{name}.map((e) => e.toJson()).toList()',\n"
        else:
            json_str += f"\t  '{key}': {name},\n"

    return f"""
        {json_str}
  }};
    """


def generate_object_safe_value(class_name: str):
    return f"""
  static {class_name} getAPIResponseObjectSafeValue(
      dynamic unsafeResponseValue) =>
      APIHelper.isAPIResponseObjectSafe(unsafeResponseValue)
          ? {class_name}.fromJson(
              unsafeResponseValue as Map<String, dynamic>)
          : {class_name}.empty();"""


def generate_dart_empty_factory(class_name, required_fields):

    class_definition = f"""
  factory {class_name}.empty() => {class_name}("""

    for var in required_fields:
        key = list(var.keys())[0]
        type_name, vname = var[key]

        if type_name == 'dict':
            var_name = snake_to_camel(key)
            class_definition += f"\n\t  {var_name}: {vname}.empty(), "

        elif type_name == 'DateTime':
            class_definition += f"\n\t  {vname}: AppComponents.defaultUnsetDateTime,"

    class_definition += '\n  );'

    return class_definition


def generate_dart_class_from_json(json_data: dict, class_name="SingleRequestResponse"):
    fields = json_data.keys()
    variables = {}
    class_definition = f"class {class_name} {{\n"

    other_classes = []
    required_fields = []

    for key in fields:

        if json_data[key].__class__.__name__ == 'bool':
            class_definition += f"  bool  {snake_to_camel(key)};\n"
            variables.update({key: ('bool', snake_to_camel(key))})

        if json_data[key].__class__.__name__ == 'str':
            if is_valid_datetime(json_data[key]) or is_valid_date(json_data[key]) or is_valid_time(json_data[key]):
                class_definition += f"  DateTime  {snake_to_camel(key)};\n"
                variables.update({key: ('DateTime', snake_to_camel(key))})
                required_fields.append({key: ('DateTime', f"{snake_to_camel(key)}")})
            else:
                class_definition += f"  String  {snake_to_camel(key)};\n"
                variables.update({key: ('str', snake_to_camel(key))})

        if json_data[key].__class__.__name__ == 'int':
            class_definition += f"  int  {snake_to_camel(key)};\n"
            variables.update({key: ('int', snake_to_camel(key))})

        if json_data[key].__class__.__name__ == 'float':
            class_definition += f"  double  {snake_to_camel(key)};\n"
            variables.update({key: ('double', snake_to_camel(key))})

        if json_data[key].__class__.__name__ == 'NoneType':
            class_definition += f"  dynamic  {snake_to_camel(key)};\n"
            variables.update({key: ('dynamic', snake_to_camel(key))})
            required_fields.append({key: ('dynamic', f"{snake_to_camel(key)}")})

        if json_data[key].__class__.__name__ == 'list':
            list_data_type = json_data[key][0].__class__.__name__
            # print(list_data_type)

            if list_data_type == 'dict':
                new_data_type = {}
                for data in json_data[key]:
                    for data_key in data.keys():
                        new_data_type.update({data_key: data[data_key]})
                # print(new_data_type)

                nested_class_name = 'Single' + str(to_pascal_case(key)).title()
                class_definition += f"  List<{nested_class_name}>  {snake_to_camel(key)};\n"
                variables.update({key: (f'List<{nested_class_name}>', snake_to_camel(key))})
                other_classes.append(generate_dart_class_from_json(new_data_type, f"{nested_class_name}"))

            if list_data_type == 'str':
                is_dynamic = False
                for data in json_data[key]:
                    if data.__class__.__name__ != 'str':
                        is_dynamic = True
                        break
                if is_dynamic:
                    class_definition += f"  List<dynamic>  {snake_to_camel(key)};\n"
                    variables.update({key: ('List<dynamic>', snake_to_camel(key))})
                else:
                    class_definition += f"  List<String>  {snake_to_camel(key)};\n"
                    variables.update({key: ('List<String>', snake_to_camel(key))})

            if list_data_type == 'int':
                is_dynamic = False
                for data in json_data[key]:
                    if data.__class__.__name__ != 'int':
                        is_dynamic = True
                        break
                if is_dynamic:
                    class_definition += f"  List<dynamic>  {snake_to_camel(key)};\n"
                    variables.update({key: ('List<dynamic>', snake_to_camel(key))})
                else:
                    class_definition += f"  List<int>  {snake_to_camel(key)};\n"
                    variables.update({key: ('List<int>', snake_to_camel(key))})

            if list_data_type == 'double':
                is_dynamic = False
                for data in json_data[key]:
                    if data.__class__.__name__ != 'double':
                        is_dynamic = True
                        break
                if is_dynamic:
                    class_definition += f"  List<dynamic>  {snake_to_camel(key)};\n"
                    variables.update({key: ('List<dynamic>', snake_to_camel(key))})
                else:
                    class_definition += f"  List<double>  {snake_to_camel(key)};\n"
                    variables.update({key: ('List<double>', snake_to_camel(key))})

        if json_data[key].__class__.__name__ == 'dict':

            inside_class_name = to_pascal_case(key)
            class_definition += f"  {inside_class_name}  {snake_to_camel(key)};\n"
            variables.update({key: ('dict', snake_to_camel(key))})
            required_fields.append({key: ('dict', f"{inside_class_name}")})
            other_classes.append(generate_dart_class_from_json(json_data[key], f"{inside_class_name}"))

    class_definition += f"\n  {generate_dart_constructor(class_name, variables)}\n"
    class_definition += f"\n  {generate_dart_factory(class_name, variables)}\n"
    class_definition += f"\n  {generate_to_json_function(variables)}\n"
    class_definition += f"\n  {generate_dart_empty_factory(class_name, required_fields)}\n"
    class_definition += f'\n {generate_object_safe_value(class_name)}'

    class_definition += "\n  }\n"
    class_definition += "\n\n".join(other_classes)

    return class_definition


def main():
    try:
        file_path = sys.argv[1]
    except:
        file_path = 'request.json'
    try:
        model_json = json.load(open(file_path, encoding='utf-8'))
        dart_class = generate_dart_class_from_json(model_json, class_name='TestingModel')

        print(dart_class)
    except:
        print(traceback.format_exc())
        print("Invalid request.json provided")
        exit()


if __name__ == '__main__':
    main()
