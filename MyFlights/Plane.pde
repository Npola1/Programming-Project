class Plane {
  float x, y, speedX, speedY, amplitude, frequency, time;
  PImage img;

  Plane(float startX, float startY, float sX, float sY, float a, float f, PImage image) {
    x = startX;
    y = startY;
    speedX = sX;
    speedY = sY;
    amplitude = a;
    frequency = f;
    time = 0;
    img = image;
  }

  void update() {
    x += speedX;
    y += speedY + amplitude * sin(time);
    time += frequency;
    if (y > height) {
      planeVisible = false;
      exploded = true;
      explosionStartTime = millis();
      explosionX = x;
      explosionY = height - explosionImage.height;
    }
  }

  void display() {
    if (img != null) {
      image(img, x, y);
    } else {
      fill(0);
      triangle(x, y, x + 30, y - 10, x + 30, y + 10);
      rect(x + 10, y - 10, 40, 20);
      triangle(x + 40, y, x + 60, y - 10, x + 60, y + 10);
    }
  }
}
