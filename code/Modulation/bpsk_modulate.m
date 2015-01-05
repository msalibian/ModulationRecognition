function [xn_noise_if, sigpow, nn, xn_noise_if_cmpx] = bpsk_modulate(n, fs, sps, fif, dsss, sd, norm_factor)
	%symbol to chip mapping in IEEE 802.15.4
	pn(:,1) = [1 1 1 1 0 1 0 1 1 0 0 1 0 0 0]';
	pn(:,2) = [0 0 0 0 1 0 1 0 0 1 1 0 1 1 1]';

	%generate symbols
	data = randi([0 1], n, 1);
	%spreading by mapping symbols to chip
	data_dsss = arrayfun(@(x) pn(:,x+1), data, ...
'UniformOutput', false);

	%new input sequence for bpsk modulation
	data_dsss = cell2mat(data_dsss);
	
	%create modulator system object
	hMod = comm.BPSKModulator;
	%modulate bpsk signal with random sequence
	modData = step(hMod, data_dsss);
	
	%filter span in symbols, default is 10
	%filtSpanInSymbols = 10;
	filtSpanInSymbols = 25;
	%alpha as indicated in the paper
	rolloff = 1;
	%create raised cosine receive filter system object
	hTxFilter = comm.RaisedCosineTransmitFilter(...
	'RolloffFactor', rolloff, ...
	'FilterSpanInSymbols', filtSpanInSymbols, ...
	'OutputSamplesPerSymbol', sps, ...
	'Shape', 'Normal'); 

	%modulate bpsk signal with raised cosine filter	
	xn = step(hTxFilter, modData);

	%build time sequence
	t = 0:1/fs:(length(xn)/fs-1/fs);
	%transpose time sequence to obtain column vector
	t = t';
	
	xn_if_cmpx = xn.*exp(i*2*pi*(fif*t+rand(1))).*sqrt(norm_factor);
	
	xn_if = real(xn_if_cmpx);
	
	%generate noise sequence
	nn = sd*randn(length(xn_if),1);
	
	%add noise to received signal
	xn_noise_if = xn_if + nn;
	%calculate signal power for this sample
	%sigpow = mean(xn_if.^2);
	sigpow = mean((imag(xn_if_cmpx)).^2);
	
	nn_cmpx = sd*sqrt(-1)*randn(length(xn_if), 1);
	
	xn_noise_if_cmpx = xn_if_cmpx + nn + nn_cmpx;
	
	if ~all(real(xn_noise_if_cmpx) == xn_noise_if)
		error('bpsk complex and real received signals differ')
	end
	
end
	
	
	