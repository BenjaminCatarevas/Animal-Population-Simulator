//NOTE: Some parameter combinations (such as 700 rabbits, 25 foxes, .004 delta, and 2 delta time) results in a program crash. Please be aware when modifying the preloaded parameters.

//IMPORTED LIBRARIES
import controlP5.*; //button library
import javax.swing.JOptionPane; //dialog box library
import java.io.BufferedWriter; //writing library
import java.io.FileWriter; //file writing library

//GLOBALS
//Containers for the amount of rabbits and foxes

Animal Rabbit = new Animal(255.0, 255.0, 255.0); //instantiation of rabbit with parameters to define the color of the dot (white)
Animal Fox = new Animal(255.0, 134.0, 3.0); //instantiation of fox with parameters to define the color of the dot (orange)

ArrayList<Datapoint> phaseGraphPoints = new ArrayList <Datapoint>(); //arraylist to contain phase graph Datapoint objects
//we create an arraylist for the phase graph because it contains information from both instantiations of the Animal class
//we don't need to do this for the graph class or the bar graph class because those are only basing information of the time and the population of one animal population

LV amounts = new LV(); //new Lotka Volterra class; global to access the number of foxes and rabbits
//the above takes in 0 parameters because that is how we denote whether or not the user has submitted a simulation
//if this line was not here, it would not run successfully.
//with this constructor, we have a boolean set to denote whether or not the simulation has began, called "startSimulation"

//Object for creating textfields and buttons
ControlP5 cp5;

//Object for creating a checkbox
CheckBox lineGraphCheckbox, phaseGraphCheckbox, barGraphCheckbox;

Graph lineGraph; //global variable to access all of the variables of the graphg (length, width, etc.)
Graph phaseGraph; //phase space graph object
Graph barGraph; //bar graph Graph object

//String containers to hold input values by user
String numberOfFoxes, numberOfRabbits, alpha, beta, gamma, delta, deltaTime;

boolean displayLineGraph = false; //boolean to determine whether or not to display the line graph
boolean displayPhaseGraph = false; //boolean to determine whether or not to display the phase graph
boolean displayBarGraph = false; //boolean to determine whether or not to display the phase graph

void setup() {
  size(1300, 710); //Window size
  background(100); //Background color
  frameRate(30); //Frame rate

  //Instantiated objects of the graph class
  //(x origin point, y origin point, number of pixels for x axis, number of pixels for y axis, number of plottable x points, number of plottable y points, graph label, x label, y label)
  //The above is what is passed into the constructor for the graph class
  lineGraph = new Graph (15.0, (height/2.0), (width/2.0)-30, (height/2.0)-30, 1000.0, 1500.0, "Population Vs. Time", "Time", "Population");
  phaseGraph = new Graph(15.0, height-20, (width/2.0)-30, (height/2.0)-50, 500.0, 1000.0, "Foxes Vs. Rabbits", "Rabbits", "Foxes");
  barGraph = new Graph (15.0, (height/2.0), (width/2.0)-30, (height/2.0)-30, 1000.0, 1500.0, "Population Amounts", "", "Population");

  //Creating new buttons and textfields
  //BOTTOM RIGHT QUADRANT
  cp5 = new ControlP5(this); //Constructor to create buttons, textfields, etc.
  //Textfields get invoked the following: setting the position, the height, not having a field with text, and a pre-determined string value
  cp5.addTextfield("Number of Rabbits").setPosition(width/2 + 250, height/2).setSize(70, 40).setAutoClear(false).setValue("500");
  cp5.addTextfield("Number of Foxes").setPosition(width/2 + 250, height/2+75).setSize(70, 40).setAutoClear(false).setValue("5");
  cp5.addTextfield("Alpha").setPosition(width/2 + 250, height/2+150).setSize(70, 40).setAutoClear(false).setValue(".04");
  cp5.addTextfield("Beta").setPosition(width/2 + 250, height/2+225).setSize(70, 40).setAutoClear(false).setValue(".0004");
  cp5.addTextfield("Gamma").setPosition(width/2 + 350, height/2).setSize(70, 40).setAutoClear(false).setValue(".2");
  cp5.addTextfield("Delta").setPosition(width/2 + 350, height/2 + 75).setSize(70, 40).setAutoClear(false).setValue(".0004");
  cp5.addTextfield("Change in Time").setPosition(width/2 + 350, height/2 + 150).setSize(70, 40).setAutoClear(false).setValue(".2");
  //Checkboxes get invoked the following: setting the position, the of the box when it's not clicked, the color when it's being hovered over, the color when it's clicked, the size, and the name of the object associated with it
  lineGraphCheckbox = cp5.addCheckBox("lineGraphCheckBox").setPosition(width/2 + 250, height/2 + 300).setColorForeground(color(120)).setColorActive(color(255)).setColorLabel(color(255)).setSize(40, 40).addItem("Line Graph", 0);
  phaseGraphCheckbox = cp5.addCheckBox("phaseGraphCheckBox").setPosition(width/2 + 350, height/2 + 300).setColorForeground(color(120)).setColorActive(color(255)).setColorLabel(color(255)).setSize(40, 40).addItem("Phase Graph", 0);
  barGraphCheckbox = cp5.addCheckBox("barGraphCheckBox").setPosition(width/2 + 450, height/2 + 300).setColorForeground(color(120)).setColorActive(color(255)).setColorLabel(color(255)).setSize(40, 40).addItem("Bar Graph", 0);
  //Submit button gets invoked the following: setting the position and size
  cp5.addBang("submit").setPosition(width/2 + 350, height/2 + 225).setSize(80, 40);
}

