declare
   l_columns   apex_exec.t_columns;
   l_filters   apex_exec.t_filters;
   l_order_bys apex_exec.t_order_bys;
   l_context   apex_exec.t_context;
begin
   --If you are using it outside of APEX, you must create a session.
   apex_session.create_session(
      p_app_id   => APP_ID,
      p_page_id  => PAGE_ID,
      p_username => 'MY_USER'
   );
   
   -- Add filter by JOB and SAL
   -- Only the MANAGER
   apex_exec.add_filter(
      p_filters     => l_filters,
      p_filter_type => apex_exec.c_filter_eq,
      p_column_name => 'JOB',
      p_value       => 'MANAGER' 
   );
   --Which has a salary greater or equals to 2500$
   apex_exec.add_filter(
      p_filters     => l_filters,
      p_filter_type => apex_exec.c_filter_gte,
      p_column_name => 'SAL',
      p_value       => 2500 
   );
   
   --Ordering the results by descending HIREDATE 
   apex_exec.add_order_by(
      p_order_bys     => l_order_bys,
      p_column_name   => 'HIREDATE',
      p_direction     => apex_exec.c_order_desc 
   );
   
   -- Open the context
   l_context := apex_exec.open_query_context(
                   p_location   => apex_exec.c_location_local_db,
                   p_table_name => 'EMP',
                   p_filters    => l_filters,
                   p_order_bys  => l_order_bys
                );

   -- Loop through the results
   while apex_exec.next_row(l_context)
   loop
      -- Get the column ENAME value
      sys.dbms_output.put_line(
         apex_exec.get_varchar2(
            p_context     => l_context,
            p_column_name => 'ENAME'
         )
      );
   end loop;

   -- Close the context
   apex_exec.close(l_context);
   
   --If you are using it outside of APEX, you have to delete the created session
   apex_session.delete_session(v('APP_SESSION'));
   
   return;
exception
   when others then
      apex_exec.close(l_context);
      
      --If you are using it outside of APEX, you have to delete the created session
      apex_session.delete_session(v('APP_SESSION'));
      
      raise;
end;