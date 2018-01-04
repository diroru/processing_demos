
ArrayList<String> getImagePaths() {
  ArrayList<String> result =new ArrayList<String>();
  
  File folder = new File(dataPath(""));
  File[] listOfFiles = folder.listFiles();

  for (int i = 0; i < listOfFiles.length; i++) {
    if (listOfFiles[i].isFile()) {
      
      try {
        PImage img = loadImage(listOfFiles[i].getName());
        if (img.width > 0 && img.height > 0) {
          result.add(listOfFiles[i].getName());
        }
        System.out.println("Loaded " + listOfFiles[i].getName()); 
        img = null;
      } catch (Exception e) {
      }
    } else if (listOfFiles[i].isDirectory()) {
      //System.out.println("Directory " + listOfFiles[i].getName());
    }
  }
  return result;
}