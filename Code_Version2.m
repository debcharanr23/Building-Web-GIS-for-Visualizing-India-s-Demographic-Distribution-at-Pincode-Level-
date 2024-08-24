%% Code for data filteration:
% -----To know the no. of pin codes in each district
% Specify the path to your .csv file
file_path = 'Data_new.csv';

% Use readtable to read the .csv file
data_table = readtable(file_path, 'VariableNamingRule', 'preserve');

% Sort the table alphabetically based on column 8 (assuming the column is named 'Column_8')
sorted_table = sortrows(data_table, 10);

% Extract column 10 from the sorted table
column_10 = sorted_table(:, 10);

% Convert column 10 to a cell array
column_10_cell = table2cell(column_10);

% Convert cell array elements to strings
column_10_strings = string(column_10_cell);

% Get unique elements and their counts
[unique_elements,~,index] = unique(column_10_strings);
counts = accumarray(index, 1);

% Create a new table with unique elements and their corresponding counts
new_table = table(unique_elements, counts, 'VariableNames', {'Unique_Element', 'Frequency'});


% Specify the path to your .csv file
file_path = 'Population_data.csv';

% Use readtable to read the .csv file
data_table_popl = readtable(file_path, 'VariableNamingRule', 'preserve');

% Sort the table alphabetically based on column 8 (assuming the column is named 'Column_8')
sorted_table_popl = sortrows(data_table_popl, 1);

% Assuming table1 and table2 are your two tables

% Perform inner join based on column 1
common_rows = innerjoin(new_table, sorted_table_popl, 'Keys', 1);

% Specify the file path for saving the CSV file
output_file_path = 'common_rows.csv';

% Save the common_rows table as a CSV file
writetable(common_rows, output_file_path);

% Assuming your table is named 'my_table'
column_names = sorted_table.Properties.VariableNames;
% Access the name of the first column
first_column_name = column_names{10};
disp(first_column_name);

% Initialize an empty table for the results
result_table = table();

% Iterate over each element in the 1st column of the first table
for i = 1:size(common_rows, 1)
    % Get the district from the 1st column of the first table
    district = common_rows{i, 1};
    
    % Find rows in the second table where the district matches
    matching_rows = sorted_table(column_10_strings == district, :);
    
    % Add matching rows to the result table, repeating each row based on the number of matches
    for j = 1:size(matching_rows, 1)
        result_table = [result_table; matching_rows(j, :)];
    end
end

%########
% Convert the table to a numeric matrix
common_rows1 = table2array(common_rows);
C2 = common_rows1(:,2);
C5 = common_rows1(:,5);
C6 = common_rows1(:,6);
C7 = common_rows1(:,7);
C8 = common_rows1(:,8);

% Initialize an empty table to store the results
new_table = [];

% Iterate over each row in the original table
for i = 1:size(common_rows1)
    % Extract the values from the current row
    col2_value = double(C2(i));
    col5_value = double(C5(i));
    col6_value = double(C6(i));
    col7_value = double(C7(i));
    col8_value = double(C8(i));
    
    % Perform element-wise division
    new_col5_value = col5_value / col2_value;
    new_col6_value = col6_value / col2_value;
    new_col7_value = col7_value / col2_value;
    new_col8_value = col8_value / col2_value;

    
    % Append the results as a new row to the new table
    new_table = [new_table;common_rows1(i,1) common_rows1(i,2) common_rows1(i,3) common_rows1(i,4) new_col5_value new_col6_value new_col7_value new_col8_value ];

    %new_table = [new_table; {new_col5_value, new_col6_value, new_col7_value, new_col8_value}];
end

% Assuming the column variable names are stored in the 'Properties.VariableNames' property of the common_rows table
column_names = common_rows.Properties.VariableNames;

% Convert the matrix to a table
new_table = array2table(new_table, 'VariableNames', column_names);

% Extract the values from column 2 as double
col2_values = double(new_table{:, 2});

% Initialize an empty table for the results
Popl_fin = table();

% Iterate over each row in the common_rows table
for i = 1:size(col2_values)
    % Extract the current row
    current_row = new_table(i, :);
    
    % Get the number of times to repeat the row
    repeat_count = col2_values(i);
    
    % Repeat the current row and add it to the new table
    repeated_rows = repmat(current_row, repeat_count, 1);
    Popl_fin = [Popl_fin; repeated_rows];
end

% Extract columns 5, 6, 7, and 8 from Popl_fin
col5 = Popl_fin(:, 5);
col6 = Popl_fin(:, 6);
col7 = Popl_fin(:, 7);
col8 = Popl_fin(:, 8);

% Add the extracted columns to result_table
result_table_new = [result_table, col5, col6, col7, col8];

% Specify the file path for saving the CSV file
output_file_path = 'result_table_new.csv';

% Save the common_rows table as a CSV file
writetable(result_table_new, output_file_path);











