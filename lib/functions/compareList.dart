bool compareLists<T>(List<T> list1, List<T> list2) {
  for (T item in list1) {
    if (list2.contains(item)) {
      return true;
    }
  }
  return false;
}