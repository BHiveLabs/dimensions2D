include<shortcuts.scad>

//default constants
//LT=0.5; //line thickness
//DC="black"; //dimension colour

//°µ
module dimx2D(length,dist=20*LT,la=true,ra=true,ts=LT*10){
  dim2D(length=length,rot=[0,0,0],dist=dist,la=la,ra=ra,ts=ts);
}

module dimy2D(length,dist=20*LT,la=true,ra=true,ts=LT*10){
  dim2D(length=length,rot=[0,0,90],dist=dist,la=la,ra=ra,ts=ts);
}

module dim2D(length,rot=[0,0,0],dist=20*LT,la=true,ra=true,ts=LT*10){
  rotate(rot) union() {
    //display endlines
    ty(-0.1*dist){
      ly(-dist);
      tx(length) ly(-dist);
    }
    //display measurement line with optional arrows
    ty(-dist){
      textWidth=ceil(log(length))*LT*8; //length text ~width
      echo(textWidth=textWidth);
      color("BLACK") tx(length/2) /*rx(-rot[0]) ry(-rot[1]) rz(-rot[2])*/ rotzyx(-rot) rotate($vpr) { //must reverse the order of removing the rotation of the text because rotate works on x, then y, and finally z.
        if (textWidth>0.8*length){ // if so, put text outside of dim
          rotzyx(rot) ty(1.25*LT*10*sign(-dist)) rotzyx(-rot) text(str(length),valign="center",halign="center",size=ts);
        } else{
          text(str(length),valign="center",halign="center",size=ts);
        }
      }
      difference(){
        union(){
          //echo(textWidth=textWidth);
          //echo(length=length);
          BothArrowHeads=20*LT;
          excess=length-BothArrowHeads-textWidth;
          //echo(BothArrowHeads=20*LT);
          //echo(excess=length-BothArrowHeads-textWidth);
          if(excess>=BothArrowHeads){
            lx(length);
          }
          if(la==true){              
            if(excess>=BothArrowHeads){
              arrow2D();
            } else{
              rz(180) arrow2D();
            }
          }
          if(ra==true){
            if(excess>=BothArrowHeads){
              tx(length) rz(180) arrow2D();
            } else{
              tx(length) arrow2D();
            }
          }
        }
        tx(length/2) rx(-rot[0]) ry(-rot[1]) rz(-rot[2]) rotate($vpr) square([textWidth,textWidth],center=true);
      }
    }
  }
}

module lx(length=10, LT=LT){
  //creates a line along x-axis
  //length = length of line
  //DC = dimension colour (global variable)
  //LT = line thickness (global variable)
  color(DC){
    if(length>0){
      translate([0,-LT/2]) square([length,LT]);
    }else{
      translate([length,-LT/2]) square([-length,LT]);
    }
  }
}

module ly(length=10, LT=LT){
  rz(90) lx(length,LT);
}

//////////////2D dimensions from top view//////////////////////

module tdim(length,dist=20*LT,la=true,ra=true,ts=LT*10){
  dim2D(length=length,rot=[0,0,0],dist=-dist,la=la,ra=ra,ts=ts);
}

module bdim(length,dist=20*LT,la=true,ra=true,ts=LT*10){
  //same as dimx
  dim2D(length=length,rot=[0,0,0],dist=dist,la=la,ra=ra,ts=ts);
}

module ldim(length,dist=20*LT,la=true,ra=true,ts=LT*10){
  dim2D(length=length,rot=[0,0,90],dist=-dist,la=la,ra=ra,ts=ts);
}

module rdim(length,dist=20*LT,la=true,ra=true,ts=LT*10){
  //same as dimy
  dim2D(length=length,rot=[0,0,90],dist=dist,la=la,ra=ra,ts=ts);
}

module adim(length,angle,dist=20*LT,la=true,ra=true,ts=LT*10){
  //position this at the centre of the line to be dimensioned.
  //length is dimension length
  //angle is angle dimension is drawn at. Clockwise from 12 o'clock.
  tx(-length/2*cos(angle)) ty(length/2*sin(angle)){
    dim2D(length=length,rot=[0,0,-angle],dist=-dist,la=la,ra=ra,ts=ts);
  }
}
//adim(length=120,angle=-40,dist=90); //angle example

//ldr("hello",aa=34,al=70);
module ldr(message,aa=45,al=40,tl=10,ta=90,ts=LT*10,type=""){
  //message is the text to display
  //aa is the arrow angle. Defined as clockwise rotation from 12 o'clock
  //al is arrow length
  //tl is text leader length
  //ta is text angle. Same definition as aa.
  //ts is text size.
  //tdir is text leader direction
  //THINGS TO ADD
  //text leader direction
  rz(90-aa){
    arrow2D();//add arrowhead
    lx(al);//add line
    tx(al) rz(aa-ta){
      ldrOffset=(aa<0 || aa>180) ? -tl : 0;
      txtOffset=(aa<0 || aa>180) ? -(tl+2*LT) : tl+2*LT;
      tx(ldrOffset) lx(tl);//add leader to text
      color(DC) tx(txtOffset){
        alignment=(aa<0 || aa>180) ? "right" : "left"; // is text on left?
        if(type=="D"){
          txt=str("Ø ",str(message));
          text(txt,valign="center",halign=alignment,size=ts);//add text
        }
        else if(type=="R"){
          txt=str("R ",str(message));
          text(txt,valign="center",halign=alignment,size=ts);//add text
        }
        else{
          txt=message;
          text(str(txt),valign="center",halign=alignment,size=ts);//add text
        }  
      }
    }
  }
}

