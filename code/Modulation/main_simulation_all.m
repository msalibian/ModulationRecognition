% Main script that simulates the six modulation formats: OOK, BPSK, OQPSK, 
% BFSK-A, BFSK-B, and BFSK-R2.

clear;

% Path to reference the scripts that run simulations.
addpath('C:/Users/Ken/Documents/GitHub/MSC_Project/code/Modulation')

% Data output directory for modulation data.
out_dir = 'C:/Users/Ken/Documents/GitHub/MSC_Project/data/Modulation';

% Observation window size.
N = 512;

% Number of observations per modulation and SNR.
% Change variable P to simulate for either training or testing data.
% P = 200; % for train data
% P = 1100; % for test data
% Put the two values into an array and loop through both values.
Parr = [200, 1100];

% Choose a range of signal-to-noise ratio.
snrdB_vec = -32:2:16;

% Indicate number of columns in total:
%	This variable helps index the columns when inserting values in the matrix 
%	containing the data.
%	A breakdown of the number of columns that amounts to 138:
%		Column 1: SNR
%		Columns 2-137: Feature variables
%		Column 138: Modulation Type (encoded as 1 to 6 <--> OOK, BPSK, ... BFSK-R2).
nX = 138;

for i=1:2
    P = Parr(i);
    % Individually call each function that sets up the parameters 
    % to simulate each modulation format.
    ook_config_wrapper(out_dir, N, P, snrdB_vec, nX);
    bpsk_config_wrapper(out_dir, N, P, snrdB_vec, nX);
    oqpsk_config_wrapper(out_dir, N, P, snrdB_vec, nX);
    bfskA_config_wrapper(out_dir, N, P, snrdB_vec, nX);
    bfskB_config_wrapper(out_dir, N, P, snrdB_vec, nX);
    bfskR2_config_wrapper(out_dir, N, P, snrdB_vec, nX);
end

