with Ada.Integer_Text_IO,
     Ada.Text_IO,
     Constraint_Engine;

use  Ada.Integer_Text_IO, Ada.Text_IO;

procedure Example is

   package Test_Engine is new Constraint_Engine(Nb_Var => 2,
                                                Nb_Ctr => 2);
   use Test_Engine;

   P : Type_Problem;
   S : Type_Array_Variable;

begin

   P.Add_Var(Low_Interval => 0,
             Top_Interval => 400);

   P.Add_Var(Low_Interval => 0,
             Top_Interval => 500);

   P.Add_Constraint_Var(V1_Position => 1,
                        Rel         => IS_MORE,
                        V2_Position => 2);

   P.Add_Constraint_Int(V1_Position => 1,
                        Rel         => IS_MORE,
                        V           => 150);

   P := P.Find_Solution;
   S := P.Get_Var;

   Put("Solution : ");
   for Cursor in S'Range loop
      Put( Integer'Image(S(Cursor).Curr_Solution) & ", ");
   end loop;
   New_Line;

end Example;