void draw() { //tasks that are repeated
  background(175); //Background color throughout the simulation

  for (Dot d : Fox.population) { //for every Rabbit object in the rabbitPopulation arraylist
    d.move(); //move the rabbit
    d.draw(); //draw the rabbit
  }
  for (Dot d : Rabbit.population) { //for every Fox object in the foxPopulation arraylist
    d.move(); //move the fox
    d.draw(); //draw the fox
  }

  if (amounts.startSimulation == true) { //as long as the boolean variable has been set to true, start the simulation
    //Adding datapoints to arraylist to display on graph
    //Add a new datapoint that takes the current predator (foxes) in the simulation and the amount of time the simulation has ran (always 0 because that's the most updated time. We shift the x coordinate elsewhere)
    Rabbit.lineGraphPoints.add(new Datapoint (0, amounts.currentPrey)); //x coord = 0 because we are using steps to denote the situation of the simulation (amount of foxes and rabbits)
    //Datapoint has the constructor passed in an x and y coordinate (for the line graph, it's the current time (always 0) and the population amount)

    //Add a new datapoint that takes the current prey (rabbits) in the simulation and the amount of time the simulation has ran (always 0 because that's the most updated time. We shift the x coordinate elsewhere)
    Fox.lineGraphPoints.add(new Datapoint (0, amounts.currentPredator)); //x coord = 0 because we are using steps to denote the situation of the simulation (amount of foxes and rabbits)
    //Datapoint has the constructor passed in an x and y coordinate (for the line graph, it's the current time (always 0) and the population amount)


    if (amounts.currentPrey - phaseGraph.maxX != int(numberOfRabbits) && amounts.currentPredator != int(numberOfFoxes)) {
      //If the point being plotted is not equivalent to the initial populations (both foxes and rabbits), then do the following
      phaseGraphPoints.add(new Datapoint(amounts.currentPrey-phaseGraph.maxX, amounts.currentPredator)); //add new datapoint to the phase graph arraylist
      //we are subtracting the maxX from the currentPrey amount because we want the phase graph to be based from the origin (bottom left corner) of the phase space graph
    }
    //The above is formatted in an if statement because the program, as of right now without the if statement, plots the initial population values as a point without scaling it
    //This if statement prevents that
    //The if statement says that, verbally, as long as the graph's numbers do not equal the initial values, it can successfully be plotted

    //add a new datapoint to the bar graph
    Rabbit.barGraphPoints.add(new Datapoint(100, amounts.currentPrey));
    //we keep the x coordinate static because we want the bar graph to stay in one place
    Fox.barGraphPoints.add(new Datapoint(200, amounts.currentPredator));
    //we keep the x coordinate static because we want the bar graph to stay in one place

    amounts.step(); //calculate new rabbit and fox populations
    Rabbit.updatePopulation(amounts.currentPrey, Rabbit.population.size()); //invoke the updatePopulation on the Rabbit class so it can change the population based on the LV calculation
    //it takes in the newly calculated rabbit population and the current rabbit population for the updatePopulation() function
    Fox.updatePopulation(amounts.currentPredator, Fox.population.size()); //invoke the updatePopulation on the Fox class so it can change the population based on the LV calculation
    //it takes in the newly calculated fox population and the current fox population for the updatePopulation() function
  }

  //we call the below function/run the for loops even if the line graph isn't currently visible because we want it to keep plotting points at all times, so it has a consistent line whenever it's viewed
  for (Datapoint d : Rabbit.lineGraphPoints) { //shifting the x coord; we do this because the line graph is most updated on the right hand side. Thus we must move the graph TO THE LEFT
    d.shift();
  }

  for (Datapoint d : Fox.lineGraphPoints) { //shifting the x coord; we do this because the line graph is most updated on the right hand side. Thus we must move the graph TO THE LEFT
    d.shift();
  }

  //The folloing is done to constrain the capacities of the arraylist to a certain amount.
  //Since arraylists have no initial capacity, adding elements under the assumption that it will kick off the oldest element ends up doing nothing (confusing arraylist with plain array)
  //More info here: http://stackoverflow.com/questions/8896758/initial-size-for-the-arraylist
  if (Rabbit.lineGraphPoints.size() > 1000) { //if the datapoint arraylist for the rabbits has exceeded the maximum size, remove the oldest point (the 0'th element)
    Rabbit.lineGraphPoints.remove(0); //removal of the oldest point
  }
  if (Fox.lineGraphPoints.size() > 1000) { //if the datapoint arraylist for the foxes has exceeded the maximum size, remove the oldest point (the 0'th element)
    Fox.lineGraphPoints.remove(0); //removal of the oldest point
  }

  if (phaseGraphPoints.size() > 1000) { //if the datapoint arraylist for the phase graph has exceeded the maximum size, remove the oldets point (0'th element)
    phaseGraphPoints.remove(0); //remove the oldest point
  }

  if (Rabbit.barGraphPoints.size() > 2) { //if the datapoint arraylist for the bar graph has exceede the maximum size, remove the oldest point (0'th element)
    //since we want the bar graph to change every cycle, we only want one point graphed/used to create the bar graph
    Rabbit.barGraphPoints.remove(0); //remove the oldest point
  }

  if (Fox.barGraphPoints.size() > 2) { //if the datapoint arraylist for the bar graph has exceede the maximum size, remove the oldest point (0'th element)
    //since we want the bar graph to change every cycle, we only want one point graphed/used to create the bar graph
    Fox.barGraphPoints.remove(0); //remove the oldest point
  }

  //We are constantly checking if the graphs have been declared visible because if we abstract it to a function, it will only run once, then stop.
  if (displayLineGraph) { //If the user wants the line graph to be displayed
    lineGraph.display(); //display the line graph
    lineGraph.displayText("Population vs. Time", lineGraph.numPixelLengthX/2.0, 20, "Time", lineGraph.numPixelLengthX/2, lineGraph.numPixelLengthY+25, "Population", 15, lineGraph.numPixelLengthY/2);
    //the above line is to display the text of the line graph, it takes in the graph label and its x/y coords, the x axis label and its x/y coords, and the y-axis label and its x/y coords

    for (Datapoint d : Rabbit.lineGraphPoints) { //for every Datapoint objet in the arraylist lineGraphRabbitPoints, do the following
      lineGraph.displayData(255, 255, 255, d.xCoord, d.yCoord); //display the datapoint; it takes RGB (white in this case) and the location (starting point in this case) of the dot
    }

    for (Datapoint d : Fox.lineGraphPoints) { //for every Datapoint object in the arraylist lineGraphFoxPoints, do the following
      lineGraph.displayData(255, 154, 3, d.xCoord, d.yCoord); //display the datapoint; it takes RGB (orange in this case) and the location (starting point in this case) of the dot
    }
  }

  if (displayPhaseGraph) { //If the user wants the phase space graph to be displayed
    phaseGraph.display(); //display phase graph
    //the following line displays the text for the phase space graph
    phaseGraph.displayText("Rabbits vs. Foxes", phaseGraph.numPixelLengthX/2.0, (phaseGraph.numPixelLengthY/2.0) + 220, "Rabbits", phaseGraph.numPixelLengthX/2.0, (phaseGraph.numPixelLengthY*2.0) + 95, "Foxes", 20, (phaseGraph.numPixelLengthY/2.0)+350);

    for (Datapoint d : phaseGraphPoints) { //for every Datapoint object in the arraylist phaseGraphPoints, do the following
      phaseGraph.displayData(0, 0, 255, d.xCoord, d.yCoord); //dispaly the datapoint with a passed in RGB value of blue
    }
  }

  if (displayBarGraph) { //If the user wants the bar graph to be displayed
    barGraph.display(); //display the axes for the bar graph
    for (Datapoint d : Rabbit.barGraphPoints) { //for every datapoint in the bar graph points array of the rabbit animal class
      rectMode(CORNERS); //set the mode for drawing a rectangle to corners
      fill(255, 255, 255); //color it white
      rect(100, height/2, 150, barGraph.convertY(d.yCoord)); //draw the rectangle from a fixed bottom-left corner to a dynamic top-right corner (dynamic meaning the y value changes)
    }

    for (Datapoint d : Fox.barGraphPoints) { //for every datapoint in the bar graph points array of the fox animal class
      rectMode(CORNERS); //set the mode for drawing a rectangle to corners
      fill(255, 154, 3); //color it orange
      rect(200, height/2, 250, barGraph.convertY(d.yCoord)); //draw the rectangle from a fixed bottom-left corner to a dynamic top-right corner (dynamic meaning the y value changes)
    }
    fill(255); //color the font white (otherwise it just takes the previous fill() command's color)
    barGraph.displayText("Populations", lineGraph.numPixelLengthX/2.0, 20, "", lineGraph.numPixelLengthX/2, lineGraph.numPixelLengthY+45, "Population", 15, lineGraph.numPixelLengthY/2);
    //display the bar graph text
  }

  //Line to separate graphs from simulation
  stroke(30); //color
  strokeWeight(2); //weight/fatness of the line
  line(width/2 - 10, 0, width/2 - 10, height); //where the line is being drawn (middle of the canvas)
  strokeWeight(1); //reverting the weight back to 1 because otherwise when a line is drawn, it'll take the previously declared strokeWeight() parameter

  fill(0); //coloring the text because otherwise it'll inherit the previously declared text() parameter
  text("Number of rabbits: " + Rabbit.population.size(), width/2+10, height/2+20); //display the number of rabbits
  text("Number of foxes:   " + Fox.population.size(), width/2+10, height/2+30); //display the number of foxes

  //Line graph scaling
  if (Fox.highestPopulationValue > Rabbit.highestPopulationValue) { //if the Fox object has reached a higher maximum value than the Rabbit object
    lineGraph.scaleY = lineGraph.numPixelLengthY / Fox.highestPopulationValue; //scale the line graph y axis according to the Fox's maximum value
    barGraph.scaleY = barGraph.numPixelLengthY / Fox.highestPopulationValue; //scale the bar graph y axis according to the Fox's maximum value
    barGraph.maxY = barGraph.numPixelLengthY / barGraph.scaleY; //increase the maximum y value of the bar graph according to the newly scaled y axis
  } else { //if the Rabbit object has reached a higher maximum value than the Fox object
    lineGraph.scaleY = lineGraph.numPixelLengthY / Rabbit.highestPopulationValue; //scale the line graph y axis according to the Rabbit's maximum value
    barGraph.scaleY = barGraph.numPixelLengthY / Rabbit.highestPopulationValue; //scale the bar graph y axis according to the Rabbit's maximum value
    barGraph.maxY = barGraph.numPixelLengthY / barGraph.scaleY; //incrase the maximum y value of the bar graph according to the newly scaled y axis
  }

  //phase graph scaling does not work properly
  //Scaling of the phase graph -- it's always being scaled because in the event there's a new maximum value
  //We can always check if there's a new highest value because each population is only bound to one axis, so we don't have to check if one is greater than the other in terms of having a higher maximum value
  phaseGraph.scaleY = phaseGraph.numPixelLengthY / Fox.highestPopulationValue; //scale the y axis of the phase graph according to the highest fox maximum value
  phaseGraph.scaleX = phaseGraph.numPixelLengthX / Rabbit.highestPopulationValue; //scale the x axis of the phase graph according to the highest rabbit maximum value
  phaseGraph.maxX = phaseGraph.numPixelLengthX / phaseGraph.scaleX; //change the maximum amount of x coordinates to fit the scale

  for (Datapoint d : phaseGraphPoints) { //for every datapoint in the phase graph datapoints arraylist
    phaseGraph.convertX(d.xCoord); //convert the x coordinate based on the new scale
    phaseGraph.convertY(d.yCoord); //convert the y coordinate based on the new scale
  }

  //ATTOFOX PREVENTION - stops simulation
  if (Fox.population.size() < 1) { //if statement to check if the simulation has encountered the Attofox Problem.
    amounts.startSimulation = false; //boolean set to false to stop the LV equation from running and producing new population amounts
    fill(0); //text color
    text("Simulation has ended due to the Atto-fox problem (only 1 fox remains). It will no longer run. Please reset.", width/2+10, height-5); //notifying user that simulation has ended

    for (Dot d : Fox.population) { //dots no longer move due to having the freeze() function called (velocity is 0)
      d.freeze();
    }
    for (Dot d : Rabbit.population) { //dots no longer move due to having the freeze() function called (velocity is 0)
      d.freeze();
    }
  }
}

