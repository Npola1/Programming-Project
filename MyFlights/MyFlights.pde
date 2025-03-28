import java.util.*;

// Flight Data Visualization System
// Created for CSU11013 Programming Project 2025

// Data structures
ArrayList<Flight> flights;
ArrayList<Flight> filteredFlights;
HashMap<String, Airport> airports;
HashMap<String, Integer> airlines;

// UI variables
int currentScreen = 0; // 0: main menu, 1: airport view, 2: date range view, 3: lateness view, 4: compare view
int startIndex = 0;
int recordsPerPage = 15;
String selectedAirport = "";
String startDate = "";
String endDate = "";
PFont titleFont, regularFont;
boolean showFilters = false;
String searchQuery = "";
PImage mainMenuBackground;
PImage otherScreensBackground;
String searchQuery2 = ""; // Second airline search query

// Screen dimensions
final int SCREEN_WIDTH = 1200;
final int SCREEN_HEIGHT = 800;

void setup() {
  size(1600, 800);
  titleFont = createFont("Arial Bold", 24);
  regularFont = createFont("Arial", 14);

  mainMenuBackground = loadImage("background.png");
  otherScreensBackground = loadImage("Background2.png");

  // Initialize data structures
  flights = new ArrayList<Flight>();
  filteredFlights = new ArrayList<Flight>();
  airports = new HashMap<String, Airport>();
  airlines = new HashMap<String, Integer>();

  // Load data
  loadFlightData("flights10k.csv");

  // Initially, filtered flights is the same as all flights
  filteredFlights = new ArrayList<Flight>(flights);
}

void draw() {
  // Draw the appropriate background based on currentScreen value
  if (currentScreen == 0) {
    if (mainMenuBackground != null) {
      image(mainMenuBackground, 0, 0, width, height);
    } else {
      background(240);
    }
  } else {
    if (otherScreensBackground != null) {
      image(otherScreensBackground, 0, 0, width, height);
    } else {
      background(240);
    }
  }

  // Switch cases for drawing
  switch (currentScreen) {
    case 0:
      drawMainMenu();
      break;
    case 1:
      drawAirportView();
      break;
    case 2:
      drawDateRangeView();
      break;
    case 3:
      drawLatenessView();
      break;
    case 4:
      drawCompare();
      break;
    case 5:  // Added case for Compare by Airlines
      drawCompareAirlines();
      break;
    case 6:  // Future case for Compare by Airports if needed
      drawCompareAirports();
      break;
    default:
      break;
  }

  // Draw navigation bar
  drawNavigationBar();
}

void drawMainMenu() {
  if (mainMenuBackground != null) {
    image(mainMenuBackground, 0, 0, width, height);
  } else {
    background(240);
  }

  textFont(titleFont);
  fill(50);
  textAlign(CENTER);
  text("Flight Data Visualization", width / 2, 80);

  textFont(regularFont);

  // Draw option buttons
  drawButton("Compare by Flights/Airports", width / 2 - 150, 120, 300, 60, currentScreen == 4);
  drawButton("View Flights by Airport", width / 2 - 150, 200, 300, 60, currentScreen == 1);
  drawButton("View Flights by Date Range", width / 2 - 150, 280, 300, 60, currentScreen == 2);
  drawButton("View Flights Sorted by Lateness", width / 2 - 150, 360, 300, 60, currentScreen == 3);

  // Draw a sample visualization of all data
  drawSummaryVisualization();
}

void drawCompare() {
  textFont(titleFont);
  fill(50);
  textAlign(CENTER);
  text("Compare by Airports/Flights", width / 2, 80);

  textFont(regularFont);
  textAlign(LEFT);

  // Compare by Flights/Airlines button
  drawButton("Compare by Flights (Airlines)", width / 2 - 250, 200, 500, 80, currentScreen == 4);

  // Compare by Airports button
  drawButton("Compare by Airports", width / 2 - 250, 300, 500, 80, currentScreen == 4);
}

