getRatingCount(int? count){

  if(count==null){
    return 'null';
  }
  if(count<500){
    return '($count)';
  }
  return '(${(count/1000).toStringAsFixed(1)}k)';
}