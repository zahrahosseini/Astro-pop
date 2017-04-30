unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, jpeg, Menus, Gauges;

type
  TForm1 = class(TForm)

    Timer1: TTimer;
    Image1: TImage;
    Panel1: TPanel;
    Edit1: TEdit;
    Button1: TButton;
    Label1: TLabel;
    Panel2: TPanel;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Image2: TImage;
    Image3: TImage;
    Label3: TLabel;
    SaveDialog1: TSaveDialog;
    Button2: TButton;
    Panel3: TPanel;
    Button6: TButton;
    Edit2: TEdit;
    Label6: TLabel;
    Panel4: TPanel;
    RadioGroup1: TRadioGroup;
    Button7: TButton;
    Button8: TButton;
    Edit3: TEdit;
    Image4: TImage;
    Image5: TImage;
    Gauge1: TGauge;
    Label4: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  level:integer;nam:string;
  n:integer;
  a:array[1..16,1..16]of boolean;
  laps,loadexe:boolean;
  loadcolor:array[1..15,-1..14]of tcolor;
  scor:integer;
  //n:tedade blocks mojud dar sabad
  //mokhtasat safhe bazi:(20,20,220,220)
  //abade blocks va safine:20*20

implementation


{$R *.dfm}


procedure gameover;
begin
  Form1.Label4.Caption:='game over!!';
  form1.timer1.Enabled:=false;
  laps:=false;
end;


//flb:"find last block" flb mahale akharin block har sotun ra moshakhas mikonad
function flb(c:integer):integer;
var i,p:integer;
begin
  p:=15;
  for i:=1 to 15 do
  begin
    if form1.Canvas.Pixels[c*40+20,i*20+40]=form1.Color then
    begin
     p:=i-1;
     break;
    end;
  end;
  flb:=p;
end;


//shift:az radife aval ta akharin rdife havi block be
//andaze iek rdif be paieen shift karde
procedure shift;
var j:integer;a:array[1..15]of integer;
begin
  for j:=1 to 15 do
  begin
      a[j]:=flb(j);
      if a[j]=15 then gameover;
  end;
    for j:=1 to 15 do
      if laps then
        form1.Canvas.CopyRect(rect(40*j,70,40*j+40,20*a[j]+70),form1.Canvas,rect(40*j,50,40*j+40,20*a[j]+50));
end;


//makerow:iek radif dar avalin satr eijad karde.
procedure makerow(r:integer);
var i,x,y:integer;
begin
  x:=0;y:=20*r+30;
  for i:=1 to 15 do
  begin
    case random(level+2) of
      0:form1.Canvas.Brush.Color:=clyellow;
      1:form1.Canvas.Brush.Color:=clred;
      2:form1.Canvas.Brush.Color:=clgreen;
      3:form1.Canvas.Brush.Color:=claqua;
      4:form1.Canvas.Brush.Color:=clblue;
      5:form1.Canvas.Brush.Color:=cllime;
      6:form1.Canvas.Brush.Color:=clwhite;
    end;
    x:=x+40;
    form1.Canvas.Rectangle(rect(x,y,x+40,y+20));
  end;
end;


//charge:dar sotuni ke safine ast nazdiktarin block ra dar surat
//vojude va hamrangi ba saier blocks mojud dar sabad safine dar iaft mikonad
procedure charge;
var l:integer;k:integer;
begin
  k:=form1.image1.left;l:=flb(k div 40); if l=14 then gameover;;
  if (l<>0) and(l<>15)and laps then
  begin
      if(form1.Canvas.Pixels[k+20,20*l+40]=form1.Canvas.Pixels[k+20,20*(15-n)+40])or (n=0) then
      begin
        n:=n+1;
        form1.Canvas.Brush.Color:=form1.Canvas.Pixels[k+20,20*l+10+30];
        form1.Canvas.Rectangle(k,330-20*n,k+40,350-20*n);
        form1.Canvas.Brush.Color:=form1.Color;
        form1.Canvas.Rectangle(rect(k,l*20+30,k+40,l*20+50));
      end;
  end;
