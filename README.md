# Constraint Engine package in Ada

Simple ADA package for constraint solving. Supported operations are relational operations between integer variables.

# How to

Initialize the package
---

`package Test_Engine is new Constraint_Engine(Nb_Var => 2, Nb_Ctr => 3);`

* The parameter `Nb_Var` represents the number of variables.
* The parameter `Nb_Ctr` represents the number of constraints.

Add the variables
---

```Ada
declare
   P : Type_Problem;
   ...
begin
   P.Add_Var(Low_Interval => 0, Top_Interval => 5000);
```

* The parameter `Low_Interval` represents the lowest allowed value for this variable.
* The parameter `Top_Interval` represents the highest allowed value for this variable.

Add the constraints (relation between two variables)
---

```Ada
   P.Add_Constraint_Var(V1_Position => 1,
                        Rel         => IS_MORE,
                        V2_Position => 2);
```

* The parameter `V1_Position` represents a variable position **in the added order**.
* The parameter `Rel` represents the relation between the two variables.
* The parameter `V2_Position` represents a variable position **in the added order**.

Add the constraints (relation between a variable and an integer)
---


```Ada
   P.Add_Constraint_Int(V1_Position => 2,
                        Rel         => IS_MORE,
                        V           => 3999);
```

* The parameter `V1_Position` represents a variable position **in the added order**.
* The parameter `Rel` represents the relation between the variable and the integer.
* The parameter `V` is the integer's value.

The relations
---

Relations are represented by an enum :

```Ada
   type Enum_Relational is
     (IS_EQUAL,      -- =
      IS_LESS_EQUAL, -- <=
      IS_LESS,       -- <
      IS_MORE_EQUAL, -- >=
      IS_MORE,       -- >
      IS_INEQUAL);   -- /=
```

# Research of the solution

* The solution is found by changing variables values in accordance with their respective domains. When a solution is found, the constraint engine stops and returns a `Type_Problem` object.
* To launch the research of a solution, call the `Find_Solution`.
* Reading the solution consists in parsing values of the returned `Type_Problem` object for example :

```Ada
declare
   ...
   S : Type_Array_Variable;
begin
   ...
   
   P := P.Find_Solution;
   S := P.Get_Var;

   Put("Solution : ");
   for Cursor in S'Range loop
      Put( S(Cursor).Curr_Solution'Image & ", ");
   end loop;
   New_Line;
```

If no solution has been found, the `No_Solution` exception is thrown.

# License

This software is under the MIT License.
