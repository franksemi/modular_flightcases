

// eurorack eowave sides v1

/*
module 3d_layout() {
translate ([0,-180,0]) side(); 
//rotate (a=90,v=[0,1,0]) {translate ([-160,0,0]) side();} // 
rotate ([90,63,90]) {translate ([-91,0,0]) side();} // 
rotate ([90,63,90]) {translate ([-91,0,500]) side();} // 

//mirror ([-1,1,0]) translate ([0,150,0]) side(); 
}
3d_layout();
*/

// 2d

CircleFragments = 10;

module 2d_layout() {
rotate (a=0,v=[0,0,0]) translate([0,10,0]) projection(cut = true) side();
}
2d_layout();


module side() {
difference() {
 //           translate ([0,0,0]) color("lightgrey") cube ([120,200,8]) ;
                hull () {             
                translate ([10,0,0]) cylinder (r =10,h=8,$fn=30);
                translate ([180,180,0]) cylinder (r =10,h=8,$fn=30 );
                translate ([10,180,0]) cylinder (r =10,h=8,$fn=30 );
                translate ([80,0,0]) cylinder (r =10,h=8,$fn=30 );
                }
                hull () {         
                translate ([26,15,0]) cylinder(r=3/2,h=8,$fn=30);
                translate ([26,166,0]) cylinder(r=3/2,h=8,$fn=30);
                }
                translate ([153,163,0]) cylinder(r=4,h=8,$fn=30);
                translate ([79,18,0]) cylinder(r=4,h=8,$fn=30);
        
              }
               }



// eurorack eowave sides v1

/*
module 3d_layout() {
translate ([0,-180,0]) side(); 
//rotate (a=90,v=[0,1,0]) {translate ([-160,0,0]) side();} // 
rotate ([90,63,90]) {translate ([-91,0,0]) side();} // 
rotate ([90,63,90]) {translate ([-91,0,500]) side();} // 

//mirror ([-1,1,0]) translate ([0,150,0]) side(); 
}
3d_layout();
*/

// 2d

CircleFragments = 10;

module 2d_layout() {
rotate (a=0,v=[0,0,0]) translate([0,10,0]) projection(cut = true) side();
}
2d_layout();


module side() {
difference() {
 //           translate ([0,0,0]) color("lightgrey") cube ([120,200,8]) ;
                hull () {             
                translate ([10,0,0]) cylinder (r =10,h=8,$fn=30);
                translate ([180,180,0]) cylinder (r =10,h=8,$fn=30 );
                translate ([10,180,0]) cylinder (r =10,h=8,$fn=30 );
                translate ([80,0,0]) cylinder (r =10,h=8,$fn=30 );                     
                }
                hull () {         
                translate ([26,15,0]) cylinder(r=3/2,h=8,$fn=30);
                translate ([26,166,0]) cylinder(r=3/2,h=8,$fn=30);
                }
                translate ([153,163,0]) cylinder(r=4,h=8,$fn=30);
                translate ([79,18,0]) cylinder(r=4,h=8,$fn=30);
        
              }
               }

