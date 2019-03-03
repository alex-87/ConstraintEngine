with
     ADA.Containers.Vectors;

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


   package Var_Vector is new ADA.Containers.Vectors(Index_Type   => Positive,
                                                    Element_Type => Type_Variable);
   
   package Ctr_Vector is new ADA.Containers.Vectors(Index_Type   => Positive,
                                                    Element_Type => Type_Constraint);


   type Type_Array_Position   is
     Array( Integer range <> ) of Positive;
   
   function Find_Solution
     (Self : in Type_Problem) return Type_Problem;

   function Is_Valid_Solution
     (Self : Type_Problem) return Boolean;

   function Is_Valid_Relation
     (Self : Type_Problem; V_1 : Integer; Rel : Enum_Relational; V_2 : Integer) return Boolean;

   function Get_Var
     (Self : Type_Problem) return Var_Vector.Vector;

   function Check_Contradiction
     (Self : Type_Problem) return Boolean;

   pragma Assertion_Policy (Pre => Check);
   procedure Add_Var
     (Self : in out Type_Problem; Low_Interval : Integer; Top_Interval : Integer)
     with Pre => Low_Interval <= Top_Interval;

   procedure Add_Constraint_Var
     (Self : in out Type_Problem; V1_Position : Positive; Rel : Enum_Relational; V2_Position : Positive);

   pragma Assertion_Policy (Pre => Check);
   procedure Add_Constraint_Var_Multiple
     (Self : in out Type_Problem; V_All_Position : Type_Array_Position; Rel : Enum_Relational)
   with Pre => Rel = IS_EQUAL or Rel = IS_INEQUAL;
   
   procedure Add_Constraint_Int
     (Self : in out Type_Problem; V1_Position : Positive; Rel : Enum_Relational; V : Integer);
   
   procedure Add_Constraint_Int_Multiple
     (Self : in out Type_Problem; V_All_Position : Type_Array_Position; Rel : Enum_Relational; V : Integer);

   
   --- Exceptions
   
   No_Solution : exception;
   
   Contradicted_Contraint : exception;

private


   type Type_Problem is tagged
      record
         Var_Cur  : Integer := 0;
         Ctr_Cur  : Integer := 0;
         Var_List : Var_Vector.Vector;
         Ctr_List : Ctr_Vector.Vector;
      end record;

end Constraint_Engine;
