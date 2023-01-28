declare
   l_columns       apex_exec.t_columns;
   l_filters       apex_exec.t_filters;
   l_query_context apex_exec.t_context;
   l_dml_context   apex_exec.t_context;
begin
   -- If you are using it outside of APEX, you must create a session.
   apex_session.create_session(
      p_app_id   => APP_ID,
      p_page_id  => PAGE_ID,
      p_username => 'MY_USER'
   );
   
   -- Filtering on ENAME
   apex_exec.add_filter(
      p_filters     => l_filters,
      p_filter_type => apex_exec.c_filter_eq,
      p_column_name => 'ENAME',
      p_value       => 'LOUIS' 
   );
   
   -- Getting the record
   l_query_context := apex_exec.open_query_context(
                         p_location   => apex_exec.c_location_local_db,
                         p_table_name => 'EMP',
                         p_filters    => l_filters
                      );
   
   -- Declare the columns for DML
   apex_exec.add_column(
      p_columns        => l_columns,
      p_column_name    => 'EMPNO',
      p_data_type      => apex_exec.c_data_type_number,
      p_is_primary_key => true 
   );
   apex_exec.add_column(
      p_columns        => l_columns,
      p_column_name    => 'ENAME',
      p_data_type      => apex_exec.c_data_type_varchar2 
   );
   apex_exec.add_column(
      p_columns        => l_columns,
      p_column_name    => 'JOB',
      p_data_type      => apex_exec.c_data_type_varchar2 
   );
   apex_exec.add_column(
      p_columns        => l_columns,
      p_column_name    => 'HIREDATE',
      p_data_type      => apex_exec.c_data_type_date 
   );
   apex_exec.add_column(
      p_columns        => l_columns,
      p_column_name    => 'MGR',
      p_data_type      => apex_exec.c_data_type_number 
   );
   apex_exec.add_column(
      p_columns        => l_columns,
      p_column_name    => 'SAL',
      p_data_type      => apex_exec.c_data_type_number 
   );
   apex_exec.add_column(
      p_columns        => l_columns,
      p_column_name    => 'COMM',
      p_data_type      => apex_exec.c_data_type_number 
   );
   apex_exec.add_column(
      p_columns        => l_columns,
      p_column_name    => 'DEPTNO',
      p_data_type      => apex_exec.c_data_type_number 
   );
   
   -- Open the DML context
   l_dml_context := apex_exec.open_local_dml_context(
                      p_columns               => l_columns,
                      p_query_type            => apex_exec.c_query_type_table,
                      p_table_name            => 'EMP',
                      p_lost_update_detection => apex_exec.c_lost_update_none
                   );
   
   while apex_exec.next_row(l_query_context) loop
      -- Add data
      apex_exec.add_dml_row(
         p_context   => l_dml_context,
         p_operation => apex_exec.c_dml_operation_update 
      );
      
      apex_exec.set_values(
         p_context        => l_dml_context,
         p_source_context => l_query_context
      );
      
      apex_exec.set_value(
         p_context     => l_dml_context,
         p_column_name => 'SAL',
         p_value       => 500 * 10 
      );
   
   end loop;
   
   -- Execute the DML
   apex_exec.execute_dml(
      p_context           => l_dml_context,
      p_continue_on_error => false
   );
   
   -- Close the contexts
   apex_exec.close(l_dml_context);
   apex_exec.close(l_query_context);
   
   --If you are using it outside of APEX, you have to delete the created session
   apex_session.delete_session(v('APP_SESSION'));
   
   return;
exception
   when others then
      apex_exec.close(l_dml_context);
      apex_exec.close(l_query_context);
      
      --If used outside of APEX you have to delete the created session
      apex_session.delete_session(v('APP_SESSION'));
      
      raise;
end;