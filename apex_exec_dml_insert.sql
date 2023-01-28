declare
   l_columns   apex_exec.t_columns;
   l_context   apex_exec.t_context;
begin
   --If you are using it outside of APEX, you must create a session.
   apex_session.create_session(
      p_app_id   => APP_ID,
      p_page_id  => PAGE_ID,
      p_username => 'MY_USER'
   );
   
   -- Declare the columns
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
   l_context := apex_exec.open_local_dml_context(
                   p_columns => l_columns,
                   p_query_type => apex_exec.c_query_type_table,
                   p_table_name => 'EMP',
                   p_lost_update_detection => apex_exec.c_lost_update_none
                );
   
   -- Add data
   apex_exec.add_dml_row(
      p_context   => l_context,
      p_operation => apex_exec.c_dml_operation_insert 
   );
       
   apex_exec.set_value(
      p_context     => l_context,
      p_column_name => 'ENAME',
      p_value       => 'LOUIS' 
   );
   apex_exec.set_value(
      p_context     => l_context,
      p_column_name => 'JOB',
      p_value       => 'DEV' 
   );
   apex_exec.set_value(
      p_context     => l_context,
      p_column_name => 'MGR',
      p_value       => 7839 
   );
   apex_exec.set_value(
      p_context     => l_context,
      p_column_name => 'HIREDATE',
      p_value       => current_date 
   );
   apex_exec.set_value(
      p_context     => l_context,
      p_column_name => 'SAL',
      p_value       => 500 
   );
   apex_exec.set_value(
      p_context     => l_context,
      p_column_name => 'DEPTNO',
      p_value       => 10 
   );
   
   -- Execute the DML
   apex_exec.execute_dml(
      p_context           => l_context,
      p_continue_on_error => false
   );
   
   -- Close the context
   apex_exec.close(l_context);
   
   --If you are using it outside of APEX, you have to delete the created session
   apex_session.delete_session(v('APP_SESSION'));
   
   return;
exception
   when others then
      apex_exec.close(l_context);
      
      --If used outside of APEX you have to delete the created session
      apex_session.delete_session(v('APP_SESSION'));
      
      raise;
end;