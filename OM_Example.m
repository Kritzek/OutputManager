
x=linspace(-50,50,100);
omh1=OutputManager();

fh1=figure();
plot(x,x,'r')
omh1.AddFigure(fh1);
omh1.ChangeName(fh1,'xlinear');

fh2=figure();
plot(x,x.^2,'-b')
omh1.AddFigure(fh2);
omh1.ChangeName(2,'xsquare');

fh3=figure();
plot(x,abs(x));
omh1.AddFigure(fh3);



omh2=OutputManager();

fh4=figure();
plot(x,tan(x/100*2*pi),'r')
omh2.AddFigure(fh4);
omh2.ChangeName(fh4,'xtan');

fh5=figure();
plot(x,sin(x/100*2*pi),'-b')
omh2.AddFigure(fh5);
omh2.ChangeName(fh5,'xsin');

fh6=figure();
plot(x,sin(x/100*2*pi).^2);
omh2.AddFigure(fh6);
omh2.ChangeName(fh6,'xsinsq');