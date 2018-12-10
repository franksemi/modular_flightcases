showFlat = true;
showFolded = true;
showExpanded = false;
showPlatter = false;
showOpenBox = false;
openFront = false;
openTop = true;

// ------------------------------------------------------
// - F5 for 3d render -----------------------------------
// - F6 for 2d render -----------------------------------
// - Always 2d render before export to .DXF -------------
// ------------------------------------------------------
// change box size here ---------------------------------
boxDepth   = 282;   // (inner measurements in mm)
boxWidth   = 640;   // (inner measurements in mm - 1 mm = 5.08 HP) 
boxHeight  = 80;    // (inner measurements in mm)
plateThickness = 8; // Material thickness
wishTabWidth = 8;   // Tabs width
// ------------------------------------------------------

flatSpacing = 10;
axleDia = 10;
axlePos = 90;
largeBearingDepth = 8;
largeBearingOuterDia = 38.1;
largeBearingInnerDia = 27;
largeBearingFreeDia = largeBearingOuterDia - 2*2;
smallBearingDepth = 8;
smallBearingOuterDia = 26;
smallBearingInnerDia = 10;
smallBearingFreeDia = smallBearingOuterDia - 2*2;

motorPosMin = 45;
motorPosMax = 90;
motorFastenerDia = 4;
distBoxTorus = 15;
motorFastenerDist = 50;
$fa = 8; $fs = 0.8;

epsilon=0.001;

module backFront()
{
    translate([plateThickness,plateThickness])
        square([boxWidth-plateThickness*2,boxHeight-plateThickness*2]);

    tabStyleTop = (!openTop) ? 0 : 6;
    tabStyleBack = 3;
    tabStyleSide = 3;
    tabStyleButt = 0;
    
    tab(boxWidth,wishTabWidth,tabStyleButt,plateThickness);
    translate([plateThickness+epsilon,0])
      rotate([0,0,90])
        tab(boxHeight,wishTabWidth,tabStyleBack,plateThickness);
    translate([boxWidth,0])
      rotate([0,0,90])
        tab(boxHeight,wishTabWidth,tabStyleSide,plateThickness);
    translate([0,boxHeight-plateThickness-epsilon])
      tab(boxWidth,wishTabWidth,tabStyleTop,plateThickness);
}

module side()
{
    translate([plateThickness,plateThickness])
        square([boxDepth-plateThickness*2,boxHeight-plateThickness*2]);

    tabStyleTop = (!openTop) ? 0 : 6;
    tabStyleSide = 1;
    tabStyleButt = 0;
    
    tab(boxDepth,wishTabWidth,tabStyleButt,plateThickness);
    translate([plateThickness+epsilon,0])
      rotate([0,0,90])
        tab(boxHeight,wishTabWidth,openFront?5:tabStyleSide,plateThickness);
    translate([boxDepth,0])
      rotate([0,0,90])
        tab(boxHeight,wishTabWidth,tabStyleSide,plateThickness);
    translate([0,boxHeight-plateThickness-epsilon])
      tab(boxDepth,wishTabWidth,tabStyleTop,plateThickness);
}

module top()
{
    translate([plateThickness,plateThickness])
        square([boxWidth-plateThickness*2,boxDepth-plateThickness*2]);

    tabStyleSide = 2;
    tabStyleTopButt = 2;
    tab(boxWidth,wishTabWidth,openFront?4:tabStyleTopButt,plateThickness);
    translate([plateThickness+epsilon,0])
      rotate([0,0,90])
        tab(boxDepth,wishTabWidth,tabStyleSide,plateThickness);
    translate([boxWidth,0])
      rotate([0,0,90])
        tab(boxDepth,wishTabWidth,tabStyleSide,plateThickness);
    translate([0,boxDepth-plateThickness-epsilon])
      tab(boxWidth,wishTabWidth,tabStyleTopButt,plateThickness);
}

