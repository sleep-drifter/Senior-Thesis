class LiveSurface {



  //Variables
  ArrayList<Vec2> liveSurface;
  //  Instead of any of the usual variables, this will store a reference to a Box2D Body



  //Constructor
  LiveSurface() {

    //Initially, make a default surface
    liveSurface = new ArrayList<Vec2>(); //how do i return values from a for loop
    liveSurface.add(new Vec2(0, height));
    liveSurface.add(new Vec2(width, height-100));

    ChainShape chain = new ChainShape();

    // Make an array of Vec2 (from openCV) for the ChainShape.
    Vec2[] contourVertices = new Vec2[liveSurface.size()];

    for (int i = 0; i < contourVertices.length; i++) {
      // Convert each vertex to Box2D World coordinates.
      contourVertices[i] = box2d.coordPixelsToWorld(liveSurface.get(i));
    }

    // Create the ChainShape with array of Vec2.
    chain.createChain(contourVertices, contourVertices.length);

    //Attach the Shape to the Body.
    BodyDef bd = new BodyDef();
    Body body = box2d.world.createBody(bd);
    body.createFixture(chain, 1);
    //[end]
  }



  //Additional methods 

  void update() {

    println("I found " + opencv.findContours().size() + " many contours");

    //Only update if at least one contour has been found
    if (opencv.findContours().size() > 0) {


      //Reset the surface
      liveSurface = new ArrayList<Vec2>();

      //openCV code below
      
      //>>>>instead of for looping, just grab the first arraylist item
      
      for (Contour contour : opencv.findContours(false, true)) {  //Contours will be sorted by area, largest first

        //Get the individual points from the contour
        for (PVector p : contour.getPolygonApproximation().getPoints()) {
          liveSurface.add(new Vec2(p.x, p.y));
        }
        
      }

      ChainShape chain = new ChainShape();

      // Make an array of Vec2 (from openCV) for the ChainShape.
      Vec2[] contourVertices = new Vec2[liveSurface.size()];

      for (int i = 0; i < contourVertices.length; i++) {
        // Convert each vertex to Box2D World coordinates.
        contourVertices[i] = box2d.coordPixelsToWorld(liveSurface.get(i));
      }

      // Create the ChainShape with array of Vec2.
      chain.createChain(contourVertices, contourVertices.length);

      //Attach the Shape to the Body.
      BodyDef bd = new BodyDef();
      Body body = box2d.world.createBody(bd);
      body.createFixture(chain, 1);
      //[end]
    }
    
  }



  void display() {
    strokeWeight(5); //add strokeweight
    stroke(#ffcc00); //gold stroke
    noFill();

    // Draw the ChainShape as a series of vertices.
    beginShape();
    for (Vec2 v: liveSurface) {
      vertex(v.x, v.y);
    }

    endShape();
  }
}