//dialdr(d=120,aa=60,al=70);
module dialdr(d,aa=45,al=40,tl=10,ta=90,ts=LT*10){
  tx(d/2*sin(aa)) ty(d/2*cos(aa)){
    ldr(message=d,aa=aa,al=al,tl=tl,ta=ta,ts=ts,type="D");
  }
}

//radldr(r=140,aa=80,al=70);
module radldr(r,aa=45,al=40,tl=10,ta=90,tdir="r",ts=LT*10){
  tx(r*sin(aa)) ty(r*cos(aa)){
    ldr(message=r,aa=aa,al=al,tl=tl,ta=ta,tdir=tdir,ts=ts,type="R");
  }
}

module arrow2D(shaft=true){
  //draws an arrow where the tip is at origin and the body extends along x axis
  color(DC)
  union(){
    //arrow head
    hull(){
      tx(sin(20)*LT/2) rz(20) translate([0,-LT/2,0]) square([LT*10,LT]);
      tx(sin(20)*LT/2) rz(-20) translate([0,-LT/2,0]) square([LT*10,LT]);
    }
    //arrow stick
    if (shaft) translate([0,-LT/2]) square([LT*20,LT]);
  }
}
module rotdim(sa,a,dist,tdist=4,ts=LT*10){
  color(DC){
    //display endlines
    rz(-sa) ty(0.1*dist) ly(dist,0.2);
    rz(-sa-a) ty(0.1*dist) ly(dist,0.2);
    //add arc
    rz(-sa) arc(ro=dist+0.1,ri=dist-0.1,a=a);
    //add arrows
    rz(90-sa) tx(dist) rz(-90) arrow2D(shaft=false);
    rz(90-(a+sa)) tx(dist) rz(90) arrow2D(shaft=false);
    //add text
    rz(90-sa-a/2) tx(dist+tdist) rz(-90+sa+a/2)  text(str(a,"°"),valign="center",halign="center",size=ts);
    }
    
}
//rotdim(a=45,sa=45,dist=10,ts=LT*10);

module circSector(r,a,n=24){
  // creates a circular sector starting at 12 o'clock and rotating clockwise
  angles=[for(i=[0:n-1]) -a*i/(n-1) ];
  points = [for(i=angles)[r*cos(i+90),r*sin(i+90)]];
  polygon(concat(points,[[0,0]]));
}
//circSector(10,30);

module arc(ro,ri,a,n=24){
  difference(){
    circSector(r=ro,a=a,n=n);
    rz(1) circSector(r=ri,a=a+2,n=n);
  }
}
//arc(20,18,90);


module slice(){
  //tz(-lt/2) linear_extrude(lt){
    color("black") difference(){
      offset(delta=lt/2){
        projection(cut=true){
          children();
        }
      }
      offset(delta=-lt/2){
        projection(cut=true){
          children();
        }
      }
    }
  //}
}

module outl(){
  //tz(-lt/2) linear_extrude(lt){
    color("black") difference(){
      offset(delta=lt/2){
        projection(cut=false){
          children();
        }
      }
      offset(delta=-lt/2){
        projection(cut=false){
          children();
        }
      }
    }
  //}
}

module dashedCircle(r,d,a=360,clr="black",LT=LT/1.5){
  color(clr) difference(){
    difference(){ //circle bit
      circle(d=d+LT);
      circle(d=d-LT);
    }
    for(t=[0:30:150]){
      rz(t+2.5) square([LT*10,d+2],center=true);
      rz(t-2.5) square([LT*10,d+2],center=true);
    }
  }
}


//add circle centres
module markcen(s=LT*10, LT=LT/1.5){
  color("black") {
    square([LT,s],center=true);
    square([s,LT],center=true);
  }
}

module crosshair(s,LT=LT/1.5){
  difference(){
    color("black") {
      square([LT,s],center=true);
      square([s,LT],center=true);
    }
    children();
  }
}

module section(w,h,x0=0,y0=0,ds=2,lt=lt,clr=DC){
  //slices a hatched section of a part
  //w is the width of part
  //h is the height of part
  //x0,y0 give the part centre
  //ds is the spacing of the hatchings along y axis
  //lt is line thickness of hatchings
  //clr is color
  color("black"){
    outl() children();
    slice() children();
    color("black") intersection(){
      projection(cut=true) children();
      tx(x0) ty(y0) for(i=[-h/2-w/2:ds:h/2+w/2]) ty(i) rz(-45) square([lt,1.5*w],center=true);
    }
  }
}