% clear the workspace, command line and variables
clear all
close all
clc

% initialize simulation model variables
simin =timetable(seconds(0),0);
const=1;
A_m = 0;
B_m = 0;
C_m = 0;
D_m = 0;
numm = 0;
denum = 1;


%% Q3/ Simulate the model and verify the results

% Specify the values of the parameters of the system
Msprung = (350+750)/4; %kg;
Munsprung = 15; %kg;
Ks = 140000; %N/m;
Kt = 300000; %N/m;
Bt = 5000; %Ns/m;

% create arrays for the input blocks parameters to run two scenarios
step2_final_values = [0 10];
step_time = [1 6];
ramp_slopes = [0 0.001];
ramp_start_times = [0 1];


% a for loop to plot the inputs and output for the two verification
% scenarios
for scenario=1:2
    step_stime = step_time(scenario);     % assign the step time for the corresponding scenario to a new variable
    step2_fvalue = step2_final_values(scenario);     % assign the step2 final value for the corresponding scenario to a new variable
    ramp_slope = ramp_slopes(scenario);     % assign the ramp slope for the corresponding scenario to a new variable
    ramp_stime = ramp_start_times(scenario);       % assign the ramp start time for the corresponding scenario to a new variable
    sttr = num2str(scenario);
    sttr = "Verification Scenario " + sttr;
    sim("Home_exam_retake_sim")
    figure('Name',sttr, "NumberTitle","off")     % create a figure with custom name
    tiledlayout(2,2,"TileSpacing","compact", "Padding","compact")    % use tiledlayout to have all the output variables plots in one figure
    nexttile
    plot(ans.tout,ans.Zs)   % Plot Zs
    title("Zs")
    legend('displcement [m]', 'Location','southeast')
    xlabel('time')
    ylabel('Displacement')
    grid on
    nexttile
    plot(ans.tout, ans.ddot_Zs)   % plot ddot_zs
    title("ddot Zs")
    legend('Acceleration [m/s^2]')
    xlabel('time')
    ylabel('Acceleration')
    grid on
    nexttile
    plot(ans.tout, ans.Zus)    % plot Zus
    title("Zus")
    legend('displcement [m]',"Location","southeast")
    xlabel('time')
    ylabel('Displacement')
    grid on
    nexttile
    plot(ans.tout, ans.ddot_Zus)    % plot ddot_zus
    title("ddot Zus")
    legend('Acceleration [m/s^2]')
    xlabel('time')
    ylabel('Acceleration')
    grid on
    in_str = "Input " + sttr;
    figure("Name",in_str, "NumberTitle","off")     % create a second figure for the inputs plots
    plot(ans.tout, ans.Zr, 'LineWidth',3)          % plot Zr
    title("Zr")
    legend('Displacement [m]','Location', 'SouthEast')
    xlabel('time')
    ylabel('Displacement')
    grid on

end


%% Q4/ Model validation 
% 1 - validation data output vs model output
const = 0;        % assign the switch threshold to get the required input
data = readtable("PMS Exam - Quarter Car.xlsx");        % import data from the spreadsheet
% assign table columns to variables
time = data.Time;
zr = data.RoadDisplacement_m_;
ddot_zs = data.SprungMassAcceleration_m_s2_;
zs = data.SprungMassDisplacement_m_;
zus = data.UnsprungMassDisplacement_m_;
% plot the validation data
figure('Name',"Validation_data", "NumberTitle","off")     % create a figure with custom name
tiledlayout(2,2,"TileSpacing","compact", "Padding","compact")    % use tiledlayout to have all the output variables plots in one figure
nexttile
plot(time,zr)
title("Zr")
legend('displcement [m]', 'Location','southeast')
xlabel('time')
ylabel('Displacement')
grid on
nexttile
plot(time, ddot_zs) 
title("ddot Zs")
legend('Acceleration [m/s^2]')
xlabel('time')
ylabel('Acceleration')
grid on
nexttile
plot(time, zus) 
title("Zus")
legend('displcement [m]',"Location","southeast")
xlabel('time')
ylabel('Displacement')
grid on
nexttile
plot(time, zs)   
title("Zs")
legend('Displacement [m]')
xlabel('time')
ylabel('Displacement')
grid on
% filter the data using the moving average filter and run the model with
% the filtered data as input
zs = smooth(zs);
zus = smooth(zus);
time = seconds(time);
simin = timetable(time, zr);
sim("Home_exam_retake_sim")
% plot the validation data next to the model output
figure("Name","Validation vs Model","NumberTitle","off")
tiledlayout(3,1,"TileSpacing","compact","Padding","compact")
nexttile
plot(time,ddot_zs)   
hold on
plot(ans.tout, ans.ddot_Zs)   
title("ddot Zs")
legend('Validation acceleration [m/s^2]', "Model acceleration [m/s^2]", 'Location','southeast')
xlabel('time')
ylabel('Acceleration')
grid on
hold off
nexttile
plot(time,zs)   
hold on
plot(ans.tout, ans.Zs)   
title("Zs")
legend('Validation displacement [m]', "Model displacement [m]", 'Location','southeast')
xlabel('time')
ylabel('Displacement')
grid on
hold off
nexttile
plot(time,zus)   
hold on
plot(ans.tout, ans.Zus)
title("Zus")
legend('Validation displacement [m]', "Model displacement [m]", 'Location','southeast')
xlabel('time')
ylabel('Displacement')
grid on
hold off