void drawCompareAirlines() {
  fill(50);
  textAlign(CENTER);
  textSize(24);
  text("Compare Airlines", width / 2, 50);

  textAlign(LEFT);
  textSize(16);

  // Airline 1 input box
  fill(255);
  rect(20, 100, 300, 40);
  fill(0);
  text("Enter Airline 1: " + searchQuery, 30, 125);

  // Airline 2 input box (moved further down to prevent overlap)
  fill(255);
  rect(20, 200, 300, 40);
  fill(0);
  text("Enter Airline 2: " + searchQuery2, 30, 225);

  // Draw matching airlines for searchQuery (Airline 1)
  ArrayList<String> matchingAirlines1 = findMatchingAirlines(searchQuery);
  for (int i = 0; i < min(10, matchingAirlines1.size()); i++) {
    String airline = matchingAirlines1.get(i);
    drawButton(airline, 20, 260 + i * 30, 300, 25, searchQuery.equals(airline));
  }

  // Draw matching airlines for searchQuery2 (Airline 2)
  ArrayList<String> matchingAirlines2 = findMatchingAirlines(searchQuery2);
  for (int i = 0; i < min(10, matchingAirlines2.size()); i++) {
    String airline = matchingAirlines2.get(i);
    drawButton(airline, 20, 440 + i * 30, 300, 25, searchQuery2.equals(airline));
  }

  // Draw two large boxes for graphs (moved down by 50px)
  stroke(150);
  strokeWeight(2);
  
  // First box (left)
  fill(220);
  rect(350, 100, 500, 500);
  fill(0);
  textAlign(CENTER);
  text("Graph 1: " + (searchQuery.isEmpty() ? "No Airline Selected" : searchQuery), 600, 100);
  
  // Second box (right)
  fill(220);
  rect(870, 100, 500, 500);
  fill(0);
  textAlign(CENTER);
  text("Graph 2: " + (searchQuery2.isEmpty() ? "No Airline Selected" : searchQuery2), 1120, 100);
}

void drawCompareAirports(){
  // Future code for compare by airports (if needed)
}

void drawAirportView() {
  textFont(titleFont);
  fill(50);
  textAlign(CENTER);
  text("Flights by Airport", width/2, 80);

  textFont(regularFont);
  textAlign(LEFT);

  // Draw airport filter
  fill(255);
  rect(20, 100, 300, 40);
  fill(0);
  text("Search Airport: " + searchQuery, 30, 125);

  // Draw airport list based on search
  ArrayList<String> matchingAirports = findMatchingAirports(searchQuery);
  for (int i = 0; i < min(10, matchingAirports.size()); i++) {
    String airport = matchingAirports.get(i);
    boolean isSelected = airport.equals(selectedAirport);
    drawButton(airport, 20, 150 + i * 30, 300, 25, isSelected);
  }

  // Draw flight data if an airport is selected
  if (!selectedAirport.isEmpty()) {
    drawFlightTable(350, 100, width - 380, height - 150);
    drawAirportStats(selectedAirport);
  }
}

ArrayList<String> findMatchingAirlines(String searchQuery) {
  ArrayList<String> matchingAirlines = new ArrayList<String>();

  for (Flight flight : flights) {
    if (flight.airline.toLowerCase().contains(searchQuery.toLowerCase()) && !matchingAirlines.contains(flight.airline)) {
      matchingAirlines.add(flight.airline);
    }
  }

  return matchingAirlines;
}

ArrayList<String> findMatchingAirports(String searchQuery) {
  ArrayList<String> matchingAirports = new ArrayList<String>();

  for (String airportCode : airports.keySet()) {
    if (airportCode.toLowerCase().contains(searchQuery.toLowerCase())) {
      matchingAirports.add(airportCode);
    }
  }

  return matchingAirports;
}

// PRAD
void drawDateRangeView() {
  textFont(titleFont);
  fill(50);
  textAlign(CENTER);
  text("Flights by Date Range", width/2, 80);

  textFont(regularFont);
  textAlign(LEFT);

  // Draw date range selector
  fill(255);
  rect(20, 100, 150, 40);
  rect(200, 100, 150, 40);
  fill(0);
  text("Start Date: " + startDate, 30, 125);
  text("End Date: " + endDate, 210, 125);

  // Apply filter button
  drawButton("Apply Filter", 20, 160, 150, 40, false);

  // Draw flight data
  drawFlightTable(20, 220, width - 40, height - 270);

  // Draw date range visualization
  drawDateRangeVisualization();
}

void drawLatenessView() {
  textFont(titleFont);
  fill(50);
  textAlign(CENTER);
  text("Flights by Lateness", width/2, 80);

  textFont(regularFont);
  textAlign(LEFT);

  // Draw lateness visualization
  drawLatenessVisualization();

  // Draw flight data
  drawFlightTable(20, 350, width - 40, height - 400);
}

