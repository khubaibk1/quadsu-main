enum PetType {
  dog,
  cat,
}

extension PetTypeExtension on PetType {
  int get value {
    switch (this) {
      case PetType.dog:
        return 1;
      case PetType.cat:
        return 2;
      default:
        return 1;
    }
  }

  static PetType fromValue(int value) {
    switch (value) {
      case 1:
        return PetType.dog;
      case 2:
        return PetType.cat;
      default:
        return PetType.dog;
    }
  }
}

class PetTypeIntegers{

  static const int dog = 1;
  static const int cat = 2;
}

