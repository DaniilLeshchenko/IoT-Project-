// Includes the Servo library
#include <Servo.h>

// Defines Tirg and Echo pins of the Ultrasonic Sensor
const int trigPin = 12;
const int echoPin = 11;
// Defines the pin for reading from the potentiometer
const int potPin = A1;  
// Defines pins for the servo motors
const int servo1Pin = 3;
const int servo2Pin = 4;
// Defines the pin for the speaker
const int speakerPin = 8;

// Variables for the duration and the distance
long duration;
int distance;
// Variable for the angle of the servo motion
int angle = 0;

// Distance threshold for triggering the alert
int thresholdDistance = 10;
// Direction of servo movement
bool forward = true;

// Creates servo objects for controlling the servo motors
Servo myServo1;
Servo myServo2;

void setup() {
  // Sets the trigPin as an Output
  pinMode(trigPin, OUTPUT);
  // Sets the echoPin as an Input
  pinMode(echoPin, INPUT);
  // Sets the speakerPin as an Output
  pinMode(speakerPin, OUTPUT);
  // Initializes serial communication
  Serial.begin(9600);
  // Attaches the servo motors to their respective pins
  myServo1.attach(servo1Pin);
  myServo2.attach(servo2Pin);
}

void loop() {
  // Reads the value from the potentiometer (0-690)
  int potValue = analogRead(potPin);
  // Maps the potentiometer value to a servo angle (0-180 degrees)
  int manualAngle = map(potValue, 0, 690, 0, 180);
  // Sets the angle of the second servo based on the potentiometer
  myServo2.write(manualAngle);
  // Short delay for stability
  delay(5);

  // Rotates the first servo motor within a range
  if (forward) {
    myServo1.write(angle);
    delay(5);
    // Calculates the distance measured by the Ultrasonic sensor for each degree
    distance = calculateDistance();
    // Prints angle, distance, and manual angle to the serial monitor
    Serial.print(angle);
    Serial.print(",");
    Serial.print(distance);
    Serial.print(",");
    Serial.print(manualAngle);
    Serial.print(".");
    
    // Increments the angle for the next position
    angle++;
    // Checks the distance and plays a sound alert if necessary
    soundAlert(distance);
  } else {
    // Similar operations for moving the servo in the opposite direction
    myServo1.write(angle);
    delay(5);
    distance = calculateDistance();
    
    Serial.print(angle);
    Serial.print(",");
    Serial.print(distance);
    Serial.print(",");
    Serial.print(manualAngle);
    Serial.print(".");

    angle--;
    soundAlert(distance);
  }
  // Changes the direction of the servo motion at the endpoints
  if (angle == 181) {
    forward = false;
  }
  if (angle == -1) {
    forward = true;
  }
}

// Calculates the distance measured by the Ultrasonic sensor
int calculateDistance() { 
  digitalWrite(trigPin, LOW); 
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH); 
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  duration = pulseIn(echoPin, HIGH);
  distance = duration * 0.034 / 2;
  return distance;
}

// Plays a sound alert if an object is closer than the threshold distance
void soundAlert(int distance) {
  if (distance <= thresholdDistance) {
    // Increases the frequency for the alert
    for (int frequency = 100; frequency <= 1000; frequency++) {
      tone(speakerPin, frequency);
      delay(10);
    }

    // Decreases the frequency for the alert
    for (int frequency = 1000; frequency >= 100; frequency--) {
      tone(speakerPin, frequency);
      delay(10);
    }
  } else {
    // Turns off the speaker if the object is farther than the threshold
    noTone(speakerPin);
  }
}
