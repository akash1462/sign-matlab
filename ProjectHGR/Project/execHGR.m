% Clear and Close Everything
close all
clear all;
clc;


% Sample Inputs
% input='Images/Inputs/sample/b_sample.jpg';
% input='Images/Inputs/sample/c_sample.jpg';
% input='Images/Inputs/sample/h_sample.jpg';
% input='Images/Inputs/sample/i_sample.jpg';
% input='Images/Inputs/sample/o_sample.jpg';
% input='Images/Inputs/sample/y_sample.jpg';
% input='Images/Inputs/sample/b_sample_green.jpg';
% input='Images/Inputs/sample/c_caglar.jpg';
% input='Images/Inputs/sample/a_caglar.jpg'; %No match exists for this
% input because there isn't any similar image in the database

% ----------------------------------------------------------------
% Recognize the Sample
input='Images/Inputs/sample/b_sample_green.jpg';
results=hgr(input);