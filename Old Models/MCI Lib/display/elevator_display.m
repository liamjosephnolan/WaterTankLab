function [sys,x0,str,ts]=elevator_display(t,x,u,flag,display)

global h_figure     %handle of figure
global h_line       %picture of plane
global h_text_cabin %Text Masse Pendel
global h_text_chord %Text Masse Pendel
global X_lok_cabin  %Array mit Koordinatenvektoren im lok. Sys.
global X_lok_chord  %Array mit Koordinatenvektoren im lok. Sys.

switch flag,
    
case 0, % init
    sizes=simsizes;
    sizes.NumContStates=0;
    sizes.NumDiscStates=0;
    sizes.NumOutputs=0;
    sizes.NumInputs=4;
    sizes.DirFeedthrough=4;
    sizes.NumSampleTimes=1;
    ts=0.02;
    sys=simsizes(sizes);
    x0=[];
    str=[];
    
    %Initialisieung Graphik
    if display==true
        h_figure=figure('NumberTitle','off');
        set(h_figure,'Position',[0 0 300 1000]);
        set(h_figure,'Color',[0 0 0]);
        set(h_figure,'Menubar','none');
        axis([-3 3 -20 0]);
        %axis equal
        axis manual
        xlabel('x'), ylabel('y');
        grid on
        set(get(h_figure,'Children'),'Color',[0 0 0])
        set(get(h_figure,'Children'),'Xcolor',[0.5 0.5 0.5])
        set(get(h_figure,'Children'),'Ycolor',[0.5 0.5 0.5])
        disp('initializing grafics');

        %Darstellung in lok Koordinaten; zwei Werte hintereinander
        %entsprechen jeweils einer Linie: 

        %Kabine = 4 Linien (werden translatorisch verschoben)
        x_lok_cabin=[0.5 -0.5 -0.5 -0.5 -0.5  0.5  0.5 0.5];
        y_lok_cabin=[0.0  0.0  0.0 -1.0 -1.0 -1.0 -1.0 0.0];

        %Seil = 1 Linie (wird translatorisch verschoben)
        x_lok_chord=[0.0 0.0];
        y_lok_chord=[0.0 0.0];

        X_lok_cabin=[x_lok_cabin;y_lok_cabin];    %Array mit Koordinatenvektoren im lok. Sys. 
        X_glob_cabin=X_lok_cabin;                 %Array mit Koordinatenvektoren im glob. Sys.

        X_lok_chord=[x_lok_chord;y_lok_chord]; %Array mit Koordinatenvektoren im lok. Sys. 
        X_glob_chord=X_lok_chord;               %Array mit Koordinatenvektoren im glob. Sys.

        %4+1=5 Linien
        X=reshape([X_glob_cabin(1,:),X_glob_chord(1,:)],2,5);   %Matrix x-Koordinaten f�r Darstellung
        Y=reshape([X_glob_cabin(2,:),X_glob_chord(1,:)],2,5);   %Matrix y-Koordinaten f�r Darstellung

        disp('drawing objects');
        %Zeichnen der Linien
        h_line=line(X,Y);               

        %Beschriftung Pendel
        h_text_chord=text(0.1,0.0,'y');
        set(h_text_chord, 'Color',[0 1 0])
        set(h_text_chord, 'FontSize',20)

        %Beschriftung Wagen
        h_text_cabin=text(0,-0.5,'m');
        set(h_text_cabin, 'Color',[1 1 0])
        set(h_text_cabin, 'FontSize',20)

        for i=1:5
            set(h_line(i),'LineWidth',3)
        end

        set(h_line(1),'Color',[1 1 0])  %Wagen oben
        set(h_line(2),'Color',[1 1 0])  %Wagen links
        set(h_line(3),'Color',[1 1 0])  %Wagen unten
        set(h_line(4),'Color',[1 1 0])  %Wagen rechts
        set(h_line(5),'Color',[0 1 0])  %Pendel
    end

case 3, % out

    %Translatorischen Verschiebung Wagen und Kraftpfeil
    X_glob_cabin=X_lok_cabin-[zeros(1,8);ones(1,8)]*u(1);

    X_glob_chord=[0.0 0.0;0.0 -u(1)];

    %Aktualisierung Graphik  
    X=reshape([X_glob_cabin(1,:),X_glob_chord(1,:)],2,5);   %Matrix x-Koordinaten f�r Darstellung
    Y=reshape([X_glob_cabin(2,:),X_glob_chord(2,:)],2,5);   %Matrix y-Koordinaten f�r Darstellung

    for i=1:5
        set(h_line(i),'XData',X(:,i));
        set(h_line(i),'YData',Y(:,i));
    end

    set(h_text_chord, 'Position',[0.2,-u(1)/2])
    set(h_text_cabin, 'Position',[-0.3,-u(1)-0.5])

    e=(u(1)-u(2))/u(2);
    e=min(e,1);
    
    if e>0
        set(h_line(5),'Color',[0 e 0])  %Pendel
    else 
        set(h_line(5),'Color',[1 0 0])  %Pendel
    end
    
    %Anpassung der Simualtionszeit an Echtzeit
    pause(0.01);
    
case 9,     %clean
    delete(h_figure), clear h_figure;
end