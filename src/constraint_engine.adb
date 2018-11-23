pragma Ada_2012;

with Ada.Integer_Text_IO,
     Ada.Text_IO,
     Constraint_Engine;

use  Ada.Integer_Text_IO, Ada.Text_IO;

package body Constraint_Engine is


   -------------------
   -- Find_Solution --
   -------------------

   function Find_Solution
     (Self : in Type_Problem)
      return Type_Problem
   is
      Next_P   : Type_Problem := Self;
      Inc_Next : Boolean := False;
   begin

      if Next_P.Is_Valid_Solution then
         return Next_P;
      end if;

      loop
         for Var_Cursor in Next_P.Var_List'Range loop

            if Var_Cursor = 1 then

               if Next_P.Var_List( Nb_Var ).Curr_Solution >= Next_P.Var_List( Nb_Var ).Top_Interval and
                  Next_P.Var_List( 1 ).Curr_Solution >= Next_P.Var_List( 1 ).Top_Interval
               then
                  raise No_Solution
                    with "No solution can be found.";
               end if;

               if Next_P.Var_List( 1 ).Curr_Solution < Next_P.Var_List( 1 ).Top_Interval then

                  Next_P.Var_List( 1 ).Curr_Solution := Next_P.Var_List( 1 ).Curr_Solution + 1;

                  if Next_P.Is_Valid_Solution then
                     return Next_P;
                  end if;

               else
                  Inc_Next := True;
                  Next_P.Var_List( 1 ).Curr_Solution := Next_P.Var_List( 1 ).Low_Interval - 1;
               end if;
            else
               if Inc_Next and Next_P.Var_List( Var_Cursor ).Curr_Solution < Next_P.Var_List( Var_Cursor ).Top_Interval then
                  Next_P.Var_List( Var_Cursor ).Curr_Solution := Next_P.Var_List( Var_Cursor ).Curr_Solution + 1;
                  Inc_Next := False;
               else
                  if Inc_Next then
                     Next_P.Var_List( Var_Cursor ).Curr_Solution := Next_P.Var_List( Var_Cursor ).Low_Interval;
                     Inc_Next := True;
                  end if;
               end if;

            end if;
         end loop;
      end loop;

   end Find_Solution;


   -----------------------
   -- Is_Valid_Solution --
   -----------------------

   function Is_Valid_Solution
     (Self : Type_Problem)
      return Boolean
   is
      Cur_V1 : Integer := 0;
      Cur_V2 : Integer := 0;
   begin

      for I in Self.Ctr_List'Range loop
         Cur_V1 := Self.Var_List( Self.Ctr_List(I).V1_Position ).Curr_Solution;

         if Self.Ctr_List(I).Is_Var_Ctr then
            Cur_V2 := Self.Var_List( Self.Ctr_List(I).V2_Position ).Curr_Solution;
         else
            Cur_V2 := Self.Ctr_List(I).V;
         end if;

         if not Is_Valid_Relation(Self, Cur_V1, Self.Ctr_List(I).Rel, Cur_V2) then
            return False;
         end if;

      end loop;

      return True;
   end Is_Valid_Solution;


   -----------------------
   -- Is_Valid_Relation --
   -----------------------

   function Is_Valid_Relation
     (Self : Type_Problem; V_1 : Integer; Rel : Enum_Relational; V_2 : Integer)
      return Boolean
   is
   begin
      case Rel is
         when IS_EQUAL      => return V_1 =  V_2;
         when IS_LESS_EQUAL => return V_1 <= V_2;
         when IS_LESS       => return V_1 <  V_2;
         when IS_MORE_EQUAL => return V_1 >= V_2;
         when IS_MORE       => return V_1 >  V_2;
         when IS_INEQUAL    => return V_1 /= V_2;
         when others => return False;
      end case;
   end Is_Valid_Relation;


   -------------
   -- Get_Var --
   -------------

   function Get_Var(Self : Type_Problem) return Type_Array_Variable
   is
   begin
      return Self.Var_List;
   end;


   -------------
   -- Add_Var --
   -------------

   procedure Add_Var
     (Self : in out Type_Problem; Low_Interval : Integer; Top_Interval : Integer)
   is
      New_Var : Type_Variable := (Low_Interval, Top_Interval, Low_Interval);
   begin

      Self.Var_List( Self.Var_Cur + 1 ) := New_Var;
      Self.Var_Cur                      := Self.Var_Cur + 1;
   end Add_Var;


   ------------------------
   -- Add_Constraint_Var --
   ------------------------

   procedure Add_Constraint_Var
     (Self : in out Type_Problem;
      V1_Position : Positive;
      Rel : Enum_Relational;
      V2_Position : Positive)
   is
      C : Type_Constraint := (V1_Position, Rel, V2_Position, 0, True);
   begin
      Self.Ctr_List( Self.Ctr_Cur + 1 ) := C;
      Self.Ctr_Cur                      := Self.Ctr_Cur + 1;
   end Add_Constraint_Var;


   ---------------------------------
   -- Add_Constraint_Var_Multiple --
   ---------------------------------

   procedure Add_Constraint_Var_Multiple
     (Self : in out Type_Problem;
      V_All_Position : Type_Array_Position;
      Rel : Enum_Relational)
   is
   begin
      for Current_A in V_All_Position'Range loop
         for Current_B in V_All_Position'Range loop
            Self.Add_Constraint_Var(V1_Position => V_All_Position( Current_A ),
                                    Rel         => Rel,
                                    V2_Position => V_All_Position( Current_B ) );
         end loop;
      end loop;
   end Add_Constraint_Var_Multiple;


   ------------------------
   -- Add_Constraint_Int --
   ------------------------

   procedure Add_Constraint_Int
     (Self : in out Type_Problem;
      V1_Position : Positive;
      Rel : Enum_Relational;
      V : Integer)
   is
      C : Type_Constraint := (V1_Position, Rel, 1, V, False);
   begin
      Self.Ctr_List( Self.Ctr_Cur + 1 ) := C;
      Self.Ctr_Cur                      := Self.Ctr_Cur + 1;
   end Add_Constraint_Int;

end Constraint_Engine;
