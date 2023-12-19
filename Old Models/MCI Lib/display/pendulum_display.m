function [sys,x0,str,ts]=pendulum_display(t,x,u,flag,display)

global h_figure     %handle of figure
global h_line       %picture of plane
global h_text_pendel%Text Masse Pendel
global X_lok_pendel %Array mit Koordinatenvektoren im lok. Sys.
%l_pend=p.l;         %Laenge Pendel
l_pend=1;

switch flag,
    
case 0, % init
    sizes=simsizes;
    sizes.NumContStates=0;
    sizes.NumDiscStates=0;
    sizes.NumOutputs=0;
    sizes.NumInputs=1;
    sizes.DirFeedthrough=1;
    sizes.NumSampleTimes=1;
    ts=0.02;
    sys=simsizes(sizes);
    x0=[];
    str=[];
    
    %Initialisieung Graphik
    if display==true
        h_figure=figure('NumberTitle','off');
        set(h_figure,'Position',[100 100 600 600]);
        set(h_figure,'Color',[0 0 0]);
        set(h_figure,'Menubar','none');
        axis([-1.2 1.2 -1.2 1.2]);
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


        %Pendel = 1 Linien (werden gedreht)
        X=[0.0 0.0];
        Y=[-l_pend 0.0];

        X_lok_pendel=[X;Y];                        %Array mit Koordinatenvektoren im lok. Sys. 
        X_glob_pendel=X_lok_pendel;                %Array mit Koordinatenvektoren im glob. Sys.

        disp('drawing objects');
        %Zeichnen der Linien
        h_line=line(X,Y);               

        %Beschriftung Pendel
        h_text_pendel=text(0,-l_pend,'m');
        set(h_text_pendel, 'Color',[0 1 0])
        set(h_text_pendel, 'FontSize',20)

        set(h_line,'LineWidth',3)
        set(h_line,'Color',[0 1 0])  %Pendel
    end

case 3, % out

    % Rotatorische Bewegung Pendel
    Q=[ cos(u), sin(u);...
       -sin(u), cos(u)];

    X_glob_pendel=Q'*X_lok_pendel;

    % Aktualisierung Graphik  
    X=X_glob_pendel(1,:);
    Y=X_glob_pendel(2,:);
 
    set(h_line,'XData',X);
    set(h_line,'YData',Y);

    set(h_text_pendel, 'Position',X_glob_pendel(:,1))
    axis([-1.2 1.2 -1.2 1.2]);

    %Anpassung der Simualtionszeit an Echtzeit
    pause(0.01);
    
case 9,     %clean
    delete(h_figure), clear h_figure;
end