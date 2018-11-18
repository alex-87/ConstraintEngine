generic
   Nb_Var : Integer;
   Nb_Ctr : Integer;
package Constraint_Engine is

   type Type_Problem    is
     tagged private;
   
   type Enum_Relational is
     (IS_EQUAL,      -- =
      IS_LESS_EQUAL, -- <=
      IS_LESS,       -- <
      IS_MORE_EQUAL, -- >=
      IS_MORE,       -- >
      IS_INEQUAL);   -- /=

   type Type_Variable is tagged
      record
         Low_Interval  : Integer;
         Top_Interval  : Integer;
         Curr_Solution : Integer;
      end record;

   type Type_Constraint is tagged
      record
         V1_Position : Positive;
         Rel         : Enum_Relational;
         V2_Position : Positive;
         V           : Integer;
         Is_Var_Ctr  : Boolean;
      end record;

   type Type_Array_Constraint is
     Array( 1 .. Nb_Ctr ) of Type_Constraint;
   
   type Type_Array_Variable   is
     Array( 1 .. Nb_Var ) of Type_Variable;
   
   function Find_Solution
     (Self : in Type_Problem) return Type_Problem;

   function Is_Valid_Solution
     (Self : Type_Problem) return Boolean;

   function Is_Valid_Relation
     (Self : Type_Problem; V_1 : Integer; Rel : Enum_Relational; V_2 : Integer) return Boolean;

   function Get_Var
     (Self : Type_Problem) return Type_Array_Variable;

   pragma Assertion_Policy (Pre => Check);
   procedure Add_Var
     (Self : in out Type_Problem; Low_Interval : Integer; Top_Interval : Integer)
     with Pre => Low_Interval <= Top_Interval;

   procedure Add_Constraint_Var
     (Self : in out Type_Problem; V1_Position : Positive; Rel : Enum_Relational; V2_Position : Positive);
   
   procedure Add_Constraint_Int
     (Self : in out Type_Problem; V1_Position : Positive; Rel : Enum_Relational; V : Integer);


   No_Solution : exception;

private

   type Type_Problem is tagged
      record
         Var_Cur  : Integer;
         Ctr_Cur  : Integer;
         Var_List : Type_Array_Variable;
         Ctr_List : Type_Array_Constraint;
      end record;

end Constraint_Engine;
