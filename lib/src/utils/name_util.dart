class NameAndLastName {
  String name;
  String lastName;

  NameAndLastName({required this.name, required this.lastName});
}

NameAndLastName getNameAndLastName(String fullName) {
  List<String> nameAndLastName = fullName.split(" ");
  if (nameAndLastName.length == 1) {
    return NameAndLastName(name: nameAndLastName[0], lastName: "");
  }

  if (nameAndLastName.length == 2) {
    return NameAndLastName(
        name: nameAndLastName[0], lastName: nameAndLastName[1]);
  }

  if (nameAndLastName.length == 3) {
    return NameAndLastName(
        name: nameAndLastName[0],
        lastName: "${nameAndLastName[1]} ${nameAndLastName[2]}");
  }

  if (nameAndLastName.length == 4) {
    return NameAndLastName(
        name: "${nameAndLastName[0]} ${nameAndLastName[1]}",
        lastName: "${nameAndLastName[2]} ${nameAndLastName[3]}");
  }

  if (nameAndLastName.length == 5) {
    return NameAndLastName(
        name:
            "${nameAndLastName[0]} ${nameAndLastName[1]} ${nameAndLastName[2]}",
        lastName: "${nameAndLastName[3]} ${nameAndLastName[4]}");
  }

  String name = "";
  String lastName = "";

  return NameAndLastName(name: name, lastName: lastName);
}
