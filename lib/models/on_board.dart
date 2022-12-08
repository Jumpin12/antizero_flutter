class SliderModel {
  String imageAssetPath;

  SliderModel({this.imageAssetPath});

  void setImageAssetPath(String getImageAssetPath) {
    imageAssetPath = getImageAssetPath;
  }

  String getImageAssetPath() {
    return imageAssetPath;
  }
}

List<SliderModel> getSlides() {
  // ignore: deprecated_member_use
  List<SliderModel> slides = List<SliderModel>();
  SliderModel sliderModel = SliderModel();

  //Screen 1
  sliderModel.setImageAssetPath('assets/images/OnBoard/onBoard1.jpeg');
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  //Screen 2
  sliderModel.setImageAssetPath('assets/images/OnBoard/onBoard2.jpeg');
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  //Screen 3
  sliderModel.setImageAssetPath('assets/images/OnBoard/onBoard3.jpeg');
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  return slides;
}