void drawNavigationBar() {
  fill(50);
  rect(0, height - 50, width, 50);
  fill(255);
  textAlign(CENTER);
  textFont(regularFont);

  // Draw navigation buttons
  drawButton("Main Menu", 100, height - 40, 150, 30, currentScreen == 0);
  drawButton("Airport View", 300, height - 40, 150, 30, currentScreen == 1);
  drawButton("Date Range", 500, height - 40, 150, 30, currentScreen == 2);
  drawButton("Lateness", 700, height - 40, 150, 30, currentScreen == 3);
  drawButton("Compare", 900, height - 40, 150, 30, currentScreen == 4);

  // Draw pagination controls if applicable
  if (filteredFlights.size() > recordsPerPage) {
    drawButton("Previous", width - 350, height - 40, 100, 30, false);
    drawButton("Next", width - 150, height - 40, 100, 30, false);
    fill(255);
    textAlign(CENTER);
    text("Page " + (startIndex / recordsPerPage + 1) + " of " +
         (int)Math.ceil(filteredFlights.size() / (float)recordsPerPage), width - 200, height - 25);
  }
}

void drawButton(String label, float x, float y, float w, float h, boolean selected) {
  if (selected) {
    fill(100, 150, 230);
  } else if (mouseX >= x && mouseX <= x + w && mouseY >= y && mouseY <= y + h) {
    fill(200, 220, 255);
  } else {
    fill(180);
  }
  rect(x, y, w, h, 5);

  fill(0);
  textAlign(CENTER, CENTER);
  text(label, x + w/2, y + h/2);
}

void drawFlightTable(float x, float y, float w, float h) {
  fill(255);
  rect(x, y, w, h);

  // Draw table headers
  fill(50);
  rect(x, y, w, 30);
  fill(255);
  textAlign(LEFT, CENTER);
  text("Date", x + 10, y + 15);
  text("Flight", x + 100, y + 15);
  text("Origin", x + 180, y + 15);
  text("Destination", x + 270, y + 15);
  text("Scheduled Dep", x + 370, y + 15);
  text("Actual Dep", x + 470, y + 15);
  text("Scheduled Arr", x + 570, y + 15);
  text("Actual Arr", x + 670, y + 15);
  text("Status", x + 770, y + 15);

  // Draw rows
  fill(0);
  int endIndex = min(startIndex + recordsPerPage, filteredFlights.size());
  for (int i = startIndex; i < endIndex; i++) {
    Flight flight = filteredFlights.get(i);
    float rowY = y + 30 + (i - startIndex) * 30;

    // Alternate row colors
    if ((i - startIndex) % 2 == 0) {
      fill(240);
    } else {
      fill(220);
    }
    rect(x, rowY, w, 30);

    fill(0);
    textAlign(LEFT, CENTER);
    text(formatDate(flight.flightDate), x + 10, rowY + 15);
    text(flight.airline + flight.flightNumber, x + 100, rowY + 15);
    text(flight.origin, x + 180, rowY + 15);
    text(flight.destination, x + 270, rowY + 15);
    text(formatTime(flight.scheduledDeparture), x + 370, rowY + 15);
    text(formatTime(flight.actualDeparture), x + 470, rowY + 15);
    text(formatTime(flight.scheduledArrival), x + 570, rowY + 15);
    text(formatTime(flight.actualArrival), x + 670, rowY + 15);

    // Status (cancelled, diverted, on time, delayed)
    if (flight.cancelled == 1) {
      fill(255, 0, 0);
      text("Cancelled", x + 770, rowY + 15);
    } else if (flight.diverted == 1) {
      fill(255, 165, 0);
      text("Diverted", x + 770, rowY + 15);
    } else if (flight.actualDeparture > flight.scheduledDeparture) {
      fill(255, 165, 0);
      int delayMinutes = calculateDelayMinutes(flight.scheduledDeparture, flight.actualDeparture);
      text("Delayed " + delayMinutes + " min", x + 770, rowY + 15);
    } else {
      fill(0, 128, 0);
      text("On Time", x + 770, rowY + 15);
    }
  }
}

