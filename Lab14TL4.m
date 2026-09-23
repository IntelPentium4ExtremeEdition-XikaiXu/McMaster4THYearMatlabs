clear;
close all;
clc;


% Exercise 1
% Define the sinusoidal signal using an anonymous function
x = @(t, f, theta, A) A * cos(2*pi*f*t + theta);

Fs = 100;                  % Sampling frequency: 100 Hz
t = 0 : 1/Fs : 0.5;       % Sampling times from 0 to 0.5 seconds
n = 0 : length(t)-1;      % Sample numbers: 0, 1, ..., 50

Matrix = [
    5, 10, 0;
    5, 25, 0;
    5, 40, 0;
    5, 60, 0;
    5, 40, pi/2;
    5, 60, pi/2
];

figure;

for i = 1:size(Matrix, 1)

    % Extract parameters from row i
    A = Matrix(i, 1);
    f = Matrix(i, 2);
    theta = Matrix(i, 3);

    % Generate samples of the sinusoidal signal
    xn = x(t, f, theta, A);

    % Select one position in a 3-by-2 figure
    subplot(3, 2, i);

    % Plot x[n] against sample number n
    stem(n, xn, 'filled');

    % Label the plot
    xlabel('Sample Number n');
    ylabel('Amplitude x[n]');

    title(sprintf('Case %c: A = %.0f, f = %.0f Hz, φ = %.2f rad', ...
        char('A' + i - 1), A, f, theta));
    grid on;
end

%% Exercise 2: Unit impulses and unit steps

clear;
close all;
clc;

% Sample range
n = 1:30;

% Define the unit impulse and unit step functions
delta = @(n) double(n == 0);
unitstep = @(n) double(n >= 0);

% Exercise 2(a)
ydelta = delta(n - 16);        % delta[n - 16]
yunit = unitstep(n - 12);      % u[n - 12]

% Exercise 2(b)
x1 = unitstep(n - 14) - unitstep(n - 15);

% Exercise 2(c)
x2 = unitstep(n - 9) - unitstep(n - 16);

% Create plots
figure;

subplot(2, 2, 1);
stem(n, ydelta, "filled");
xlabel("Sample Number n");
ylabel("\delta[n-16]");
title("Unit Impulse \delta[n-16]");
grid on;
xlim([1 30]);
ylim([-0.1 1.2]);

subplot(2, 2, 2);
stem(n, yunit, "filled");
xlabel("Sample Number n");
ylabel("u[n-12]");
title("Unit Step u[n-12]");
grid on;
xlim([1 30]);
ylim([-0.1 1.2])

%% Exercise 3: Complex signals

% Parameters
A = 1;
omega = pi/10;
n = 1:40;

% Generate the complex-valued signal
x_complex = A * exp(1j * omega * n);

%% Exercise 3(a): Complex-plane plot

figure;

plot(real(x_complex), imag(x_complex), "o-");

xlabel("Real Part, Re\{x[n]\}");
ylabel("Imaginary Part, Im\{x[n]\}");
title("Complex-Plane Plot of x[n] = Ae^{j\omega n}");

grid on;
axis equal;

%% Exercise 3(b): Real and imaginary parts

figure;

subplot(2, 1, 1);
stem(n, real(x_complex), "filled");
xlabel("Sample Number n");
ylabel("Re\{x[n]\}");
title("Real Part of x[n]");
grid on;

subplot(2, 1, 2);
stem(n, imag(x_complex), "filled");
xlabel("Sample Number n");
ylabel("Im\{x[n]\}");
title("Imaginary Part of x[n]");
grid on;

sgtitle("Exercise 3(b): Real and Imaginary Parts");

% Exercise 3(c): Magnitude and phase

magnitude = abs(x_complex);
wrapped_phase = angle(x_complex);
unwrapped_phase = unwrap(wrapped_phase);

figure;

subplot(2, 1, 1);
stem(n, magnitude, "filled");
xlabel("Sample Number n");
ylabel("|x[n]|");
title("Magnitude of x[n]");
grid on;
ylim([0 1.2]);

subplot(2, 1, 2);
stem(n, unwrapped_phase, "filled");
xlabel("Sample Number n");
ylabel("Phase (rad)");
title("Unwrapped Phase of x[n]");
grid on;

sgtitle("Exercise 3(c): Magnitude and Phase");


%% Final Experiment
% Part A: Read the audio file
[MusicY, Musicfs] = audioread('defineit.wav');

% If the audio is stereo, convert it to mono
if size(MusicY, 2) > 1
MusicY = mean(MusicY, 2);
end

% Create the time axis
audioTime = (0:length(MusicY)-1) / Musicfs;

figure;

subplot(2, 1, 1);
plot(audioTime, MusicY);
xlabel("Time (s)");
ylabel("Amplitude");
title("Original Speech Waveform");
grid on;

subplot(2, 1, 2);
histogram(MusicY, 50);
xlabel("Amplitude");
ylabel("Number of Samples");
title("Histogram of Original Speech Signal");
grid on;

