% speed test for constraints

clc;
clear all;
close all;

X = ones(42,1);

[cEq, cIn] = Constraints(X);