// YANKO
void drawSummaryVisualization() {
  // Draw a simple summary visualization at the bottom of the main screen
  fill(255);
  rect(50, 450, width - 100, 300);

  // Count flights per airline
  HashMap<String, Integer> airlineCounts = new HashMap<String, Integer>();
  for (Flight flight : flights) {
    if (airlineCounts.containsKey(flight.airline)) {
      airlineCounts.put(flight.airline, airlineCounts.get(flight.airline) + 1);
    } else {
      airlineCounts.put(flight.airline, 1);
    }
  }

  // Draw a bar chart of top airlines
  ArrayList<Map.Entry<String, Integer>> sortedAirlines = new ArrayList<Map.Entry<String, Integer>>(airlineCounts.entrySet());
  Collections.sort(sortedAirlines, new Comparator<Map.Entry<String, Integer>>() {
    public int compare(Map.Entry<String, Integer> a, Map.Entry<String, Integer> b) {
      return b.getValue().compareTo(a.getValue());
    }
  });

  fill(50);
  textAlign(CENTER);
  text("Top Airlines by Number of Flights", width/2, 470);

  int maxCount = 0;
  for (int i = 0; i < min(10, sortedAirlines.size()); i++) {
    if (sortedAirlines.get(i).getValue() > maxCount) {
      maxCount = sortedAirlines.get(i).getValue();
    }
  }

  // Draw bars
  for (int i = 0; i < min(10, sortedAirlines.size()); i++) {
    String airline = sortedAirlines.get(i).getKey();
    int count = sortedAirlines.get(i).getValue();
    float barHeight = (count / (float)maxCount) * 200;
    float barWidth = (width - 200) / min(10, sortedAirlines.size());

    fill(100, 150, 230);
    rect(100 + i * barWidth, 700 - barHeight, barWidth - 10, barHeight);

    fill(0);
    textAlign(CENTER);
    text(airline, 100 + i * barWidth + barWidth/2, 720);
    text(count, 100 + i * barWidth + barWidth/2, 700 - barHeight - 10);
  }
}

// SUMAMA
void drawAirportStats(String airport) {
  // Count flights to/from the selected airport
  int departingFlights = 0;
  int arrivingFlights = 0;
  int cancelledFlights = 0;
  int divertedFlights = 0;
  int delayedFlights = 0;

  for (Flight flight : flights) {
    if (flight.origin.equals(airport)) {
      departingFlights++;
      if (flight.cancelled == 1) {
        cancelledFlights++;
      } else if (flight.diverted == 1) {
        divertedFlights++;
      } else if (flight.actualDeparture > flight.scheduledDeparture) {
        delayedFlights++;
      }
    }
    if (flight.destination.equals(airport)) {
      arrivingFlights++;
    }
  }

  // Draw stats box
  fill(255);
  rect(20, 400, 300, 400); // Increased height for spacing

  fill(50);
  textAlign(CENTER);
  text("Airport Statistics: " + airport, 170, 420);

  textAlign(LEFT);
  fill(0);
  text("Departing Flights: " + departingFlights, 30, 450);
  text("Arriving Flights: " + arrivingFlights, 30, 480);
  text("Cancelled Flights: " + cancelledFlights, 30, 510);
  text("Diverted Flights: " + divertedFlights, 30, 540);
  text("Delayed Flights: " + delayedFlights, 30, 570);

  // Prevent division by zero
  if (departingFlights == 0) {
    text("No departing flights to show pie chart", 30, 600);
    return;
  }

  // Draw a pie chart of flight statuses
  float total = departingFlights;
  float cancelledPercentage = (float)cancelledFlights / total;
  float divertedPercentage = (float)divertedFlights / total;
  float delayedPercentage = (float)delayedFlights / total;
  float normalPercentage = 1 - cancelledPercentage - divertedPercentage - delayedPercentage;

  int pieX = 170, pieY = 620, pieSize = 100; // Adjusted Y position

  // Draw pie chart sections
  float startAngle = 0;

  // Normal flights - Cyan
  fill(0, 204, 102);
  arc(pieX, pieY, pieSize, pieSize, startAngle, startAngle + normalPercentage * TWO_PI);
  startAngle += normalPercentage * TWO_PI;

  // Cancelled flights - Red
  fill(255, 0, 0);
  arc(pieX, pieY, pieSize, pieSize, startAngle, startAngle + cancelledPercentage * TWO_PI);
  startAngle += cancelledPercentage * TWO_PI;

  // Diverted flights - Orange
  fill(255, 165, 0);
  arc(pieX, pieY, pieSize, pieSize, startAngle, startAngle + divertedPercentage * TWO_PI);
  startAngle += divertedPercentage * TWO_PI;

  // Delayed flights - Yellow
  fill(255, 255, 0);
  arc(pieX, pieY, pieSize, pieSize, startAngle, startAngle + delayedPercentage * TWO_PI);

  // Adjusted Legend Positioning
  int legendX = 20, legendY = height - 130;

  // Draw legend rectangles
  fill(0, 204, 102);
  rect(legendX, legendY, 15, 15);
  fill(255, 0, 0);
  rect(legendX, legendY + 20, 15, 15);
  fill(255, 165, 0);
  rect(legendX, legendY + 40, 15, 15);
  fill(255, 255, 0);
  rect(legendX, legendY + 60, 15, 15);

  // Draw legend text
  fill(0);
  textAlign(LEFT);
  text("Normal: " + (int)(normalPercentage * 100) + "%", legendX + 20, legendY + 10);
  text("Cancelled: " + (int)(cancelledPercentage * 100) + "%", legendX + 20, legendY + 30);
  text("Diverted: " + (int)(divertedPercentage * 100) + "%", legendX + 20, legendY + 50);
  text("Delayed: " + (int)(delayedPercentage * 100) + "%", legendX + 20, legendY + 70);
}

