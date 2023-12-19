function [sys,x0,str,ts]=double_pendulum_display(t,x,u,flag,display)

global h_figure     %handle of figure
global h_line       %picture of plane
global h_text_wagen %Text Masse
global h_text_pendel1 %Text Pendel 1
global h_text_pendel2 %Text Pendel 2
global X_lok_wagen  %Array mit Koordinatenvektoren im lok. Sys.
global X_lok_pendel1 %Array mit Koordinatenvektoren im lok. Sys.
global X_lok_pendel2 %Array mit Koordinatenvektoren im lok. Sys.
%l_pend=p.l;         %Laenge Pendel
l_pend=1;

switch flag,
    
case 0, % init
    sizes=simsizes;
    sizes.NumContStates=0;
    sizes.NumDiscStates=0;
    sizes.NumOutputs=0;
    sizes.NumInputs=7;
    sizes.DirFeedthrough=7;
    sizes.NumSampleTimes=1;
    ts=0.02;
    sys=simsizes(sizes);
    x0=[];
    str=[];
    
    %Initialisieung Graphik
    if display==true
        h_figure=figure('NumberTitle','off');
        set(h_figure,'Position',[0 0 1000 1000]);
        set(h_figure,'Color',[0 0 0]);
        set(h_figure,'Menubar','none');
        axis([-2.4 2.4 -2.4 2.4]);
        axis equal
        axis manual
        xlabel('x'), ylabel('y');
        grid on
        set(get(h_figure,'Children'),'Color',[0 0 0])
        set(get(h_figure,'Children'),'Xcolor',[0.5 0.5 0.5])
        set(get(h_figure,'Children'),'Ycolor',[0.5 0.5 0.5])
        disp('initializing grafics');

        %Darstellung in lok Koordinaten; zwei Werte hintereinander
        %entsprechen jeweils einer Linie: 

        %Wagen+Pfeil = 7 Linien (werden translatorisch verschoben)
        x_lok_wagen=[0.2 -0.2 -0.2 -0.2 -0.2  0.2  0.2 0.2 0.0 0.0 0.0 0.0 0.0 0.0];
        y_lok_wagen=[0.1  0.1  0.1 -0.1 -0.1 -0.1 -0.1 0.1 0.0 0.0 0.0 0.0 0.0 0.0];

        %Pendel 1 = 1 Linien (werden gedreht)
        x_lok_pendel1=[ 0.0 0.0];
        y_lok_pendel1=[-l_pend 0.0];

        %Pendel 2 = 1 Linien (werden gedreht)
        x_lok_pendel2=[ 0.0 0.0];
        y_lok_pendel2=[-l_pend 0.0];

        X_lok_wagen=[x_lok_wagen;y_lok_wagen];    %Array mit Koordinatenvektoren im lok. Sys. 
        X_glob_wagen=X_lok_wagen;                 %Array mit Koordinatenvektoren im glob. Sys.

        X_lok_pendel1=[x_lok_pendel1;y_lok_pendel1]; %Array mit Koordinatenvektoren im lok. Sys. 
        X_glob_pendel1=X_lok_pendel1;               %Array mit Koordinatenvektoren im glob. Sys.

        X_lok_pendel2=[x_lok_pendel2;y_lok_pendel2]; %Array mit Koordinatenvektoren im lok. Sys. 
        X_glob_pendel2=X_lok_pendel2;               %Array mit Koordinatenvektoren im glob. Sys.

        %7+2=9 Linien
        X=reshape([X_glob_wagen(1,:),X_glob_pendel1(1,:),X_glob_pendel2(1,:)],2,9);   %Matrix x-Koordinaten f�r Darstellung
        Y=reshape([X_glob_wagen(2,:),X_glob_pendel1(1,:),X_glob_pendel2(1,:)],2,9);   %Matrix y-Koordinaten f�r Darstellung

        disp('drawing objects');
        %Zeichnen der Linien
        h_line=line(X,Y);               

        %Beschriftung Pendel 1
        h_text_pendel1=text(0,-l_pend,'m_1');
        set(h_text_pendel1, 'Color',[0 1 0])
        set(h_text_pendel1, 'FontSize',20)

        %Beschriftung Pendel 2
        h_text_pendel2=text(0,-l_pend,'m_2');
        set(h_text_pendel2, 'Color',[0 1 0])
        set(h_text_pendel2, 'FontSize',20)

        %Beschriftung Wagen
        h_text_wagen=text(0,0.25,'m_0');
        set(h_text_wagen, 'Color',[1 1 0])
        set(h_text_wagen, 'FontSize',20)

        for i=1:9
            set(h_line(i),'LineWidth',3)
        end

        set(h_line(1),'Color',[1 1 0])  %Wagen oben
        set(h_line(2),'Color',[1 1 0])  %Wagen links
        set(h_line(3),'Color',[1 1 0])  %Wagen unten
        set(h_line(4),'Color',[1 1 0])  %Wagen rechts
        set(h_line(5),'Color',[1 0 0])  %Pfeil Schaft
        set(h_line(6),'Color',[1 0 0])  %Pfeil Spitze oben
        set(h_line(7),'Color',[1 0 0])  %Pfeil Spitze unten
        set(h_line(8),'Color',[0 1 0])  %Pendel 1
        set(h_line(9),'Color',[0 1 0])  %Pendel 2
    end

