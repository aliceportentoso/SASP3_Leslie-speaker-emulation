% SSSP Homework 1
% students and students code:
% Chiara Lunghi     233195
% Alice Portentoso  232985

function [y,y_lpf,y_hpf,y_hp_sdf] = leslie(x, Fs, freq)
%Leslie Speaker Emulation
%
% J. Pekonen et al. Computationally Efficient Hammond Organ Synthesis
% in Proc. of the 14th International Conference on Digital Audio
% Effects(DAFx-11), Paris, France, Sept. 19-23, 2011

% length of the input signal
N = length(x);

% global modulator parameters
alpha=0.9;
% tremble spectral delay filter parameter 
Ms_t=0.2;
Mb_t=-0.75;
N_sdf_t=4;
% bass spectral delay filter parameter 
Ms_b=0.04;
Mb_b=-0.92;
N_sdf_b=3;
% buffer
buffer_b=N_sdf_b+1;
buffer_h=N_sdf_t+1;

% cross-over network design
% cutoff frequency
fc = 800;

[b_lp, a_lp] = butter(4, fc*2/Fs, 'low'); %LPF design
[b_hp, a_hp] = butter(4, fc*2/Fs, 'high');  %HPF desigbn

% allocate input and output buffers for IIR filters
% hp filter buffers (order 4)
hpf.state=zeros(4,1);    
hpf.in=zeros(4,1);
% lp filter buffers
lpf.state=zeros(4,1);
lpf.in=zeros(4,1);
% treble sdf filter buffers
sdf_h.state=zeros(N_sdf_t+1,1); 
sdf_h.in=zeros(N_sdf_t+1,1); 
% bass sdf filter buffers
sdf_b.state=zeros(N_sdf_b+1,1); 
sdf_b.in=zeros(N_sdf_b+1,1); 

% modulators 
t=1:N;
m_b=Ms_b*sin(2*pi*freq*t/Fs)+Mb_b;          % bass modulator
m_t=Ms_t*sin(2*pi*(freq+0.1)*t/Fs)+Mb_t;    % tremble modulator

% initializations
y_lp_sdf=zeros(N,1);
y_hp_sdf=zeros(N,1);

y_lpf=zeros(1,N);
y_hpf=zeros(1,N);

y_lp_am=zeros(1,N);
y_hp_am=zeros(1,N);

y = zeros(1,N);

% sample processing
for n=1:N
    
    % compute crossover network filters outputs
    y_lpf(n) = b_lp(1)*x(n) + lpf.state(4);
    lpf.in(1) = b_lp(5)*x(n) - a_lp(5)*y_lpf(n);
    lpf.in(2) = b_lp(4)*x(n)  + lpf.state(1) - a_lp(4)*y_lpf(n);
    lpf.in(3) = b_lp(3)*x(n)  + lpf.state(2) - a_lp(3)*y_lpf(n);
    lpf.in(4) = b_lp(2)*x(n)  + lpf.state(3) - a_lp(2)*y_lpf(n);
    lpf.state=lpf.in;

    y_hpf(n) = b_hp(1)*x(n) + hpf.state(4);
    hpf.in(1) = b_hp(5)*x(n) - a_hp(5)*y_hpf(n);
    hpf.in(2) = b_hp(4)*x(n)  + hpf.state(1) - a_hp(4)*y_hpf(n);
    hpf.in(3) = b_hp(3)*x(n)  + hpf.state(2) - a_hp(3)*y_hpf(n);
    hpf.in(4) = b_hp(2)*x(n)  + hpf.state(3) - a_hp(2)*y_hpf(n);
    hpf.state=hpf.in;

    % compute bass SDF output
    sdf_b.in(end)=y_lpf(n);
    for i=0:N_sdf_b 
        y_lp_sdf(n)=y_lp_sdf(n)+nchoosek(N_sdf_b,i)*m_b(n)^i*(sdf_b.in(i+1)-sdf_b.state(buffer_b-i)); 
    end
    sdf_b.state(end)=y_lp_sdf(n);
    sdf_b.state=circshift(sdf_b.state,-1);
    sdf_b.in=circshift(sdf_b.in,-1);
    sdf_b.state(end)=0;

    % compute treble SDF output
    sdf_h.in(end)=y_hpf(n);
    for i=0:N_sdf_t 
        y_hp_sdf(n)=y_hp_sdf(n)+nchoosek(N_sdf_t,i)*m_t(n)^i*(sdf_h.in(i+1)-sdf_h.state(buffer_h-i));
    end
    sdf_h.state(end)=y_hp_sdf(n);
    sdf_h.state=circshift(sdf_h.state,-1);
    sdf_h.in=circshift(sdf_h.in,-1);
    sdf_h.state(end)=0;
   
    % implement AM modulation blocks
    y_lp_am(n)=y_lp_sdf(n)*(1+alpha*m_b(n));
    y_hp_am(n)=y_hp_sdf(n)*(1+alpha*m_t(n));

    y(n)=y_lp_am(n)+y_hp_am(n);
    
end

