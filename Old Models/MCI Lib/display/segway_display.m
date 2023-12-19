function [sys,x0,str,ts]=bb8_display(t,x,u,flag,display)

% u(1) = wheel angle
% u(2) = rod angle

r1=0.3;
r2=1.3;
n_spokes=5;

global h_figure     % handle of figure
global h_line       % picture of spokes and rod
global h_wheel      % picture of wheel
global h_mass       % picture of mass
%global h_text_wagen %Text Masse Pendel
%global h_text_pendel%Text Masse Pendel
global X_loc_wheel  % Array mit Koordinatenvektoren im lok. Sys.
global X_loc_rod % Array mit Koordinatenvektoren im lok. Sys.

switch flag,
    
case 0, % init
    sizes=simsizes;
    sizes.NumContStates=0;
    sizes.NumDiscStates=0;
    sizes.NumOutputs=0;
    sizes.NumInputs=4;
    sizes.DirFeedthrough=2;
    sizes.NumSampleTimes=1;
    ts=0.02;
    sys=simsizes(sizes);
    x0=[];
    str=[];
    
    %Initialisieung Graphik
    if display==true
        h_figure=figure('NumberTitle','off');
        set(h_figure,'Position',[30 780 1600 400]);
        set(h_figure,'Color',[0 0 0]);
        set(h_figure,'Menubar','none');
        axis([-(r1+r2) 3*(r1+r2) -r1 r2]);
        %axis([-2 2 -1.4 0.6]);
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
        
        % wheel = circle + n spokes (translated & rotated)
        for i=1:n_spokes
            x_loc_wheel(2*i-1)=0;
            x_loc_wheel(2*i)=r1*sin(2*pi*i/n_spokes);
            y_loc_wheel(2*i-1)=0;
            y_loc_wheel(2*i)=r1*cos(2*pi*i/n_spokes);
        end
        
        % rod = circle + 1 line (rotated)
        x_loc_rod=[0.0 0.0];
        y_loc_rod=[-r2 0.0];
        
        X_loc_wheel=[x_loc_wheel;y_loc_wheel];    %Array mit Koordinatenvektoren im lok. Sys.
        X_glob_wheel=X_loc_wheel;                 %Array mit Koordinatenvektoren im glob. Sys.
        
        
        X_loc_rod=[x_loc_rod;y_loc_rod];          %Array mit Koordinatenvektoren im lok. Sys.
        X_glob_rod=X_loc_rod;                     %Array mit Koordinatenvektoren im glob. Sys.
        
        % 3+1=4 lines
        X=reshape([X_glob_wheel(1,:),X_glob_rod(1,:)],2,n_spokes+1);   %Matrix x-Koordinaten f�r Darstellung
        Y=reshape([X_glob_wheel(2,:),X_glob_rod(2,:)],2,n_spokes+1);   %Matrix y-Koordinaten f�r Darstellung
        
        disp('drawing objects');
        %Zeichnen der Linien
        h_line=line(X,Y);
        
        %Beschriftung Pendel
        %     h_text_pendel=text(0,-p.l,'m_2');
        %     set(h_text_pendel, 'Color',[0 1 0])
        %     set(h_text_pendel, 'FontSize',20)
        
        %Beschriftung Wagen
        %     h_text_wagen=text(0,0.25,'m_1');
        %     set(h_text_wagen, 'Color',[1 1 0])
        %     set(h_text_wagen, 'FontSize',20)
        
        for i=1:n_spokes+1
            set(h_line(i),'LineWidth',3)
            set(h_line(i),'Color',[1 1 0])
        end
        set(h_line(end),'Color',[0 1 0])  % rod
        h_wheel=rectangle('Position',[-r1,-r1,2*r1,2*r1],'EdgeColor',[1 1 0],'Curvature',[1,1],'Linewidth',3)
        h_mass=rectangle('Position',[-r1/10,-r2-r1/10,r1/5,r1/5],'FaceColor',[0 1 0],'EdgeColor',[0 1 0],'Curvature',[1,1])
    end
case 3, % out
    
    %Pendel = 1 Linien (werden gedreht)
    x_loc_rod=[ 0.0 0.0];
    y_loc_rod=[-r2 0.0];
    X_loc_rod=[x_loc_rod;y_loc_rod]; %Array mit Koordinatenvektoren im lok. Sys. 

    % rotation matrix wheel
    Q1=[ cos(u(1)), -sin(u(1));...
       sin(u(1)), cos(u(1))];

    % translation wheel
    X_glob_wheel=Q1'*X_loc_wheel+[ones(1,2*n_spokes);zeros(1,2*n_spokes)]*u(1)*r1;
    
    % rotation matrix rod
    Q2=[ cos(u(2)), sin(u(2));...
       -sin(u(2)), cos(u(2))];

    X_glob_rod=Q2'*X_loc_rod;
    
    %Translatorischen Verschiebung Pendel
    X_glob_rod=X_glob_rod+[ones(1,2);zeros(1,2)]*u(1)*r1;
    
    %Aktualisierung Graphik  
    X=reshape([X_glob_wheel(1,:),X_glob_rod(1,:)],2,n_spokes+1);   %Matrix x-Koordinaten f�r Darstellung
    Y=reshape([X_glob_wheel(2,:),X_glob_rod(2,:)],2,n_spokes+1);   %Matrix y-Koordinaten f�r Darstellung
    
    for i=1:n_spokes+1
        set(h_line(i),'XData',X(:,i));
        set(h_line(i),'YData',Y(:,i));
    end
    set(h_wheel,'Position',[r1*(u(1)-1),-r1,2*r1,2*r1]);
    set(h_mass,'Position',[-r1/10+r1*u(1)+r2*sin(u(2)),-r2*cos(u(2))-r1/10,r1/5,r1/5]);
    
%     set(h_text_pendel, 'Position',X_glob_pendel(:,1))
%     set(h_text_wagen, 'Position',[u(1),0.25])
    
    %Anpassung der Simualtionszeit an Echtzeit
    pause(0.01);
    
case 9,     %clean
    delete(h_figure), clear h_figure;
end