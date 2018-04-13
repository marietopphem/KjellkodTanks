// Sound effects from: http://www.freesfx.co.uk/
// TODO: use a HashMap for the audio players

class Audio {
  AudioPlayer audioShot;
  AudioPlayer audioBlast;
  AudioPlayer audioTank;

  Audio() {
    //audioShot = minim.loadFile("shot.mp3");
    audioBlast = minim.loadFile("tank_firing.mp3");
    //audioBlast = minim.loadFile("blast.mp3");
    audioTank = minim.loadFile("tank_idle.mp3");
    
  }

  void shot() {
    audioShot.rewind();
    audioShot.play();
  }

  void blast() {
    audioBlast.rewind();
    audioBlast.play();
  }
  
  void engineStart() {
    //audioTank.rewind();
    //audioTank.play();
  }
  void engineStop() {
    //audioTank.rewind();
    //audioTank.pause();
  }
}
