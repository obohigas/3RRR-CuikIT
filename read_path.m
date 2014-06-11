function path = read_path(filename)
% This function only returns those variables that will be supplied by the
% controller, namely: t1 t2 t3 and relative p1 p2 p3 (not absolute!)

fid2 = fopen([filename '.samples'],'r');
tline = fgetl(fid2);
while isempty(tline)
    tline = fgetl(fid2);
end
ii = regexp(tline,' ');
t1 = str2num( tline(ii(2):ii(3)) );
t2 = str2num( tline(ii(3):ii(4)) );
t3 = str2num( tline(ii(4):ii(5)) );
p1 = str2num( tline(ii(5):ii(6)) ) - t1;
p2 = str2num( tline(ii(6):ii(7)) ) - t2;
p3 = str2num( tline(ii(7):ii(8)) ) - t3;
path = [t1 t2 t3 p1 p2 p3]'; % start
%tline = fgetl(fid2);
%while isempty(tline)
%    tline = fgetl(fid2);
%end
%ii = regexp(tline,' ');
%t1 = str2num( tline(ii(2):ii(3)) );
%t2 = str2num( tline(ii(3):ii(4)) );
%t3 = str2num( tline(ii(4):ii(5)) );
%p1 = str2num( tline(ii(5):ii(6)) ) - t1;
%p2 = str2num( tline(ii(6):ii(7)) ) - t2;
%p3 = str2num( tline(ii(7):ii(8)) ) - t3;
%goal = [t1 t2 t3 p1 p2 p3]'; % goal

fid1 = fopen([filename '_path.sol'],'r');
N = str2num(fgetl(fid1));

for i=1:N-1
    tline = fgetl(fid1);
    ii = regexp(tline,' ');
    t1 = str2num( tline(ii(2):ii(3)) );
    t2 = str2num( tline(ii(3):ii(4)) );
    t3 = str2num( tline(ii(4):ii(5)) );
    p1 = str2num( tline(ii(5):ii(6)) ) - t1;
    p2 = str2num( tline(ii(6):ii(7)) ) - t2;
    p3 = str2num( tline(ii(7):ii(8)) ) - t3;
    conf = [t1 t2 t3 p1 p2 p3]';
    path = [path conf];
end

%path = [path goal];

fclose(fid1);
fclose(fid2);