void lineGraphCheckBox(float[] a) { //function that is called whenver the check box is clicked for the line graph
  if (displayLineGraph == false) { //if the line graph is not displayed
    displayLineGraph = true; //display it
    displayBarGraph = false; //toggle off the bar graph so that way the two do not overlap
    barGraphCheckbox.deactivateAll(); //change the checkbox to false/off to match up with the boolean being set to false
  } else { //if the line graph IS displayed
    displayLineGraph = false; //hide the display
  }
}

void phaseGraphCheckBox(float[] a) { //function that is called whenver the check box is clicked for the phase graph
  if (displayPhaseGraph == false) { //if the phase graph is not displayed
    displayPhaseGraph = true; //display it
  } else { //if the phase graph IS displayed
    displayPhaseGraph = false; //hide the display
  }
}

void barGraphCheckBox (float[] a) { //function that is called whenever the check box is clicked for the bar graph
  if (displayBarGraph == false) { //if the bar graph is not being displayed
    displayBarGraph = true; //display the bar graph
    displayLineGraph = false; //toggle the line graph display so that the two do not overlap
    lineGraphCheckbox.deactivateAll(); //change the checkbox to false/off to match up with the boolean being set to false
  } else { //if the bar graph IS displayed
    displayBarGraph = false; //hide the bar graph dispaly
  }
}