% Display audio information

info = audioinfo('defineit.wav');
disp(info);

% Part C: Listen to the original signal

soundsc(MusicY, Musicfs);

% Optional pause so the next audio does not immediately interrupt it
pause(length(MusicY) / Musicfs + 1);


peakAmplitude = max(abs(MusicY));

if peakAmplitude == 0
y_scaled = MusicY;
else
y_scaled = MusicY / peakAmplitude;
end


numberOfBits = 3;
numLevels = 2^numberOfBits;

% Quantization step size for the interval [-1, 1]
deltaQ = 2 / numLevels;

% Apply rounding quantization
y3bit = deltaQ * round(y_scaled / deltaQ);

y3bit(y3bit > 1) = 1;
y3bit(y3bit < -1) = -1;


e = y_scaled - y3bit;


figure;
subplot(2, 2, 1);
plot(audioTime, y_scaled);
xlabel("Time (s)");
ylabel("Amplitude");
title("Scaled Speech Signal");
grid on;

subplot(2, 2, 2);
histogram(y_scaled, 50);
xlabel("Amplitude");
ylabel("Number of Samples");
title("Histogram of Scaled Speech Signal");
grid on;

subplot(2, 2, 3);
plot(audioTime, y3bit);
xlabel("Time (s)");
ylabel("Quantized Amplitude");
title("3-Bit Quantized Speech Signal");
grid on;

subplot(2, 2, 4);
histogram(y3bit, 50);
xlabel("Quantized Amplitude");
ylabel("Number of Samples");
title("Histogram of 3-Bit Quantized Signal");
grid on;

figure;
subplot(2, 1, 1);
plot(audioTime, e);
xlabel("Time (s)");
ylabel("Error");
title("Quantization Error: e = y_{scaled} - y_{3bit}");
grid on;

subplot(2, 1, 2);
histogram(e, 50);
xlabel("Quantization Error");
ylabel("Number of Samples");
title("Histogram of Quantization Error");
grid on;

soundsc(y3bit, Musicfs);

% Part G: Peak clipping experiment

% Deliberately amplify the scaled signal so that many samples exceed
% the quantizer input range [-1, 1]
clippingGain = 4;
y_pclip = clippingGain * y_scaled;

% Apply the same 3-bit rounding quantizer
y3bit_pclip = deltaQ * round(y_pclip / deltaQ);

% Saturate the quantizer output to the range [-1, 1]
y3bit_pclip(y3bit_pclip > 1) = 1;
y3bit_pclip(y3bit_pclip < -1) = -1;

% Calculate the peak-clipping quantization error
e_pclip = y_pclip - y3bit_pclip;

% Find the samples that exceed the quantizer range
clippedSamples = abs(y_pclip) > 1;
numberOfClippedSamples = sum(clippedSamples);
clippedPercentage = 100 * numberOfClippedSamples / length(y_pclip);

fprintf("Clipping gain: %.1f\n", clippingGain);
fprintf("Number of clipped samples: %d\n", numberOfClippedSamples);
fprintf("Percentage of clipped samples: %.2f%%\n", clippedPercentage);

% Plot the over-scaled and clipped signals

figure;

subplot(2, 2, 1);
plot(audioTime, y_pclip);
hold on;
yline(1, "r--", "Upper Limit");
yline(-1, "r--", "Lower Limit");
hold off;

xlabel("Time (s)");
ylabel("Amplitude");
title("Over-Scaled Speech Signal y_{pclip}");
grid on;

subplot(2, 2, 2);
histogram(y_pclip, 50);
hold on;
xline(1, "r--", "Upper Limit");
xline(-1, "r--", "Lower Limit");
hold off;

xlabel("Amplitude");
ylabel("Number of Samples");
title("Histogram of y_{pclip}");
grid on;

subplot(2, 2, 3);
plot(audioTime, y3bit_pclip);
xlabel("Time (s)");
ylabel("Quantized Amplitude");
title("3-Bit Peak-Clipped Quantized Signal");
grid on;
ylim([-1.2 1.2]);

subplot(2, 2, 4);
histogram(y3bit_pclip, 50);
xlabel("Quantized Amplitude");
ylabel("Number of Samples");
title("Histogram of Peak-Clipped Quantized Signal");
grid on;

sgtitle("Part G: Peak-Clipping Experiment");

% Plot the peak-clipping error

figure;

subplot(2, 1, 1);
plot(audioTime, e_pclip);
xlabel("Time (s)");
ylabel("Error");
title("Peak-Clipping Error");
grid on;

subplot(2, 1, 2);
histogram(e_pclip, 50);
xlabel("Error");
ylabel("Number of Samples");
title("Histogram of Peak-Clipping Error");
grid on;

sgtitle("Part G: Error After Peak Clipping");
% Listen to the peak-clipped quantized signal
soundsc(y3bit_pclip, Musicfs);