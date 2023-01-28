declare
   l_sql_query varchar2(4000);
   l_columns   apex_exec.t_columns;
   l_context   apex_exec.t_context;
begin
   --If you are using it outside of APEX, you must create a session.
   apex_session.create_session(
      p_app_id   => APP_ID,
      p_page_id  => PAGE_ID,
      p_username => 'MY_USER'
   );
   
   l_sql_query := 'select * from emp';
   
   -- Open the context
   l_context := apex_exec.open_query_context(
                   p_location   => apex_exec.c_location_local_db,
                   p_sql_query  => l_sql_query
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
      
      --If used outside of APEX you have to delete the created session
      apex_session.delete_session(v('APP_SESSION'));
      
      raise;
end;