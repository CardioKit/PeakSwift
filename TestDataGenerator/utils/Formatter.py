# source: https://www.javatpoint.com/camelcase-in-python
def to_camel_case(text: str, seperator: str) -> str:
    seperated = text.split(seperator)
    converted = "".join(word[0].upper() + word[1:].lower() for word in seperated)
    return converted[0].lower() + converted[1:]


def to_upper_case(text: str) -> str:
    return text[0].upper() + text[1:]