// YUSUF
void drawDateRangeVisualization() {
  // Draw a line chart of flights per day
  HashMap<String, Integer> flightsPerDay = new HashMap<String, Integer>();

  for (Flight flight : filteredFlights) {
    String date = flight.flightDate;
    if (flightsPerDay.containsKey(date)) {
      flightsPerDay.put(date, flightsPerDay.get(date) + 1);
    } else {
      flightsPerDay.put(date, 1);
    }
  }

  // Sort dates
  ArrayList<String> dates = new ArrayList<String>(flightsPerDay.keySet());
  Collections.sort(dates);

  // Find max value
  int maxFlights = 0;
  for (Integer count : flightsPerDay.values()) {
    if (count > maxFlights) {
      maxFlights = count;
    }
  }

  // Draw chart
  fill(255);
  rect(400, 100, width - 420, 100);

  fill(50);
  textAlign(CENTER);
  text("Flights per Day", width/2, 120);

  // Draw lines
  stroke(100, 150, 230);
  strokeWeight(2);

  float xStep = (width - 440) / (float)(dates.size() - 1);
  for (int i = 0; i < dates.size() - 1; i++) {
    float x1 = 410 + i * xStep;
    float y1 = 190 - (flightsPerDay.get(dates.get(i)) / (float)maxFlights) * 60;
    float x2 = 410 + (i + 1) * xStep;
    float y2 = 190 - (flightsPerDay.get(dates.get(i + 1)) / (float)maxFlights) * 60;

    line(x1, y1, x2, y2);

    // Draw points
    fill(100, 150, 230);
    ellipse(x1, y1, 5, 5);
  }

  // Draw last point
  fill(100, 150, 230);
  ellipse(410 + (dates.size() - 1) * xStep,
          190 - (flightsPerDay.get(dates.get(dates.size() - 1)) / (float)maxFlights) * 60,
          5, 5);

  strokeWeight(1);
  stroke(0);
}

