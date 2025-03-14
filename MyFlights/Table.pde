class Table {
  String[][] data;
  int rowHeight = 30;
  int colWidth = 150;
  int xOffset = 50;
  int yOffset = 50;
  int maxCols;  

  Table(String[][] inputData, int cols) {
    data = inputData;
    maxCols = cols;
  }
  
  void display() {
    fill(255);
    textSize(14);
    
   
    for (int i = 0; i < data.length; i++) {
      for (int j = 0; j < maxCols; j++) {
        int x = xOffset + j * colWidth;
        int y = yOffset + i * rowHeight;
        
      
        if (j < data[i].length) {

          fill(i == 0 ? color(100, 100, 255) : color(50));  
          rect(x, y, colWidth, rowHeight);
          

          fill(255);
          text(data[i][j], x + 5, y + 20);
        }
      }
    }
  }
}