% 2 - sensitivity analysis
% create arrays of the parameters values for each scenario of the
% sensitivity analysis.
Msprung_array = [247.5 (350+750)/4 275 275 275]; %kg
Munsprung_array = [15 13.5 15 15 15]; %kg;
Ks_array = [140000 140000 126000 140000 140000]; %N/m;
Kt_array = [300000 300000 300000 270000 300000]; %N/m;
Bt_array = [5000 5000 5000 5000 5500]; %Ns/m;

for test = 1:5                    % a for loop to run the sensitivity test
    Msprung = Msprung_array(test);
    Munsprung = Munsprung_array(test);
    Ks = Ks_array(test);
    Kt = Kt_array(test);
    Bt = Bt_array(test);
    sim("Home_exam_retake_sim")
    figure('Name',"Sensitivity_test"+test, "NumberTitle","off")     % create a figure with custom name
    tiledlayout(2,2,"TileSpacing","compact", "Padding","compact")    % use tiledlayout to have all the output variables plots in one figure
    nexttile
    plot(ans.tout,ans.Zs)
    title("Zs")
    legend('displcement [m]', 'Location','southeast')
    xlabel('time')
    ylabel('Displacement')
    grid on
    nexttile
    plot(ans.tout, ans.ddot_Zs) 
    title("ddot Zs")
    legend('Acceleration [m/s^2]')
    xlabel('time')
    ylabel('Acceleration')
    grid on
    nexttile
    plot(ans.tout, ans.Zus) 
    title("Zus")
    legend('displcement [m]',"Location","southeast")
    xlabel('time')
    ylabel('Displacement')
    grid on
    nexttile
    plot(ans.tout, ans.ddot_Zus)   
    title("ddot Zus")
    legend('Displacement [m]')
    xlabel('time')
    ylabel('Displacement')
    grid on
end


%% Q5/ State-space representation

format long           % set the format of the numbers to "long" instead of "double"
[A_m B_m C_m D_m] = linmod('Home_exam_retake_sim');      % find the state-space representation of the simulated model
sim("Home_exam_retake_sim")
figure('Name',"State space", "NumberTitle","off")     % create a figure with custom name
tiledlayout(2,1,"TileSpacing","compact", "Padding","compact")
nexttile
plot(time, ans.state_s)   
title("state space Zs")
legend('Displacement[m]')
xlabel('time')
ylabel('Displacement')
grid on
nexttile
plot(time, ans.Zs)   
title("differential equation Zs")
legend('Displacement[m]')
xlabel('time')
ylabel('Displacement')
grid on


%% Q6/ Transfer function

clear numm denum
[b a] = ss2tf(A_m,B_m,C_m,D_m);         % get the transfer function of the model from the state-space representation.
numm = [b];
denum = [a];
sim("Home_exam_retake_sim")
figure('Name',"Transfer function", "NumberTitle","off")     % create a figure with custom name
tiledlayout(3,1,"TileSpacing","compact", "Padding","compact")
nexttile
plot(time, ans.transfer_f)                             % plot the transfer function output
title("transfer function Zs")
legend('Displacement[m]')
xlabel('time')
ylabel('Displacement')
grid on
nexttile
plot(time, ans.state_s)                              % plot the state space output
title("state space Zs")
legend('Displacement[m]')
xlabel('time')
ylabel('Displacement')
grid on
nexttile
plot(time, ans.Zs)                                  % plot the differential equation output
title("differential equation Zs")
legend('Displacement[m]')
xlabel('time')
ylabel('Displacement')
grid on
