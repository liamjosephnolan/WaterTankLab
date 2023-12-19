close all
command_V = 2.5;


sensordata = [58 2.58 1.5; % Height, Sensor V, Command V
              75 2.73 1.6;
              90 2.87 1.7;
              108 2.93 3.5;
              117 3.04 3.6;
              123 3.12 3.7;
              130 3.2  3.8;
              136 3.25 3.9;
              141 3.31, 4];
          
          y = sensordata(:,1);
          x = sensordata(:,2);
          
          P = polyfit(x,y,1);
          
          fit = P(1)*x+P(2);
          figure
          plot(x,y,'*')
          hold on
          plot(x,fit)

       