void submit() { //Function to send information to reset function, called through submit button
  numberOfRabbits = cp5.get(Textfield.class, "Number of Rabbits").getText(); //assignment of initial rabbit population
  numberOfFoxes = cp5.get(Textfield.class, "Number of Foxes").getText(); //assignment of initial fox population
  alpha = cp5.get(Textfield.class, "Alpha").getText(); //assignment of alpha value
  beta = cp5.get(Textfield.class, "Beta").getText(); //assignment of beta value
  gamma = cp5.get(Textfield.class, "Gamma").getText(); //assignment of gamma value
  delta = cp5.get(Textfield.class, "Delta").getText(); //assignment of delta value
  deltaTime = cp5.get(Textfield.class, "Change in Time").getText(); //assignment of change in time

  //Way to hardcode values if need be. Simply replace values and hit submit button

  //alpha = ".04";
  //beta = ".0004";
  //gamma = ".2";
  //delta = ".0004";
  //deltaTime = ".2";
  //numberOfRabbits = "500";
  //numberOfFoxes = "5";


  //If statement to make sure all parameters are numbers, not left blank, and are within a valid range defined by the programer
  if (numberOfRabbits.equals("") || numberOfFoxes.equals("") || alpha.equals("") || beta.equals("") || gamma.equals("") || delta.equals("") || deltaTime.equals("") ||
    isNumeric(numberOfRabbits) == false || isNumeric(numberOfFoxes) == false || isNumeric(alpha) == false || isNumeric(beta) == false || isNumeric(gamma) == false || isNumeric(delta) == false || isNumeric(deltaTime) == false) {
    println("One or more of the fields has not been adequately filled out. Please make sure all parameters are valid numbers, no fields are left blank, and are feasible (i.e. a starting value of 100000 rabbits will not suffice)");
  } else { //if the values in the text fields are valid
    //call the function called reset to start a new simulation
    reset (float(alpha), float(beta), float(gamma), float(delta), float(deltaTime), float(numberOfRabbits), float(numberOfFoxes));
  }
}

