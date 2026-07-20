extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  String capitalizeFirstLettersAsCapital() {

    String a = this;
    print(a);
    List ss = a.trim().split(" ");
    print('$ss');
    List newSS = List.generate(ss.length, (index) => '${ss[index][0].toString().toUpperCase()}${ss[index].toString().substring(1).toLowerCase()}');
    print('$newSS');

    return newSS.join(" ");
  }
}