void drawLatenessVisualization() {
  // Calculate average delay by airline
  HashMap<String, Integer> totalDelayByAirline = new HashMap<String, Integer>();
  HashMap<String, Integer> flightCountByAirline = new HashMap<String, Integer>();

  for (Flight flight : flights) {
    if (flight.cancelled == 0 && flight.diverted == 0 &&
        flight.actualDeparture > 0 && flight.scheduledDeparture > 0) {
      int delay = calculateDelayMinutes(flight.scheduledDeparture, flight.actualDeparture);

      if (totalDelayByAirline.containsKey(flight.airline)) {
        totalDelayByAirline.put(flight.airline, totalDelayByAirline.get(flight.airline) + delay);
        flightCountByAirline.put(flight.airline, flightCountByAirline.get(flight.airline) + 1);
      } else {
        totalDelayByAirline.put(flight.airline, delay);
        flightCountByAirline.put(flight.airline, 1);
      }
    }
  }

  // Calculate average delay
  HashMap<String, Float> avgDelayByAirline = new HashMap<String, Float>();
  for (String airline : totalDelayByAirline.keySet()) {
    avgDelayByAirline.put(airline,
                          totalDelayByAirline.get(airline) / (float)flightCountByAirline.get(airline));
  }

  // Sort airlines by average delay
  ArrayList<Map.Entry<String, Float>> sortedAirlines =
    new ArrayList<Map.Entry<String, Float>>(avgDelayByAirline.entrySet());
  Collections.sort(sortedAirlines, new Comparator<Map.Entry<String, Float>>() {
    public int compare(Map.Entry<String, Float> a, Map.Entry<String, Float> b) {
      return b.getValue().compareTo(a.getValue());
    }
  });

  // Draw horizontal bar chart
  fill(255);
  rect(20, 100, width - 40, 230);

  fill(50);
  textAlign(CENTER);
  text("Average Delay by Airline (minutes)", width/2, 120);

  // Draw bars
  textAlign(RIGHT);
  for (int i = 0; i < min(10, sortedAirlines.size()); i++) {
    String airline = sortedAirlines.get(i).getKey();
    float avgDelay = sortedAirlines.get(i).getValue();

    fill(0);
    text(airline, 100, 150 + i * 18);

    fill(255, 100, 100);
    rect(110, 142 + i * 18, min(avgDelay * 5, width - 160), 12);

    fill(0);
    textAlign(LEFT);
    text(nf(avgDelay, 0, 1) + " min", 115 + min(avgDelay * 5, width - 160), 150 + i * 18);
  }
}

// Global variable to track which airline text field is active:
// 0 = none, 1 = Airline 1 field, 2 = Airline 2 field
int activeAirlineField = 0;


void keyPressed() {
  if (currentScreen == 5) { // Compare Airlines screen
    if (activeAirlineField == 1) { // Update Airline 1 field
      if (key == BACKSPACE && searchQuery.length() > 0) {
        searchQuery = searchQuery.substring(0, searchQuery.length() - 1);
      } else if (key >= ' ' && key <= 'z') {
        searchQuery += key;
      }
    } else if (activeAirlineField == 2) { // Update Airline 2 field
      if (key == BACKSPACE && searchQuery2.length() > 0) {
        searchQuery2 = searchQuery2.substring(0, searchQuery2.length() - 1);
      } else if (key >= ' ' && key <= 'z') {
        searchQuery2 += key;
      }
    }
  } else if (currentScreen == 1) {
    // Existing airport view key handling:
    if (key == BACKSPACE && searchQuery.length() > 0) {
      searchQuery = searchQuery.substring(0, searchQuery.length() - 1);
    } else if (key >= ' ' && key <= 'z') {
      searchQuery += key;
    }
  } else if (currentScreen == 2) {
    // Date range view key handling:
    if (mouseX >= 20 && mouseX <= 170 && mouseY >= 100 && mouseY <= 140) {
      // Start date input
      if (key == BACKSPACE && startDate.length() > 0) {
        startDate = startDate.substring(0, startDate.length() - 1);
      } else if ((key >= '0' && key <= '9') || key == '/') {
        startDate += key;
      }
    } else if (mouseX >= 200 && mouseX <= 350 && mouseY >= 100 && mouseY <= 140) {
      // End date input
      if (key == BACKSPACE && endDate.length() > 0) {
        endDate = endDate.substring(0, endDate.length() - 1);
      } else if ((key >= '0' && key <= '9') || key == '/') {
        endDate += key;
      }
    }
  }
}

