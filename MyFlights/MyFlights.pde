// Try me GITHUB

//  TRY THE FIRST PUSH. THIS TEXT MUST BE VIISBLE FROM THE REPO

// Thitd rttqer Prad
// Prad added table class
String[][] tableData;
Table myTable;

void setup() {
  size(800, 600);
  background(0);
  
  String[] lines = loadStrings("flights2k.csv");
  if (lines == null || lines.length == 0) {
    println("Error loading file.");
    return;
  }
  
  
  int maxCols = 0;
  tableData = new String[lines.length][];
  
  for (int i = 0; i < lines.length; i++) {
    tableData[i] = split(lines[i], ",");  // Assuming CSV is comma-separated
    
    maxCols = max(maxCols, tableData[i].length);
  }

  
  for (int i = 0; i < lines.length; i++) {
    println(join(tableData[i], ", "));
  }

  myTable = new Table(tableData, maxCols);
}

void draw() {
  background(0);
  myTable.display();
}
