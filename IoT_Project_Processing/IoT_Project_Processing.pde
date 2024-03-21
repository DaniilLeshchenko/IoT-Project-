import processing.serial.*; // imports library for serial communication
import java.awt.event.KeyEvent; // imports library for reading the data from the serial port
import java.io.IOException;

Serial myPort; // defines Object Serial
// defubes variables
String angle="";
String distance="";
String data="";
String manualAngle = "";
String noObject;
float pixsDistance;
int iAngle, iDistance;
int index1=0;
int index2=0;
int index3 = 0;
PFont orcFont;

void setup() {
  
 //size (1920, 1080);
 fullScreen();
 smooth();
 myPort = new Serial(this,"COM7", 9600); // starts the serial communication
 myPort.bufferUntil('.'); // reads the data from the serial port up to the character '.'. So actually it reads this: angle,distance.
 orcFont = loadFont("OCRAExtended-30.vlw");
}

void draw() {
  
  fill(98,245,31);
  textFont(orcFont);
  // simulating motion blur and slow fade of the moving line
  noStroke();
  fill(0,4); 
  rect(0, 0, width, 1010); 
  
  fill(98,245,31); // green color
  // calls the functions for drawing the radar
  drawRadar(); 
  drawLine();
  drawObject();
  drawText();
}

void serialEvent (Serial myPort) { // starts reading data from the Serial Port
  // reads the data from the Serial Port up to the character '.' and puts it into the String variable "data".
  data = myPort.readStringUntil('.');
  data = data.substring(0,data.length()-1);
  
  index1 = data.indexOf(","); // find the character ',' and puts it into the variable "index1"
  angle= data.substring(0, index1); // read the data from position "0" to position of the variable index1 or thats the value of the angle the Arduino Board sent into the Serial Port
  distance= data.substring(index1+1, data.length()); // read the data from position "index1" to the end of the data pr thats the value of the distance
  
  index3 = data.lastIndexOf(","); // Находим последнюю запятую в строке
  manualAngle = data.substring(index3 + 1); // Считываем угол с потенциометра
  distance = data.substring(index1 + 1, index3); // Обновляем чтение расстояния
  // converts the String variables into Integer
  iAngle = int(angle);
  iDistance = int(distance);
}

void drawRadar() {
  pushMatrix();
  translate(960,1000); // перемещает начальные координаты в новое место
  noFill();
  strokeWeight(2);
  stroke(98,245,31);
  // рисует дуги арок
  arc(0,0,900*2,900*2,PI,TWO_PI); // радиус 900 пикселей
  arc(0,0,675*2,675*2,PI,TWO_PI); // радиус 675 пикселей
  arc(0,0,450*2,450*2,PI,TWO_PI); // радиус 450 пикселей
  arc(0,0,225*2,225*2,PI,TWO_PI); // радиус 225 пикселей
  // рисует линии углов
  line(-900,0,900,0);
  line(0,0,-900*cos(radians(30)),-900*sin(radians(30)));
  line(0,0,-900*cos(radians(60)),-900*sin(radians(60)));
  line(0,0,-900*cos(radians(90)),-900*sin(radians(90)));
  line(0,0,-900*cos(radians(120)),-900*sin(radians(120)));
  line(0,0,-900*cos(radians(150)),-900*sin(radians(150)));
  line(-900*cos(radians(30)),0,900,0);
  popMatrix();
}

void drawObject() {
  pushMatrix();
  translate(960,1000); // перемещает начальные координаты в новое место
  strokeWeight(9);
  stroke(255,10,10); // красный цвет для объекта
  // Используем коэффициент масштабирования, соответствующий максимальному радиусу радара
  pixsDistance = iDistance * (900.0 / 200.0); // пересчитывает дистанцию из см в пиксели
  // Ограничиваем диапазон до 200 см
  if(iDistance <= 200){
    // Рисуем объект в соответствии с углом и дистанцией
    line(pixsDistance*cos(radians(iAngle)), -pixsDistance*sin(radians(iAngle)), 900*cos(radians(iAngle)), -900*sin(radians(iAngle)));
  }
  popMatrix();
}

void drawLine() {
  pushMatrix();
  strokeWeight(9);
  stroke(30,250,60);
  translate(960,1000); // moves the starting coordinats to new location
  // Используем тот же коэффициент масштабирования для линии
  line(0,0,900*cos(radians(iAngle)),-900*sin(radians(iAngle))); // draws the line according to the angle
  popMatrix();
}
void drawText() {
  // Рисование текстов на экране
  pushMatrix();
  if(iDistance <= 200) {
    noObject = "In Range";
  } else {
    noObject = "Out of Range";
  }
  fill(0,0,0);
  noStroke();
  rect(0, 1010, width, 1080);
  fill(98,245,31);
  textSize(25);
  // Метки дистанции изменены для отображения до 2 метров
  text("50cm",1180,990);
  text("100cm",1380,990);
  text("150cm",1580,990);
  text("200cm",1780,990);
  textSize(40);
  text("Object: " + noObject, 240, 1050);
  text("Horizontal Angle: " + iAngle +" °", 850, 1050);
  text("Vertical Angle: " + manualAngle + " °", 850, 1120);
  text("Distance: ", 1450, 1050);
  if(iDistance <= 200) {
    text("        " + iDistance +" cm", 1470, 1050);
  }
  textSize(25);
  // Коррекция местоположения меток углов
  translate(961+960*cos(radians(30)),982-960*sin(radians(30)));
  rotate(-radians(-60));
  text("30°",0,0);
  resetMatrix();
  translate(954+960*cos(radians(60)),984-960*sin(radians(60)));
  rotate(-radians(-30));
  text("60°",0,0);
  resetMatrix();
  translate(945+960*cos(radians(90)),990-960*sin(radians(90)));
  rotate(radians(0));
  text("90°",0,0);
  resetMatrix();
  translate(935+960*cos(radians(120)),1003-960*sin(radians(120)));
  rotate(radians(-30));
  text("120°",0,0);
  resetMatrix();
  translate(940+960*cos(radians(150)),1018-960*sin(radians(150)));
  rotate(radians(-60));
  text("150°",0,0);
  popMatrix(); 
}