void mousePressed() {
  // Main menu buttons
  if (currentScreen == 0) {
    if (mouseX >= width / 2 - 150 && mouseX <= width / 2 + 150) {
      if (mouseY >= 120 && mouseY <= 180) {
        currentScreen = 4; // Compare view
        return;
      } else if (mouseY >= 200 && mouseY <= 260) {
        currentScreen = 1; // Airport view
        return;
      } else if (mouseY >= 280 && mouseY <= 340) {
        currentScreen = 2; // Date range view
        return;
      } else if (mouseY >= 360 && mouseY <= 420) {
        currentScreen = 3; // Lateness view
        return;
      }
    }
  }

  // Compare view - select comparison type
  if (currentScreen == 4) {
    if (mouseX >= width / 2 - 250 && mouseX <= width / 2 + 250) {
      if (mouseY >= 200 && mouseY <= 280) {
        currentScreen = 5; // Compare by Flights (Airlines)
        return;
      } else if (mouseY >= 300 && mouseY <= 380) {
        currentScreen = 6; // Compare by Airports
        return;
      }
    }
  }

  // Airport view - airport selection
  if (currentScreen == 1) {
    ArrayList<String> matchingAirports = findMatchingAirports(searchQuery);
    for (int i = 0; i < min(10, matchingAirports.size()); i++) {
      if (mouseX >= 20 && mouseX <= 320 &&
          mouseY >= 150 + i * 30 && mouseY <= 175 + i * 30) {
        selectedAirport = matchingAirports.get(i);
        filterFlightsByAirport(selectedAirport);
        return;
      }
    }
  }

  // Date range view - apply filter button
  if (currentScreen == 2) {
    if (mouseX >= 20 && mouseX <= 170 && mouseY >= 160 && mouseY <= 200) {
      filterFlightsByDateRange(startDate, endDate);
      return;
    }
  }

  // Compare Airlines screen
  if (currentScreen == 5) {
    // Check if click is in Airline 1 input box:
    if (mouseX >= 20 && mouseX <= 320 && mouseY >= 100 && mouseY <= 140) {
      activeAirlineField = 1;  // Activate Airline 1 field
      return;
    }
    // Check if click is in Airline 2 input box:
    // Updated the Y-range here to match the drawn rectangle at y=200, height=40 (200 to 240)
    if (mouseX >= 20 && mouseX <= 320 && mouseY >= 200 && mouseY <= 240) {
      activeAirlineField = 2;  // Activate Airline 2 field
      return;
    }
    
    // Check if click is on an Airline 1 list item
    ArrayList<String> matchingAirlines1 = findMatchingAirlines(searchQuery);
    for (int i = 0; i < min(10, matchingAirlines1.size()); i++) {
      if (mouseX >= 20 && mouseX <= 320 &&
          mouseY >= 260 + i * 30 && mouseY <= 285 + i * 30) {
        searchQuery = matchingAirlines1.get(i);
        activeAirlineField = 0; // Deactivate field after selection
        return;
      }
    }
    
    // Check if click is on an Airline 2 list item
    ArrayList<String> matchingAirlines2 = findMatchingAirlines(searchQuery2);
    for (int i = 0; i < min(10, matchingAirlines2.size()); i++) {
      if (mouseX >= 20 && mouseX <= 320 &&
          mouseY >= 440 + i * 30 && mouseY <= 465 + i * 30) {
        searchQuery2 = matchingAirlines2.get(i);
        activeAirlineField = 0; // Deactivate field after selection
        return;
      }
    }
  }

  // Navigation bar
  if (mouseY >= height - 50) {
    if (mouseX >= 100 && mouseX <= 250) {
      currentScreen = 0; // Main menu
      return;
    } else if (mouseX >= 300 && mouseX <= 450) {
      currentScreen = 1; // Airport view
      return;
    } else if (mouseX >= 500 && mouseX <= 650) {
      currentScreen = 2; // Date range view
      return;
    } else if (mouseX >= 700 && mouseX <= 850) {
      currentScreen = 3; // Lateness view
      return;
    } else if (mouseX >= 900 && mouseX <= 1050) {
      currentScreen = 4; // Compare view
      return;
    }
  }

  // "Previous" button in Compare View (Return to Main Menu)
  if (currentScreen == 4) {
    if (mouseX >= width - 300 && mouseX <= width - 200 &&
        mouseY >= height - 40 && mouseY <= height - 10) {
      currentScreen = 0;
      return;
    }
  }

  // Pagination controls
  if (filteredFlights.size() > recordsPerPage) {
    if (mouseX >= width - 300 && mouseX <= width - 200 &&
        mouseY >= height - 40 && mouseY <= height - 10) {
      startIndex = max(0, startIndex - recordsPerPage);
      return;
    } else if (mouseX >= width - 150 && mouseX <= width - 50 &&
               mouseY >= height - 40 && mouseY <= height - 10) {
      startIndex = min(filteredFlights.size() - recordsPerPage, startIndex + recordsPerPage);
      return;
    }
  }
}