module topWithHoles(for2D=false) {
  epsilon = 0.17;
  difference() {
    asPlate()
      top();
    translate([axlePos, boxDepth/2, -epsilon])
      cylinder(r=largeBearingFreeDia/2, h=plateThickness+2*epsilon, center=false);
    translate([axlePos, boxDepth/2, plateThickness-largeBearingDepth])
      cylinder(r=largeBearingOuterDia/2, h=largeBearingDepth+2*epsilon);
  }
  if (for2D) {
    // Something for the CNC to get the inner diameter in the 2D drawing.
    translate([axlePos, boxDepth/2, plateThickness-0.5*largeBearingDepth])
      cylinder(r=largeBearingFreeDia/2, h=largeBearingDepth, center=false);
  }
}

module bottomWithHoles(for2D=false) {
  epsilon = 0.117;
  difference() {
    asPlate()
      top();
    // Room for the axle to not touch the box.
    translate([axlePos, boxDepth/2, -epsilon])
      cylinder(r=smallBearingFreeDia/2, h=plateThickness+2*epsilon, center=false);
    // Hole fitting the lower, small ball bearing.
    translate([axlePos, boxDepth/2, plateThickness-smallBearingDepth])
      cylinder(r=smallBearingOuterDia/2, h=smallBearingDepth+2*epsilon);
    // Holes for mounting motor, with some flexibility to adjust the belt tension.
    for (i = [-0.5 : 1 : 0.5]) {
      translate([0, i*motorFastenerDist, 0]) {
        hull() {
          translate([axlePos + motorPosMin, boxDepth/2, -epsilon])
            cylinder(r=motorFastenerDia/2, h=plateThickness+2*epsilon, center=false);
          translate([axlePos + motorPosMax, boxDepth/2, -epsilon])
            cylinder(r=motorFastenerDia/2, h=plateThickness+2*epsilon, center=false);
        }
      }
    }
  }
  if (for2D) {
    // Something for the CNC to get the inner diameter in the 2D drawing.
    translate([axlePos, boxDepth/2, plateThickness-0.5*smallBearingDepth])
      cylinder(r=smallBearingFreeDia/2, h=smallBearingDepth, center=false);
  }
}

module foldedBox(expanded) {
  delta = expanded ? plateThickness : 0;
  inRed() {
    asPlate()
      top();
    if (!openTop)
    {
      translate([0,0,boxHeight-plateThickness+2*delta])
      asPlate()
        top();
    }
  }
  inGreen() {
    translate([-delta,0,delta])
      rotate([90,0,90])
        asPlate()
          side();
    translate([boxWidth-plateThickness+delta,0,delta])
      rotate([90,0,90])
        asPlate()
          side();
  }
  inBlue() {
    if (!showOpenBox && !openFront) {
      translate([0,plateThickness-delta,delta])
        rotate([90,0,0])
          asPlate()
            backFront();
    }
    translate([0,boxDepth+delta,delta])
      rotate([90,0,0])
        asPlate()
          backFront();
  }

  if (showPlatter) {
    vertpos =  boxHeight + (showExpanded ? 2*plateThickness : 0) + distBoxTorus;
    translate([axlePos, boxDepth/2, vertpos])
      %ledtorus_rotor();
  }
}


if (showFlat) {
    translate([0,-boxWidth,0])
    {
      if(!openTop) {
        translate([3*boxWidth+flatSpacing,-10])
          rotate([0,0,180])
                top();
      }
      translate([0,-boxDepth-flatSpacing])
            top();
      translate([boxWidth,0])
        rotate([0,0,-90])
            translate([flatSpacing,flatSpacing,0])
        side();
      translate([-flatSpacing,-boxDepth-flatSpacing])
      rotate([0,0,90])
        side();
      translate([boxWidth,-boxDepth-flatSpacing*2])
        rotate([0,0,180])
        backFront();
      if (!openFront)
      {
        translate([0,0])
            backFront();
      }
    }
}


if (showFolded) {
  foldedBox(showExpanded);
}


module inRed() {
  color([1, 0, 0])
    children();
}

module inGreen() {
  color([0, 1, 0])
    children();
}

module inBlue() {
  color([0, 0, 1])
    children();
}

module asPlate() {
  linear_extrude(height=plateThickness, convexity=10)
    children();
}

