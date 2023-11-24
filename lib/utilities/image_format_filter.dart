class ImageFormatFilter{
  
  static filterImageUrl(url){
    final splittedUrl = url.split('.');
    var imageType = splittedUrl.last;
    return imageType;
  }

}
