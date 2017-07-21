%% Setup
clear;
addpath(fullfile(pwd,'../'));
%rng('default')

%% Parameters
run parameters

%% Script
print = 1;
repeat = 10;
[ mean_total, totals  ] = simulate_policy( params.optimal_policy, params, print, repeat );