case 3, % out

    %Aktualisierung der Bilddarstellung Pfeil
    l_vek=u(7)/25;                  %L�nge des eingezeichneten Kraftvektors
    X_lok_wagen(1,10)=l_vek;        %Pfeil Schaft x1
    X_lok_wagen(1,11)=l_vek;        %Pfeil Spitze oben x1
    X_lok_wagen(1,12)=l_vek*2/3;    %Pfeil Spitze oben x2
    X_lok_wagen(1,13)=l_vek;        %Pfeil Spitze unten x1
    X_lok_wagen(1,14)=l_vek*2/3;    %Pfeil Spitze unten x2
    X_lok_wagen(2,12)=l_vek/3;      %Pfeil Spitze oben y2
    X_lok_wagen(2,14)=-l_vek/3;     %Pfeil Spitze unten y2


    %Translatorischen Verschiebung Wagen und Kraftpfeil
    X_glob_wagen=X_lok_wagen+[ones(1,14);zeros(1,14)]*u(1);

    %Rotatorische Bewegung Pendel 1
    Q1=[ cos(u(2)), sin(u(2));...
       -sin(u(2)), cos(u(2))];

    X_glob_pendel1=Q1'*X_lok_pendel1;

    %Rotatorische Bewegung Pendel 2
    Q2=[ cos(u(3)), sin(u(3));...
       -sin(u(3)), cos(u(3))];

    X_glob_pendel2=Q2'*X_lok_pendel2;

    %Translatorischen Verschiebung Pendel 1
    X_glob_pendel1=X_glob_pendel1+[ones(1,2);zeros(1,2)]*u(1);

    %Translatorischen Verschiebung Pendel 2
    X_glob_pendel2=X_glob_pendel2+[X_glob_pendel1(:,1) X_glob_pendel1(:,1)];

    %Aktualisierung Graphik  
    X=reshape([X_glob_wagen(1,:),X_glob_pendel1(1,:),X_glob_pendel2(1,:)],2,9);   %Matrix x-Koordinaten f�r Darstellung
    Y=reshape([X_glob_wagen(2,:),X_glob_pendel1(2,:),X_glob_pendel2(2,:)],2,9);   %Matrix y-Koordinaten f�r Darstellung

    for i=1:9
        set(h_line(i),'XData',X(:,i));
        set(h_line(i),'YData',Y(:,i));
    end

    set(h_text_pendel1, 'Position',X_glob_pendel1(:,1))
    set(h_text_pendel2, 'Position',X_glob_pendel2(:,1))
    set(h_text_wagen, 'Position',[u(1),0.25])

    %Anpassung der Simualtionszeit an Echtzeit
    pause(0.01);
    
case 9,     %clean
    delete(h_figure), clear h_figure;
end