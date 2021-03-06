function [sys,x0,str,ts] = homework_controller(t, x, u, flag)
switch flag,
  case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;  % 调用初始化子函数
  case 1,
    sys=[];
  case 2,
    sys=[];
  case 3,
    sys=mdlOutputs(t,x,u);    %计算输出子函数
  case 4,
    sys=[];   %计算下一仿真时刻子函数
  case 9,
    sys=[];    %终止仿真子函数
  otherwise
    DAStudio.error('Simulink:blocks:unhandledFlag', num2str(flag));

end

function [sys,x0,str,ts,simStateCompliance]=mdlInitializeSizes   %初始化子函数

sizes = simsizes;

sizes.NumContStates  = 0;  %连续状态变量个数
sizes.NumDiscStates  = 0;  %离散状态变量个数
sizes.NumOutputs     = 3;  %输出变量个数
sizes.NumInputs      = 4;   %输入变量个数
sizes.DirFeedthrough = 1;   %输入信号是否在输出端出现
sizes.NumSampleTimes = 0;   % at least one sample time is needed

sys = simsizes(sizes);
x0  = [];   %初始值
str = [];   
ts  = [];   %[0 0]用于连续系统，[-1 0]表示继承其前的采样时间设置
simStateCompliance = 'UnknownSimState';

function sys=mdlOutputs(t,x,u)   %计算输出子函数
thd = u(1);
dthd = cos(t);
ddthd = -sin(t);
dddthd = -cos(t);

x1 = u(2);
dx1 = u(3);

f = 2*x1^2;
df = 4*x1*dx1;

x2 = dx1 - f;
dx2 = u(4);


k1 = 10;
k2 = 100;
k3 = 500;

ddx1 = 4*x1*dx1+dx2;
ddf = 4*x1*ddx1+4*dx1*dx1;

z1 = x1 - thd;
dz1 = dx1 - dthd;
ddz1 = ddx1 - ddthd;
x2d = -f+dthd-k1*z1;
dx2d = -df + ddthd - k1*dz1;
ddx2d = -ddf + dddthd - k1*ddz1;

z2 = x2 - x2d;
dz2 = dx2 - dx2d;

x3 = dx2;

x3d = dx2d - k2*z2-z1;
dx3d = ddx2d - k2*dz2 - dz1;
z3 = x3 - x3d;

ut = dx3d - z2 - k3*z3;

sys(1) = ut;
sys(2) = x2;
sys(3) = z1;