module in2D() {
  projection(cut=true)
    translate([0, 0, -0.99*plateThickness])
      children();
}
/*
module speaker_front() {
    difference() {
            translate ([8,-boxWidth+8,170]) color("yellow") cube ([boxDepth-16,boxWidth-16,plateThickness]) ; 
                translate ([80,-70,170]) cylinder (d =73,h=plateThickness,$fn=180);
                translate ([80,-210,170]) cylinder (d =73,h=plateThickness,$fn=180);
                translate ([115,-140,170]) cylinder (d =23,h=plateThickness,$fn=180);
            }
}
    rotate (a=90,v=[0,0,1]) translate([0,0,0]) speaker_front(); 
    rotate (a=90,v=[0,0,1]) translate([0,110,0]) projection(cut = true) speaker_front();   
*/

/*

module speaker_front_2() {
    difference() {
            translate ([8,-boxWidth+8,170]) color("yellow") cube ([boxDepth-16,plateThickness,boxWidth-16]) ; 
                translate ([80,-70,170]) cylinder (d =73,h=plateThickness,$fn=10);
                translate ([80,-210,170]) cylinder (d =73,h=plateThickness,$fn=10);
                translate ([115,-140,170]) cylinder (d =23,h=plateThickness,$fn=10);
            }
}
    rotate (a=90,v=[0,0,1]) translate([0,0,0]) speaker_front(); 
    rotate (a=90,v=[0,0,1]) translate([0,110,0]) projection(cut = true) speaker_front_2();   
*/

/*
  Create the tabs along the edge of a side of the box.
  Parameters:
    length         length of the edge.
    wishTabLength  Requested length of one tab (short length, ie. only the
                   protruding part). This length will be rounded up so that
                   there will be an integer number of tabs.
    start          tabStyle. 0 is ____####____####____
                             1 is | |###___###___###| |
                             2 is ####____####____####
                             3 is | |___###___###___| |
                             4 is ####################
                             5 is _##################_
                             6 is _____________________
    tabDepth       How much the tab should protrude.
*/
module tab(length, wishTabLength, start, tabDepth)
{
    tabDepthExtra = epsilon;
    cornerAdd = (wishTabLength < 2*tabDepth) ? 2*tabDepth - wishTabLength : 0;

    actualLen = (start == 1 || start==3) ? (length-2*tabDepth) :
      (start == 0 || start == 2) ? length - 2*cornerAdd : length;
    wishNum = actualLen / wishTabLength;
    tabNum = floor(0.5*(wishNum-1));
    tabLength = actualLen / (2*tabNum+1);

    if (start == 0) {
        for (i=[0:tabNum-1]) {
            translate([cornerAdd + ((1+2*i)*tabLength),0])
              square([tabLength,tabDepth+tabDepthExtra]);
        }
    }
    if (start == 1) {
        for (i=[0:tabNum]) {
            translate([tabDepth+((2*i)*tabLength),0]) {
                if(i==0) {
                  square([tabLength,tabDepth+tabDepthExtra]);
                } else if(i==tabNum) {
                  square([tabLength,tabDepth+tabDepthExtra]);
                } else {
                  square([tabLength,tabDepth+tabDepthExtra]);
                }
            }
        }

    }
    if (start == 2) {
        for (i=[0:tabNum]) {
          if (i==0) {
            translate([((2*i)*tabLength),0])
              square([tabLength+cornerAdd,tabDepth+tabDepthExtra]);
          } else if (i== tabNum) {
            translate([cornerAdd + ((2*i)*tabLength),0])
              square([tabLength+cornerAdd,tabDepth+tabDepthExtra]);
          } else {
            translate([cornerAdd + ((2*i)*tabLength),0])
              square([tabLength,tabDepth+tabDepthExtra]);
          }
        }
    }
    if (start == 3) {
        for (i=[0:tabNum-1]) {
            translate([tabDepth+((1+2*i)*tabLength),0])
              square([tabLength,tabDepth+tabDepthExtra]);
        }
    }
    if (start == 4) {
      square([length, tabDepth+tabDepthExtra]);
    }
    if (start == 5) {
      translate([tabDepth, 0])
        square([length - 2*tabDepth, tabDepth+tabDepthExtra]);
    }
}