//PROGRAM FUNCTIONS
//Function called reset which starts a new simulation; it gets passed in values based on what the user inputs
void reset (float alpha, float beta, float gamma, float delta, float changeInTime, float numberOfRabbits, float numberOfFoxes) {
  Fox.population.clear(); //clear the fox population because we're starting a new simulation
  Fox.lineGraphPoints.clear(); //clear the fox datapoint arraylist for the line graph
  Rabbit.population.clear(); //clear the rabbit population because were starting a new simulation
  Rabbit.lineGraphPoints.clear(); //clear the rabbit datapoint arraylist because new simulation
  phaseGraphPoints.clear(); //clear phase graph points

  //Instaniation of the new LV class to calculate the number of foxes and rabbits
  amounts = new LV(alpha, beta, gamma, delta, changeInTime, numberOfRabbits, numberOfFoxes); //is passed in new alpha, beta, gamma, delta, time change, initial rabbits, initial foxes
  amounts.startSimulation = true; //set the simulation start boolean to true; this is because the reset function has been called, meaning there are user inputs for the LV class
}

//Function for checking if user specified values are numerical
//Source: http://stackoverflow.com/questions/14206768/how-to-check-if-a-string-is-numeric
boolean isNumeric (String input) { //function found via Stackoverflow that returns a boolean based on whether or not a passed string is a number
  return input.matches("[-+]?\\d*\\.?\\d+");
  //the above uses the .matches function for regular expression to check if the passed string, when parsed through regex, is true
  //.matches returns a boolean variable, which is then returned by the function
}


