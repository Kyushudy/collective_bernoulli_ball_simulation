f = load('optimization_record_2balloons_i`.txt');
e = f(:,end);
[mine,index] = min(e);
disp(mine);
disp(index);
format shorte
disp(f(index,:));