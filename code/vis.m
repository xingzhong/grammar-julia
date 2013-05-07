[X,Y,tagset]=load_file('P3_2_8_p02', 0);
T=size(X,1);	% Length of sequence in frames
x = reshape(X, T, 4, 20);
subplot(2,1,1)
plot(x(150:200, 1, 7), x(150:200,2,7), '->')
x = diff(x(150:200, 1:2, 7));
[idx,ctrs] = kmeans(x,4)

subplot(2,1,2)
%plot( x(:,1,7), x(:,2,:), '->' )
%hold on
plot(x(idx==1,1),x(idx==1,2),'r.','MarkerSize',12)
hold on
plot(x(idx==2,1),x(idx==2,2),'b.','MarkerSize',12)
hold on
plot(x(idx==3,1),x(idx==3,2),'k.','MarkerSize',12)
hold on
plot(x(idx==4,1),x(idx==4,2),'g.','MarkerSize',12)
hold on
plot(ctrs(:,1),ctrs(:,2),'kx',...
     'MarkerSize',12,'LineWidth',2)

grid on
xlabel('x')
ylabel('y')