class LV { //Class created to do calculations of rabbit + fox population and to hold current values
  float alpha, beta, gamma, delta; //parameters set by user
  float initialPrey, initialPredator, currentPrey, currentPredator; 
  //inital prey+predator are set by user, current prey+predator are used for counting the current amounts
  float deltaTime; 
  //float to determine how much time to advance by for each cycle
  boolean startSimulation; //determines if the simulation begins or not
  float totalTime; //value to hold how much time has passed since the simulation began


  //Constructor to receive all parameters set by user
  LV (float userAlpha, float userBeta, float userGamma, float userDelta, float userTime, float userPrey, float userPredator) {
    //This constructor takes in the initial alpha value, beta value, gamma value, delta value, change in time value, initial rabbits and initial foxes
    alpha = userAlpha; 
    beta = userBeta; 
    gamma = userGamma; 
    delta = userDelta; 
    currentPrey = userPrey; 
    currentPredator = userPredator; 
    deltaTime = userTime;
    //startSimulation = true;
  }

  LV () { //second constructor to denote whether or not the simulation has began
    startSimulation = false; //boolean variable native to the LV class that denotes whether or not the simulation has begun
  }

  void step() { //called to update amount of predators/prey

    //EULER'S METHOD (no longer in use)
    /*
    float tempCurrentPrey = currentPrey + deltaTime*((alpha*currentPrey) - (beta*currentPrey*currentPredator)); 
     float tempCurrentPredator = currentPredator + deltaTime*((delta*currentPrey*currentPredator) - (gamma*currentPredator));
     isolate the currentPrey to a temporary variable due to the fact that we need to use the previous prey/predator to calculate the new prey/predator
     
     currentPrey = tempCurrentPrey; //update currentPrey
     currentPredator = tempCurrentPredator; //update currentPredator
     we multiply by deltaTime because are solving for the amount of prey and predators, and deltaTime is on the left side of the equation as the denominator for prey and predators
     so we have to multiply each side by deltaTime to isolate the number of predators/prey
     */

    //This is the 4th Order Runge Kutta Method
    //The K values are various estimates of the slopes betwee t and t + deltaT (t + deltaT being the next projection of the simulation)
    //Fourth order numerical integrator

    //Definition of variables used in Fourth Order Runge Kutta Method
    float R = currentPrey;
    float F = currentPredator;
    float a = alpha;
    float b = beta;
    float g = gamma;
    float d = delta;
    float dt = deltaTime;

    //println(R, F, a, b, g, d, dt);

    //Obtaining first K value for foxes + rabbits
    float k1R =  a*R - b*R*F;
    float k1F = -g*F + d*R*F;

    //Obtaining second K value for foxes + rabbits
    float k2R =  a*(R + dt/2.0*k1R) - b*(R + dt/2.0*k1R)*(F + dt/2.0*k1F);
    float k2F = -g*(F + dt/2.0*k1F) + d*(R + dt/2.0*k1R)*(F + dt/2.0*k1F);

    //Obtaining third K value for foxes + rabbits
    float k3R =  a*(R + dt/2.0*k2R) - b*(R + dt/2.0*k2R)*(F + dt/2.0*k2F);
    float k3F = -g*(F + dt/2.0*k2F) + d*(R + dt/2.0*k2R)*(F + dt/2.0*k2F);

    //Obtaining fourth K value for foxes + rabbits
    float k4R =  a*(R + dt*k3R) - b*(R + dt*k3R)*(F + dt*k3F);
    float k4F = -g*(F + dt*k3F) + d*(R + dt*k3R)*(F + dt*k3F);

    //println("R ks: " + k1R, k2R, k3R, k4R);
    //println("F ks: " + k1F, k2F, k3F, k4F);

    //Calculating new values
    currentPrey =     R + dt/6.0*(k1R + 2.0*k2R + 2.0*k3R + k4R);
    currentPredator = F + dt/6.0*(k1F + 2.0*k2F + 2.0*k3F + k4F);    

    //println("Current values: " + currentPrey, currentPredator);
  }
}


