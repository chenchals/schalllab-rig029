fn = 'EVENTDEF.PRO';

content = fileread(fn);

tokens = regexp(content,'constant\s+([A-Z]\w*)\s*=\s*(\d{1,4});','tokens');
tokens = [tokens{:}];
tokens = reshape(tokens,[2,numel(tokens)/2])';

tokensTbl = cell2table(tokens);

tokensTbl.col3 =  cellfun(@str2num,tokensTbl{:,2});
sortedTbl = sortrows(tokensTbl,'col3');

fo = fopen('eventDefSorted.pro','w');
for ii=1:size(sortedTbl,1)
    line = join(['declare constant ', sortedTbl{ii,1}, ' = ' sortedTbl{ii,2}, ';'],'');
    line
    fprintf(fo,'%s\n',char(line))
end