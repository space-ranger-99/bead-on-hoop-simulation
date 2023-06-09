% BEAD_ON_HOOP_SIMULATION simulates the dynamics of a bead on a rotating
% hoop.
%
% This script demonstrates the dynamics of a bead constrained to move on a
% rotating hoop, subject to gravity. It defines the system parameters,
% solves the bead-on-hoop dynamics, and plots the results for the angle of
% the bead and the Hamiltonian over time.
%
% The script consists of the following main functions:
%   - init_params: Initializes the system parameters.
%   - solve_dynamics: Solves the bead-on-hoop dynamics using the ode45
%   solver.
%   - bead_on_hoop_dynamics: Calculates the bead-on-hoop dynamics based on
%   the system parameters.
%   - plot_and_save_results: Plots and saves the simulation results.
%
% Usage:
%   bead_on_hoop_simulation()
%
% See also: ode45
%
% Author: Alexander Little
% Affiliation: Toronto Metropolitan University

function bead_on_hoop_simulation()
    params = init_params();
    [t, y] = solve_dynamics(params);
    plot_and_save_results(t, y, params);
end

% Initialize system parameters
function params = init_params()
    params = struct('bead_mass', 1, 'hoop_radius', 1, ... 
        'hoop_angular_velocity', 1, 'gravitational_acceleration', -9.81);
end

% Solve the bead on hoop dynamics
function [t, y] = solve_dynamics(params)
    y0 = [pi / 4; 0];
    tspan = [0 20];
    options = odeset('RelTol', 1e-12, 'AbsTol', 1e-15);
    [t, y] = ode45(@(t, y) bead_on_hoop_dynamics(t, y, params), tspan, ... 
        y0, options);
end

% Calculate the bead on hoop dynamics
function dydt = bead_on_hoop_dynamics(~, y, params)
    bead_angle = y(1);
    bead_momentum = y(2);

    bead_angle_rate = bead_momentum / (params.bead_mass * ... 
        params.hoop_radius ^ 2);
    
    bead_momentum_rate = params.bead_mass * ... 
        params.gravitational_acceleration * params.hoop_radius * ... 
        sin(bead_angle) - params.bead_mass * params.hoop_radius ^ 2 * ... 
        params.hoop_angular_velocity ^ 2 * cos(bead_angle) * ... 
        sin(bead_angle);

    dydt = [bead_angle_rate; bead_momentum_rate];
end

% Plot and save the simulation results
function plot_and_save_results(t, y, params)
    figure;
    subplot(2, 1, 1);
    plot(t, y(:, 1));
    xlabel('Time (s)');
    ylabel('Bead Angle (rad)');
    title('Time History of Bead Angle');

    subplot(2, 1, 2);
    hamiltonian = y(:, 2) .^ 2 ./ (2 * params.bead_mass * ... 
        params.hoop_radius ^ 2) + (1/2) * params.bead_mass * ... 
        params.hoop_radius ^ 2 * params.hoop_angular_velocity ^ 2 * ... 
        (sin(y(:, 1))) .^ 2 - params.bead_mass * ... 
        params.gravitational_acceleration * params.hoop_radius * (1 - ... 
        cos(y(:, 1)));
    plot(t, hamiltonian);
    xlabel('Time (s)');
    ylabel('Hamiltonian');
    title('Time History of Hamiltonian');

    saveas(gcf, 'bead_on_hoop_simulation_results', 'png');
end
