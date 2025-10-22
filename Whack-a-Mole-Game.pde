int score = 0;
int timer = 30; // Set the game duration in seconds
int moleInterval = 3000; // Set the initial interval at which moles appear in millis
int lastMoleTime = 0;
boolean moleActive = false;
int moleSpeedIncrease = 200; // Set the amount to reduce moleInterval by on each click

// Define the positions of the circles
float[] circleX = new float[6];
float[] circleY = new float[6];

float moleX, moleY; // Position of the mole
int moleVisibleStartTime; // Record the start time when the mole becomes visible
int moleVisibleDuration = 120; // Set the duration in frames that the mole remains visible (2 seconds at 60 fps)

void setup() {
  size(400, 400);
  
  // Set up positions for the circles
  circleX[0] = 100; //I hard coded this because i wanted to control every circle positon
  circleY[0] = 115;
  circleX[1] = 230;
  circleY[1] = 115;
  circleX[2] = 350;
  circleY[2] = 115;
  circleX[3] = 100;
  circleY[3] = 230;
  circleX[4] = 230;
  circleY[4] = 230;
  circleX[5] = 350;
  circleY[5] = 230;
  
  moleX = -100; // Initialize mole position off-screen
  moleY = -100;
}

void drawMole(float x, float y) {
  // Draw mouse head
  fill(125, 75, 0); // Brown color for mole head
  ellipse(x, y, 50, 30);
  
  // Draw mole ears
  fill(125, 75, 0); // Brown color for ears
  ellipse(x - 15, y - 15, 20, 20);
  ellipse(x + 15, y - 15, 20, 20);
  
  // Draw mole eyes
  fill(255); // White color for eyes
  ellipse(x - 10, y, 8, 8);
  ellipse(x + 10, y, 8, 8);
  
  // Draw mole nose
  fill(0); // Black color for nose
  ellipse(x, y + 5, 5, 5);
  
  // Draw mole tail
  stroke(125, 75, 0); // Brown color for tail
  strokeWeight(3);
  line(x + 20, y + 15, x + 40, y - 10);
  strokeWeight(2);
  stroke(0);
}

void draw() {
  background(0, 128, 0); // Green background
  
  // Draw brown rectangle in the middle
  fill(139, 69, 19); // Brown color for rectangle
  rect(0, 70, width, 260);
  
  // Draw circles inside the rectangle
  fill(0); // Black color for circles
  for (int i = 0; i < 6; i++) {
    ellipse(circleX[i], circleY[i], 60, 60);
  }
  
  // Display score and timer
  fill(255);
  textSize(20);
  text("Score: " + score, 20, 30);
  text("Time: " + timer, width - 100, 30);
  
  // Draw the mole if active
  if (moleActive) {
    drawMole(moleX, moleY);
  }
  
  // Check if the game is over
  if (timer <= 0) {
    gameOver();
  } else {
    // Check if it's time to show a new mole
    if (!moleActive && millis() - lastMoleTime > moleInterval) {
      // Choose a random circle
      int randomCircle = int(random(6));
      
      // Choose a random position within the selected circle
      moleX = random(circleX[randomCircle], circleX[randomCircle]);
      moleY = random(circleY[randomCircle], circleY[randomCircle]);
      
      moleActive = true;
      moleVisibleStartTime = frameCount; // Record the start time when the mole becomes visible
      lastMoleTime = millis(); // Record the time when the mole became active
    }
    
    // Check if it's time to hide the mole
    if (moleActive && frameCount - moleVisibleStartTime > moleVisibleDuration) {
      moleActive = false;  // Hide the mole after the visible duration
      lastMoleTime = millis();  // Update lastMoleTime after hiding the mole
    }
    
    // Decrease timer
    if (frameCount % 60 == 0 && timer > 0) {
      timer--;
    }
  }
}

void mousePressed() {
  // Check if the mouse click is on an active mole
  if (moleActive) {
    float distance = dist(mouseX, mouseY, moleX, moleY);
    if (distance < 25) {
      score++;
      // Reset mole position off-screen
      moleX = -100;
      moleY = -100;
      moleActive = false;
      // Increase mole speed on each click
      moleInterval -= moleSpeedIncrease;
      if (moleInterval < 500) {
        moleInterval = 500; // Ensure the minimum interval is not too fast
      }
    }
  }
}

void gameOver() {
  background(0, 128, 0);
  fill(255);
  textSize(32);
  textAlign(CENTER, CENTER);
  text("Game Over!", width / 2, height / 2 - 50);
  text("Score: " + score, width / 2, height / 2 + 50);
  noLoop(); // Stop the draw loop
}