end;
procedure serch(m,n:integer;var k:integer);
begin
  if not(a[m,n-1]) then
    if form1.Canvas.Pixels[40*m+20,20*n+40]=form1.Canvas.Pixels[40*m+20,20*(n-1)+40]then
      begin a[m,n-1]:=true;k:=k+1;serch(m,n-1,k);end;
  if not(a[m,n+1]) then
    if form1.Canvas.Pixels[40*m+20,20*n+40]=form1.Canvas.Pixels[40*m+20,20*(n+1)+40]then
      begin a[m,n+1]:=true;k:=k+1;serch(m,n+1,k);end;
  if not(a[m-1,n]) then
    if form1.Canvas.Pixels[40*m+20,20*n+40]=form1.Canvas.Pixels[40*(m-1)+20,20*n+40]then
      begin a[m-1,n]:=true;k:=k+1;serch(m-1,n,k);end;
  if not(a[m+1,n]) then
    if form1.Canvas.Pixels[40*m+20,20*n+40]=form1.Canvas.Pixels[40*(m+1)+20,20*n+40]then
      begin a[m+1,n]:=true;k:=k+1;serch(m+1,n,k);end;
end;


procedure loading;
var i,j:integer;
begin
 for i:=1 to 15 do
  begin
   form1.Canvas.Brush.Color:=loadcolor[i,-1];
   form1.Canvas.Rectangle(40*i,10,40*i+40,30);
  end;
  for i:=1 to 14 do
    for j:=1 to 15 do
    begin
      if loadcolor[j,i]<>form1.Color then
       begin
        form1.Canvas.Brush.Color:=loadcolor[j,i];
        form1.Canvas.Rectangle(40*j,20*i+30,40*j+40,20*i+50);
      end;
    end;
  loadexe:=false;
end;



procedure uptodate;
var i:integer;
begin
   if loadexe then
    loading
   else
   begin
     scor:=0;
     form1.Gauge1.MaxValue:=50*level;
     form1.Gauge1.MinValue:=0;
     form1.Gauge1.Progress:=0;
     form1.Canvas.Brush.Color:=form1.Color;
     form1.Canvas.Rectangle(40,50,640,350);
     makerow(-1);
     n:=0;
     for i:=1 to (level)+1 do
        makerow(i);
   end;
   form1.timer1.Enabled:=true;
   laps:=true;
   form1.image1.Visible:=true;
   form1.label3.Caption:=('level'+inttostr(level));
end;


procedure nextlevel;
begin
  laps:=false;
  level:=level+1;
  if level>5 then
    showmessage('you win '+nam)
  else
  begin
    form1.label4.caption:=' next level ';
    uptodate;
  end;
end;


//discharge:tamame blocks mojud dar sabad ra be entehaie akharin block
//sotuni ke safine dar an ast ezafe karde
procedure discharge;
var l,m,k,i,j,d,c,t:integer;
    b:array[1..15]of integer;
begin
  k:=form1.Image1.Left;l:=flb(k div 40);if l=15 then gameover;
  if (n<>0)and laps then
  begin
    form1.Canvas.CopyRect(rect(k,20*l+50,k+40,20*(l+n)+50),form1.Canvas,rect(k,330-20*n,k+40,330));
    m:=15-(l+n+1);
    form1.canvas.Brush.Color:= form1.Color;
    form1.Canvas.Rectangle(k,330-20*m,k+40,330);
    t:=n+l;
    n:=0;
    for i:=1 to 16 do
      for j:=1to 16 do
        a[i,j]:=false;
    for i:=1 to 15 do
      b[i]:=flb(i);
    c:=0;
    serch(k div 40,t,c);
    if c>3 then
    begin
      for i:=1 to 15 do
      begin
        d:=0;
        for j:=1 to b[i] do
        begin
          if not(a[i,j]) then
          begin
            if d<>0 then
            begin
            form1.Canvas.CopyRect(rect(40*i,20*(j-d)+30,40*(i+1),20*(j-d)+50),form1.Canvas,rect(40*i,j*20+30,40*(i+1),20*j+50));
            form1.Canvas.Rectangle(rect(40*i,j*20+30,40*(i+1),20*j+50));
            end;
          end
          else
          begin
            d:=d+1; form1.Canvas.Brush.Color:=form1.Color;;
            form1.Canvas.Rectangle(rect(40*i,j*20+30,40*(i+1),20*j+50));
          end;
        end;
      end;
      form1.gauge1.AddProgress(c);
      scor:=scor+c;
      messagebeep($ffff);
    end;
  end;
  if  scor>(50*level)then
    nextlevel;