// DANIEL
void loadFlightData(String filename) {
  println("Loading flight data from " + filename);
  String[] lines = loadStrings(filename);

  // Skip header
  for (int i = 1; i < lines.length; i++) {
    String[] data = lines[i].split(",");

    // Make sure we have enough data
    if (data.length >= 17) {
      Flight flight = new Flight();

      // Parse flight data
      flight.flightDate = data[0];
      flight.airline = data[1];
      flight.flightNumber = data[2];
      flight.origin = data[3];
      flight.originCity = data[4];
      flight.originState = data[5];
      flight.originWac = parseInt(data[6]);
      flight.destination = data[7];
      flight.destinationCity = data[8];
      flight.destinationState = data[9];
      flight.destinationWac = parseInt(data[10]);
      flight.scheduledDeparture = parseInt(data[11]);
      flight.actualDeparture = parseInt(data[12]);
      flight.scheduledArrival = parseInt(data[13]);
      flight.actualArrival = parseInt(data[14]);
      flight.cancelled = parseInt(data[15]);
      flight.diverted = parseInt(data[16]);

      if (data.length > 17) {
        flight.distance = parseFloat(data[17]);
      }

      flights.add(flight);

      // Add origin and destination to airports
      if (!airports.containsKey(flight.origin)) {
        Airport airport = new Airport();
        airport.code = flight.origin;
        airport.city = flight.originCity;
        airport.state = flight.originState;
        airport.wac = flight.originWac;
        airports.put(flight.origin, airport);
      }

      if (!airports.containsKey(flight.destination)) {
        Airport airport = new Airport();
        airport.code = flight.destination;
        airport.city = flight.destinationCity;
        airport.state = flight.destinationState;
        airport.wac = flight.destinationWac;
        airports.put(flight.destination, airport);
      }

      // Add airline to airlines map
      if (!airlines.containsKey(flight.airline)) {
        airlines.put(flight.airline, 1);
      } else {
        airlines.put(flight.airline, airlines.get(flight.airline) + 1);
      }
    }
  }
  println("Loaded " + flights.size() + " flights and " + airports.size() + " airports");
}

String formatDate(String date) {
  // Convert from YYYYMMDD to MM/DD/YYYY
  if (date.length() >= 8) {
    String year = date.substring(0, 4);
    String month = date.substring(4, 6);
    String day = date.substring(6, 8);
    return month + "/" + day + "/" + year;
  }
  return date;
}

String formatTime(int time) {
  if (time <= 0) return "-";

  // Convert from HHMM to HH:MM
  String timeStr = String.format("%04d", time);
  return timeStr.substring(0, 2) + ":" + timeStr.substring(2, 4);
}

int calculateDelayMinutes(int scheduled, int actual) {
  if (scheduled <= 0 && actual <= 0) return 0;

  int scheduledHour = scheduled / 60;
  int scheduledMinute = scheduled % 60;
  int actualHour = actual / 60;
  int actualMinute = actual % 60;

  int scheduledTotalMinutes = scheduledHour * 60 + scheduledMinute;
  int actualTotalMinutes = actualHour * 60 + actualMinute;

  int diff = actualTotalMinutes - scheduledTotalMinutes;

  // Handle overnight flights
  if (diff < -720) {  // More than 12 hours negative
    diff += 1440;     // Add 24 hours
  } else if (diff > 720) {  // More than 12 hours positive
    diff -= 1440;     // Subtract 24 hours
  }

  return max(diff, 0);  // Only return positive delays
}
void filterFlightsByAirport(String airport) {
  filteredFlights.clear();
  for (Flight flight : flights) {
    if (flight.origin.equals(airport) || flight.destination.equals(airport)) {
      filteredFlights.add(flight);
    }
  }
  startIndex = 0; // Reset the start index for pagination
}
void filterFlightsByDateRange(String startDate, String endDate) {
  filteredFlights.clear();
  for (Flight flight : flights) {
    if (flight.flightDate.compareTo(startDate) >= 0 && flight.flightDate.compareTo(endDate) <= 0) {
      filteredFlights.add(flight);
    }
  }
  startIndex = 0; // Reset the start index for pagination
}


// Flight class
class Flight {
  String flightDate;
  String airline;
  String flightNumber;
  String origin;
  String originCity;
  String originState;
  int originWac;
  String destination;
  String destinationCity;
  String destinationState;
  int destinationWac;
  int scheduledDeparture;
  int actualDeparture;
  int scheduledArrival;
  int actualArrival;
  int cancelled;
  int diverted;
  float distance;
}

// Airport class
class Airport {
  String code;
  String city;
  String state;
  int wac;
}