class Animal { //Animal class to contain all interaction of animals -- this is used to abstract the foxes and rabbits to one class since they have the same purpose in the simulation
  ArrayList<Dot> population = new ArrayList <Dot>(); //arraylist to contain the population amounts (visual)
  ArrayList<Datapoint> lineGraphPoints = new ArrayList<Datapoint>(); //arraylist to contain the datapoints
  //ArrayList<Datapoint> phaseGraphPoints = new ArrayList<Datapoint>(); //arraylist to contain the datapoints
  ArrayList<Datapoint> barGraphPoints = new ArrayList<Datapoint>(); //arralist to contain bar graph datapoints for the fox and rabbit
  float r, g, b; //color to determine the dot color; since we have multiple animals we need some way of denoting which one is which
  float highestPopulationValue; //container for the highest population value

  Animal (float userR, float userG, float userB) { //takes in color of the animal in the form of RGB
    r = userR;
    g = userG;
    b = userB;
  }

  void updatePopulation (float LVPopulation, float animalPopulation) { //function to update the population of the animals
    //NET GAIN OF ANIMALS
    if (LVPopulation > animalPopulation) { //if the calculated/projected population is greater than the current population
      int change = abs(ceil(LVPopulation - animalPopulation)); //find the change in populations
      for (int i = 0; i < change; i++) { //as long as i is less than the change
        population.add(new Dot (random(width/2, width), (random(0, height/2)), r, g, b, 5)); //add new animals to the simulation (birth)
      }
    }

    //NET LOSS OF ANIMALS
    if (LVPopulation < animalPopulation) { //if the calculated/projecte population is less than the current population
      int change = abs(ceil(LVPopulation - animalPopulation)); //find the change in populaions
      for (int i = 0; i < change; i++) { //as long as i is less than the change
        population.remove(0); //remove animals from the simulation (death)
      }
    }
    if (LVPopulation > highestPopulationValue) { //function to check if there is a new maximum value
      highestPopulationValue = LVPopulation; //if so, set the highest population value variable to the LV population (we choose the LV population value because that's the most updated one)
    }
  }
}



class Dot { //class to visualize the animals moving around in the simulation
  float x, y; //location of the animal
  float xVelocity, yVelocity; //movement speed
  float r, g, b; //color of the animal
  float size; //size of the animal

  Dot (float startingX, float startingY, float userR, float userG, float userB, float startingSize) {
    //Constructor takes in the starting x and y coords, and the color (RGB), as well as the size of the dot
    x = startingX;
    y = startingY;
    xVelocity = random(-8, 8);
    yVelocity = random(-8, 8);
    r = userR;
    g = userG;
    b = userB;
    size = startingSize;
  }

  void move() { //limited to top right quadrant
    x = x + xVelocity; //how it will modify the x coordinate
    y = y + yVelocity; //how it will modify the y coordinate

    if (x > width) { //if it reaches the right side of the quadrant
      xVelocity = xVelocity * -1;
    }

    if (x < (width/2) + 10) { //if it reaches the left side of the quadrant
      xVelocity = xVelocity * -1;
    }

    if (y > height/2) { //if it reaches the bottom of the quadrant
      yVelocity = yVelocity * -1;
    }

    if (y < 0) { //if it reaches the top of the quadrant (since 0 = top of quadrant)
      yVelocity = yVelocity * -1;
    }
  }