end;



procedure goright;
var l,k:integer;
begin
  k:=form1.Image1.Left;
  if ((n=0)or(form1.Canvas.Pixels[k+60,20*(15-n)+40]=form1.Color))and (k<600) then
      if form1.Canvas.Pixels[k+60,340]=form1.Color then
      begin
        form1.Image1.Left:=form1.Image1.Left+40;
        l:=form1.Image1.Left;
        if (n<>0) then
        begin
          form1.Canvas.CopyRect(rect(l,20*(15-n)+30,l+40,330),form1.Canvas,rect(k,20*(15-n)+30,k+40,330));
          form1.Canvas.Brush.Color:=form1.Color;
          form1.Canvas.Rectangle(rect(k,20*(15-n)+30,k+40,330));
        end;
    end;
end;



procedure goleft;
var l,k:integer;
begin
  k:=form1.Image1.Left;
  if ((n=0)or(form1.Canvas.Pixels[k-20,20*(15-n)+40]=form1.Color))and (k>40) then
    if form1.Canvas.Pixels[k-10,340]=form1.Color then
    begin
      form1.Image1.Left:=form1.Image1.Left-40;
      l:=form1.Image1.Left;
      if (n<>0) then
      begin
        form1.Canvas.CopyRect(rect(l,20*(15-n)+30,l+40,330),form1.Canvas,rect(k,20*(15-n)+30,k+40,330));
        form1.Canvas.Brush.Color:=form1.Color;
        form1.Canvas.Rectangle(rect(k,20*(15-n)+30,k+40,330));
      end;
    end;
end;




procedure TForm1.Button1Click(Sender: TObject);
begin
 if level=0 then
  showmessage('please enter your name and select a level or load a file')
 else
    begin
     form1.Canvas.Pen.style:=psclear;
     nam:=edit1.Text;
     image3.Visible:=false;
     panel1.Visible:=false;
  end;
end;




procedure TForm1.Timer1Timer(Sender: TObject);
begin
   if laps then
   begin
    shift;
    form1.Canvas.CopyRect(rect(40,50,640,70),form1.Canvas,rect(40,10,640,30));
    makerow(-1);
   end;
end;




procedure TForm1.FormCreate(Sender: TObject);
begin
  laps:=false;
  AnimateWindow(Form1.Handle, 300, AW_Center);
  edit1.Text:='';
  image1.Visible:=false;
  image1.Left:=40;image1.Top:=330;
  image1.Width:=40;image1.Height:=20;
  timer1.Enabled:=false;
end;



procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if laps then
    case key of
      vk_down:  if n<4 then charge;
      vk_up:    discharge;
      vk_right: goright;
      vk_left:  goleft;
    end;
end;




procedure TForm1.Button2Click(Sender: TObject);
var 
f:textfile;scor:integer;color:tcolor;i,j:integer;
k:integer;
dir:string;
begin
  dir:=edit3.Text;
  k:=image1.Left;
  scor:=form1.Gauge1.Progress;
  assignfile(f,dir);
  rewrite(f);
  writeln(f,nam);
  writeln(f,level);
  writeln(f,scor);
  writeln(f,n);
  writeln(f,k);
  for i:=-1 to 14 do
    for j:=1 to 15 do
    begin
      color:=form1.Canvas.Pixels[40*j+20,20*i+40];
      writeln(f,color);
    end;
  closefile(f);
end;



procedure TForm1.Button3Click(Sender: TObject);
begin
 if button3.caption='start' then
 begin
  uptodate;
  button3.caption:='pause';
 end
 else
 begin
   if button3.caption='pause' then
   begin
    button3.caption:='play';laps:=false;
   end
   else
   begin
     if button3.caption='play' then
     begin
      button3.caption:='pause';laps:=true;
     end;
   end;
 end;

