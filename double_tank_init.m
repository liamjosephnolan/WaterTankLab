clear al
close all
clc

p.rho = 1000; %kg/m3
p.At = 5e-2;
p.Ao = 2.5e-4;
p.zeta = 0.05;
p.g = 9.81;
p.a = (p.Ao/p.At)*sqrt(2*p.g/(1+p.zeta));

traj.start_time = 10; % s
traj.duration = 100; % s
traj.start_val = 0.05; % m
traj.end_val = 0.1; % m


x_init = [0.1 0.15];
A = [0 1;0 0];

B = [0; 1];
C = [1, 0];

poles = [complex(-0.1,0),complex(-0.1,0)];

K = acker(A,B,poles);

V=-1/(C*inv(A-B*K)*B);