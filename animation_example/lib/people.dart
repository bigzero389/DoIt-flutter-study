class People {
  String name;
  double height;
  double weight;
  double? BMI;

  People(this.name, this.height, this.weight) {
    // unit : cm, kg
    BMI = weight / ((height / 100) * (height / 100));
  }
}