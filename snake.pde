//Não esquecer de comentar as funçoes para explicar o que fazem.
//Colocar som para quando a cobra come a comida.

import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioPlayer song;
FFT fft;

int direcao = 0;
int cobratamanho = 5;
int tempo = 0;
int[] headX= new int[2500];
int[] headY= new int[2500];
int comidaX = (round(random(47)) + 1) * 8;
int comidaY = (round(random(47)) + 1) * 8;
boolean refazer = true;
boolean pararJogo = false;

void setup(){
  restart();
  size(400,400);
  textAlign(CENTER);
  minim = new Minim(this);
  song = minim.loadFile("teste.mp3", 2048);
  song.play();
  fft = new FFT(song.bufferSize(), song.sampleRate());
}

void draw(){
  fft.forward(song.mix);
  
  if (pararJogo){}
  else{
    tempo += 1;
    fill(255, 0, 0);
    stroke(0);
    rect(comidaX, comidaY, 8, 8);
    fill(199, 247, 0);
    stroke(0);
    rect(0, 0, width, 8);
    rect(0, height - 8, width, 8);
    rect(0, 0, 8, height);
    rect(width - 8, 0, 8, height);

    if ((tempo % 5) == 0){
      viagem();
      tela();
      checagem();
    }
  }
}

void keyPressed(){
  if (key == CODED){
    if (keyCode == UP && direcao != 270 && (headY[1]-8) != headY[2]){
      direcao = 90;
    }
    if (keyCode == DOWN && direcao != 90 && (headY[1]+8) != headY[2]){
      direcao = 270;
    }
    if (keyCode == LEFT && direcao != 0 && (headX[1]-8) != headX[2]){
      direcao = 180;
    }
    if (keyCode == RIGHT && direcao != 180 && (headX[1]+8)!= headX[2]){
      direcao = 0;
    }
    if (keyCode == SHIFT){
      restart();
    }
  }
}

void viagem(){
  for(int i = cobratamanho; i > 0; i--){
    if (i != 1){
      headX[i] = headX[i-1];
      headY[i] = headY[i-1];
    }else{
      switch(direcao){
        case 0: headX[1] += 8; break;
        case 90: headY[1] -= 8; break;
        case 180: headX[1] -= 8; break;
        case 270: headY[1] += 8; break;
      }
    }
  }
}

void tela(){
  if (headX[1] == comidaX && headY[1] == comidaY){
    cobratamanho += round(random(3) + 1);
    refazer = true;
    
    while(refazer){
      comidaX = (round(random(47)) + 1) * 8;
      comidaY = (round(random(47)) + 1) * 8;
      
      for(int i = 1; i < cobratamanho; i++){
        if (comidaX == headX[i] && comidaY == headY[i]){
          refazer = true;
        }else{
          refazer = false;
          i = 100;
        }
      }
    }
  }
  fill(255);
  rect(headX[1], headY[1], 8, 8);
  fill(0);
  rect(headX[cobratamanho], headY[cobratamanho], 8, 8);
}

void checagem(){
  for(int i = 2; i <= cobratamanho; i++){
    if (headX[1] == headX[i] && headY[1] == headY[i]){
      fill(0);
      rect(125, 125, 160, 100);
      fill(255);
      text("PERDEU", 200, 150);
      text("SCORE:  " + str(cobratamanho - 1), 200, 175);
      text("Para reiniciar aperte SHIFT", 200, 200);
      pararJogo = true;
    }
    if (headX[1] >= (width - 8) || headY[1] >= (height - 8) || headX[1] <= 0 || headY[1] <= 0){
      fill(0);
      rect(125, 125, 160, 100);
      fill(255);
      text("PERDEU", 200, 150);
      text("SCORE:  " + str(cobratamanho - 1), 200, 175);
      text("Para reiniciar aperte SHIFT", 200, 200);
      pararJogo = true;
    }
  }
}

void restart(){
  background(0);
  headX[1] = 200;
  headY[1] = 200;
  for(int i = 2; i < 1000; i++){
    headX[i] = 0;
    headY[i] = 0;
  }
  pararJogo = false;
  comidaX = (round(random(47)) + 1) * 8;
  comidaY = (round(random(47)) + 1) * 8;
  cobratamanho = 2;
  tempo = 0;
  direcao = 0;
  refazer = true;
}
