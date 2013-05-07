
% Demo 1: Visualize a sequence.
%
% Author: Sebastian Nowozin <Sebastian.Nowozin@microsoft.com>

disp(['Visualizing sequence P1_1_1_p06']);

[X,Y,tagset]=load_file('P3_2_8_p02', 0);
T=size(X,1);	% Length of sequence in frames
x = reshape(X, T, 4, 20)
% Animate sequence
h=axes;
%for ti=1:T
for ti = 150:210
	skel_vis(X,ti,h);
	drawnow;
  if Y(ti) > 0
    disp(Y(ti))
  end
	pause(1/30);
	cla;
end