  void draw() { //what the fox will look like
    strokeWeight(1); 
    stroke(0); 
    fill(r, g, b); 
    ellipseMode(CENTER); 
    ellipse(x, y, size, size);
  }

  void freeze() {
    xVelocity = 0;
    yVelocity = 0;
  }
}

class Graph {
  float originX, originY, numPixelLengthX, numPixelLengthY; //origin's coordinates and length of the x and y axes
  float deltaXTick; //spacing between tick marks
  String xLabel, yLabel, graphLabel; //graphLabel = title of graph, x and y are for the axes
  float maxX, maxY; //floats to contain the maximum values of the graph

  float scaleX, scaleY; //these variables are going to be used to scale the points from the simulation (fit to the graph)

  Graph (float initOriginX, float initOriginY, float initXLength, float initYLength, float initMaxX, float initMaxY, String initGraphLabel, String initXLabel, String initYLabel) {
    //constructor takes in the origin's x and y values, the pixel length of the x and y axes, how many points can be plotted for the x and y axes, and the labels for the graph itself, x and y axes
    originX = initOriginX; //pixel location X
    originY = initOriginY; //pixel location Y
    numPixelLengthX = initXLength; //size of the X axis
    numPixelLengthY = initYLength; //size of the Y axis
    graphLabel = initGraphLabel; //name of Graph
    xLabel = initXLabel; //x label graph
    yLabel = initYLabel; //y label graph
    maxX = initMaxX; //maximum number of x points
    maxY = initMaxY; //maximum number of y points

    scaleX = numPixelLengthX / maxX; //defining the x scale
    scaleY = numPixelLengthY / maxY; //defining the y scale
  }

  float convertX (float X) { //converting the passed in x coord to fit the scale, has a passed in value of an x coordinate of a point
    //i.e. for a line graph, you'd pass in the time value
    float pixelCoordX = originX + numPixelLengthX + (scaleX * X);
    return pixelCoordX;
  }

  float convertY (float Y) { //converting the passed in y coord to fit the scale, has a passed in value of a y coordinate of a point
    //i.e. for a line graph, you'd pass in the population amount (foxes, rabbits, etc.)
    float pixelCoordY = originY - (scaleY * Y);
    return pixelCoordY;
  }

  void display() { //displays the graph
    stroke(0);
    fill(255);
    arrow(originX, originY, (originX+numPixelLengthX), originY);
    arrow(originX, originY, originX, (originY - numPixelLengthY));
  }

  void displayText(String graphLabel, float graphLabelX, float graphLabelY, String xLabel, float xLabelX, float xLabelY, String yLabel, float yLabelX, float yLabelY) { //displays graph names
    text(graphLabel, graphLabelX, graphLabelY);
    text(xLabel, xLabelX, xLabelY);
    text(yLabel, yLabelX, yLabelY);
  }

  //Arrow function from processing forum:
  //https://processing.org/discourse/beta/num_1219607845.html
  void arrow(float x1, float y1, float x2, float y2) { 
    stroke(0);
    line(x1, y1, x2, y2);
    pushMatrix();
    translate(x2, y2);
    float a = atan2(x1-x2, y2-y1);
    rotate(a);
    line(0, 0, -10, -10);
    line(0, 0, 10, -10);
    popMatrix();
  }

  void displayData (int r, int g, int b, float datapointX, float datapointY) { //function to display the coordinates of the graph
    fill(r, g, b);
    noStroke();
    ellipse(convertX(datapointX), convertY(datapointY), 5, 5); //plot the point
  }

  void displayBarData (int r, int g, int b, float leftCornerX, float leftCornerY, float rightCornerX, float rightCornerY) {
    fill(r, g, b);
    noStroke();
    rectMode(CORNER);
    rect(leftCornerX, leftCornerY, rightCornerX, convertY(rightCornerY));
  }
}

class Datapoint { //class to contain data points for class -- dynamic so that we can use this class for the phase graph and the line graph
  float xCoord, yCoord; //internal variables used to contain x and y coords

  Datapoint (float initialXCoord, float initialYCoord) { //constructor that takes in x and y coordinates
    xCoord = initialXCoord;
    yCoord = initialYCoord;
  }

  void shift() { //function to move the coords over by 1 to make room for a new one -- used for line graph, not phase space
    xCoord = xCoord - 1;
  }
}