end;

procedure TForm1.Button4Click(Sender: TObject);
begin
form1.Close;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
laps:=false;
image2.Visible:=false;
Image2.Width:=form1.Width;
image2.Top:=form1.Top;
image2.Left:=form1.left;
Image2.Height:=form1.Height;
Image2.Canvas.CopyRect(Rect(form1.Left,form1.top,form1.Left+form1.Width,form1.top+form1.Height),Canvas,Rect(form1.Left,form1.top,form1.Left+form1.Width,form1.top+form1.Height));
 If SaveDialog1.Execute then
   Image2.Picture.Bitmap.SaveToFile(SaveDialog1.FileName);
image2.Visible:=false;
laps:=true;
end;

procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
if (x<(16*40))and laps then
case button of
mbleft:if n<4 then charge;
mbright:discharge;
end;
end;



procedure TForm1.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
  var k,l,s,m,i:integer;
begin
  k:=image1.Left; s:=k div 40; m:=x div 40;
  if laps and((x<640+1)and(x>40-1))then
  begin
    for i:=1 to abs(m-s)do
    begin
      if m>s then
      begin
       if ((n=0)or(form1.Canvas.Pixels[k+60,20*(15-n)+40]=form1.Color))and (k<600) then
       begin
          if form1.Canvas.Pixels[k+60,340]=form1.Color then
          begin
            form1.Image1.Left:=form1.Image1.Left+40;
            l:=form1.Image1.Left;
            if (n<>0) then
            begin
              form1.Canvas.CopyRect(rect(l,20*(15-n)+30,l+40,330),form1.Canvas,rect(k,20*(15-n)+30,k+40,330));
              form1.Canvas.Brush.Color:=form1.Color;
              form1.Canvas.Rectangle(rect(k,20*(15-n)+30,k+40,330));
              k:=image1.Left;
            end;
          end;
       end
       else break;
      end;
      if m<s then
      begin
      if((n=0)or(form1.Canvas.Pixels[k-20,20*(15-n)+40]=form1.Color))and (k>40)then
       begin
           if form1.Canvas.Pixels[k-10,340]=form1.Color then
          begin
            form1.Image1.Left:=form1.Image1.Left-40;
            l:=form1.Image1.Left;
            if (n<>0) then
            begin
              form1.Canvas.CopyRect(rect(l,20*(15-n)+30,l+40,330),form1.Canvas,rect(k,20*(15-n)+30,k+40,330));
              form1.Canvas.Brush.Color:=form1.Color;
              form1.Canvas.Rectangle(rect(k,20*(15-n)+30,k+40,330));
              k:=image1.Left;
            end;
          end;
       end
       else break;
      end;
    end;
  end;
end;


procedure TForm1.Button6Click(Sender: TObject);
var st:string;nv:integer;f:textfile;i,j:integer;
k:integer;
 begin
  if level=0  then
  begin
      if fileexists(edit2.Text) then
      begin
        assignfile(f,edit2.Text);
        reset(f);
        readln(f,st);
        edit1.Text:=st;
        readln(f,nv);
        level:=nv;
        label3.Caption:='level'+inttostr(nv);
        readln(f,nv);
        gauge1.Progress:=nv;
        readln(f,n);
        readln (f,k);
        image1.Left:=k;
        for i:=-1 to 14 do
          for j:=1 to 15 do
            readln(f,loadcolor[j,i]);
        loadexe:=true;
        closefile(f);
      end
      else
        showmessage('there is not this file');
  end;
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
   if (level=0)and(radiogroup1.ItemIndex<>-1) then
     case radiogroup1.ItemIndex of
       0:level:=1;
       1:level:=2;
       2:level:=3;
       3:level:=4;
       4:level:=5;
     end;
end;

procedure TForm1.Button8Click(Sender: TObject);
begin
radiogroup1.ItemIndex:=-1;
level:=0;
loadexe:=false;
edit1.Text:='';
end;

end.
